@echo off
chcp 65001 >nul
title Удаление автоэкспорта биохимии
color 0c

echo ==============================================================================
echo       ОСТАНОВКА И УДАЛЕНИЕ ИЗ АВТОЗАГРУЗКИ BIOCHEM AUTOEXPORT
echo ==============================================================================
echo.

echo [1/2] Остановка фоновых процессов экспортера...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-CimInstance Win32_Process | Where-Object { $_.CommandLine -like '*biochem_usb_exporter*' -or $_.CommandLine -like '*Biochem_AutoExport*' } | ForEach-Object { Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue }" >nul 2>&1

echo [2/2] Удаление ярлыка из автозагрузки Windows...
set "STARTUP_DIR=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
if exist "%STARTUP_DIR%\Biochem_AutoExport.lnk" (
    del /f /q "%STARTUP_DIR%\Biochem_AutoExport.lnk" >nul 2>&1
    echo   -^> Ярлык удален из автозагрузки.
)

echo.
echo ==============================================================================
echo Агент полностью остановлен и удален из автозапуска.
echo ==============================================================================
echo.
pause
