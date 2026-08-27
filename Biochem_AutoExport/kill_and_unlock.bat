@echo off
chcp 65001 >nul
title Р Р°Р·Р±Р»РѕРєРёСЂРѕРІРєР° РїР°РїРєРё Mindray Agent
color 0c

echo ==============================================================================
echo       РџР РРќРЈР”РРўР•Р›Р¬РќРђРЇ Р РђР—Р‘Р›РћРљРР РћР’РљРђ РџРђРџРљР Р РћРЎРўРђРќРћР’РљРђ РџР РћР¦Р•РЎРЎРћР’
echo ==============================================================================
echo.

echo [1/3] Р—Р°РІРµСЂС€РµРЅРёРµ РІСЃРµС… С„РѕРЅРѕРІС‹С… РїСЂРѕС†РµСЃСЃРѕРІ PowerShell, WScript Рё Python...
taskkill /F /IM powershell.exe /T >nul 2>&1
taskkill /F /IM wscript.exe /T >nul 2>&1
taskkill /F /IM python.exe /T >nul 2>&1
taskkill /F /IM pythonw.exe /T >nul 2>&1

echo [2/3] РћСЃС‚Р°РЅРѕРІРєР° С‡РµСЂРµР· WMI...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-CimInstance Win32_Process | Where-Object { $_.CommandLine -match 'biochem_' -or $_.ExecutablePath -match 'biochem_' } | ForEach-Object { Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue }" >nul 2>&1

echo [3/3] РћС‡РёСЃС‚РєР° Р°РІС‚РѕР·Р°РїСѓСЃРєР°...
set "STARTUP_DIR=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
if exist "%STARTUP_DIR%\Biochem_AutoExport.lnk" (
    del /f /q "%STARTUP_DIR%\Biochem_AutoExport.lnk" >nul 2>&1
)

echo.
echo ==============================================================================
echo Р’РЎР• РџР РћР¦Р•РЎРЎР« Р—РђР’Р•Р РЁР•РќР«! РџР°РїРєР° C:\Biochem_AutoExport С‚РµРїРµСЂСЊ РїРѕР»РЅРѕСЃС‚СЊСЋ СЂР°Р·Р±Р»РѕРєРёСЂРѕРІР°РЅР°.
echo Р’С‹ РјРѕР¶РµС‚Рµ СѓРґР°Р»СЏС‚СЊ РµРµ РёР»Рё РєРѕРїРёСЂРѕРІР°С‚СЊ РЅРѕРІС‹Рµ С„Р°Р№Р»С‹.
echo ==============================================================================
echo.
pause


