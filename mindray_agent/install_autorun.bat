@echo off
chcp 65001 >nul
title Установка автоэкспорта Mindray BS-230
color 0b

echo ==============================================================================
echo       УСТАНОВКА АВТОЭКСПОРТА MINDRAY BS-230 В АВТОЗАГРУЗКУ
echo ==============================================================================
echo.

set "SCRIPT_DIR=%~dp0"
set "BAT_FILE=%SCRIPT_DIR%run_exporter_window.bat"
set "STARTUP_DIR=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"

echo [1/3] Остановка старых процессов...
powershell -NoProfile -Command "Get-Process python, pythonw, powershell, wscript -ErrorAction SilentlyContinue | Where-Object { $_.MainWindowTitle -match 'MINDRAY' -or $_.CommandLine -match 'mindray' } | Stop-Process -Force -ErrorAction SilentlyContinue" >nul 2>&1

echo.
echo [2/3] Добавление в автозапуск Windows...
powershell -NoProfile -Command "$ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut('%STARTUP_DIR%\Mindray_BS230_AutoExport.lnk'); $s.TargetPath = '%BAT_FILE%'; $s.WorkingDirectory = '%SCRIPT_DIR%'; $s.Save()"

echo.
echo [3/3] Запуск программы...
start "" "%BAT_FILE%"

echo.
echo ==============================================================================
echo УСТАНОВКА ЗАВЕРШЕНА! Открылось рабочее окно монітора.
echo ==============================================================================
echo.
pause
