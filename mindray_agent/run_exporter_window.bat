@echo off
chcp 65001 >nul
title АВТОЭКСПОРТ MINDRAY BS-230 (SCAN_00)
color 0b

:start
cls
echo ==============================================================================
echo       СЛУЖБА АВТОМАТИЧЕСКОГО ЭКСПОРТА ДАННЫХ MINDRAY BS-230
echo ==============================================================================
echo.
echo  - Этот монитор ожидает подключения любой USB-флешки.
echo  - При вставке флешки данные автоматически записываются в папку SCAN_00.
echo  - Вы можете СВЕРНУТЬ это окно, но не закрывайте его во время работы.
echo.
echo ==============================================================================
echo.

:: 1. Проверяем команду python
python --version >nul 2>&1
if %errorlevel% equ 0 (
    python "%~dp0mindray_usb_exporter.py"
    goto restart
)

:: 2. Проверяем команду py
py --version >nul 2>&1
if %errorlevel% equ 0 (
    py "%~dp0mindray_usb_exporter.py"
    goto restart
)

:: 3. Если Python не установлен — работает 100% автономный встроенный движок Windows
echo [INFO] Запуск автономного движка Windows...
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0mindray_export_engine.ps1"

:restart
echo.
echo [ВНИМАНИЕ] Перезапуск через 5 секунд...
timeout /t 5
goto start
