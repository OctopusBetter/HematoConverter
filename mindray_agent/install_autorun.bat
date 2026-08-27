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

:: 1. Проверка Python
python --version >nul 2>&1
if %errorlevel% neq 0 (
    py --version >nul 2>&1
    if %errorlevel% neq 0 (
        echo [!] Python не обнаружен. Запускаем автоматическую установку...
        call "%SCRIPT_DIR%install_python.bat"
    )
)

echo.
echo [1/3] Остановка старых фоновых окон...
powershell -NoProfile -Command "Get-Process python, pythonw, powershell, wscript, cmd -ErrorAction SilentlyContinue | Where-Object { $_.MainWindowTitle -match 'MINDRAY' -or $_.CommandLine -match 'mindray' } | Stop-Process -Force -ErrorAction SilentlyContinue" >nul 2>&1
echo   -^> Предыдущие процессы остановлены.

echo.
echo [2/3] Добавление в автозапуск Windows...
powershell -NoProfile -Command "$ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut('%STARTUP_DIR%\Mindray_BS230_AutoExport.lnk'); $s.TargetPath = '%BAT_FILE%'; $s.WorkingDirectory = '%SCRIPT_DIR%'; $s.Save()"
echo   -^> Ярлык автозапуска создан:
echo      %STARTUP_DIR%\Mindray_BS230_AutoExport.lnk

echo.
echo [3/3] Запуск мониторинга...
start "" "%BAT_FILE%"

echo.
echo ==============================================================================
echo      УСТАНОВКА УСПЕШНО ЗАВЕРШЕНА!
echo ==============================================================================
echo  - Открылось рабочее окно монітора.
echo  - Вставьте флешку — данные запишутся в папку SCAN_00 автоматически!
echo.
pause
