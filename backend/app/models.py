from datetime import date, datetime

from sqlalchemy import Boolean, Date, DateTime, Float, Integer, String, Text, func
from sqlalchemy.orm import Mapped, mapped_column

from app.database import Base


class Company(Base):
    __tablename__ = "company"

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    name: Mapped[str] = mapped_column(String(80), default="")
    address: Mapped[str] = mapped_column(String(80), default="")
    city: Mapped[str] = mapped_column(String(80), default="")
    phone: Mapped[str] = mapped_column(String(40), default="")
    bank_account: Mapped[str] = mapped_column(String(40), default="")
    tax_id: Mapped[str] = mapped_column(String(20), default="")
    registration_number: Mapped[str] = mapped_column(String(20), default="")
    activity_code: Mapped[str] = mapped_column(String(20), default="")


class PurchaseLocation(Base):
    __tablename__ = "purchase_locations"

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    code: Mapped[str] = mapped_column(String(10), unique=True, index=True)
    name: Mapped[str] = mapped_column(String(60))
    buyer_name: Mapped[str] = mapped_column(String(40), default="")
    buyer_phone: Mapped[str] = mapped_column(String(30), default="")
    hidden: Mapped[bool] = mapped_column(Boolean, default=False)


class Producer(Base):
    __tablename__ = "producers"

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    code: Mapped[str] = mapped_column(String(10), unique=True, index=True)
    name: Mapped[str] = mapped_column(String(60))
    location_code: Mapped[str] = mapped_column(String(10), index=True)
    tax_statement: Mapped[str] = mapped_column(String(40), default="")
    contract: Mapped[str] = mapped_column(String(20), default="")
    parcel_area: Mapped[float] = mapped_column(Float, default=0)
    bank_account: Mapped[str] = mapped_column(String(30), default="")
    personal_id: Mapped[str] = mapped_column(String(20), default="")
    vat_registered: Mapped[str] = mapped_column(String(1), default="N")
    category: Mapped[str] = mapped_column(String(10), default="")


class Fruit(Base):
    __tablename__ = "fruits"

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    code: Mapped[str] = mapped_column(String(10), unique=True, index=True)
    name: Mapped[str] = mapped_column(String(40))
    price_extra: Mapped[float] = mapped_column(Float, default=0)
    price_class1: Mapped[float] = mapped_column(Float, default=0)
    price_class2: Mapped[float] = mapped_column(Float, default=0)
    price_class3: Mapped[float] = mapped_column(Float, default=0)
    vat_rate: Mapped[float] = mapped_column(Float, default=0)


class Good(Base):
    __tablename__ = "goods"

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    code: Mapped[str] = mapped_column(String(10), unique=True, index=True)
    name: Mapped[str] = mapped_column(String(40))
    price: Mapped[float] = mapped_column(Float, default=0)
    ratio_to_fruit: Mapped[float] = mapped_column(Float, default=0)
    ratio_from_fruit: Mapped[float] = mapped_column(Float, default=0)
    vat_rate: Mapped[float] = mapped_column(Float, default=0)
    unit: Mapped[str] = mapped_column(String(10), default="")
    status: Mapped[int] = mapped_column(Integer, default=1)


class FruitPurchase(Base):
    __tablename__ = "fruit_purchases"

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    producer_code: Mapped[str] = mapped_column(String(10), index=True)
    fruit_code: Mapped[str] = mapped_column(String(10), index=True)
    purchase_date: Mapped[date] = mapped_column(Date, index=True)
    qty_extra: Mapped[float] = mapped_column(Float, default=0)
    qty_class1: Mapped[float] = mapped_column(Float, default=0)
    qty_class2: Mapped[float] = mapped_column(Float, default=0)
    qty_class3: Mapped[float] = mapped_column(Float, default=0)
    document_no: Mapped[str] = mapped_column(String(10), default="")
    price_extra: Mapped[float] = mapped_column(Float, default=0)
    price_class1: Mapped[float] = mapped_column(Float, default=0)
    price_class2: Mapped[float] = mapped_column(Float, default=0)
    price_class3: Mapped[float] = mapped_column(Float, default=0)


class GoodsDebit(Base):
    __tablename__ = "goods_debits"

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    producer_code: Mapped[str] = mapped_column(String(10), index=True)
    good_code: Mapped[str] = mapped_column(String(10), index=True)
    debit_date: Mapped[date] = mapped_column(Date, index=True)
    quantity: Mapped[float] = mapped_column(Float, default=0)
    document_no: Mapped[str] = mapped_column(String(10), default="")
    unit_price: Mapped[float] = mapped_column(Float, default=0)


class Packaging(Base):
    __tablename__ = "packaging"

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    producer_code: Mapped[str] = mapped_column(String(10), index=True)
    transaction_date: Mapped[date] = mapped_column(Date, index=True)
    taken: Mapped[float] = mapped_column(Float, default=0)
    returned: Mapped[float] = mapped_column(Float, default=0)
    document_no: Mapped[str] = mapped_column(String(10), default="")


class ImportLog(Base):
    __tablename__ = "import_logs"

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    filename: Mapped[str] = mapped_column(String(255))
    table_name: Mapped[str] = mapped_column(String(50))
    records_imported: Mapped[int] = mapped_column(Integer, default=0)
    records_skipped: Mapped[int] = mapped_column(Integer, default=0)
    errors: Mapped[str] = mapped_column(Text, default="")
    created_at: Mapped[datetime] = mapped_column(DateTime, server_default=func.now())
