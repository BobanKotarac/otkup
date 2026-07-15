#!/usr/bin/env bash
# Maintainer script: refresh backend/wheels/ for Windows 32-bit and 64-bit
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
REQ="$ROOT/backend/requirements-windows-core.txt"
OUT="$ROOT/backend/wheels"
PY="${PYTHON:-python3}"

mkdir -p "$OUT"
for arch in win_amd64 win32; do
  for ver in 3.11 3.12 3.13; do
    echo "Downloading $arch Python $ver..."
    "$PY" -m pip download -r "$REQ" -d "$OUT" \
      --platform "$arch" --python-version "$ver" --only-binary=:all:
  done
done
echo "Done. $(ls "$OUT"/*.whl | wc -l | tr -d ' ') wheels in $OUT"
