@echo off
chcp 65001 >nul
title Удаление автоэкспорта Mindray BS-230
color 0c

echo ==============================================================================
echo       ОСТАНОВКА И УДАЛЕНИЕ АВТОЭКСПОРТА MINDRAY BS-230
echo ==============================================================================
echo.

echo [1/2] Остановка всех окон и процессов...
powershell -NoProfile -Command "Get-Process python, pythonw, powershell, wscript, cmd -ErrorAction SilentlyContinue | Where-Object { $_.MainWindowTitle -match 'MINDRAY' -or $_.CommandLine -match 'mindray' } | Stop-Process -Force -ErrorAction SilentlyContinue" >nul 2>&1
echo   -^> Процессы остановлены.

echo.
echo [2/2] Очистка автозагрузки Windows...
set "STARTUP_DIR=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
if exist "%STARTUP_DIR%\Mindray_BS230_AutoExport.lnk" (
    del /f /q "%STARTUP_DIR%\Mindray_BS230_AutoExport.lnk"
    echo   -^> Ярлык удален из автозагрузки.
)

echo.
echo ==============================================================================
echo Агент полностью остановлен и удален.
echo ==============================================================================
echo.
pause
