@echo off
chcp 65001 >nul
title ТЕСТ ЭКСПОРТА MINDRAY BS-230
color 0e

if exist "%~dp0python\python.exe" (
    "%~dp0python\python.exe" "%~dp0mindray_usb_exporter.py" --once
    goto end
)

python "%~dp0mindray_usb_exporter.py" --once

:end
echo.
pause
