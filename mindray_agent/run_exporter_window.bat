@echo off
chcp 65001 >nul
title АВТОЭКСПОРТ MINDRAY BS-230 (SCAN_00)
color 0b

:start
cls
echo ==============================================================================
echo       СЛУЖБА АВТОМАТИЧЕСКОГО ЭКСПОРТА ДАННЫХ MINDRAY BS-230 (PYTHON)
echo ==============================================================================
echo.

python "%~dp0mindray_usb_exporter.py"
if errorlevel 1 (
    py "%~dp0mindray_usb_exporter.py"
)

echo.
echo [ВНИМАНИЕ] Перезапуск через 5 секунд...
timeout /t 5
goto start
