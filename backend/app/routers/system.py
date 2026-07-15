from fastapi import APIRouter, Depends, File, Form, HTTPException, UploadFile
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
from app.schemas import DashboardStats, ImportReportSchema, TableImportResultSchema
from app.services.dbf_import import IMPORT_ORDER, extract_dbf_files, import_dbf_files

router = APIRouter(prefix="/api", tags=["system"])


@router.get("/health")
def health():
    return {"status": "ok", "version": "0.2.1", "features": ["otkup-receipt"]}


@router.get("/stats", response_model=DashboardStats)
def stats(db: Session = Depends(get_db)):
    return DashboardStats(
        purchase_locations=db.query(PurchaseLocation).count(),
        producers=db.query(Producer).count(),
        fruits=db.query(Fruit).count(),
        goods=db.query(Good).count(),
        fruit_purchases=db.query(FruitPurchase).count(),
        goods_debits=db.query(GoodsDebit).count(),
        packaging_records=db.query(Packaging).count(),
    )


@router.get("/import/supported-tables")
def supported_tables():
    return {
        "tables": [
            {
                "dbf_file": dbf,
                "model": model,
                "description": _table_description(dbf),
            }
            for dbf, model in IMPORT_ORDER
        ]
    }


def _table_description(dbf: str) -> str:
    descriptions = {
        "company": "Company profile (COMPANY.DBF)",
        "mesta": "Purchase locations (MESTA.DBF)",
        "voce": "Fruit types and prices (VOCE.DBF)",
        "roba": "Goods catalog (ROBA.DBF)",
        "kom": "Producers / partners (KOM.DBF)",
        "otkup": "Fruit purchase transactions (OTKUP.DBF)",
        "zaduz": "Goods debit transactions (ZADUZ.DBF)",
        "amb": "Packaging transactions (AMB.DBF)",
    }
    return descriptions.get(dbf, dbf)


@router.post("/import/dbf", response_model=ImportReportSchema)
async def import_dbf(
    file: UploadFile = File(...),
    clear_existing: bool = Form(False),
    db: Session = Depends(get_db),
):
    if not file.filename:
        raise HTTPException(400, "Filename is required")

    lower = file.filename.lower()
    if not (lower.endswith(".dbf") or lower.endswith(".zip")):
        raise HTTPException(400, "Upload a .dbf file or .zip archive of .dbf files")

    content = await file.read()
    if not content:
        raise HTTPException(400, "Empty file")

    try:
        files = extract_dbf_files(content, file.filename)
    except ValueError as exc:
        raise HTTPException(400, str(exc)) from exc

    if not files:
        raise HTTPException(400, "No .dbf files found in upload")

    report = import_dbf_files(
        db,
        files,
        clear_existing=clear_existing,
        source_label=file.filename,
    )

    return ImportReportSchema(
        success=report.success,
        total_imported=report.total_imported,
        files_found=report.files_found,
        files_unrecognized=report.files_unrecognized,
        results=[
            TableImportResultSchema(
                table=r.table,
                filename=r.filename,
                imported=r.imported,
                skipped=r.skipped,
                errors=r.errors,
            )
            for r in report.results
        ],
        supported_tables=[dbf for dbf, _ in IMPORT_ORDER],
    )
