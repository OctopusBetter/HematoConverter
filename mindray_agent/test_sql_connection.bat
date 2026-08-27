@echo off
chcp 65001 >nul
title ДІАГНОСТИКА БАЗИ ДАНИХ SQL (MINDRAY BS-230)
color 0e

echo ==============================================================================
echo       ПРЯМА ДІАГНОСТИКА ПІДКЛЮЧЕННЯ ДО БАЗИ ДАНИХ MS SQL SERVER
echo ==============================================================================
echo.

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0mindray_export_engine.ps1" -Once

echo.
echo ==============================================================================
echo Натисніть будь-яку клавішу для виходу...
pause >nul
