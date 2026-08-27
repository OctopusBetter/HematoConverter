@echo off
chcp 65001 >nul
title ТЕСТ ЭКСПОРТА MINDRAY BS-230
color 0e

python --version >nul 2>&1
if %errorlevel% equ 0 (
    python "%~dp0mindray_usb_exporter.py" --once
    goto end
)

py --version >nul 2>&1
if %errorlevel% equ 0 (
    py "%~dp0mindray_usb_exporter.py" --once
    goto end
)

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0mindray_export_engine.ps1" -Once

:end
echo.
pause
