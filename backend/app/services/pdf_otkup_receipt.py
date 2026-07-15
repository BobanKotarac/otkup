"""Generate single-purchase otkup receipt PDF (legacy DNEVNI OTKUPNI LIST)."""

from __future__ import annotations

from datetime import date

from reportlab.lib import colors
from reportlab.lib.pagesizes import A4, landscape
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.lib.units import cm
from reportlab.platypus import Paragraph, SimpleDocTemplate, Spacer, Table, TableStyle
from sqlalchemy.orm import Session

from app.models import Company, Fruit, FruitPurchase, Packaging, Producer, PurchaseLocation
from app.services.pdf_fonts import FONT_BOLD, FONT_REGULAR, ensure_pdf_fonts


def _fmt(value: float, decimals: int = 2) -> str:
    return f"{value:,.{decimals}f}".replace(",", "X").replace(".", ",").replace("X", ".")


def _packaging_balance(db: Session, *, producer_code: str, up_to: date) -> tuple[float, float]:
    year_start = date(up_to.year, 1, 1)
    rows = (
        db.query(Packaging)
        .filter(
            Packaging.producer_code == producer_code,
            Packaging.transaction_date >= year_start,
            Packaging.transaction_date <= up_to,
        )
        .all()
    )
    taken = sum(r.taken for r in rows)
    returned = sum(r.returned for r in rows)
    return taken, returned


def build_otkup_receipt_pdf(
    db: Session,
    *,
    purchase_id: int,
    location_code: str | None = None,
) -> bytes:
    ensure_pdf_fonts()

    purchase = db.query(FruitPurchase).filter_by(id=purchase_id).first()
    if not purchase:
        raise ValueError("Purchase not found")

    producer = db.query(Producer).filter_by(code=purchase.producer_code).first()
    fruit = db.query(Fruit).filter_by(code=purchase.fruit_code).first()
    if not producer or not fruit:
        raise ValueError("Purchase data incomplete")

    loc_code = location_code or producer.location_code
    location = db.query(PurchaseLocation).filter_by(code=loc_code).first()
    company = db.query(Company).first()

    pkg = (
        db.query(Packaging)
        .filter_by(
            producer_code=purchase.producer_code,
            transaction_date=purchase.purchase_date,
            document_no=purchase.document_no or "",
        )
        .first()
    )
    pkg_taken = pkg.taken if pkg else 0.0
    pkg_returned = pkg.returned if pkg else 0.0
    amb_taken, amb_returned = _packaging_balance(
        db, producer_code=purchase.producer_code, up_to=purchase.purchase_date
    )

    from io import BytesIO

    buffer = BytesIO()
    page = landscape(A4)
    doc = SimpleDocTemplate(buffer, pagesize=page, leftMargin=1.5 * cm, rightMargin=1.5 * cm, topMargin=1.2 * cm)
    styles = getSampleStyleSheet()
    title = ParagraphStyle("Title", parent=styles["Heading2"], fontName=FONT_BOLD, alignment=1)
    normal = ParagraphStyle("Normal", parent=styles["Normal"], fontName=FONT_REGULAR, fontSize=8)
    small = ParagraphStyle("Small", parent=normal, fontSize=7, leading=9)
    story: list = []

    doc_no = purchase.document_no.strip() or str(purchase.id)
    story.append(Paragraph(f"<b>DNEVNI OTKUPNI LIST BROJ {doc_no}</b>", title))
    story.append(Spacer(1, 0.2 * cm))
    story.append(Paragraph(
        f"Proizvođač: <b>{producer.name}</b>, JMBG: {producer.personal_id or '—'} &nbsp;&nbsp; "
        f"Otkupno mesto: {location.name if location else loc_code}",
        normal,
    ))
    if producer.tax_statement:
        story.append(Paragraph(f"Poreska izjava: {producer.tax_statement}", normal))
    story.append(Paragraph(f"Datum: {purchase.purchase_date.strftime('%d.%m.%Y')}", normal))
    story.append(Spacer(1, 0.25 * cm))
    story.append(Paragraph(f"<b>{fruit.name}</b>", normal))
    story.append(Spacer(1, 0.15 * cm))

    vat = fruit.vat_rate
    lines: list[list[str]] = [[
        "Kvalitet", "J.m.", "Količina", "Cena bez PDV", "Cena sa PDV",
        "Vredn. bez PDV", "PDV %", "Iznos PDV", "Vredn. sa PDV",
    ]]
    classes = [
        ("Prep. A", purchase.qty_extra, purchase.price_extra),
        ("A", purchase.qty_class1, purchase.price_class1),
        ("B", purchase.qty_class2, purchase.price_class2),
        ("C", purchase.qty_class3, purchase.price_class3),
    ]
    total_net = 0.0
    total_vat = 0.0
    total_gross = 0.0
    for label, qty, price in classes:
        if qty <= 0:
            continue
        net = qty * price
        vat_amt = net * vat / 100
        gross = net + vat_amt
        total_net += net
        total_vat += vat_amt
        total_gross += gross
        price_gross = price * (1 + vat / 100)
        lines.append([
            label,
            "kg",
            _fmt(qty),
            _fmt(price, 3),
            _fmt(price_gross, 3),
            _fmt(net),
            _fmt(vat, 0),
            _fmt(vat_amt),
            _fmt(gross),
        ])

    if len(lines) == 1:
        lines.append(["—", "", "0,00", "", "", "0,00", "", "0,00", "0,00"])

    table = Table(
        lines,
        colWidths=[2.2 * cm, 1.2 * cm, 2.2 * cm, 2.5 * cm, 2.5 * cm, 2.8 * cm, 1.5 * cm, 2.2 * cm, 2.8 * cm],
    )
    table.setStyle(TableStyle([
        ("FONTNAME", (0, 0), (-1, -1), FONT_REGULAR),
        ("FONTNAME", (0, 0), (-1, 0), FONT_BOLD),
        ("FONTSIZE", (0, 0), (-1, -1), 8),
        ("BACKGROUND", (0, 0), (-1, 0), colors.HexColor("#e3f2fd")),
        ("GRID", (0, 0), (-1, -1), 0.5, colors.grey),
        ("ALIGN", (2, 1), (-1, -1), "RIGHT"),
    ]))
    story.append(table)
    story.append(Spacer(1, 0.2 * cm))

    totals = Table([
        ["Ukupno bez PDV:", _fmt(total_net), "PDV:", _fmt(total_vat), "Ukupno sa PDV:", _fmt(total_gross)],
    ], colWidths=[3.5 * cm, 3 * cm, 1.5 * cm, 3 * cm, 3.5 * cm, 3 * cm])
    totals.setStyle(TableStyle([
        ("FONTNAME", (0, 0), (-1, -1), FONT_BOLD),
        ("FONTSIZE", (0, 0), (-1, -1), 8),
        ("ALIGN", (1, 0), (1, 0), "RIGHT"),
        ("ALIGN", (3, 0), (3, 0), "RIGHT"),
        ("ALIGN", (5, 0), (5, 0), "RIGHT"),
    ]))
    story.append(totals)
    story.append(Spacer(1, 0.25 * cm))

    balance = amb_returned - amb_taken
    story.append(Paragraph(
        f"<b>AMBALAŽA:</b> Ulaz {int(pkg_returned)} &nbsp; Izlaz {int(pkg_taken)} &nbsp; "
        f"Stanje (YTD): {int(amb_taken)} - {int(amb_returned)} = {int(balance)}",
        normal,
    ))
    story.append(Spacer(1, 0.3 * cm))

    if company:
        story.append(Paragraph(f"{company.name} — {company.city}", small))

    story.append(Spacer(1, 0.4 * cm))
    story.append(Paragraph(
        "Shodno Zakonu o porezu na dohodak građana, obračunati iznos poreza i doprinosa pada na teret proizvođača "
        "ukoliko proizvođač ne donese potrebnu dokumentaciju. Svojim potpisom proizvođač daje saglasnost na "
        "sve odredbe ovog otkupnog lista.",
        small,
    ))
    story.append(Spacer(1, 1 * cm))
    story.append(Paragraph(
        "____________________ &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "
        "_____________________",
        normal,
    ))
    story.append(Paragraph("Proizvođač &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Ovlasćeni otkupljivač", normal))

    doc.build(story)
    return buffer.getvalue()
