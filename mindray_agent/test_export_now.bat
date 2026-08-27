@echo off
chcp 65001 >nul
title ТЕСТ ЭКСПОРТА MINDRAY BS-230
color 0e

python "%~dp0mindray_usb_exporter.py" --once
if errorlevel 1 (
    py "%~dp0mindray_usb_exporter.py" --once
)

echo.
pause
