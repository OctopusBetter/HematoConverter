@echo off
chcp 65001 >nul
title Встановлення надійного автоекспорту Mindray BS-230
color 0b

echo ==============================================================================
echo       ВСТАНОВЛЕННЯ АГЕНТА АВТОЕКСПОРТУ ДАНИХ MINDRAY BS-230
echo ==============================================================================
echo.

set "SCRIPT_DIR=%~dp0"
set "VBS_FILE=%SCRIPT_DIR%start_exporter_hidden.vbs"
set "STARTUP_DIR=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"

echo [1/3] Зупинка старих процесів (якщо вони були запущені)...
powershell -NoProfile -Command "Get-Process powershell, wscript, pythonw -ErrorAction SilentlyContinue | Where-Object { $_.CommandLine -match 'mindray' } | Stop-Process -Force -ErrorAction SilentlyContinue"
echo   -^> Старі процеси очищено.

echo.
echo [2/3] Оновлення ярлика в автозавантаженні Windows...
if exist "%VBS_FILE%" (
    powershell -NoProfile -Command "$ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut('%STARTUP_DIR%\Mindray_BS230_AutoExport.lnk'); $s.TargetPath = '%VBS_FILE%'; $s.WorkingDirectory = '%SCRIPT_DIR%'; $s.Save()"
    echo   -^> Ярлик успішно створено в Startup:
    echo      %STARTUP_DIR%\Mindray_BS230_AutoExport.lnk
) else (
    echo   [ПОМИЛКА] Файл start_exporter_hidden.vbs не знайдено!
    pause
    exit /b 1
)

echo.
echo [3/3] Запуск надійного агента у фоновому режимі...
wscript.exe "%VBS_FILE%"

echo.
echo ==============================================================================
echo      ВСТАНОВЛЕННЯ УСПІШНО ЗАВЕРШЕНО!
echo ==============================================================================
echo.
echo  - Агент активний і працює у тихому фоновому режимі.
echo  - Він стартуватиме сам при кожному вмиканні комп'ютера.
echo  - При підключенні БУДЬ-ЯКОЇ USB-флешки дані біохімії миттєво зберігатимуться у:
echo    [Флешка]:\SCAN_00\SampleInfo_Biochem_YYYY-MM-DD.csv
echo.
echo  ПОРАДА: Ви можете запустити файл test_export_now.bat у цій папці,
echo  щоб на власні очі побачити повну діагностику та результати на екрані!
echo.
pause
