@echo off
chcp 65001 >nul
title Установка автоэкспорта Mindray BS-230
color 0b

echo ==============================================================================
echo       УСТАНОВКА АВТОЭКСПОРТА MINDRAY BS-230
echo ==============================================================================
echo.

set "SCRIPT_DIR=%~dp0"
set "BAT_FILE=%SCRIPT_DIR%run_exporter_window.bat"
set "STARTUP_DIR=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"

echo [1/3] Принудительная остановка старых процессов...
taskkill /F /IM powershell.exe /T >nul 2>&1
taskkill /F /IM wscript.exe /T >nul 2>&1
taskkill /F /IM python.exe /T >nul 2>&1
taskkill /F /IM pythonw.exe /T >nul 2>&1

echo.
echo [2/3] Добавление в автозапуск Windows...
powershell -NoProfile -Command "$ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut('%STARTUP_DIR%\Mindray_BS230_AutoExport.lnk'); $s.TargetPath = '%BAT_FILE%'; $s.WorkingDirectory = '%SCRIPT_DIR%'; $s.Save()"
echo   -^> Ярлык создан в Автозагрузке:
echo      %STARTUP_DIR%\Mindray_BS230_AutoExport.lnk

echo.
echo [3/3] Запуск монитора автоэкспорта...
start "" "%BAT_FILE%"

echo.
echo ==============================================================================
echo      УСТАНОВКА ПОЛНОСТЬЮ ЗАВЕРШЕНА!
echo ==============================================================================
echo  - Встроенный автономный Python готов к работе.
echo  - Открылось рабочее окно монітора.
echo  - Вставляйте любую флешку — файлы будут писаться в SCAN_00!
echo.
pause
