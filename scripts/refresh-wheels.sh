#!/usr/bin/env bash
# Maintainer script: refresh backend/wheels/ for Windows (run on Mac/Linux before release)
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
REQ="$ROOT/backend/requirements-windows.txt"
OUT="$ROOT/backend/wheels"
PY="${PYTHON:-python3}"

mkdir -p "$OUT"
for ver in 3.11 3.12 3.13; do
  echo "Downloading wheels for Python $ver..."
  "$PY" -m pip download -r "$REQ" -d "$OUT" \
    --platform win_amd64 --python-version "$ver" --only-binary=:all:
done
echo "Done. $(ls "$OUT"/*.whl | wc -l | tr -d ' ') wheels in $OUT"
