@echo off
chcp 65001 >nul
title Встановлення автоекспорту Mindray BS-230
color 0b

echo ==============================================================================
echo       ВСТАНОВЛЕННЯ АГЕНТА АВТОЕКСПОРТУ ДАНИХ MINDRAY BS-230
echo ==============================================================================
echo.

set "SCRIPT_DIR=%~dp0"
set "VBS_FILE=%SCRIPT_DIR%start_exporter_hidden.vbs"
set "STARTUP_DIR=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"

echo [1/3] Перевірка наявності Python...
python --version >nul 2>&1
if %errorlevel% equ 0 (
    echo   -^> Python знайдено в системі! Використовується Python агент.
) else (
    echo   -^> Python не знайдено. Автоматично підключено нативний Windows PowerShell рушій.
    echo      (Працює без встановлення додаткового ПЗ!)
)

echo.
echo [2/3] Додавання до автозавантаження Windows...
if exist "%VBS_FILE%" (
    rem Створюємо ярлик в автозавантаженні
    powershell -NoProfile -Command "$ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut('%STARTUP_DIR%\Mindray_BS230_AutoExport.lnk'); $s.TargetPath = '%VBS_FILE%'; $s.WorkingDirectory = '%SCRIPT_DIR%'; $s.Save()"
    echo   -^> Ярлик успішно створено в Startup:
    echo      %STARTUP_DIR%\Mindray_BS230_AutoExport.lnk
) else (
    echo   [ПОМИЛКА] Файл start_exporter_hidden.vbs не знайдено!
    pause
    exit /b 1
)

echo.
echo [3/3] Запуск агента у фоновому режимі...
wscript.exe "%VBS_FILE%"

echo.
echo ==============================================================================
echo      ВСТАНОВЛЕННЯ УСПІШНО ЗАВЕРШЕНО!
echo ==============================================================================
echo.
echo  - Агент активний і працює у фоновому режимі.
echo  - Він запускатиметься автоматично при кожному старті Windows.
echo  - При підключенні БУДЬ-ЯКОЇ флешки дані біохімії миттєво зберігатимуться у:
echo    [Флешка]:\Mindray_BS230_Export\SampleInfo_Biochem_YYYY-MM-DD.csv
echo.
pause
