@echo off
chcp 65001 >nul
title Видалення автоекспорту Mindray BS-230
color 0c

echo ==============================================================================
echo       ВИДАЛЕННЯ ТА ЗУПИНКА АГЕНТА MINDRAY BS-230
echo ==============================================================================
echo.

echo [1/3] Зупинка фонових процесів агента...
powershell -NoProfile -Command "Get-Process powershell, wscript, pythonw -ErrorAction SilentlyContinue | Where-Object { $_.CommandLine -match 'mindray' -or $_.MainWindowTitle -match 'Mindray' } | Stop-Process -Force -ErrorAction SilentlyContinue"
taskkill /F /IM wscript.exe >nul 2>&1
echo   -^> Процеси зупинено.

echo.
echo [2/3] Очищення автозавантаження Windows...
set "STARTUP_DIR=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
if exist "%STARTUP_DIR%\Mindray_BS230_AutoExport.lnk" (
    del /f /q "%STARTUP_DIR%\Mindray_BS230_AutoExport.lnk"
    echo   -^> Старий ярлик видалено з Startup.
)
if exist "%STARTUP_DIR%\Mindray_AutoExport.lnk" (
    del /f /q "%STARTUP_DIR%\Mindray_AutoExport.lnk"
    echo   -^> Старий ярлик видалено з Startup.
)

echo.
echo [3/3] Готово!
echo ==============================================================================
echo Агент повністю видалено та зупинено.
echo ==============================================================================
echo.
pause
