@echo off
chcp 65001 >nul
title Разблокировка папки Biochem_AutoExport
color 0e

echo ==============================================================================
echo       БЕЗОПАСНАЯ ОСТАНОВКА АГЕНТА И РАЗБЛОКИРОВКА ПАПКИ
echo ==============================================================================
echo.

echo Остановка фоновых процессов Biochem_AutoExport...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-CimInstance Win32_Process | Where-Object { $_.CommandLine -like '*biochem_usb_exporter*' -or $_.CommandLine -like '*Biochem_AutoExport*' } | ForEach-Object { Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue }" >nul 2>&1

echo.
echo ==============================================================================
echo ПРОЦЕССЫ АГЕНТА ОСТАНОВЛЕНЫ. Программа анализатора Mindray не затронута.
echo Папка C:\DEV\Biochem_AutoExport теперь полностью разблокирована.
echo ==============================================================================
echo.
pause
