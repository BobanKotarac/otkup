from datetime import date

from fastapi import APIRouter, Depends, HTTPException, Query
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
    BalanceRow,
    CompanySchema,
    CompanyUpdate,
    FruitCreate,
    FruitPurchaseCreate,
    FruitPurchaseResponse,
    FruitPurchaseSchema,
    FruitSchema,
    FruitUpdate,
    GoodCreate,
    GoodsDebitCreate,
    GoodsDebitSchema,
    GoodSchema,
    GoodUpdate,
    PackagingCreate,
    PackagingSchema,
    ProducerCreate,
    ProducerSchema,
    ProducerUpdate,
    PurchaseLocationCreate,
    PurchaseLocationSchema,
    PurchaseLocationUpdate,
    ValidationMessageSchema,
)
from app.services.codes import (
    next_fruit_code,
    next_good_code,
    next_location_code,
    next_producer_code,
    purchase_total,
)
from app.services.validation import has_blocking_errors, validate_fruit_purchase

router = APIRouter(prefix="/api", tags=["master-data & transactions"])


# --- Company ---

@router.get("/company", response_model=CompanySchema | None)
def get_company(db: Session = Depends(get_db)):
    return db.query(Company).first()


@router.put("/company", response_model=CompanySchema)
def upsert_company(data: CompanyUpdate, db: Session = Depends(get_db)):
    company = db.query(Company).first()
    if not company:
        company = Company()
        db.add(company)
    for field, value in data.model_dump().items():
        setattr(company, field, value)
    db.commit()
    db.refresh(company)
    return company


# --- Purchase locations ---

@router.get("/purchase-locations", response_model=list[PurchaseLocationSchema])
def list_purchase_locations(
    include_hidden: bool = False,
    db: Session = Depends(get_db),
):
    q = db.query(PurchaseLocation)
    if not include_hidden:
        q = q.filter(PurchaseLocation.hidden.is_(False))
    return q.order_by(PurchaseLocation.name).all()


@router.post("/purchase-locations", response_model=PurchaseLocationSchema, status_code=201)
def create_purchase_location(data: PurchaseLocationCreate, db: Session = Depends(get_db)):
    code = data.code or next_location_code(db)
    if db.query(PurchaseLocation).filter_by(code=code).first():
        raise HTTPException(400, f"Location code {code} already exists")
    loc = PurchaseLocation(
        code=code,
        name=data.name,
        buyer_name=data.buyer_name,
        buyer_phone=data.buyer_phone,
    )
    db.add(loc)
    db.commit()
    db.refresh(loc)
    return loc


@router.put("/purchase-locations/{loc_id}", response_model=PurchaseLocationSchema)
def update_purchase_location(
    loc_id: int, data: PurchaseLocationUpdate, db: Session = Depends(get_db)
):
    loc = db.get(PurchaseLocation, loc_id)
    if not loc:
        raise HTTPException(404, "Location not found")
    for field, value in data.model_dump(exclude_unset=True).items():
        setattr(loc, field, value)
    db.commit()
    db.refresh(loc)
    return loc


@router.delete("/purchase-locations/{loc_id}", status_code=204)
def delete_purchase_location(loc_id: int, db: Session = Depends(get_db)):
    loc = db.get(PurchaseLocation, loc_id)
    if not loc:
        raise HTTPException(404, "Location not found")
    loc.hidden = True
    db.commit()


# --- Producers ---

@router.get("/producers", response_model=list[ProducerSchema])
def list_producers(
    location_code: str | None = None,
    db: Session = Depends(get_db),
):
    q = db.query(Producer)
    if location_code:
        q = q.filter(Producer.location_code == location_code)
    return q.order_by(Producer.name).all()


@router.post("/producers", response_model=ProducerSchema, status_code=201)
def create_producer(data: ProducerCreate, db: Session = Depends(get_db)):
    if not db.query(PurchaseLocation).filter_by(code=data.location_code).first():
        raise HTTPException(400, f"Unknown location code: {data.location_code}")
    code = data.code or next_producer_code(db, data.location_code)
    if db.query(Producer).filter_by(code=code).first():
        raise HTTPException(400, f"Producer code {code} already exists")
    producer = Producer(code=code, **data.model_dump(exclude={"code"}))
    db.add(producer)
    db.commit()
    db.refresh(producer)
    return producer


@router.put("/producers/{producer_id}", response_model=ProducerSchema)
def update_producer(
    producer_id: int, data: ProducerUpdate, db: Session = Depends(get_db)
):
    producer = db.get(Producer, producer_id)
    if not producer:
        raise HTTPException(404, "Producer not found")
    for field, value in data.model_dump(exclude_unset=True).items():
        setattr(producer, field, value)
    db.commit()
    db.refresh(producer)
    return producer


@router.delete("/producers/{producer_id}", status_code=204)
def delete_producer(producer_id: int, db: Session = Depends(get_db)):
    producer = db.get(Producer, producer_id)
    if not producer:
        raise HTTPException(404, "Producer not found")
    db.delete(producer)
    db.commit()


# --- Fruits ---

@router.get("/fruits", response_model=list[FruitSchema])
def list_fruits(db: Session = Depends(get_db)):
    return db.query(Fruit).order_by(Fruit.name).all()


@router.post("/fruits", response_model=FruitSchema, status_code=201)
def create_fruit(data: FruitCreate, db: Session = Depends(get_db)):
    code = data.code or next_fruit_code(db)
    if db.query(Fruit).filter_by(code=code).first():
        raise HTTPException(400, f"Fruit code {code} already exists")
    fruit = Fruit(code=code, **data.model_dump(exclude={"code"}))
    db.add(fruit)
    db.commit()
    db.refresh(fruit)
    return fruit


@router.put("/fruits/{fruit_id}", response_model=FruitSchema)
def update_fruit(fruit_id: int, data: FruitUpdate, db: Session = Depends(get_db)):
    fruit = db.get(Fruit, fruit_id)
    if not fruit:
        raise HTTPException(404, "Fruit not found")
    for field, value in data.model_dump(exclude_unset=True).items():
        setattr(fruit, field, value)
    db.commit()
    db.refresh(fruit)
    return fruit


@router.delete("/fruits/{fruit_id}", status_code=204)
def delete_fruit(fruit_id: int, db: Session = Depends(get_db)):
    fruit = db.get(Fruit, fruit_id)
    if not fruit:
        raise HTTPException(404, "Fruit not found")
    db.delete(fruit)
    db.commit()


# --- Goods ---

@router.get("/goods", response_model=list[GoodSchema])
def list_goods(db: Session = Depends(get_db)):
    return db.query(Good).order_by(Good.name).all()


@router.post("/goods", response_model=GoodSchema, status_code=201)
def create_good(data: GoodCreate, db: Session = Depends(get_db)):
    code = data.code or next_good_code(db)
    if db.query(Good).filter_by(code=code).first():
        raise HTTPException(400, f"Good code {code} already exists")
    good = Good(code=code, **data.model_dump(exclude={"code"}))
    db.add(good)
    db.commit()
    db.refresh(good)
    return good


@router.put("/goods/{good_id}", response_model=GoodSchema)
def update_good(good_id: int, data: GoodUpdate, db: Session = Depends(get_db)):
    good = db.get(Good, good_id)
    if not good:
        raise HTTPException(404, "Good not found")
    for field, value in data.model_dump(exclude_unset=True).items():
        setattr(good, field, value)
    db.commit()
    db.refresh(good)
    return good


@router.delete("/goods/{good_id}", status_code=204)
def delete_good(good_id: int, db: Session = Depends(get_db)):
    good = db.get(Good, good_id)
    if not good:
        raise HTTPException(404, "Good not found")
    db.delete(good)
    db.commit()


# --- Fruit purchases ---

def _enrich_purchase(p: FruitPurchase, db: Session) -> FruitPurchaseSchema:
    producer = db.query(Producer).filter_by(code=p.producer_code).first()
    fruit = db.query(Fruit).filter_by(code=p.fruit_code).first()
    return FruitPurchaseSchema(
        **{c.name: getattr(p, c.name) for c in FruitPurchase.__table__.columns},
        producer_name=producer.name if producer else None,
        fruit_name=fruit.name if fruit else None,
        total_value=purchase_total(p),
    )


@router.get("/fruit-purchases", response_model=list[FruitPurchaseSchema])
def list_fruit_purchases(
    date_from: date | None = None,
    date_to: date | None = None,
    location_code: str | None = None,
    producer_code: str | None = None,
    db: Session = Depends(get_db),
):
    q = db.query(FruitPurchase)
    if date_from:
        q = q.filter(FruitPurchase.purchase_date >= date_from)
    if date_to:
        q = q.filter(FruitPurchase.purchase_date <= date_to)
    if producer_code:
        q = q.filter(FruitPurchase.producer_code == producer_code)
    elif location_code:
        codes = [
            p.code
            for p in db.query(Producer).filter(Producer.location_code == location_code).all()
        ]
        if codes:
            q = q.filter(FruitPurchase.producer_code.in_(codes))
        else:
            return []
    purchases = q.order_by(FruitPurchase.purchase_date.desc()).limit(500).all()
    return [_enrich_purchase(p, db) for p in purchases]


@router.post("/fruit-purchases", response_model=FruitPurchaseResponse, status_code=201)
def create_fruit_purchase(data: FruitPurchaseCreate, db: Session = Depends(get_db)):
    producer = db.query(Producer).filter_by(code=data.producer_code).first()
    fruit = db.query(Fruit).filter_by(code=data.fruit_code).first()
    if not producer:
        raise HTTPException(400, "Producer not found")
    if not fruit:
        raise HTTPException(400, "Fruit not found")

    purchase_date = data.purchase_date or date.today()
    tare = data.crate_weight_100g * 0.1
    qty_extra = max(data.qty_extra - data.crates_prep * tare, 0)
    qty_class1 = max(data.qty_class1 - data.crates_class1 * tare, 0)
    qty_class2 = max(data.qty_class2 - data.crates_class2 * tare, 0)
    qty_class3 = max(data.qty_class3 - data.crates_class3 * tare, 0)

    messages = validate_fruit_purchase(
        db,
        producer_code=data.producer_code,
        fruit_code=data.fruit_code,
        purchase_date=purchase_date,
        document_no=data.document_no,
        total_kg=data.qty_extra + data.qty_class1 + data.qty_class2 + data.qty_class3,
        crates_returned=data.crates_prep + data.crates_class1 + data.crates_class2 + data.crates_class3,
        crate_weight_100g=data.crate_weight_100g,
        crates_by_class=(data.crates_prep, data.crates_class1, data.crates_class2, data.crates_class3),
    )
    if has_blocking_errors(messages):
        raise HTTPException(400, messages[0].message)

    existing = (
        db.query(FruitPurchase)
        .filter_by(
            producer_code=data.producer_code,
            fruit_code=data.fruit_code,
            purchase_date=purchase_date,
            document_no=data.document_no,
        )
        .first()
        if data.document_no
        else None
    )

    if existing:
        existing.qty_extra = qty_extra
        existing.qty_class1 = qty_class1
        existing.qty_class2 = qty_class2
        existing.qty_class3 = qty_class3
        existing.price_extra = fruit.price_extra
        existing.price_class1 = fruit.price_class1
        existing.price_class2 = fruit.price_class2
        existing.price_class3 = fruit.price_class3
        purchase = existing
    else:
        purchase = FruitPurchase(
            producer_code=data.producer_code,
            fruit_code=data.fruit_code,
            purchase_date=purchase_date,
            qty_extra=qty_extra,
            qty_class1=qty_class1,
            qty_class2=qty_class2,
            qty_class3=qty_class3,
            document_no=data.document_no,
            price_extra=fruit.price_extra,
            price_class1=fruit.price_class1,
            price_class2=fruit.price_class2,
            price_class3=fruit.price_class3,
        )
        db.add(purchase)

    if data.packaging_taken > 0 or data.packaging_returned > 0:
        pkg = (
            db.query(Packaging)
            .filter_by(
                producer_code=data.producer_code,
                transaction_date=purchase_date,
                document_no=data.document_no or "",
            )
            .first()
        )
        if pkg:
            pkg.taken = data.packaging_taken
            pkg.returned = data.packaging_returned
        else:
            db.add(
                Packaging(
                    producer_code=data.producer_code,
                    transaction_date=purchase_date,
                    taken=data.packaging_taken,
                    returned=data.packaging_returned,
                    document_no=data.document_no or "",
                )
            )

    db.commit()
    db.refresh(purchase)
    return FruitPurchaseResponse(
        purchase=_enrich_purchase(purchase, db),
        warnings=[ValidationMessageSchema(**m.__dict__) for m in messages if m.level != "error"],
    )


# --- Goods debits ---

def _enrich_debit(d: GoodsDebit, db: Session) -> GoodsDebitSchema:
    producer = db.query(Producer).filter_by(code=d.producer_code).first()
    good = db.query(Good).filter_by(code=d.good_code).first()
    total = d.quantity * d.unit_price * (1 + (good.vat_rate / 100 if good else 0))
    return GoodsDebitSchema(
        **{c.name: getattr(d, c.name) for c in GoodsDebit.__table__.columns},
        producer_name=producer.name if producer else None,
        good_name=good.name if good else None,
        total_value=total,
    )


@router.get("/goods-debits", response_model=list[GoodsDebitSchema])
def list_goods_debits(
    date_from: date | None = None,
    date_to: date | None = None,
    location_code: str | None = None,
    producer_code: str | None = None,
    db: Session = Depends(get_db),
):
    q = db.query(GoodsDebit)
    if date_from:
        q = q.filter(GoodsDebit.debit_date >= date_from)
    if date_to:
        q = q.filter(GoodsDebit.debit_date <= date_to)
    if producer_code:
        q = q.filter(GoodsDebit.producer_code == producer_code)
    elif location_code:
        codes = [p.code for p in db.query(Producer).filter(Producer.location_code == location_code).all()]
        if codes:
            q = q.filter(GoodsDebit.producer_code.in_(codes))
        else:
            return []
    debits = q.order_by(GoodsDebit.debit_date.desc()).limit(500).all()
    return [_enrich_debit(d, db) for d in debits]


@router.post("/goods-debits", response_model=GoodsDebitSchema, status_code=201)
def create_goods_debit(data: GoodsDebitCreate, db: Session = Depends(get_db)):
    producer = db.query(Producer).filter_by(code=data.producer_code).first()
    good = db.query(Good).filter_by(code=data.good_code).first()
    if not producer:
        raise HTTPException(400, "Producer not found")
    if not good:
        raise HTTPException(400, "Good not found")

    debit_date = data.debit_date or date.today()
    unit_price = data.unit_price if data.unit_price is not None else good.price

    existing = (
        db.query(GoodsDebit)
        .filter_by(
            producer_code=data.producer_code,
            good_code=data.good_code,
            debit_date=debit_date,
            document_no=data.document_no,
        )
        .first()
        if data.document_no
        else None
    )

    if existing:
        existing.quantity = data.quantity
        existing.unit_price = unit_price
        db.commit()
        db.refresh(existing)
        return _enrich_debit(existing, db)

    debit = GoodsDebit(
        producer_code=data.producer_code,
        good_code=data.good_code,
        debit_date=debit_date,
        quantity=data.quantity,
        document_no=data.document_no,
        unit_price=unit_price,
    )
    db.add(debit)
    db.commit()
    db.refresh(debit)
    return _enrich_debit(debit, db)


# --- Packaging ---

def _enrich_packaging(p: Packaging, db: Session) -> PackagingSchema:
    producer = db.query(Producer).filter_by(code=p.producer_code).first()
    return PackagingSchema(
        **{c.name: getattr(p, c.name) for c in Packaging.__table__.columns},
        producer_name=producer.name if producer else None,
    )


@router.get("/packaging", response_model=list[PackagingSchema])
def list_packaging(
    date_from: date | None = None,
    date_to: date | None = None,
    producer_code: str | None = None,
    db: Session = Depends(get_db),
):
    q = db.query(Packaging)
    if date_from:
        q = q.filter(Packaging.transaction_date >= date_from)
    if date_to:
        q = q.filter(Packaging.transaction_date <= date_to)
    if producer_code:
        q = q.filter(Packaging.producer_code == producer_code)
    records = q.order_by(Packaging.transaction_date.desc()).limit(500).all()
    return [_enrich_packaging(p, db) for p in records]


@router.post("/packaging", response_model=PackagingSchema, status_code=201)
def create_packaging(data: PackagingCreate, db: Session = Depends(get_db)):
    if not db.query(Producer).filter_by(code=data.producer_code).first():
        raise HTTPException(400, "Producer not found")

    transaction_date = data.transaction_date or date.today()
    existing = (
        db.query(Packaging)
        .filter_by(
            producer_code=data.producer_code,
            transaction_date=transaction_date,
            document_no=data.document_no,
        )
        .first()
        if data.document_no
        else None
    )

    if existing:
        existing.taken = data.taken
        existing.returned = data.returned
        db.commit()
        db.refresh(existing)
        return _enrich_packaging(existing, db)

    record = Packaging(
        producer_code=data.producer_code,
        transaction_date=transaction_date,
        taken=data.taken,
        returned=data.returned,
        document_no=data.document_no,
    )
    db.add(record)
    db.commit()
    db.refresh(record)
    return _enrich_packaging(record, db)


# --- Reports ---

@router.get("/reports/balance", response_model=list[BalanceRow])
def report_balance(
    date_from: date | None = None,
    date_to: date | None = None,
    location_code: str | None = None,
    db: Session = Depends(get_db),
):
    producers_q = db.query(Producer)
    if location_code:
        producers_q = producers_q.filter(Producer.location_code == location_code)
    producers = producers_q.all()

    rows: list[BalanceRow] = []
    for producer in producers:
        purchases = db.query(FruitPurchase).filter(FruitPurchase.producer_code == producer.code)
        debits = db.query(GoodsDebit).filter(GoodsDebit.producer_code == producer.code)
        if date_from:
            purchases = purchases.filter(FruitPurchase.purchase_date >= date_from)
            debits = debits.filter(GoodsDebit.debit_date >= date_from)
        if date_to:
            purchases = purchases.filter(FruitPurchase.purchase_date <= date_to)
            debits = debits.filter(GoodsDebit.debit_date <= date_to)

        fruit_value = sum(purchase_total(p) for p in purchases.all())
        goods_value = 0.0
        for d in debits.all():
            good = db.query(Good).filter_by(code=d.good_code).first()
            vat = good.vat_rate if good else 0
            goods_value += d.quantity * d.unit_price * (1 + vat / 100)

        if fruit_value == 0 and goods_value == 0:
            continue

        rows.append(
            BalanceRow(
                producer_code=producer.code,
                producer_name=producer.name,
                fruit_value=round(fruit_value, 2),
                goods_value=round(goods_value, 2),
                balance=round(fruit_value - goods_value, 2),
            )
        )

    return sorted(rows, key=lambda r: r.producer_name)
