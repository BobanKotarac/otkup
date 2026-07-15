@echo off
setlocal EnableExtensions
cd /d "%~dp0.."
set "LOG=%CD%\otkup-start.log"

echo ========================================
echo   Otkup - Windows diagnostics
echo ========================================
echo Log: %LOG%
echo.

echo [Python]>> "%LOG%"
py -3 --version 2>> "%LOG%" || python --version 2>> "%LOG%" || echo NOT FOUND
py -3 --version 2>nul || python --version 2>nul || echo Python: NOT FOUND

echo.
echo [Node]>> "%LOG%"
node --version 2>> "%LOG%" || echo NOT FOUND>> "%LOG%"
node --version 2>nul || echo Node: NOT FOUND

echo.
echo [Frontend dist]>> "%LOG%"
if exist frontend\dist\index.html (echo OK) else (echo MISSING)

echo.
echo [Test venv creation]>> "%LOG%"
cd backend
if exist .venv-test rmdir /s /q .venv-test
py -3 -m venv .venv-test >> "%LOG%" 2>&1
if errorlevel 1 (
    echo VENV TEST: FAILED
    echo See %LOG%
) else (
    echo VENV TEST: OK
    rmdir /s /q .venv-test
)
cd ..

echo.
echo --- Last 20 log lines ---
powershell -NoProfile -Command "Get-Content '%LOG%' -Tail 20"
echo.
pause
