# -*- coding: utf-8 -*-
"""
ПОЛНАЯ ДИАГНОСТИКА SQL SERVER ДЛЯ MINDRAY BS-230/240
"""
import os
import sys
import winreg
import subprocess
import base64

if sys.platform == "win32":
    try:
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
        sys.stderr.reconfigure(encoding="utf-8", errors="replace")
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
    ps_diag = """
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$instances = """ + inst_array + """
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
                
                $sqlTop = @"
SELECT TOP 5 
    s.UID AS SampleUID, 
    COALESCE(s.SampID, '') AS SampleID, 
    COALESCE(p.Name, '') AS PatientName, 
    COALESCE(s.TestDate, s.RunTime, s.CollectDate) AS SampleTime, 
    c.ChemName AS ChemCode, 
    r.RawResult AS ResultVal 
FROM PtSample s WITH (NOLOCK) 
LEFT JOIN Patient p WITH (NOLOCK) ON s.PtUID = p.UID 
JOIN CCTest t WITH (NOLOCK) ON t.SAMPUID = s.UID 
JOIN Chemistry c WITH (NOLOCK) ON t.ChemUID = c.UID 
JOIN CCTestResult r WITH (NOLOCK) ON (r.UID = t.ResultUID OR r.TestUID = t.UID) 
ORDER BY s.UID DESC
"@
                $cmdTop = New-Object System.Data.SqlClient.SqlCommand($sqlTop, $conn)
                $reader = $cmdTop.ExecuteReader()
                $samples = @()
                while ($reader.Read()) {
                    $sid = $reader["SampleID"].ToString()
                    $pname = $reader["PatientName"].ToString()
                    $stime = $reader["SampleTime"].ToString()
                    $chem = $reader["ChemCode"].ToString()
                    $val = [math]::Round([double]$reader["ResultVal"], 2).ToString()
                    $samples += "      - ID: $($sid) | ФИО: $($pname) | Время: $($stime) | $($chem): $($val)"
                }
                $reader.Close()
                $conn.Close()
                
                Write-Host "   -------------------------------------------------------------"
                Write-Host "   [РЕЗУЛЬТАТЫ ДИАГНОСТИКИ БАЗЫ ДАННЫХ]:"
                Write-Host "      - Всего образцов в базе (PtSample): $sampleCount" -ForegroundColor Cyan
                Write-Host "      - Всего результатов анализов (CCTestResult): $resultCount" -ForegroundColor Cyan
                Write-Host "   -------------------------------------------------------------"
                Write-Host "   [ПОСЛЕДНИЕ АНАЛИЗЫ В БАЗЕ]:"
                foreach ($s in $samples) {
                    Write-Host $s
                }
                Write-Host "   -------------------------------------------------------------"
                $found = $true
                break
            }
        } catch {}
    }
}
if (-not $found) {
    Write-Host "   [!] Не удалось подключиться к базе стандартными способами." -ForegroundColor Red
}
"""
    try:
        enc = base64.b64encode(ps_diag.encode("utf-16le")).decode("ascii")
        subprocess.run(["powershell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-EncodedCommand", enc])
    except Exception as e:
        print("Ошибка диагностики:", e)
    print()
    print("=" * 75)
    print("ДИАГНОСТИКА ЗАВЕРШЕНА.")
    print("=" * 75)

if __name__ == "__main__":
    run_diagnostics()
