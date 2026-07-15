@echo off
setlocal EnableExtensions
cd /d "%~dp0.."

echo ========================================
echo   Otkup - system check
echo ========================================
echo.

echo Project folder:
cd
echo.

echo Python:
py -3 --version 2>nul || python --version 2>nul || echo   NOT FOUND
echo.

echo Node.js:
node --version 2>nul || echo   NOT FOUND
echo.

echo npm:
npm --version 2>nul || echo   NOT FOUND
echo.

echo Frontend build (dist):
if exist frontend\dist\index.html (
    echo   OK - pre-built UI found
) else (
    echo   MISSING - npm install + build required
)
echo.

echo Trying npm install (log: frontend\install.log)...
cd frontend
call npm install >install.log 2>&1
if errorlevel 1 (
    echo   FAILED - open frontend\install.log for details
    echo.
    echo Last lines of log:
    powershell -NoProfile -Command "Get-Content install.log -Tail 15"
) else (
    echo   OK
    del install.log 2>nul
)
cd ..

echo.
echo Press any key to close...
pause >nul
