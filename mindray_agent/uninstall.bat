@echo off
chcp 65001 >nul
title Видалення автоекспорту Mindray BS-230
color 0c

echo ==============================================================================
echo       ВИДАЛЕННЯ ТА ЗУПИНКА АГЕНТА MINDRAY BS-230
echo ==============================================================================
echo.

echo [1/2] Зупинка вікон та процесів агента...
powershell -NoProfile -Command "Get-Process powershell, wscript, pythonw, cmd -ErrorAction SilentlyContinue | Where-Object { $_.MainWindowTitle -match 'MINDRAY' -or $_.CommandLine -match 'mindray' } | Stop-Process -Force -ErrorAction SilentlyContinue"
echo   -^> Процеси зупинено.

echo.
echo [2/2] Очищення автозавантаження Windows...
set "STARTUP_DIR=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
if exist "%STARTUP_DIR%\Mindray_BS230_AutoExport.lnk" (
    del /f /q "%STARTUP_DIR%\Mindray_BS230_AutoExport.lnk"
    echo   -^> Ярлик видалено з автозавантаження.
)

echo.
echo ==============================================================================
echo Агент повністю видалено та зупинено.
echo ==============================================================================
echo.
pause
