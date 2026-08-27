@echo off
chcp 65001 >nul
title РЈРґР°Р»РµРЅРёРµ Р°РІС‚РѕСЌРєСЃРїРѕСЂС‚Р° Mindray BS-230
color 0c

echo ==============================================================================
echo       РћРЎРўРђРќРћР’РљРђ Р РЈР”РђР›Р•РќРР• РђР’РўРћР­РљРЎРџРћР РўРђ MINDRAY BS-230
echo ==============================================================================
echo.

echo [1/3] РџСЂРёРЅСѓРґРёС‚РµР»СЊРЅР°СЏ РѕСЃС‚Р°РЅРѕРІРєР° РІСЃРµС… С„РѕРЅРѕРІС‹С… РїСЂРѕС†РµСЃСЃРѕРІ...
taskkill /F /IM powershell.exe /T >nul 2>&1
taskkill /F /IM wscript.exe /T >nul 2>&1
taskkill /F /IM python.exe /T >nul 2>&1
taskkill /F /IM pythonw.exe /T >nul 2>&1

echo [2/3] РћСЃС‚Р°РЅРѕРІРєР° С‡РµСЂРµР· WMI...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-CimInstance Win32_Process | Where-Object { $_.CommandLine -match 'biochem_' -or $_.ExecutablePath -match 'biochem_' } | ForEach-Object { Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue }" >nul 2>&1

echo [3/3] РћС‡РёСЃС‚РєР° Р°РІС‚РѕР·Р°РіСЂСѓР·РєРё Windows...
set "STARTUP_DIR=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
if exist "%STARTUP_DIR%\Biochem_AutoExport.lnk" (
    del /f /q "%STARTUP_DIR%\Biochem_AutoExport.lnk" >nul 2>&1
    echo   -^> РЇСЂР»С‹Рє СѓРґР°Р»РµРЅ РёР· Р°РІС‚РѕР·Р°РіСЂСѓР·РєРё.
)

echo.
echo ==============================================================================
echo РђРіРµРЅС‚ РїРѕР»РЅРѕСЃС‚СЊСЋ РѕСЃС‚Р°РЅРѕРІР»РµРЅ, РїР°РїРєР° СЂР°Р·Р±Р»РѕРєРёСЂРѕРІР°РЅР°!
echo ==============================================================================
echo.
pause


