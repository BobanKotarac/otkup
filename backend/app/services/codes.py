"""Auto-generate legacy-style codes for new records."""

from sqlalchemy import func
from sqlalchemy.orm import Session

from app.models import Fruit, Good, Producer, PurchaseLocation


def _next_numeric_code(db: Session, model, field, start: int) -> str:
    max_val = db.query(func.max(field)).scalar()
    if max_val is None:
        return str(start)
    try:
        return str(int(max_val) + 1)
    except (TypeError, ValueError):
        return str(start)


def next_location_code(db: Session) -> str:
    return _next_numeric_code(db, PurchaseLocation, PurchaseLocation.code, 101)


def next_fruit_code(db: Session) -> str:
    return _next_numeric_code(db, Fruit, Fruit.code, 100)


def next_good_code(db: Session) -> str:
    return _next_numeric_code(db, Good, Good.code, 100)


def next_producer_code(db: Session, location_code: str) -> str:
    prefix = location_code.strip()
    producers = (
        db.query(Producer.code)
        .filter(Producer.location_code == prefix)
        .all()
    )
    nums = []
    for (code,) in producers:
        try:
            nums.append(int(code))
        except (TypeError, ValueError):
            continue
    if nums:
        return str(max(nums) + 1)
    try:
        base = int(prefix) * 1000
    except ValueError:
        base = 1000
    return str(base + 1)


def purchase_total(p) -> float:
    return (
        p.qty_extra * p.price_extra
        + p.qty_class1 * p.price_class1
        + p.qty_class2 * p.price_class2
        + p.qty_class3 * p.price_class3
    )
