"""Legacy-style business validations from the Clipper app."""

from __future__ import annotations

from dataclasses import dataclass
from datetime import date

from sqlalchemy.orm import Session

from app.models import FruitPurchase, Packaging, Producer


@dataclass
class ValidationMessage:
    code: str
    level: str  # warning | info | error
    message: str


def validate_fruit_purchase(
    db: Session,
    *,
    producer_code: str,
    fruit_code: str,
    purchase_date: date,
    document_no: str,
    total_kg: float,
    crates_returned: int,
    crate_weight_100g: float = 5,
    crates_by_class: tuple[int, int, int, int] = (0, 0, 0, 0),
) -> list[ValidationMessage]:
    messages: list[ValidationMessage] = []

    # Adjust kg for crate tare (legacy: kol -= crates * gg * 0.1)
    tare = sum(crates_by_class) * crate_weight_100g * 0.1
    net_kg = max(total_kg - tare, 0)

    same_day = (
        db.query(FruitPurchase)
        .filter(
            FruitPurchase.producer_code == producer_code,
            FruitPurchase.fruit_code == fruit_code,
            FruitPurchase.purchase_date == purchase_date,
        )
        .all()
    )

    if same_day and not document_no:
        messages.append(
            ValidationMessage(
                code="duplicate_same_day",
                level="warning",
                message="Ovaj proizvođač danas drugi put predaje ovo voće!",
            )
        )

    if document_no:
        existing = (
            db.query(FruitPurchase)
            .filter(
                FruitPurchase.producer_code == producer_code,
                FruitPurchase.fruit_code == fruit_code,
                FruitPurchase.purchase_date == purchase_date,
                FruitPurchase.document_no == document_no,
            )
            .first()
        )
        if existing:
            messages.append(
                ValidationMessage(
                    code="existing_document",
                    level="info",
                    message="Za ovog proizvođača za danas je već unet otkup — podaci će biti izmenjeni.",
                )
            )

    if crates_returned > 0 and net_kg / crates_returned > 2:
        avg = net_kg / crates_returned
        messages.append(
            ValidationMessage(
                code="crate_weight_high",
                level="warning",
                message=f"Prosek težine po gajbi veći od 2 kg ({avg:.2f} kg/gajba)!",
            )
        )

    if total_kg <= 0:
        messages.append(
            ValidationMessage(
                code="zero_quantity",
                level="error",
                message="Ukupna količina mora biti veća od nule.",
            )
        )

    producer = db.query(Producer).filter_by(code=producer_code).first()
    if not producer:
        messages.append(
            ValidationMessage(
                code="producer_missing",
                level="error",
                message="Proizvođač nije pronađen.",
            )
        )

    return messages


def has_blocking_errors(messages: list[ValidationMessage]) -> bool:
    return any(m.level == "error" for m in messages)
