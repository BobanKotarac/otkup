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

REM --- Python ---
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
echo Choose Custom install - Install for all users - e.g. C:\Python312
goto :fail

:have_python
echo Python OK.
echo.>> "%LOG%"

REM --- Frontend ---
if exist frontend\dist\index.html (
    echo Frontend OK ^(pre-built^).
    goto :start_backend
)

echo Frontend build missing - need npm. See README.
goto :fail

:start_backend
echo.
echo Starting Otkup on http://localhost:8000
echo.

cd backend
if errorlevel 1 goto :fail

REM --- Virtual environment (with Windows fallbacks) ---
if not exist .venv\Scripts\python.exe (
    echo Creating Python virtual environment...
    echo Creating venv...>> "%LOG%"
    if exist .venv rmdir /s /q .venv >> "%LOG%" 2>&1

    %PY% -m venv .venv >> "%LOG%" 2>&1
    if errorlevel 1 (
        echo Standard venv failed, retrying without pip...>> "%LOG%"
        echo Venv failed - retrying ^(Windows fix^)...
        if exist .venv rmdir /s /q .venv >> "%LOG%" 2>&1
        %PY% -m venv .venv --without-pip >> "%LOG%" 2>&1
        if errorlevel 1 goto :venv_fail
        call .venv\Scripts\activate.bat
        python -m ensurepip --upgrade >> "%LOG%" 2>&1
        if errorlevel 1 (
            echo ensurepip failed, downloading pip...>> "%LOG%"
            powershell -NoProfile -Command "Invoke-WebRequest -Uri https://bootstrap.pypa.io/get-pip.py -OutFile get-pip.py" >> "%LOG%" 2>&1
            python get-pip.py >> "%LOG%" 2>&1
            del get-pip.py 2>nul
        )
    )
)

if not exist .venv\Scripts\python.exe goto :venv_fail

call .venv\Scripts\activate.bat
if errorlevel 1 goto :venv_fail

echo Installing Python packages...
python -m pip install --upgrade pip >> "%LOG%" 2>&1
python -m pip install -r requirements-windows.txt >> "%LOG%" 2>&1
if errorlevel 1 (
    echo pip install failed.>> "%LOG%"
    echo Error: could not install Python packages.
    goto :show_log
)

echo.
echo Ready. Open http://localhost:8000 in your browser.
echo Leave this window open. Stop with Ctrl+C.
echo.

python -m uvicorn app.main:app --host 0.0.0.0 --port 8000
if errorlevel 1 (
    echo Server stopped.>> "%LOG%"
    echo Error: server stopped or port 8000 is busy.
    goto :fail
)
goto :eof

:venv_fail
echo.>> "%LOG%"
echo VENV FAILED>> "%LOG%"
echo.
echo Error: could not create Python virtual environment.
echo.
echo Common fixes on Windows:
echo   1. Reinstall Python from python.org
echo      - Custom install
echo      - Install for all users
echo      - Path like C:\Python312  ^(avoid spaces in folder name^)
echo      - Check "Add python.exe to PATH"
echo   2. Delete folder: backend\.venv
echo   3. Run this script again
echo   4. Send otkup-start.log to support
goto :show_log

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
