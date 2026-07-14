from datetime import date

from fastapi import APIRouter, Depends, HTTPException, Query
from fastapi.responses import Response
from sqlalchemy import func
from sqlalchemy.orm import Session

from app.database import get_db
from app.models import (
    Company,
    Fruit,
    FruitPurchase,
    Good,
    GoodsDebit,
    Packaging,
    Producer,
    PurchaseLocation,
)
from app.schemas import (
    DashboardStats,
    FruitPurchaseCreate,
    LiveDashboard,
    LocationTodayStats,
    ProducerTodayStats,
    SearchResultItem,
    SearchResults,
    SetupStatus,
    ValidationMessageSchema,
)
from app.services.codes import purchase_total
from app.services.pdf_priznanica import build_priznanica_pdf
from app.services.validation import has_blocking_errors, validate_fruit_purchase

router = APIRouter(prefix="/api", tags=["features"])


@router.get("/setup/status", response_model=SetupStatus)
def setup_status(db: Session = Depends(get_db)):
    company = db.query(Company).first()
    company_ok = bool(company and company.name.strip())
    has_locations = db.query(PurchaseLocation).count() > 0
    has_fruits = db.query(Fruit).count() > 0
    has_goods = db.query(Good).count() > 0
    has_producers = db.query(Producer).count() > 0

    steps = [
        ("company", company_ok),
        ("locations", has_locations),
        ("fruits", has_fruits),
        ("goods", has_goods),
        ("producers", has_producers),
    ]
    next_step = "done"
    for name, done in steps:
        if not done:
            next_step = name
            break

    return SetupStatus(
        company_configured=company_ok,
        has_locations=has_locations,
        has_fruits=has_fruits,
        has_goods=has_goods,
        has_producers=has_producers,
        complete=all(done for _, done in steps),
        next_step=next_step,
    )


@router.get("/search", response_model=SearchResults)
def global_search(q: str = Query(min_length=1), db: Session = Depends(get_db)):
    term = q.strip().lower()
    pattern = f"%{term}%"
    results: list[SearchResultItem] = []

    for p in (
        db.query(Producer)
        .filter(func.lower(Producer.name).like(pattern) | func.lower(Producer.code).like(pattern))
        .limit(10)
    ):
        results.append(SearchResultItem(type="producer", id=p.id, code=p.code, name=p.name, extra=p.location_code))

    for loc in (
        db.query(PurchaseLocation)
        .filter(func.lower(PurchaseLocation.name).like(pattern) | func.lower(PurchaseLocation.code).like(pattern))
        .limit(10)
    ):
        results.append(SearchResultItem(type="location", id=loc.id, code=loc.code, name=loc.name))

    for f in (
        db.query(Fruit)
        .filter(func.lower(Fruit.name).like(pattern) | func.lower(Fruit.code).like(pattern))
        .limit(10)
    ):
        results.append(SearchResultItem(type="fruit", id=f.id, code=f.code, name=f.name))

    for g in (
        db.query(Good)
        .filter(func.lower(Good.name).like(pattern) | func.lower(Good.code).like(pattern))
        .limit(10)
    ):
        results.append(SearchResultItem(type="good", id=g.id, code=g.code, name=g.name))

    return SearchResults(query=q, results=results)


@router.post("/fruit-purchases/validate", response_model=list[ValidationMessageSchema])
def validate_purchase(data: FruitPurchaseCreate, db: Session = Depends(get_db)):
    purchase_date = data.purchase_date or date.today()
    total_kg = data.qty_extra + data.qty_class1 + data.qty_class2 + data.qty_class3
    crates_returned = data.crates_prep + data.crates_class1 + data.crates_class2 + data.crates_class3
    messages = validate_fruit_purchase(
        db,
        producer_code=data.producer_code,
        fruit_code=data.fruit_code,
        purchase_date=purchase_date,
        document_no=data.document_no,
        total_kg=total_kg,
        crates_returned=crates_returned,
        crate_weight_100g=data.crate_weight_100g,
        crates_by_class=(data.crates_prep, data.crates_class1, data.crates_class2, data.crates_class3),
    )
    return [ValidationMessageSchema(**m.__dict__) for m in messages]


@router.get("/dashboard/live", response_model=LiveDashboard)
def live_dashboard(db: Session = Depends(get_db)):
    today = date.today()
    purchases = db.query(FruitPurchase).filter(FruitPurchase.purchase_date == today).all()

    today_kg = 0.0
    today_value = 0.0
    producer_stats: dict[str, ProducerTodayStats] = {}
    location_stats: dict[str, LocationTodayStats] = {}

    for p in purchases:
        kg = p.qty_extra + p.qty_class1 + p.qty_class2 + p.qty_class3
        val = purchase_total(p)
        today_kg += kg
        today_value += val

        producer = db.query(Producer).filter_by(code=p.producer_code).first()
        if producer:
            if producer.code not in producer_stats:
                producer_stats[producer.code] = ProducerTodayStats(
                    code=producer.code, name=producer.name, kg=0, value=0
                )
            producer_stats[producer.code].kg += kg
            producer_stats[producer.code].value += val

            loc = db.query(PurchaseLocation).filter_by(code=producer.location_code).first()
            if loc:
                if loc.code not in location_stats:
                    location_stats[loc.code] = LocationTodayStats(
                        code=loc.code, name=loc.name, kg=0, value=0, count=0
                    )
                location_stats[loc.code].kg += kg
                location_stats[loc.code].value += val
                location_stats[loc.code].count += 1

    packaging_today = db.query(Packaging).filter(Packaging.transaction_date == today).all()
    taken = sum(p.taken for p in packaging_today)
    returned = sum(p.returned for p in packaging_today)

    totals = DashboardStats(
        purchase_locations=db.query(PurchaseLocation).count(),
        producers=db.query(Producer).count(),
        fruits=db.query(Fruit).count(),
        goods=db.query(Good).count(),
        fruit_purchases=db.query(FruitPurchase).count(),
        goods_debits=db.query(GoodsDebit).count(),
        packaging_records=db.query(Packaging).count(),
    )

    return LiveDashboard(
        date=today,
        today_kg=round(today_kg, 2),
        today_value=round(today_value, 2),
        today_purchases=len(purchases),
        today_active_producers=len(producer_stats),
        by_location=sorted(location_stats.values(), key=lambda x: -x.value),
        top_producers=sorted(producer_stats.values(), key=lambda x: -x.kg)[:10],
        packaging_taken_today=taken,
        packaging_returned_today=returned,
        totals=totals,
    )


@router.get("/reports/priznanica/pdf")
def priznanica_pdf(
    producer_code: str,
    date_from: date,
    date_to: date,
    document_no: int = 1,
    db: Session = Depends(get_db),
):
    try:
        pdf_bytes = build_priznanica_pdf(
            db,
            producer_code=producer_code,
            date_from=date_from,
            date_to=date_to,
            document_no=document_no,
        )
    except ValueError as exc:
        raise HTTPException(404, str(exc)) from exc

    filename = f"priznanica_{producer_code}_{date_to.isoformat()}.pdf"
    return Response(
        content=pdf_bytes,
        media_type="application/pdf",
        headers={"Content-Disposition": f'attachment; filename="{filename}"'},
    )
