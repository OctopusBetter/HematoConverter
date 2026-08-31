@echo off
chcp 65001 >nul
title Автоэкспорт биохимии Mindray BS-230/240
color 0a

echo ==============================================================================
echo        АВТОЭКСПОРТ БИОХИМИИ MINDRAY BS-230 / BS-240 (ОКНО МОНИТОРИНГА)
echo ==============================================================================
echo.
echo Это окно выполняет автоэкспорт биохимии при подключении любой флешки.
echo Вы можете свернуть это окно - оно продолжит работать в фоне.
echo.
echo Для закрытия просто закройте это окно или нажмите Ctrl+C.
echo.

cd /d "%~dp0"
if exist "python\python.exe" (
    python\python.exe biochem_usb_exporter.py
) else (
    python biochem_usb_exporter.py
)

pause
