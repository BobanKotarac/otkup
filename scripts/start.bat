@echo off
setlocal EnableExtensions
REM Run Otkup on a single Windows machine — one port for UI + API
cd /d "%~dp0.."
if errorlevel 1 goto :fail

echo ========================================
echo   Otkup - starting...
echo ========================================
echo.

REM --- Python ---
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
echo Install from https://www.python.org/downloads/
echo Check "Add python.exe to PATH" during install.
goto :fail

:have_python
echo Python OK.

REM --- Frontend: use pre-built UI if available (no Node.js needed) ---
if exist frontend\dist\index.html (
    echo Frontend OK ^(pre-built, no npm needed^).
    goto :start_backend
)

echo Pre-built frontend not found — building with npm...
echo Node.js 20.19+ or 22.12+ is required for this step.
echo.

where npm >nul 2>&1
if errorlevel 1 (
    echo Error: npm not found.
    echo Install Node.js 22 LTS from https://nodejs.org then restart the PC.
    echo Or ask for a project copy that includes frontend\dist already built.
    goto :fail
)

for /f "delims=" %%v in ('node --version 2^>nul') do set NODEVER=%%v
echo Node version: %NODEVER%

cd frontend
if errorlevel 1 goto :fail

echo Running npm install...
call npm install --no-audit --no-fund
if errorlevel 1 (
    echo.
    echo Error: npm install failed.
    echo Run scripts\doctor.bat to save a log file and see details.
    echo Common fixes:
    echo   - Install Node.js 22 LTS from https://nodejs.org
    echo   - Restart the computer after install
    echo   - Run Command Prompt as Administrator once
    goto :fail
)

call npm run build
if errorlevel 1 (
    echo Error: frontend build failed.
    echo Node.js is probably too old. Need 20.19+ or 22.12+.
    echo Install Node.js 22 LTS from https://nodejs.org
    goto :fail
)
cd ..

:start_backend
echo.
echo Starting Otkup on http://localhost:8000
echo Leave this window open while using the app.
echo Stop the server with Ctrl+C.
echo.

cd backend
if errorlevel 1 goto :fail

if not exist .venv (
    echo Creating Python virtual environment...
    %PY% -m venv .venv
    if errorlevel 1 goto :fail
)

call .venv\Scripts\activate.bat
if errorlevel 1 goto :fail

pip install -r requirements.txt -q
if errorlevel 1 goto :fail

uvicorn app.main:app --host 0.0.0.0 --port 8000
if errorlevel 1 (
    echo Error: server stopped or port 8000 is busy.
    goto :fail
)

goto :eof

:fail
echo.
echo Press any key to close this window...
pause >nul
exit /b 1
