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
echo Install Python 3.12 from https://www.python.org/downloads/
goto :fail

:have_python
echo.

if exist frontend\dist\index.html (
    echo Frontend OK.
) else (
    echo Error: frontend\dist missing. Run: git pull
    goto :fail
)

cd backend
if errorlevel 1 goto :fail

if not exist wheels\*.whl (
    echo Error: backend\wheels missing. Run: git pull
    goto :fail
)

echo Checking pip...
%PY% -m pip --version >> "%LOG%" 2>&1
if errorlevel 1 (
    %PY% -m ensurepip --upgrade >> "%LOG%" 2>&1
)

echo.
echo Installing packages from bundled wheels...
echo ^(No compiler, no download - needs Python 3.11 / 3.12 / 3.13 64-bit^)
echo.

REM ONLY offline install - never compile from source (avoids Visual C++ / greenlet errors)
%PY% -m pip install --user --no-index --find-links=wheels --only-binary=:all: -r requirements-windows.txt >> "%LOG%" 2>&1
if errorlevel 1 (
    echo.
    echo --- install failed ---
    powershell -NoProfile -Command "Get-Content '%LOG%' -Tail 20"
    goto :pip_fail
)

echo Packages OK.
echo.
echo Starting http://localhost:8000
echo Leave this window open. Ctrl+C to stop.
echo.

%PY% -m uvicorn app.main:app --host 0.0.0.0 --port 8000
if errorlevel 1 (
    echo Error: port 8000 busy or server crashed. See %LOG%
    goto :fail
)
goto :eof

:pip_fail
echo.
echo ========================================
echo   Install failed
echo ========================================
echo.
echo Most likely: wrong Python version.
echo.
echo Need Python 3.11, 3.12, or 3.13  ^(64-bit^), from python.org
echo Check version:  py -3 --version
echo List installed:  py -0p
echo.
echo If you have 3.12 installed but default is older:
echo   py -3.12 -m pip install --user --no-index --find-links=wheels -r requirements-windows.txt
echo   py -3.12 -m uvicorn app.main:app --host 0.0.0.0 --port 8000
echo.
echo Full log: %LOG%
goto :fail

:fail
echo.
pause
exit /b 1
