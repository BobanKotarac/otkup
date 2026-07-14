"""Generate priznanica PDF (legacy Clipper document)."""

from __future__ import annotations

from datetime import date
from io import BytesIO

from reportlab.lib import colors
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.lib.units import cm
from reportlab.platypus import Paragraph, SimpleDocTemplate, Spacer, Table, TableStyle
from sqlalchemy.orm import Session

from app.models import Company, Fruit, FruitPurchase, Good, GoodsDebit, Producer
from app.services.codes import purchase_total


def _fmt(value: float, decimals: int = 2) -> str:
    return f"{value:,.{decimals}f}".replace(",", "X").replace(".", ",").replace("X", ".")


def build_priznanica_pdf(
    db: Session,
    *,
    producer_code: str,
    date_from: date,
    date_to: date,
    document_no: int = 1,
) -> bytes:
    company = db.query(Company).first()
    producer = db.query(Producer).filter_by(code=producer_code).first()
    if not producer:
        raise ValueError("Producer not found")

    purchases = (
        db.query(FruitPurchase)
        .filter(
            FruitPurchase.producer_code == producer_code,
            FruitPurchase.purchase_date >= date_from,
            FruitPurchase.purchase_date <= date_to,
        )
        .all()
    )
    debits = (
        db.query(GoodsDebit)
        .filter(
            GoodsDebit.producer_code == producer_code,
            GoodsDebit.debit_date >= date_from,
            GoodsDebit.debit_date <= date_to,
        )
        .all()
    )

    buffer = BytesIO()
    doc = SimpleDocTemplate(buffer, pagesize=A4, leftMargin=2 * cm, rightMargin=2 * cm, topMargin=1.5 * cm)
    styles = getSampleStyleSheet()
    title_style = ParagraphStyle("Title", parent=styles["Heading2"], alignment=1, textColor=colors.HexColor("#0d47a1"))
    normal = styles["Normal"]
    story = []

    cname = company.name if company else "OTKUP"
    caddr = company.address if company else ""
    ccity = company.city if company else ""
    cpib = company.tax_id if company else ""
    cmb = company.registration_number if company else ""

    story.append(Paragraph(cname, title_style))
    if caddr:
        story.append(Paragraph(caddr, normal))
    if ccity:
        story.append(Paragraph(ccity, normal))
    if cpib or cmb:
        story.append(Paragraph(f"PIB: {cpib} &nbsp;&nbsp; MB: {cmb}", normal))
    story.append(Spacer(1, 0.4 * cm))
    story.append(Paragraph("<b>Primalac priznanice</b>", normal))
    story.append(Paragraph(f"Prezime i ime: <b>{producer.name}</b> &nbsp;&nbsp; JMBG: {producer.personal_id}", normal))
    if producer.tax_statement:
        story.append(Paragraph(f"Poreska izjava: {producer.tax_statement}", normal))
    story.append(Spacer(1, 0.5 * cm))
    story.append(Paragraph(f"<b>PRIZNANICA Br. {document_no}</b>", title_style))
    story.append(Paragraph(f"Mesto i datum izdavanja: {ccity or '—'}, {date_to.strftime('%d.%m.%Y')}", normal))
    story.append(Spacer(1, 0.3 * cm))
    story.append(Paragraph("Vrsta i količina isporučenih dobara", normal))
    story.append(Spacer(1, 0.2 * cm))

    # Aggregate purchases by fruit and class
    lines: list[list[str]] = [["Rb", "Vrsta dobra", "J.m.", "Količina", "Cena", "Iznos"]]
    row_num = 0
    fruit_total = 0.0
    vat_rate = 0.0

    fruit_ids = {p.fruit_code for p in purchases}
    for fruit_code in sorted(fruit_ids):
        fruit = db.query(Fruit).filter_by(code=fruit_code).first()
        if not fruit:
            continue
        vat_rate = fruit.vat_rate
        fruit_purchases = [p for p in purchases if p.fruit_code == fruit_code]
        classes = [
            ("Prepodnevna", "qty_extra", "price_extra"),
            ("I klasa", "qty_class1", "price_class1"),
            ("II klasa", "qty_class2", "price_class2"),
            ("III klasa", "qty_class3", "price_class3"),
        ]
        for label, qty_field, price_field in classes:
            qty = sum(getattr(p, qty_field) for p in fruit_purchases)
            if qty <= 0:
                continue
            price = getattr(fruit_purchases[0], price_field.replace("qty", "price")) if fruit_purchases else 0
            amount = qty * price
            fruit_total += amount
            row_num += 1
            lines.append([
                str(row_num),
                f"{fruit.name} {label}",
                "kg",
                _fmt(qty),
                _fmt(price, 3),
                _fmt(amount),
            ])

    if row_num == 0:
        lines.append(["—", "Nema otkupa u periodu", "", "", "", ""])

    table = Table(lines, colWidths=[1 * cm, 6.5 * cm, 1.2 * cm, 2.2 * cm, 2.2 * cm, 2.5 * cm])
    table.setStyle(TableStyle([
        ("BACKGROUND", (0, 0), (-1, 0), colors.HexColor("#e3f2fd")),
        ("TEXTCOLOR", (0, 0), (-1, 0), colors.HexColor("#0d47a1")),
        ("FONTNAME", (0, 0), (-1, 0), "Helvetica-Bold"),
        ("FONTSIZE", (0, 0), (-1, -1), 9),
        ("GRID", (0, 0), (-1, -1), 0.5, colors.grey),
        ("ALIGN", (3, 1), (-1, -1), "RIGHT"),
    ]))
    story.append(table)
    story.append(Spacer(1, 0.3 * cm))

    vat_amount = fruit_total * vat_rate / 100 if producer.vat_registered == "D" else 0
    total_with_vat = fruit_total + vat_amount

    summary = [
        ["a) Svega vrednost primljenih dobara:", _fmt(fruit_total)],
        ["b) Iznos PDV naknade:", _fmt(vat_amount)],
        ["I Ukupna vrednost dobara sa PDV (a+b):", _fmt(total_with_vat)],
    ]
    st = Table(summary, colWidths=[12 * cm, 4 * cm])
    st.setStyle(TableStyle([
        ("ALIGN", (1, 0), (1, -1), "RIGHT"),
        ("FONTNAME", (0, -1), (-1, -1), "Helvetica-Bold"),
        ("LINEBELOW", (0, 0), (-1, -2), 0.25, colors.lightgrey),
    ]))
    story.append(st)
    story.append(Spacer(1, 0.3 * cm))

    # Goods debits (akontacija)
    goods_cash = 0.0
    goods_goods = 0.0
    for d in debits:
        good = db.query(Good).filter_by(code=d.good_code).first()
        if not good:
            continue
        val = d.quantity * d.unit_price * (1 + good.vat_rate / 100)
        if good.status == 1:
            goods_goods += val
        else:
            goods_cash += val

    akont = [
        ["c) Akontacija data u robi:", _fmt(goods_goods)],
        ["d) Akontacija data u novcu:", _fmt(goods_cash)],
        ["II Ukupan iznos akontacije (c+d):", _fmt(goods_goods + goods_cash)],
        ["IZNOS ZA ISPLATU:", _fmt(total_with_vat - goods_goods - goods_cash)],
    ]
    at = Table(akont, colWidths=[12 * cm, 4 * cm])
    at.setStyle(TableStyle([
        ("ALIGN", (1, 0), (1, -1), "RIGHT"),
        ("FONTNAME", (0, -1), (-1, -1), "Helvetica-Bold"),
        ("BACKGROUND", (0, -1), (-1, -1), colors.HexColor("#e3f2fd")),
    ]))
    story.append(at)
    story.append(Spacer(1, 1 * cm))
    story.append(Paragraph(f"Tekući račun: {producer.bank_account}", normal))
    story.append(Spacer(1, 1.5 * cm))
    story.append(Paragraph("Obracun izvršio: __________________ &nbsp;&nbsp;&nbsp;&nbsp; Potpis primaoca: __________________", normal))

    doc.build(story)
    return buffer.getvalue()
