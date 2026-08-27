@echo off
chcp 65001 >nul
title Разблокировка папки Mindray Agent
color 0c

echo ==============================================================================
echo       ПРИНУДИТЕЛЬНАЯ РАЗБЛОКИРОВКА ПАПКИ И ОСТАНОВКА ПРОЦЕССОВ
echo ==============================================================================
echo.

echo [1/3] Завершение всех фоновых процессов PowerShell, WScript и Python...
taskkill /F /IM powershell.exe /T >nul 2>&1
taskkill /F /IM wscript.exe /T >nul 2>&1
taskkill /F /IM python.exe /T >nul 2>&1
taskkill /F /IM pythonw.exe /T >nul 2>&1

echo [2/3] Остановка через WMI...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-CimInstance Win32_Process | Where-Object { $_.CommandLine -match 'mindray' -or $_.ExecutablePath -match 'mindray' } | ForEach-Object { Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue }" >nul 2>&1

echo [3/3] Очистка автозапуска...
set "STARTUP_DIR=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
if exist "%STARTUP_DIR%\Mindray_BS230_AutoExport.lnk" (
    del /f /q "%STARTUP_DIR%\Mindray_BS230_AutoExport.lnk" >nul 2>&1
)

echo.
echo ==============================================================================
echo ВСЕ ПРОЦЕССЫ ЗАВЕРШЕНЫ! Папка C:\mindray_agent теперь полностью разблокирована.
echo Вы можете удалять ее или копировать новые файлы.
echo ==============================================================================
echo.
pause
