@echo off
REM Run Otkup on a single Windows machine — one port for UI + API
cd /d "%~dp0.."

REM Windows often has "py" (Python launcher) but not "python" on PATH
py -3 --version >nul 2>&1
if not errorlevel 1 (
    set "PY=py -3"
    goto :have_python
)
python --version >nul 2>&1
if not errorlevel 1 (
    set "PY=python"
    goto :have_python
)
echo Error: Python 3 not found.
echo Install from https://www.python.org/downloads/ and check "Add Python to PATH".
echo On Windows you usually run Python with: py -3
exit /b 1

:have_python
echo Installing frontend dependencies...
cd frontend
call npm install
call npm run build
if errorlevel 1 exit /b 1

echo Starting Otkup on http://localhost:8000
cd ..\backend
if not exist .venv (
    echo Creating Python virtual environment...
    %PY% -m venv .venv
)
call .venv\Scripts\activate.bat
pip install -r requirements.txt -q
uvicorn app.main:app --host 0.0.0.0 --port 8000
