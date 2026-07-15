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
echo On many PCs you can run: py -3
goto :fail

:have_python
echo Python OK.

REM --- Node.js / npm ---
where npm >nul 2>&1
if errorlevel 1 (
    echo Error: npm not found. Node.js is not installed or not on PATH.
    echo Install Node.js LTS from https://nodejs.org
    echo Then close this window, restart the computer, and run start.bat again.
    goto :fail
)
echo Node.js OK.
echo.

echo Installing frontend dependencies...
cd frontend
if errorlevel 1 (
    echo Error: frontend folder not found. Are you in the otkup project?
    goto :fail
)
call npm install
if errorlevel 1 (
    echo Error: npm install failed.
    goto :fail
)
call npm run build
if errorlevel 1 (
    echo Error: frontend build failed.
    goto :fail
)

echo.
echo Starting Otkup on http://localhost:8000
echo Leave this window open while using the app.
echo Stop the server with Ctrl+C.
echo.
cd ..\backend
if errorlevel 1 goto :fail

if not exist .venv (
    echo Creating Python virtual environment...
    %PY% -m venv .venv
    if errorlevel 1 (
        echo Error: could not create virtual environment.
        goto :fail
    )
)

call .venv\Scripts\activate.bat
if errorlevel 1 (
    echo Error: could not activate virtual environment.
    goto :fail
)

pip install -r requirements.txt -q
if errorlevel 1 (
    echo Error: pip install failed.
    goto :fail
)

uvicorn app.main:app --host 0.0.0.0 --port 8000
if errorlevel 1 (
    echo Error: server stopped or failed to start.
    echo If port 8000 is busy, close the other program using it and try again.
    goto :fail
)

goto :eof

:fail
echo.
echo Press any key to close this window...
pause >nul
exit /b 1
