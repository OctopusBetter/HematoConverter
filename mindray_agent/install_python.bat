@echo off
chcp 65001 >nul
title Автоматическая установка Python для Mindray BS-230
color 0b

echo ==============================================================================
echo       АВТОМАТИЧЕСКАЯ УСТАНОВКА PYTHON (ТИХИЙ РЕЖИМ ЗА 15 СЕКУНД)
echo ==============================================================================
echo.

echo [1/3] Проверка наличия Python в системе...
python --version >nul 2>&1
if %errorlevel% equ 0 (
    echo [+] Python уже установлен!
    python --version
    goto done
)

echo [2/3] Загрузка официального установщика Python 3.11...
set "PY_URL=https://www.python.org/ftp/python/3.11.9/python-3.11.9-amd64.exe"
set "PY_INSTALLER=%TEMP%\python_installer_mindray.exe"

powershell -NoProfile -ExecutionPolicy Bypass -Command "Write-Host 'Скачивание Python 3.11 (amd64)...'; (New-Object System.Net.WebClient).DownloadFile('%PY_URL%', '%PY_INSTALLER%')"
if not exist "%PY_INSTALLER%" (
    echo [!] Ошибка скачивания 64-бит версии. Пробуем 32-бит версию...
    set "PY_URL=https://www.python.org/ftp/python/3.11.9/python-3.11.9.exe"
    powershell -NoProfile -ExecutionPolicy Bypass -Command "(New-Object System.Net.WebClient).DownloadFile('%PY_URL%', '%PY_INSTALLER%')"
)

echo.
echo [3/3] Тихая автоматическая установка (без лишних окон)...
start /wait "" "%PY_INSTALLER%" /quiet InstallAllUsers=1 PrependPath=1 Include_pip=1

echo.
echo [+] Установка завершена! Проверка...
set "PATH=%PATH%;C:\Program Files\Python311;C:\Program Files\Python311\Scripts;C:\Program Files (x86)\Python311-32;C:\Program Files (x86)\Python311-32\Scripts;%LOCALAPPDATA%\Programs\Python\Python311"

python --version
if %errorlevel% equ 0 (
    echo [УСПЕХ] Python успешно установлен и готов к работе!
) else (
    echo [INFO] Python установлен. Рекомендуется перезагрузить компьютер или запустить install_autorun.bat.
)

:done
echo.
echo ==============================================================================
echo Нажмите любую клавишу для продолжения...
pause >nul
