@echo off
chcp 65001 >nul
title РЈСЃС‚Р°РЅРѕРІРєР° Р°РІС‚РѕСЌРєСЃРїРѕСЂС‚Р° Mindray BS-230
color 0b

echo ==============================================================================
echo       РЈРЎРўРђРќРћР’РљРђ РђР’РўРћР­РљРЎРџРћР РўРђ MINDRAY BS-230
echo ==============================================================================
echo.

set "SCRIPT_DIR=%~dp0"
set "BAT_FILE=%SCRIPT_DIR%run_exporter_window.bat"
set "STARTUP_DIR=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"

echo [1/3] РџСЂРёРЅСѓРґРёС‚РµР»СЊРЅР°СЏ РѕСЃС‚Р°РЅРѕРІРєР° СЃС‚Р°СЂС‹С… РїСЂРѕС†РµСЃСЃРѕРІ...
taskkill /F /IM powershell.exe /T >nul 2>&1
taskkill /F /IM wscript.exe /T >nul 2>&1
taskkill /F /IM python.exe /T >nul 2>&1
taskkill /F /IM pythonw.exe /T >nul 2>&1

echo.
echo [2/3] Р”РѕР±Р°РІР»РµРЅРёРµ РІ Р°РІС‚РѕР·Р°РїСѓСЃРє Windows...
powershell -NoProfile -Command "$ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut('%STARTUP_DIR%\Biochem_AutoExport.lnk'); $s.TargetPath = '%BAT_FILE%'; $s.WorkingDirectory = '%SCRIPT_DIR%'; $s.Save()"
echo   -^> РЇСЂР»С‹Рє СЃРѕР·РґР°РЅ РІ РђРІС‚РѕР·Р°РіСЂСѓР·РєРµ:
echo      %STARTUP_DIR%\Biochem_AutoExport.lnk

echo.
echo [3/3] Р—Р°РїСѓСЃРє РјРѕРЅРёС‚РѕСЂР° Р°РІС‚РѕСЌРєСЃРїРѕСЂС‚Р°...
start "" "%BAT_FILE%"

echo.
echo ==============================================================================
echo      РЈРЎРўРђРќРћР’РљРђ РџРћР›РќРћРЎРўР¬Р® Р—РђР’Р•Р РЁР•РќРђ!
echo ==============================================================================
echo  - Р’СЃС‚СЂРѕРµРЅРЅС‹Р№ Р°РІС‚РѕРЅРѕРјРЅС‹Р№ Python РіРѕС‚РѕРІ Рє СЂР°Р±РѕС‚Рµ.
echo  - РћС‚РєСЂС‹Р»РѕСЃСЊ СЂР°Р±РѕС‡РµРµ РѕРєРЅРѕ РјРѕРЅС–С‚РѕСЂР°.
echo  - Р’СЃС‚Р°РІР»СЏР№С‚Рµ Р»СЋР±СѓСЋ С„Р»РµС€РєСѓ вЂ” С„Р°Р№Р»С‹ Р±СѓРґСѓС‚ РїРёСЃР°С‚СЊСЃСЏ РІ SCAN_00!
echo.
pause

