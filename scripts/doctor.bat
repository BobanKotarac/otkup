@echo off
setlocal EnableExtensions
cd /d "%~dp0.."
set "LOG=%CD%\otkup-doctor.log"

echo ========================================
echo   Otkup - Windows diagnostics
echo ========================================
echo.

echo Python:>> "%LOG%"
py -3 --version 2>> "%LOG%" || python --version 2>> "%LOG%" || echo NOT FOUND>> "%LOG%"
py -3 --version 2>nul || python --version 2>nul || echo   NOT FOUND

echo pip:>> "%LOG%"
py -3 -m pip --version 2>> "%LOG%" || echo NOT FOUND>> "%LOG%"
py -3 -m pip --version 2>nul || echo   NOT FOUND

echo.>> "%LOG%"
if exist frontend\dist\index.html (echo Frontend dist: OK) else (echo Frontend dist: MISSING)

echo.
echo Testing pip install (dry run)...
cd backend
py -3 -m pip install --user -r requirements-windows.txt --dry-run >> "%LOG%" 2>&1
if errorlevel 1 (
    echo   pip: PROBLEM - see %LOG%
) else (
    echo   pip: OK
)
cd ..

echo.
echo Log saved: %LOG%
pause
