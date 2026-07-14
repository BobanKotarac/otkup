from datetime import date

from pydantic import BaseModel, Field


# --- Import ---

class TableImportResultSchema(BaseModel):
    table: str
    filename: str
    imported: int
    skipped: int
    errors: list[str]


class ImportReportSchema(BaseModel):
    success: bool
    total_imported: int
    files_found: list[str]
    files_unrecognized: list[str]
    results: list[TableImportResultSchema]
    supported_tables: list[str]


# --- Company ---

class CompanySchema(BaseModel):
    id: int
    name: str
    address: str
    city: str
    phone: str
    bank_account: str
    tax_id: str
    registration_number: str
    activity_code: str

    model_config = {"from_attributes": True}


class CompanyUpdate(BaseModel):
    name: str = ""
    address: str = ""
    city: str = ""
    phone: str = ""
    bank_account: str = ""
    tax_id: str = ""
    registration_number: str = ""
    activity_code: str = ""


# --- Purchase locations ---

class PurchaseLocationSchema(BaseModel):
    id: int
    code: str
    name: str
    buyer_name: str
    buyer_phone: str
    hidden: bool = False

    model_config = {"from_attributes": True}


class PurchaseLocationCreate(BaseModel):
    name: str
    buyer_name: str = ""
    buyer_phone: str = ""
    code: str | None = None


class PurchaseLocationUpdate(BaseModel):
    name: str | None = None
    buyer_name: str | None = None
    buyer_phone: str | None = None
    hidden: bool | None = None


# --- Producers ---

class ProducerSchema(BaseModel):
    id: int
    code: str
    name: str
    location_code: str
    tax_statement: str = ""
    contract: str = ""
    parcel_area: float = 0
    bank_account: str = ""
    personal_id: str = ""
    vat_registered: str = "N"
    category: str = ""

    model_config = {"from_attributes": True}


class ProducerCreate(BaseModel):
    name: str
    location_code: str
    tax_statement: str = ""
    contract: str = ""
    parcel_area: float = 0
    bank_account: str = ""
    personal_id: str = ""
    vat_registered: str = "N"
    category: str = ""
    code: str | None = None


class ProducerUpdate(BaseModel):
    name: str | None = None
    tax_statement: str | None = None
    contract: str | None = None
    parcel_area: float | None = None
    bank_account: str | None = None
    personal_id: str | None = None
    vat_registered: str | None = None
    category: str | None = None


# --- Fruits ---

class FruitSchema(BaseModel):
    id: int
    code: str
    name: str
    price_extra: float
    price_class1: float
    price_class2: float
    price_class3: float
    vat_rate: float = 0

    model_config = {"from_attributes": True}


class FruitCreate(BaseModel):
    name: str
    price_extra: float = 0
    price_class1: float = 0
    price_class2: float = 0
    price_class3: float = 0
    vat_rate: float = 0
    code: str | None = None


class FruitUpdate(BaseModel):
    name: str | None = None
    price_extra: float | None = None
    price_class1: float | None = None
    price_class2: float | None = None
    price_class3: float | None = None
    vat_rate: float | None = None


# --- Goods ---

class GoodSchema(BaseModel):
    id: int
    code: str
    name: str
    price: float
    ratio_to_fruit: float = 0
    ratio_from_fruit: float = 0
    vat_rate: float = 0
    unit: str = ""
    status: int = 1

    model_config = {"from_attributes": True}


class GoodCreate(BaseModel):
    name: str
    price: float = 0
    ratio_to_fruit: float = 0
    ratio_from_fruit: float = 0
    vat_rate: float = 0
    unit: str = ""
    status: int = 1
    code: str | None = None


class GoodUpdate(BaseModel):
    name: str | None = None
    price: float | None = None
    ratio_to_fruit: float | None = None
    ratio_from_fruit: float | None = None
    vat_rate: float | None = None
    unit: str | None = None
    status: int | None = None


# --- Fruit purchases ---

class FruitPurchaseSchema(BaseModel):
    id: int
    producer_code: str
    fruit_code: str
    purchase_date: date
    qty_extra: float
    qty_class1: float
    qty_class2: float
    qty_class3: float
    document_no: str
    price_extra: float
    price_class1: float
    price_class2: float
    price_class3: float
    producer_name: str | None = None
    fruit_name: str | None = None
    total_value: float | None = None

    model_config = {"from_attributes": True}


class FruitPurchaseCreate(BaseModel):
    producer_code: str
    fruit_code: str
    purchase_date: date | None = None
    qty_extra: float = 0
    qty_class1: float = 0
    qty_class2: float = 0
    qty_class3: float = 0
    document_no: str = ""
    crates_prep: int = 0
    crates_class1: int = 0
    crates_class2: int = 0
    crates_class3: int = 0
    crate_weight_100g: float = 5
    packaging_taken: float = 0
    packaging_returned: float = 0


class ValidationMessageSchema(BaseModel):
    code: str
    level: str
    message: str


class FruitPurchaseResponse(BaseModel):
    purchase: FruitPurchaseSchema
    warnings: list[ValidationMessageSchema] = []


# --- Goods debits ---

class GoodsDebitSchema(BaseModel):
    id: int
    producer_code: str
    good_code: str
    debit_date: date
    quantity: float
    document_no: str
    unit_price: float
    producer_name: str | None = None
    good_name: str | None = None
    total_value: float | None = None

    model_config = {"from_attributes": True}


class GoodsDebitCreate(BaseModel):
    producer_code: str
    good_code: str
    debit_date: date | None = None
    quantity: float = 0
    document_no: str = ""
    unit_price: float | None = None


# --- Packaging ---

class PackagingSchema(BaseModel):
    id: int
    producer_code: str
    transaction_date: date
    taken: float
    returned: float
    document_no: str
    producer_name: str | None = None

    model_config = {"from_attributes": True}


class PackagingCreate(BaseModel):
    producer_code: str
    transaction_date: date | None = None
    taken: float = 0
    returned: float = 0
    document_no: str = ""


# --- Reports ---

class BalanceRow(BaseModel):
    producer_code: str
    producer_name: str
    fruit_value: float
    goods_value: float
    balance: float


class DashboardStats(BaseModel):
    purchase_locations: int
    producers: int
    fruits: int
    goods: int
    fruit_purchases: int
    goods_debits: int
    packaging_records: int


class DateRangeFilter(BaseModel):
    date_from: date | None = None
    date_to: date | None = None
    location_code: str | None = None
    producer_code: str | None = None


class SetupStatus(BaseModel):
    company_configured: bool
    has_locations: bool
    has_fruits: bool
    has_goods: bool
    has_producers: bool
    complete: bool
    next_step: str


class SearchResultItem(BaseModel):
    type: str
    id: int
    code: str
    name: str
    extra: str = ""


class SearchResults(BaseModel):
    query: str
    results: list[SearchResultItem]


class LocationTodayStats(BaseModel):
    code: str
    name: str
    kg: float
    value: float
    count: int


class ProducerTodayStats(BaseModel):
    code: str
    name: str
    kg: float
    value: float


class LiveDashboard(BaseModel):
    date: date
    today_kg: float
    today_value: float
    today_purchases: int
    today_active_producers: int
    by_location: list[LocationTodayStats]
    top_producers: list[ProducerTodayStats]
    packaging_taken_today: float
    packaging_returned_today: float
    totals: DashboardStats
