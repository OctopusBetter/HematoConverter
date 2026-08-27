@echo off
chcp 65001 >nul
title Р”РёР°РіРЅРѕСЃС‚РёРєР° SQL Server Mindray BS-230/240
color 0b

if exist "%~dp0python\python.exe" (
    "%~dp0python\python.exe" "%~dp0diag_sql.py"
) else (
    python "%~dp0diag_sql.py"
)

echo.
pause

