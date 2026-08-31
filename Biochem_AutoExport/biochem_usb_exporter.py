# -*- coding: utf-8 -*-
"""
MINDRAY BS-230 / BS-240 USB AUTO-EXPORTER (PYTHON NATIVE)
- Экспорт глюкозы (Glu), ГГТ (GGT) и Штрих-кода (BarcodeID) из базы BA80.
- Сохранение в SCAN_00 на USB-флешку в формате HematoConverter.
"""

import os
import sys
import time
import string
import ctypes
import winreg
import datetime
import winsound
import threading
import subprocess
import base64

if sys.platform == "win32":
    try:
        if sys.stdout is not None:
            sys.stdout.reconfigure(encoding="utf-8", errors="replace")
        if sys.stderr is not None:
            sys.stderr.reconfigure(encoding="utf-8", errors="replace")
    except Exception:
        pass

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
LOG_FILE = os.path.join(SCRIPT_DIR, "agent_log.txt")

def log(msg):
    t = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    line = f"[{t}] {msg}"
    try:
        if sys.stdout is not None:
            print(line)
    except Exception:
        pass
    try:
        with open(LOG_FILE, "a", encoding="utf-8") as f:
            f.write(line + "\n")
    except Exception:
        pass

def safe_print(msg):
    try:
        if sys.stdout is not None:
            print(msg)
    except Exception:
        pass

def play_chime():
    try:
        winsound.MessageBeep(winsound.MB_ICONASTERISK)
    except Exception:
        pass

def speak(text="Биохимия скопирована на флешку"):
    def _speak():
        try:
            import win32com.client
            speaker = win32com.client.Dispatch("SAPI.SpVoice")
            speaker.Speak(text)
        except Exception:
            try:
                ps_cmd = f'Add-Type -AssemblyName System.Speech; (New-Object System.Speech.Synthesis.SpeechSynthesizer).Speak("{text}")'
                subprocess.run(["powershell", "-NoProfile", "-Command", ps_cmd], capture_output=True, timeout=4)
            except Exception:
                pass
    threading.Thread(target=_speak, daemon=True).start()

def get_sql_instance():
    try:
        key = winreg.OpenKey(winreg.HKEY_LOCAL_MACHINE, r"SYSTEM\CurrentControlSet\Services")
        i = 0
        while True:
            try:
                sname = winreg.EnumKey(key, i)
                if sname.upper().startswith("MSSQL$"):
                    inst = sname[6:]
                    winreg.CloseKey(key)
                    return f".\\{inst}"
                elif sname.upper() == "MSSQLSERVER":
                    winreg.CloseKey(key)
                    return "."
                i += 1
            except OSError:
                break
        winreg.CloseKey(key)
    except Exception:
        pass
    return ".\\BS240"

def get_usb_drives():
    drives = []
    try:
        bitmask = ctypes.windll.kernel32.GetLogicalDrives()
        for letter in string.ascii_uppercase:
            if letter in ["C", "D"]:
                continue
            if bitmask & (1 << (ord(letter) - ord('A'))):
                drive_path = f"{letter}:\\"
                dtype = ctypes.windll.kernel32.GetDriveTypeW(drive_path)
                if dtype == 2:
                    drives.append(drive_path)
                elif dtype == 3 and os.path.exists(drive_path):
                    scan_folder = os.path.join(drive_path, "SCAN_00")
                    if os.path.exists(scan_folder) or letter in ["E", "F", "G", "H", "I", "J", "K", "U"]:
                        drives.append(drive_path)
    except Exception as e:
        log(f"Ошибка получения дисков: {e}")
    return drives

def fetch_patients_from_sql():
    inst = get_sql_instance()
    log(f"🔍 Запрос к базе данных SQL ({inst} -> BA80)...")
    
    ps_script = f"""
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$inst = "{inst}"
$db = "BA80"
$passwords = @("MINDRAY#BS800", "MINDRAY#BS200", "MINDRAY#BA80", "MINDRAY#BS240", "mindray", "sa", "")
$sql = @"
SELECT 
    s.UID AS SampleUID, 
    COALESCE(s.SampID, '') AS SampID, 
    COALESCE(s.BarcodeID, '') AS BarcodeID,
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

$connected = $false
$conn = $null

try {{
    $conn = New-Object System.Data.SqlClient.SqlConnection("Server=$inst;Database=$db;Integrated Security=True;Connect Timeout=3;")
    $conn.Open()
    if ($conn.State -eq "Open") {{ $connected = $true }}
}} catch {{}}

if (-not $connected) {{
    foreach ($pwd in $passwords) {{
        try {{
            $conn = New-Object System.Data.SqlClient.SqlConnection("Server=$inst;Database=$db;User Id=sa;Password=$pwd;Connect Timeout=2;")
            $conn.Open()
            if ($conn.State -eq "Open") {{ $connected = $true; break }}
        }} catch {{}}
    }}
}}

if ($connected) {{
    $cmd = New-Object System.Data.SqlClient.SqlCommand($sql, $conn)
    $reader = $cmd.ExecuteReader()
    while ($reader.Read()) {{
        $uid = $reader["SampleUID"].ToString()
        $sid = $reader["SampID"].ToString()
        $bid = $reader["BarcodeID"].ToString()
        $pname = $reader["PatientName"].ToString()
        $rawTime = $reader["SampleTime"]
        $dstr = ""
        $tstr = ""
        if ($rawTime -ne [DBNull]::Value) {{
            $dt = [datetime]$rawTime
            $dstr = $dt.ToString("dd.MM.yyyy")
            $tstr = $dt.ToString("HH:mm:ss")
        }}
        $chem = $reader["ChemCode"].ToString()
        $val = [math]::Round([double]$reader["ResultVal"], 2).ToString()
        [Console]::WriteLine("ROW|$uid|$sid|$bid|$pname|$dstr|$tstr|$chem|$val")
    }}
    $reader.Close()
    $conn.Close()
}} else {{
    [Console]::WriteLine("SQL_CONNECTION_FAILED")
}}
"""
    patients = {}
    test_counts = {}
    try:
        enc = base64.b64encode(ps_script.encode("utf-16le")).decode("ascii")
        proc = subprocess.run(["powershell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-EncodedCommand", enc], capture_output=True, timeout=20)
        raw_out = proc.stdout.decode("utf-8", errors="replace")
        lines = raw_out.splitlines()
        for line in lines:
            line = line.strip()
            if line.startswith("ROW|"):
                parts = line.split("|")
                if len(parts) >= 9:
                    _, uid, sid, bid, pname, dstr, tstr, chem, val = parts[:9]
                    sid = sid.strip()
                    bid = bid.strip()
                    pname = pname.strip()
                    chem = chem.strip()
                    val = val.strip()
                    
                    key = f"{uid}_{dstr}_{sid}_{pname}"
                    if key not in patients:
                        patients[key] = {
                            "SampleUID": int(uid) if uid.isdigit() else 0,
                            "SampleID": sid,
                            "Barcode": bid,
                            "PatientName": pname,
                            "Date": dstr,
                            "Time": tstr,
                            "Glu": "",
                            "GGT": ""
                        }
                    
                    chem_upper = chem.upper()
                    # Map Channel 1 (Mg / Glu) -> Glu, Channel 2 (T-Bil-V / GGT) -> GGT
                    if "GLU" in chem_upper or chem_upper == "MG":
                        patients[key]["Glu"] = val
                        test_counts["Glu"] = test_counts.get("Glu", 0) + 1
                    elif "GT" in chem_upper or "Γ-GT" in chem_upper or "GGT" in chem_upper or "BIL" in chem_upper:
                        patients[key]["GGT"] = val
                        test_counts["GGT"] = test_counts.get("GGT", 0) + 1

        if patients:
            counts_str = ", ".join([f"{k}: {v}" for k, v in list(test_counts.items())[:6]])
            log(f"🟢 УСПЕХ: Извлечено из SQL Server {len(patients)} пациентов ({counts_str})!")
            return patients
        else:
            log(f"Ответ SQL: {raw_out[:150]}")
    except Exception as e:
        log(f"Ошибка запроса к базе SQL: {e}")
    return {}

def export_to_drive(drive_path):
    target_dir = os.path.join(drive_path, "SCAN_00")
    if not os.path.exists(target_dir):
        try:
            os.makedirs(target_dir, exist_ok=True)
            log(f"📁 Создана папка SCAN_00 на флешке: {target_dir}")
        except Exception as e:
            log(f"Ошибка создания папки {target_dir}: {e}")
            return 0
            
    patients = fetch_patients_from_sql()
    if not patients:
        log("⚠️ База данных не вернула записей.")
        return 0
        
    today_str = datetime.datetime.now().strftime("%Y-%m-%d")
    csv_path = os.path.join(target_dir, f"SampleInfo_Biochem_{today_str}.csv")
    csv_lines = ['"ID образца.","Штрих-код","Фамилия","Имя","ФИО","Дата","Время","Glu","GGT","Тип_анализа"\n']
    
    # Sort newest patients first (highest SampleUID first)
    sorted_patients = sorted(patients.values(), key=lambda p: p.get("SampleUID", 0), reverse=True)
    
    for p in sorted_patients:
        full_name = p["PatientName"].strip()
        if full_name:
            parts = full_name.split()
            last_name = parts[0]
            first_name = " ".join(parts[1:]) if len(parts) > 1 else ""
        else:
            last_name = ""
            first_name = ""
            
        barcode_val = p.get("Barcode", "")
        line = f'"{p["SampleID"]}","{barcode_val}","{last_name}","{first_name}","{full_name}","{p["Date"]}","{p["Time"]}","{p["Glu"]}","{p["GGT"]}","BIOCHEM"\n'
        csv_lines.append(line)
        
    with open(csv_path, "w", encoding="utf-8-sig") as f:
        f.writelines(csv_lines)
        
    log(f"✅ УСПЕШНО СОХРАНЕНО: {len(sorted_patients)} пациентов -> {csv_path}")
    return len(sorted_patients)

def main():
    once = "--once" in sys.argv
    safe_print("=" * 70)
    safe_print("      АВТОЭКСПОРТ ВСЕЙ БАЗЫ MINDRAY BS-230 / BS-240 (PYTHON)")
    safe_print("=" * 70)
    
    if once:
        log("--- РЕЖИМ ДИАГНОСТИКИ И ТЕСТОВОГО ЭКСПОРТА ---")
        drives = get_usb_drives()
        if not drives:
            log(f"⚠️ Флешка не найдена. Тестовый экспорт в {os.path.join(SCRIPT_DIR, 'SCAN_00')}")
            cnt = export_to_drive(SCRIPT_DIR)
            log(f"Готово: {cnt} записей сохранено.")
            play_chime()
            speak("Тестовый экспорт завершен")
        else:
            for d in drives:
                log(f"🚀 Найдена флешка: {d}")
                cnt = export_to_drive(d)
                play_chime()
                speak("Биохимия скопирована на флешку")
        log("--- ДИАГНОСТИКА ЗАВЕРШЕНА ---")
        return

    log("⏳ Ожидание подключения любой USB-флешки...")
    processed_drives = set()
    last_check_times = {}

    while True:
        try:
            current_drives = get_usb_drives()
            now = time.time()
            today_str = datetime.datetime.now().strftime("%Y-%m-%d")

            for d in current_drives:
                csv_path = os.path.join(d, "SCAN_00", f"SampleInfo_Biochem_{today_str}.csv")
                file_missing = not os.path.exists(csv_path)
                is_new_drive = d not in processed_drives
                time_since_last = now - last_check_times.get(d, 0)

                if is_new_drive or file_missing or time_since_last > 60:
                    processed_drives.add(d)
                    last_check_times[d] = now
                    log(f"🚀 Обнаружена флешка (экспорт данных): {d}")
                    try:
                        cnt = export_to_drive(d)
                        play_chime()
                        speak("Биохимия скопирована на флешку")
                    except Exception as e:
                        log(f"Ошибка экспорта на {d}: {e}")

            to_remove = [p for p in processed_drives if p not in current_drives]
            for r in to_remove:
                log(f"⏏️ Флешка извлечена: {r}")
                processed_drives.remove(r)
                if r in last_check_times:
                    del last_check_times[r]
        except Exception as e:
            log(f"Ошибка в цикле: {e}")
        time.sleep(1)

if __name__ == "__main__":
    main()
