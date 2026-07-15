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
echo Check "Add python.exe to PATH" during install.
goto :fail

:have_python
echo Python OK ^(AppData install is fine^).
echo.>> "%LOG%"

if exist frontend\dist\index.html (
    echo Frontend OK ^(pre-built^).
    goto :start_backend
)
echo Frontend build missing - run: git pull
goto :fail

:start_backend
cd backend
if errorlevel 1 goto :fail

echo.
echo Checking pip...
%PY% -m pip --version >> "%LOG%" 2>&1
if errorlevel 1 (
    echo pip missing - installing pip...
    %PY% -m ensurepip --upgrade >> "%LOG%" 2>&1
    if errorlevel 1 (
        echo Downloading pip installer...
        powershell -NoProfile -Command "Invoke-WebRequest -Uri https://bootstrap.pypa.io/get-pip.py -OutFile get-pip.py" >> "%LOG%" 2>&1
        %PY% get-pip.py --user >> "%LOG%" 2>&1
        del get-pip.py 2>nul
    )
)

echo.
echo Installing Python packages ^(first run may take 2-3 minutes^)...
echo.

%PY% -m pip install --user --upgrade pip wheel setuptools
if errorlevel 1 (
    echo pip upgrade warning - continuing...>> "%LOG%"
)

%PY% -m pip install --user -r requirements-windows.txt
if errorlevel 1 (
    echo.>> "%LOG%"
    echo --user install failed, retrying...>> "%LOG%"
    echo.
    echo Retrying install ^(without --user^)...
    %PY% -m pip install -r requirements-windows.txt >> "%LOG%" 2>&1
    if errorlevel 1 goto :pip_fail
)

echo.
echo Packages OK.
echo Starting Otkup on http://localhost:8000
echo Open that in Chrome or Edge. Leave this window open. Ctrl+C to stop.
echo.

%PY% -m uvicorn app.main:app --host 0.0.0.0 --port 8000
if errorlevel 1 (
    echo Server error.>> "%LOG%"
    echo Error: server stopped or port 8000 is busy.
    goto :show_log
)
goto :eof

:pip_fail
echo.>> "%LOG%"
echo PIP INSTALL FAILED>> "%LOG%"
echo.
echo Error: could not install Python packages.
echo.
echo Try this manually in Command Prompt:
echo   cd %CD%
echo   py -3 -m pip install -r requirements-windows.txt
echo.
echo If that fails too, send the file: otkup-start.log
goto :show_log

:show_log
echo.
echo --- Last lines from log ---
powershell -NoProfile -Command "Get-Content '%LOG%' -Tail 30"
goto :fail

:fail
echo.
echo Full log: %LOG%
echo Press any key to close...
pause >nul
exit /b 1
