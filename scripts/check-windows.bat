@echo off
setlocal EnableExtensions
cd /d "%~dp0.."

echo ========================================
echo   Otkup - Windows check
echo ========================================
echo.

echo [1] Python version
py -3 --version 2>nul || echo   NOT FOUND
echo.

echo [2] 32 or 64 bit
py -3 -c "import struct; print('  ', struct.calcsize('P')*8, 'bit')" 2>nul || echo   FAILED
echo.

echo [3] pip
py -3 -m pip --version 2>nul || echo   NOT FOUND
echo.

echo [4] frontend\dist
if exist frontend\dist\index.html (echo   OK) else (echo   MISSING - git pull)
echo.

echo [5] backend\wheels
if exist backend\wheels\*.whl (
    for /f %%c in ('dir /b backend\wheels\*.whl 2^>nul ^| find /c /v ""') do echo   %%c wheel files
    if exist backend\wheels\pydantic_core-2.46.4-cp313-cp313-win32.whl (echo   cp313 32-bit wheels: OK) else (echo   cp313 32-bit wheels: MISSING)
    if exist backend\wheels\pydantic_core-2.46.4-cp313-cp313-win_amd64.whl (echo   cp313 64-bit wheels: OK) else (echo   cp313 64-bit wheels: MISSING)
) else (
    echo   MISSING - git pull needed
)
echo.

echo [6] Test install
cd backend
py -3 -m pip install --no-index --find-links=wheels -r requirements-windows.txt
if errorlevel 1 (
    echo   INSTALL: FAILED ^(see errors above^)
) else (
    echo   INSTALL: OK
)
cd ..
echo.
pause
