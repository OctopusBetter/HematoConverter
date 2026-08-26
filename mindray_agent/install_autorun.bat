@echo off
chcp 65001 >nul
title Встановлення автоекспорту Mindray BS-230
color 0b

echo ==============================================================================
echo       ВСТАНОВЛЕННЯ НАДІЙНОГО АВТОЕКСПОРТУ ДАНИХ MINDRAY BS-230
echo ==============================================================================
echo.

set "SCRIPT_DIR=%~dp0"
set "BAT_FILE=%SCRIPT_DIR%run_exporter_window.bat"
set "STARTUP_DIR=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"

echo [1/3] Зупинка старих фонових процесів...
powershell -NoProfile -Command "Get-Process powershell, wscript, pythonw -ErrorAction SilentlyContinue | Where-Object { $_.CommandLine -match 'mindray' -or $_.MainWindowTitle -match 'MINDRAY' } | Stop-Process -Force -ErrorAction SilentlyContinue"
taskkill /F /IM wscript.exe >nul 2>&1
echo   -^> Попередні процеси зупинено.

echo.
echo [2/3] Додавання до автозавантаження Windows (видиме вікно)...
if exist "%BAT_FILE%" (
    powershell -NoProfile -Command "$ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut('%STARTUP_DIR%\Mindray_BS230_AutoExport.lnk'); $s.TargetPath = '%BAT_FILE%'; $s.WorkingDirectory = '%SCRIPT_DIR%'; $s.Save()"
    echo   -^> Ярлик успішно створено в Startup:
    echo      %STARTUP_DIR%\Mindray_BS230_AutoExport.lnk
) else (
    echo   [ПОМИЛКА] Файл run_exporter_window.bat не знайдено!
    pause
    exit /b 1
)

echo.
echo [3/3] Запуск моніторингу у робочому вікні...
start "" "%BAT_FILE%"

echo.
echo ==============================================================================
echo      ВСТАНОВЛЕННЯ УСПІШНО ЗАВЕРШЕНО!
echo ==============================================================================
echo.
echo  - Відкрилося робоче вікно моніторингу Mindray BS-230.
echo  - Воно автоматично відкриватиметься при кожному старті Windows.
echo  - Вставте флешку прямо зараз — і ви побачите у вікні процес запису!
echo.
pause
