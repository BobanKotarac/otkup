@echo off
setlocal EnableExtensions
cd /d "%~dp0.."
set "LOG=%CD%\otkup-start.log"

echo Otkup start log - %DATE% %TIME% > "%LOG%"
echo Project: %CD%>> "%LOG%"
echo.>> "%LOG%"

echo ========================================
echo   Otkup - starting...
echo ========================================
echo Log file: %LOG%
echo.

REM --- Python (py launcher works with AppData installs) ---
py -3 --version >nul 2>&1
if not errorlevel 1 (
    set "PY=py -3"
    py -3 --version
    goto :have_python
)
python --version >nul 2>&1
if not errorlevel 1 (
    set "PY=python"
    python --version
    goto :have_python
)
echo Error: Python 3 not found.
echo Install from https://www.python.org/downloads/
echo Check "Add python.exe to PATH" during install.
goto :fail

:have_python
echo Python OK.
echo Using Python directly - no virtual environment ^(works with AppData install^).
echo.>> "%LOG%"

REM --- Frontend ---
if exist frontend\dist\index.html (
    echo Frontend OK ^(pre-built^).
    goto :start_backend
)

echo Frontend build missing - run git pull to get the latest version.
goto :fail

:start_backend
echo.
echo Installing / updating Python packages...
echo This may take a minute on first run.
echo.

cd backend
if errorlevel 1 goto :fail

REM Install for current user - avoids venv issues on Windows AppData Python
%PY% -m pip install --user --upgrade pip >> "%LOG%" 2>&1
%PY% -m pip install --user -r requirements-windows.txt >> "%LOG%" 2>&1
if errorlevel 1 (
    echo pip install failed.>> "%LOG%"
    echo Error: could not install Python packages.
    goto :show_log
)

echo.
echo Starting Otkup on http://localhost:8000
echo Open that address in Chrome or Edge.
echo Leave this window open. Stop with Ctrl+C.
echo.

%PY% -m uvicorn app.main:app --host 0.0.0.0 --port 8000
if errorlevel 1 (
    echo Server stopped.>> "%LOG%"
    echo Error: server stopped or port 8000 is busy.
    goto :show_log
)
goto :eof

:show_log
echo.
echo --- Last lines from log ---
powershell -NoProfile -Command "Get-Content '%LOG%' -Tail 25"
goto :fail

:fail
echo.
echo Full log: %LOG%
echo Press any key to close...
pause >nul
exit /b 1
