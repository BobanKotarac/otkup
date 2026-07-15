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
echo Install Python 3.12 or 3.13 from https://www.python.org/downloads/
goto :fail

:have_python
echo.

REM --- Report 32 or 64 bit (both supported) ---
%PY% -c "import struct; b=struct.calcsize('P')*8; print('Python', b, 'bit')" 2>> "%LOG%"
echo.

if exist frontend\dist\index.html (
    echo Frontend OK.
) else (
    echo Error: frontend\dist missing. Run: git pull
    goto :fail
)

cd backend
if errorlevel 1 goto :fail

if not exist wheels (
    echo Error: backend\wheels folder missing. Run: git pull
    goto :fail
)

dir /b wheels\*.whl >nul 2>&1
if errorlevel 1 (
    echo Error: backend\wheels is empty. Run: git pull
    goto :fail
)

echo Wheels folder OK.
echo.

echo Checking pip...
%PY% -m pip --version >> "%LOG%" 2>&1
if errorlevel 1 (
    echo Installing pip...
    %PY% -m ensurepip --upgrade
)

echo.
echo Installing packages from bundled wheels...
echo 32-bit and 64-bit Windows both supported.
echo.

call :install_wheels --user
if not errorlevel 1 goto :packages_ok

echo.
echo Retry without --user...
call :install_wheels
if not errorlevel 1 goto :packages_ok

goto :pip_fail

:install_wheels
if "%~1"=="--user" (
    set "PIPFLAGS=--user"
) else (
    set "PIPFLAGS="
)
%PY% -m pip install %PIPFLAGS% --no-index --find-links=wheels --only-binary=:all: -r requirements-windows-core.txt
if errorlevel 1 exit /b 1
REM SQLAlchemy auto-requires greenlet on 32-bit — skip deps (not needed for SQLite)
%PY% -m pip install %PIPFLAGS% --no-index --find-links=wheels --only-binary=:all: --no-deps sqlalchemy==2.0.51
exit /b %errorlevel%

:packages_ok
echo.
echo Packages OK.
echo Starting http://localhost:8000
echo Leave this window open. Ctrl+C to stop.
echo.

%PY% -m uvicorn app.main:app --host 0.0.0.0 --port 8000
if errorlevel 1 (
    echo Error: port 8000 busy or server crashed.
    goto :fail
)
goto :eof

:pip_fail
echo.
echo ========================================
echo   Install failed
echo ========================================
echo.
echo Python %PY% — versions 3.11 / 3.12 / 3.13 supported ^(32 or 64 bit^).
echo.
echo Common causes:
echo   1. backend\wheels not downloaded - run: git pull
echo   2. Old pip - run: py -3 -m pip install --upgrade pip
echo.
echo Manual test ^(copy/paste in Command Prompt^):
echo   cd %CD%
echo   py -3 -m pip install --no-index --find-links=wheels -r requirements-windows-core.txt
echo   py -3 -m pip install --no-index --find-links=wheels --no-deps sqlalchemy==2.0.51
echo   py -3 -m uvicorn app.main:app --port 8000
echo.
echo Send otkup-start.log if still stuck.
goto :fail

:fail
echo.
pause
exit /b 1
