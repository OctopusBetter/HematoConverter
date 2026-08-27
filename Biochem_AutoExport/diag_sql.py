# -*- coding: utf-8 -*-
"""
ПОЛНАЯ ДИАГНОСТИКА SQL SERVER ДЛЯ MINDRAY BS-230/240
"""
import os
import sys
import winreg
import subprocess

if sys.platform == "win32":
    try:
        os.system("chcp 65001 >nul")
    except Exception:
        pass

def get_sql_services():
    services = []
    try:
        key = winreg.OpenKey(winreg.HKEY_LOCAL_MACHINE, r"SYSTEM\CurrentControlSet\Services")
        i = 0
        while True:
            try:
                sname = winreg.EnumKey(key, i)
                if sname.upper().startswith("MSSQL$"):
                    services.append(sname)
                elif sname.upper() == "MSSQLSERVER":
                    services.append("MSSQLSERVER")
                i += 1
            except OSError:
                break
        winreg.CloseKey(key)
    except Exception:
        pass
    return services

def run_diagnostics():
    print("=" * 75)
    print("      ПОЛНАЯ ДИАГНОСТИКА SQL СЕРВЕРА MINDRAY (BS-230 / BS-240)")
    print("=" * 75)
    print()
    services = get_sql_services()
    print(f"1. Обнаруженные службы SQL в Windows: {services}")
    instances = []
    for s in services:
        if s.startswith("MSSQL$"):
            inst = s[6:]
            instances.append(f".\\{inst}")
            instances.append(f"(local)\\{inst}")
        elif s == "MSSQLSERVER":
            instances.append(".")
    if not instances:
        instances = [r".\BS240", r".\BS230", r".\BS200", r"(local)\BS240", "."]
    print(f"2. Целевые экземпляры для проверки: {instances}")
    print()
    print("3. Проверка подключения к базе данных...")
    print("-" * 75)
    inst_array = "@(" + ", ".join([f'"{i}"' for i in instances]) + ")"
    ps_diag = '''
$instances = ''' + inst_array + '''
$passwords = @("MINDRAY#BS800", "MINDRAY#BS200", "MINDRAY#BA80", "MINDRAY#BS240", "mindray", "Admin", "sa", "")
$databases = @("BA80", "BS240", "BS230", "BA40", "BA200", "master")
$found = $false
foreach ($inst in $instances) {
    if ($found) { break }
    foreach ($db in $databases) {
        if ($found) { break }
        $connStr = "Server=$inst;Database=$db;Integrated Security=True;Connect Timeout=2;"
        try {
            $conn = New-Object System.Data.SqlClient.SqlConnection($connStr)
            $conn.Open()
            if ($conn.State -eq "Open") {
                Write-Host "   [+] ПОДКЛЮЧЕНО: $inst -> База: $db (Авторизация: Windows Auth)" -ForegroundColor Green
                $cmd = New-Object System.Data.SqlClient.SqlCommand("SELECT COUNT(*) FROM PtSample", $conn)
                $sampleCount = $cmd.ExecuteScalar()
                $cmd2 = New-Object System.Data.SqlClient.SqlCommand("SELECT COUNT(*) FROM CCTestResult", $conn)
                $resultCount = $cmd2.ExecuteScalar()
                $cmd3 = New-Object System.Data.SqlClient.SqlCommand("SELECT SUM(CASE WHEN c.ShortName LIKE '%GLU%' THEN 1 ELSE 0 END) AS GluCount, SUM(CASE WHEN c.ShortName LIKE '%GT%' THEN 1 ELSE 0 END) AS GgtCount FROM CCTestResult r JOIN Chemistry c ON r.ChemUID = c.UID", $conn)
                $reader = $cmd3.ExecuteReader()
                $gluCnt = 0; $ggtCnt = 0
                if ($reader.Read()) {
                    $gluCnt = $reader["GluCount"]
                    $ggtCnt = $reader["GgtCount"]
                }
                $reader.Close()
                $sqlTop = "SELECT TOP 5 COALESCE(s.SampleID, '') AS SampleID, COALESCE(p.Name, '') AS PatientName, s.SampleTime, c.ShortName AS ChemCode, r.ConcResult AS ResultVal FROM PtSample s WITH (NOLOCK) LEFT JOIN Patient p WITH (NOLOCK) ON s.PtUID = p.UID JOIN CCTestResult r WITH (NOLOCK) ON r.SampleUID = s.UID JOIN Chemistry c WITH (NOLOCK) ON r.ChemUID = c.UID ORDER BY s.SampleTime DESC"
                $cmdTop = New-Object System.Data.SqlClient.SqlCommand($sqlTop, $conn)
                $adapter = New-Object System.Data.SqlClient.SqlDataAdapter($cmdTop)
                $dt = New-Object System.Data.DataTable
                $adapter.Fill($dt) | Out-Null
                $conn.Close()
                Write-Host "   -------------------------------------------------------------"
                Write-Host "   [РЕЗУЛЬТАТЫ ДИАГНОСТИКИ БАЗЫ ДАННЫХ]:"
                Write-Host "      - Всего образцов (PtSample): $sampleCount" -ForegroundColor Cyan
                Write-Host "      - Всего тестов (CCTestResult): $resultCount" -ForegroundColor Cyan
                Write-Host "      - Всего тестов Глюкозы (Glu): $gluCnt" -ForegroundColor Yellow
                Write-Host "      - Всего тестов ГГТ (GGT): $ggtCnt" -ForegroundColor Yellow
                Write-Host "   -------------------------------------------------------------"
                Write-Host "   [ПОСЛЕДНИЕ АНАЛИЗЫ В БАЗЕ]:"
                foreach ($row in $dt.Rows) {
                    Write-Host "      - ID: $($row.SampleID) | ФИО: $($row.PatientName) | Время: $($row.SampleTime) | $($row.ChemCode): $($row.ResultVal)"
                }
                Write-Host "   -------------------------------------------------------------"
                $found = $true
                break
            }
        } catch {}
        if (-not $found) {
            foreach ($pass in $passwords) {
                $connStr = "Server=$inst;Database=$db;User Id=sa;Password=$pass;Connect Timeout=1;"
                try {
                    $conn = New-Object System.Data.SqlClient.SqlConnection($connStr)
                    $conn.Open()
                    if ($conn.State -eq "Open") {
                        Write-Host "   [+] ПОДКЛЮЧЕНО: $inst -> База: $db (Пароль sa: $pass)" -ForegroundColor Green
                        $cmd = New-Object System.Data.SqlClient.SqlCommand("SELECT COUNT(*) FROM PtSample", $conn)
                        $sampleCount = $cmd.ExecuteScalar()
                        $conn.Close()
                        Write-Host "   [ДАННЫЕ]: Найдено образцов: $sampleCount" -ForegroundColor Cyan
                        $found = $true
                        break
                    }
                } catch {}
            }
        }
    }
}
if (-not $found) {
    Write-Host "   [!] Не удалось подключиться к базе стандартными способами." -ForegroundColor Red
}
'''
    try:
        subprocess.run(["powershell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-Command", ps_diag])
    except Exception as e:
        print("Ошибка диагностики:", e)
    print()
    print("=" * 75)
    print("ДИАГНОСТИКА ЗАВЕРШЕНА.")
    print("=" * 75)

if __name__ == "__main__":
    run_diagnostics()
