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

if exist "%~dp0python\python.exe" (
    "%~dp0python\python.exe" "%~dp0mindray_usb_exporter.py"
    goto restart
)

python "%~dp0mindray_usb_exporter.py"

:restart
echo.
echo [ВНИМАНИЕ] Перезапуск через 5 секунд...
timeout /t 5
goto start
