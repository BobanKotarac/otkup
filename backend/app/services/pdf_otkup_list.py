"""Generate daily otkup list PDF (legacy printout after purchase entry)."""

from __future__ import annotations

from datetime import date

from reportlab.lib import colors
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.lib.units import cm
from reportlab.platypus import Paragraph, SimpleDocTemplate, Spacer, Table, TableStyle
from sqlalchemy.orm import Session

from app.models import Company, Fruit, FruitPurchase, Producer, PurchaseLocation
from app.services.codes import purchase_total
from app.services.pdf_fonts import FONT_BOLD, FONT_REGULAR, ensure_pdf_fonts


def _fmt(value: float, decimals: int = 2) -> str:
    return f"{value:,.{decimals}f}".replace(",", "X").replace(".", ",").replace("X", ".")


def build_otkup_list_pdf(
    db: Session,
    *,
    purchase_date: date,
    location_code: str | None = None,
) -> bytes:
    ensure_pdf_fonts()

    company = db.query(Company).first()
    location = db.query(PurchaseLocation).filter_by(code=location_code).first() if location_code else None

    producers_q = db.query(Producer)
    if location_code:
        producers_q = producers_q.filter(Producer.location_code == location_code)
    producer_codes = {p.code for p in producers_q.all()}

    purchases = (
        db.query(FruitPurchase)
        .filter(FruitPurchase.purchase_date == purchase_date)
        .order_by(FruitPurchase.producer_code, FruitPurchase.fruit_code)
        .all()
    )
    if location_code:
        purchases = [p for p in purchases if p.producer_code in producer_codes]

    from io import BytesIO

    buffer = BytesIO()
    doc = SimpleDocTemplate(buffer, pagesize=A4, leftMargin=2 * cm, rightMargin=2 * cm, topMargin=1.5 * cm)
    styles = getSampleStyleSheet()
    title = ParagraphStyle("Title", parent=styles["Heading2"], fontName=FONT_BOLD, alignment=1)
    normal = ParagraphStyle("Normal", parent=styles["Normal"], fontName=FONT_REGULAR)
    story = []

    cname = company.name if company else "OTKUP"
    story.append(Paragraph(cname, title))
    story.append(Paragraph(f"<b>OTKUPNI LIST</b> — {purchase_date.strftime('%d.%m.%Y')}", title))
    loc_name = location.name if location else "Sva mesta"
    story.append(Paragraph(f"Otkupno mesto: {loc_name}", normal))
    story.append(Spacer(1, 0.4 * cm))

    lines: list[list[str]] = [["Rb", "Proizvođač", "Voće", "Količina (kg)", "Vrednost"]]
    total_kg = 0.0
    total_val = 0.0
    for i, p in enumerate(purchases, start=1):
        producer = db.query(Producer).filter_by(code=p.producer_code).first()
        fruit = db.query(Fruit).filter_by(code=p.fruit_code).first()
        kg = p.qty_extra + p.qty_class1 + p.qty_class2 + p.qty_class3
        val = purchase_total(p)
        total_kg += kg
        total_val += val
        lines.append([
            str(i),
            producer.name if producer else p.producer_code,
            fruit.name if fruit else p.fruit_code,
            _fmt(kg),
            _fmt(val),
        ])

    if len(lines) == 1:
        lines.append(["—", "Nema otkupa za izabrani dan", "", "", ""])

    table = Table(lines, colWidths=[1 * cm, 5.5 * cm, 4 * cm, 3 * cm, 3 * cm])
    table.setStyle(TableStyle([
        ("FONTNAME", (0, 0), (-1, -1), FONT_REGULAR),
        ("FONTNAME", (0, 0), (-1, 0), FONT_BOLD),
        ("FONTSIZE", (0, 0), (-1, -1), 9),
        ("BACKGROUND", (0, 0), (-1, 0), colors.HexColor("#e3f2fd")),
        ("GRID", (0, 0), (-1, -1), 0.5, colors.grey),
        ("ALIGN", (3, 1), (-1, -1), "RIGHT"),
    ]))
    story.append(table)
    story.append(Spacer(1, 0.3 * cm))
    summary = Table([
        ["Ukupno kg:", _fmt(total_kg)],
        ["Ukupna vrednost:", _fmt(total_val)],
    ], colWidths=[12 * cm, 4 * cm])
    summary.setStyle(TableStyle([
        ("FONTNAME", (0, 0), (-1, -1), FONT_BOLD),
        ("ALIGN", (1, 0), (1, -1), "RIGHT"),
    ]))
    story.append(summary)

    doc.build(story)
    return buffer.getvalue()
