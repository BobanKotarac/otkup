#!/usr/bin/env python3
"""CLI tool to import legacy DBF files (for technicians / batch migrations)."""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from app.database import SessionLocal, Base, engine
from app.services.dbf_import import SUPPORTED_TABLES, import_dbf_files


def collect_dbf_files(path: Path) -> dict[str, Path]:
    if path.is_file() and path.suffix.lower() == ".dbf":
        return {path.stem.lower(): path}
    if path.is_dir():
        return {p.stem.lower(): p for p in path.glob("*.dbf")} | {
            p.stem.lower(): p for p in path.glob("*.DBF")
        }
    raise SystemExit(f"Not a .dbf file or directory: {path}")


def main() -> None:
    parser = argparse.ArgumentParser(description="Import Clipper DBF files into Otkup database")
    parser.add_argument("path", help="Path to a .dbf file or folder containing .dbf files")
    parser.add_argument(
        "--clear",
        action="store_true",
        help="Delete existing data before import (recommended for first client migration)",
    )
    args = parser.parse_args()

    source = Path(args.path)
    files = collect_dbf_files(source)
    if not files:
        raise SystemExit("No .dbf files found")

    missing = SUPPORTED_TABLES - set(files.keys())
    if missing:
        print(f"Warning: missing optional tables: {', '.join(sorted(missing))}")

    Base.metadata.create_all(bind=engine)
    db = SessionLocal()
    try:
        report = import_dbf_files(db, files, clear_existing=args.clear, source_label=str(source))
    finally:
        db.close()

    print(f"\nImport complete — {report.total_imported} records")
    for r in report.results:
        status = "OK" if not r.errors else "ERRORS"
        print(f"  [{status}] {r.filename} → {r.table}: {r.imported} imported, {r.skipped} skipped")
        for err in r.errors[:5]:
            print(f"         {err}")
    if report.files_unrecognized:
        print(f"  Unrecognized: {', '.join(report.files_unrecognized)}")


if __name__ == "__main__":
    main()
