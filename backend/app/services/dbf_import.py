"""Import legacy Clipper/xBase DBF files into PostgreSQL/SQLite."""

from __future__ import annotations

import io
import tempfile
import zipfile
from dataclasses import dataclass, field
from datetime import date, datetime
from pathlib import Path
from typing import Any, Callable

from dbfread import DBF
from sqlalchemy.orm import Session

from app.models import (
    Company,
    Fruit,
    FruitPurchase,
    Good,
    GoodsDebit,
    ImportLog,
    Packaging,
    Producer,
    PurchaseLocation,
)

# DBF basename (case-insensitive) -> import order and handler key
IMPORT_ORDER: list[tuple[str, str]] = [
    ("company", "company"),
    ("mesta", "purchase_locations"),
    ("voce", "fruits"),
    ("roba", "goods"),
    ("kom", "producers"),
    ("otkup", "fruit_purchases"),
    ("zaduz", "goods_debits"),
    ("amb", "packaging"),
]

SUPPORTED_TABLES = {name for name, _ in IMPORT_ORDER}


@dataclass
class TableImportResult:
    table: str
    filename: str
    imported: int = 0
    skipped: int = 0
    errors: list[str] = field(default_factory=list)


@dataclass
class ImportReport:
    results: list[TableImportResult] = field(default_factory=list)
    files_found: list[str] = field(default_factory=list)
    files_unrecognized: list[str] = field(default_factory=list)

    @property
    def total_imported(self) -> int:
        return sum(r.imported for r in self.results)

    @property
    def success(self) -> bool:
        return bool(self.results) and all(not r.errors for r in self.results)


def _normalize_key(record: dict[str, Any]) -> dict[str, Any]:
    return {str(k).upper().strip(): v for k, v in record.items()}


def _str(value: Any, default: str = "") -> str:
    if value is None:
        return default
    return str(value).strip()


def _float(value: Any, default: float = 0.0) -> float:
    if value is None or value == "":
        return default
    try:
        return float(value)
    except (TypeError, ValueError):
        return default


def _int(value: Any, default: int = 0) -> int:
    if value is None or value == "":
        return default
    try:
        return int(float(value))
    except (TypeError, ValueError):
        return default


def _parse_date(value: Any) -> date | None:
    if value is None or value == "":
        return None
    if isinstance(value, datetime):
        return value.date()
    if isinstance(value, date):
        return value
    text = _str(value)
    if not text:
        return None
    # Clipper DTOS format: YYYYMMDD
    if len(text) == 8 and text.isdigit():
        return date(int(text[0:4]), int(text[4:6]), int(text[6:8]))
    for fmt in ("%Y-%m-%d", "%d.%m.%Y", "%m/%d/%Y"):
        try:
            return datetime.strptime(text, fmt).date()
        except ValueError:
            continue
    return None


def _read_dbf(path: Path) -> list[dict[str, Any]]:
    table = DBF(str(path), encoding="latin-1", ignore_missing_memofile=True)
    return [_normalize_key(dict(row)) for row in table]


def extract_dbf_files(upload: bytes, filename: str) -> dict[str, Path]:
    """Extract .dbf files from a zip archive or single file upload."""
    extracted: dict[str, Path] = {}
    tmp_dir = Path(tempfile.mkdtemp(prefix="otkup_dbf_"))

    if filename.lower().endswith(".zip"):
        with zipfile.ZipFile(io.BytesIO(upload)) as zf:
            for info in zf.infolist():
                if info.filename.lower().endswith(".dbf") and not info.is_dir():
                    target = tmp_dir / Path(info.filename).name
                    target.write_bytes(zf.read(info))
                    extracted[target.stem.lower()] = target
    elif filename.lower().endswith(".dbf"):
        target = tmp_dir / filename
        target.write_bytes(upload)
        extracted[target.stem.lower()] = target
    else:
        raise ValueError("Upload must be a .dbf file or .zip archive containing .dbf files")

    return extracted


def _import_company(db: Session, records: list[dict], result: TableImportResult) -> None:
    db.query(Company).delete()
    if not records:
        return
    row = records[0]
    db.add(
        Company(
            name=_str(row.get("CO_LINE1")),
            address=_str(row.get("CO_LINE2")),
            city=_str(row.get("CO_LINE3")),
            phone=_str(row.get("CO_LINE4")),
            bank_account=_str(row.get("CO_LINE5")),
            tax_id=_str(row.get("CO_LINE6")),
            registration_number=_str(row.get("CO_LINE7")),
            activity_code=_str(row.get("CO_LINE8")),
        )
    )
    result.imported = 1


def _import_purchase_locations(db: Session, records: list[dict], result: TableImportResult) -> None:
    for row in records:
        code = _str(row.get("SIFRA_M"))
        if not code:
            result.skipped += 1
            continue
        existing = db.query(PurchaseLocation).filter_by(code=code).first()
        if existing:
            existing.name = _str(row.get("NAZIV_M"))
            existing.buyer_name = _str(row.get("OTK_M"))
            existing.buyer_phone = _str(row.get("OTK_TEL"))
        else:
            db.add(
                PurchaseLocation(
                    code=code,
                    name=_str(row.get("NAZIV_M")),
                    buyer_name=_str(row.get("OTK_M")),
                    buyer_phone=_str(row.get("OTK_TEL")),
                )
            )
        result.imported += 1


def _import_fruits(db: Session, records: list[dict], result: TableImportResult) -> None:
    for row in records:
        code = _str(row.get("SIFRA_V"))
        if not code:
            result.skipped += 1
            continue
        existing = db.query(Fruit).filter_by(code=code).first()
        data = dict(
            name=_str(row.get("NAZIV_V")),
            price_extra=_float(row.get("CENA_V")),
            price_class1=_float(row.get("DRUGA")),
            price_class2=_float(row.get("TRECA")),
            price_class3=_float(row.get("CETVRTA")),
            vat_rate=_float(row.get("PDV")),
        )
        if existing:
            for k, v in data.items():
                setattr(existing, k, v)
        else:
            db.add(Fruit(code=code, **data))
        result.imported += 1


def _import_goods(db: Session, records: list[dict], result: TableImportResult) -> None:
    for row in records:
        code = _str(row.get("SIFRA_R"))
        if not code:
            result.skipped += 1
            continue
        existing = db.query(Good).filter_by(code=code).first()
        data = dict(
            name=_str(row.get("NAZIV_R")),
            price=_float(row.get("CENA_R")),
            ratio_to_fruit=_float(row.get("ODN")),
            ratio_from_fruit=_float(row.get("ODN_MAL")),
            vat_rate=_float(row.get("PDV")),
            unit=_str(row.get("JM")),
            status=_int(row.get("STATUS"), 1),
        )
        if existing:
            for k, v in data.items():
                setattr(existing, k, v)
        else:
            db.add(Good(code=code, **data))
        result.imported += 1


def _import_producers(db: Session, records: list[dict], result: TableImportResult) -> None:
    for row in records:
        code = _str(row.get("SIFRA_K"))
        if not code:
            result.skipped += 1
            continue
        existing = db.query(Producer).filter_by(code=code).first()
        data = dict(
            name=_str(row.get("IME_K")),
            location_code=_str(row.get("MESTO_K"))[:3] if _str(row.get("MESTO_K")) else code[:3],
            tax_statement=_str(row.get("MESTO_K")),
            contract=_str(row.get("UGO")),
            parcel_area=_float(row.get("POV")),
            bank_account=_str(row.get("TR")),
            personal_id=_str(row.get("JMBG")),
            vat_registered=_str(row.get("PDD"), "N")[:1] or "N",
            category=_str(row.get("KAT")),
        )
        if existing:
            for k, v in data.items():
                setattr(existing, k, v)
        else:
            db.add(Producer(code=code, **data))
        result.imported += 1


def _import_fruit_purchases(db: Session, records: list[dict], result: TableImportResult) -> None:
    for i, row in enumerate(records, start=1):
        producer = _str(row.get("SIFRA_OTK"))
        fruit = _str(row.get("SIFRA_OTV"))
        purchase_date = _parse_date(row.get("DATUM_OTK"))
        if not producer or not fruit or not purchase_date:
            result.skipped += 1
            continue
        try:
            db.add(
                FruitPurchase(
                    producer_code=producer,
                    fruit_code=fruit,
                    purchase_date=purchase_date,
                    qty_extra=_float(row.get("KOL_OTK")),
                    qty_class1=_float(row.get("RAZ_OTK")),
                    qty_class2=_float(row.get("KOL_OTKII")),
                    qty_class3=_float(row.get("KOL4") or row.get("RAZ_OTKII")),
                    document_no=_str(row.get("DOC_OTK")),
                    price_extra=_float(row.get("CENA1")),
                    price_class1=_float(row.get("CENA2")),
                    price_class2=_float(row.get("CENA3")),
                    price_class3=_float(row.get("CENA4")),
                )
            )
            result.imported += 1
        except Exception as exc:
            result.errors.append(f"Row {i}: {exc}")
            result.skipped += 1


def _import_goods_debits(db: Session, records: list[dict], result: TableImportResult) -> None:
    for i, row in enumerate(records, start=1):
        producer = _str(row.get("SIFRA_ZAD"))
        good = _str(row.get("SIFRA_ZAR"))
        debit_date = _parse_date(row.get("DATUM_ZAD"))
        if not producer or not good or not debit_date:
            result.skipped += 1
            continue
        try:
            db.add(
                GoodsDebit(
                    producer_code=producer,
                    good_code=good,
                    debit_date=debit_date,
                    quantity=_float(row.get("KOL_ZAD")),
                    document_no=_str(row.get("DOC_ZAD")),
                    unit_price=_float(row.get("CENA")),
                )
            )
            result.imported += 1
        except Exception as exc:
            result.errors.append(f"Row {i}: {exc}")
            result.skipped += 1


def _import_packaging(db: Session, records: list[dict], result: TableImportResult) -> None:
    for i, row in enumerate(records, start=1):
        producer = _str(row.get("AMB_SIF"))
        transaction_date = _parse_date(row.get("AMB_DATUM"))
        if not producer or not transaction_date:
            result.skipped += 1
            continue
        try:
            db.add(
                Packaging(
                    producer_code=producer,
                    transaction_date=transaction_date,
                    taken=_float(row.get("AMB_KOL")),
                    returned=_float(row.get("AMB_RAZ")),
                    document_no=_str(row.get("AMB_DOC")),
                )
            )
            result.imported += 1
        except Exception as exc:
            result.errors.append(f"Row {i}: {exc}")
            result.skipped += 1


IMPORT_HANDLERS: dict[str, Callable[[Session, list[dict], TableImportResult], None]] = {
    "company": _import_company,
    "purchase_locations": _import_purchase_locations,
    "fruits": _import_fruits,
    "goods": _import_goods,
    "producers": _import_producers,
    "fruit_purchases": _import_fruit_purchases,
    "goods_debits": _import_goods_debits,
    "packaging": _import_packaging,
}


def import_dbf_files(
    db: Session,
    files: dict[str, Path],
    *,
    clear_existing: bool = False,
    source_label: str = "upload",
) -> ImportReport:
    report = ImportReport(files_found=sorted(files.keys()))

    unrecognized = [k for k in files if k not in SUPPORTED_TABLES]
    report.files_unrecognized = unrecognized

    if clear_existing:
        for model in (
            Packaging,
            GoodsDebit,
            FruitPurchase,
            Producer,
            Good,
            Fruit,
            PurchaseLocation,
            Company,
        ):
            db.query(model).delete()

    for dbf_key, handler_key in IMPORT_ORDER:
        path = files.get(dbf_key)
        if not path:
            continue

        result = TableImportResult(table=handler_key, filename=path.name)
        try:
            records = _read_dbf(path)
            handler = IMPORT_HANDLERS[handler_key]
            handler(db, records, result)
            db.flush()
        except Exception as exc:
            result.errors.append(str(exc))

        report.results.append(result)
        db.add(
            ImportLog(
                filename=source_label,
                table_name=handler_key,
                records_imported=result.imported,
                records_skipped=result.skipped,
                errors="; ".join(result.errors),
            )
        )

    db.commit()
    return report
