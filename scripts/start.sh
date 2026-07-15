#!/usr/bin/env bash
# Run Otkup on a single machine — one port for UI + API (good for demos & local use)
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PORT="${PORT:-8000}"

if ! command -v node >/dev/null 2>&1; then
  echo "Error: Node.js is not installed."
  echo "Install from https://nodejs.org or run: brew install node"
  exit 1
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "Error: Python 3 is not installed."
  echo "Install from https://python.org or run: brew install python"
  exit 1
fi

if lsof -nP -iTCP:"$PORT" -sTCP:LISTEN >/dev/null 2>&1; then
  echo "Error: port $PORT is already in use by another app."
  echo ""
  echo "Something else is running on http://localhost:$PORT (not Otkup)."
  echo "Stop it with:"
  echo "  lsof -ti :$PORT | xargs kill"
  echo ""
  echo "Or start Otkup on a different port:"
  echo "  PORT=8001 ./scripts/start.sh"
  exit 1
fi

echo "Building frontend..."
cd "$ROOT/frontend"
if [ ! -d node_modules ]; then
  echo "Installing frontend dependencies..."
  npm install
fi
npm run build

echo "Starting Otkup on http://localhost:$PORT"
cd "$ROOT/backend"
if [ ! -d .venv ]; then
  echo "Creating Python virtual environment..."
  python3 -m venv .venv
fi
# shellcheck source=/dev/null
source .venv/bin/activate
pip install -q -r requirements.txt

exec uvicorn app.main:app --host 0.0.0.0 --port "$PORT"
