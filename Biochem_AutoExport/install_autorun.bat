@echo off
chcp 65001 >nul
title Установка автоэкспорта биохимии Mindray BS-230
color 0b

echo ==============================================================================
echo       УСТАНОВКА АВТОЭКСПОРТА БИОХИМИИ MINDRAY BS-230 / BS-240
echo ==============================================================================
echo.

set "SCRIPT_DIR=%~dp0"
set "BAT_FILE=%SCRIPT_DIR%run_exporter_window.bat"
set "STARTUP_DIR=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"

echo [1/3] Перезапуск фонового процесса экспортера...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-CimInstance Win32_Process | Where-Object { $_.CommandLine -like '*biochem_usb_exporter*' } | ForEach-Object { Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue }" >nul 2>&1

echo.
echo [2/3] Добавление в автозапуск Windows...
powershell -NoProfile -Command "$ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut('%STARTUP_DIR%\Biochem_AutoExport.lnk'); $s.TargetPath = '%BAT_FILE%'; $s.WorkingDirectory = '%SCRIPT_DIR%'; $s.Save()"
echo   -^> Ярлык создан в Автозагрузке:
echo      %STARTUP_DIR%\Biochem_AutoExport.lnk

echo.
echo [3/3] Запуск рабочего окна монитора...
start "" "%BAT_FILE%"

echo.
echo ==============================================================================
echo      УСТАНОВКА ПОЛНОСТЬЮ ЗАВЕРШЕНА!
echo ==============================================================================
echo  - Встроенный автономный Python готов к работе.
echo  - Открылось рабочее окно монитора.
echo  - Вставляйте любую флешку - файлы будут автоматически писаться в SCAN_00!
echo.
pause
