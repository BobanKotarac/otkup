@echo off
REM Run Otkup on a single Windows machine — one port for UI + API
cd /d "%~dp0.."

echo Installing frontend dependencies...
cd frontend
call npm install
call npm run build
if errorlevel 1 exit /b 1

echo Starting server on http://localhost:8000
cd ..\backend
if not exist .venv (
    python -m venv .venv
)
call .venv\Scripts\activate.bat
pip install -r requirements.txt -q
uvicorn app.main:app --host 0.0.0.0 --port 8000
