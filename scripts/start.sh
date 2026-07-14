#!/usr/bin/env bash
# Run Otkup on a single machine — one port for UI + API (good for demos & local use)
set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"

echo "Building frontend..."
cd "$ROOT/frontend"
npm run build --silent

echo "Starting server on http://localhost:8000"
cd "$ROOT/backend"
source .venv/bin/activate 2>/dev/null || { python3 -m venv .venv && source .venv/bin/activate && pip install -q -r requirements.txt; }
exec uvicorn app.main:app --host 0.0.0.0 --port 8000
