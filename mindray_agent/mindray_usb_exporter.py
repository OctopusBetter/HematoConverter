# -*- coding: utf-8 -*-
"""
MINDRAY BS-230 USB AUTO-EXPORTER (PYTHON)
- Прямое извлечение ВСЕЙ базы (400+ анализов) из базы MS SQL Server (BA80).
- Автоматически использует инстанс .\BS240 и Windows Integrated Security + стандартные пароли Mindray.
- Мгновенная запись в SCAN_00 на USB-флешку.
- Звуковой сигнал + голосовое оповещение Windows.
"""

import os
import sys
import glob
import json
import time
import string
import ctypes
import winreg
import datetime
import winsound
import threading
import subprocess

if sys.platform == "win32":
    try:
        os.system("chcp 65001 >nul")
    except Exception:
        pass

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
LOG_FILE = os.path.join(SCRIPT_DIR, "agent_log.txt")

def log(msg):
    t = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    line = f"[{t}] {msg}"
    print(line)
    try:
        with open(LOG_FILE, "a", encoding="utf-8") as f:
            f.write(line + "\n")
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

def get_detected_sql_instances():
    instances = []
    try:
        key = winreg.OpenKey(winreg.HKEY_LOCAL_MACHINE, r"SYSTEM\CurrentControlSet\Services")
        i = 0
        while True:
            try:
                sname = winreg.EnumKey(key, i)
                if sname.upper().startswith("MSSQL$"):
                    inst = sname[6:]
                    if f".\\{inst}" not in instances:
                        instances.append(f".\\{inst}")
                    if f"(local)\\{inst}" not in instances:
                        instances.append(f"(local)\\{inst}")
                elif sname.upper() == "MSSQLSERVER":
                    if "." not in instances:
                        instances.append(".")
                i += 1
            except OSError:
                break
        winreg.CloseKey(key)
    except Exception:
        pass
    for default in [r".\BS240", r".\BS230", r".\BS200", r"(local)\BS240", r"(local)\BS230", "."]:
        if default not in instances:
            instances.append(default)
    return instances

def get_usb_drives():
    drives = []
    bitmask = ctypes.windll.kernel32.GetLogicalDrives()
    for letter in string.ascii_uppercase:
        if letter == "C":
            continue
        if bitmask & 1:
            drive_path = f"{letter}:\\"
            dtype = ctypes.windll.kernel32.GetDriveTypeW(drive_path)
            if dtype == 2:
                drives.append(drive_path)
            elif dtype == 3 and os.path.exists(drive_path):
                scan_folder = os.path.join(drive_path, "SCAN_00")
                if os.path.exists(scan_folder) or letter in ["E", "F", "G", "H", "I", "J", "K", "U"]:
                    drives.append(drive_path)
        bitmask >>= 1
    return drives

def extract_all_from_sql():
    instances = get_detected_sql_instances()
    log(f"🔍 Запрос к базе данных SQL (цели: {instances[:2]})...")
    inst_array = "@(" + ", ".join([f'"{i}"' for i in instances]) + ")"
    ps_script = '''
$ErrorActionPreference = "SilentlyContinue"
$instances = ''' + inst_array + '''
$passwords = @("MINDRAY#BS800", "MINDRAY#BS200", "MINDRAY#BA80", "MINDRAY#BS240", "mindray", "sa", "")
$databases = @("BA80", "BS240", "BS230", "BA40", "BA200")
$patients = @()
$connectedInfo = ""
foreach ($inst in $instances) {
    if ($patients.Count -gt 0) { break }
    foreach ($db in $databases) {
        if ($patients.Count -gt 0) { break }
        $connStr = "Server=$inst;Database=$db;Integrated Security=True;Connect Timeout=3;"
        try {
            $conn = New-Object System.Data.SqlClient.SqlConnection($connStr)
            $conn.Open()
            if ($conn.State -eq "Open") {
                $sql = "SELECT s.UID AS SampleUID, COALESCE(s.SampleID, '') AS SampleID, COALESCE(p.Name, '') AS PatientName, s.SampleTime, c.ShortName AS ChemCode, r.ConcResult AS ResultVal FROM PtSample s WITH (NOLOCK) LEFT JOIN Patient p WITH (NOLOCK) ON s.PtUID = p.UID JOIN CCTestResult r WITH (NOLOCK) ON r.SampleUID = s.UID JOIN Chemistry c WITH (NOLOCK) ON r.ChemUID = c.UID ORDER BY s.SampleTime ASC"
                $cmd = New-Object System.Data.SqlClient.SqlCommand($sql, $conn)
                $adapter = New-Object System.Data.SqlClient.SqlDataAdapter($cmd)
                $table = New-Object System.Data.DataTable
                $adapter.Fill($table) | Out-Null
                $conn.Close()
                foreach ($row in $table.Rows) {
                    $patients += [PSCustomObject]@{
                        SampleID = "$($row.SampleID)".Trim()
                        PatientName = "$($row.PatientName)".Trim()
                        SampleTime = "$($row.SampleTime)"
                        ChemCode = "$($row.ChemCode)".ToUpper()
                        ResultVal = "$($row.ResultVal)".Trim()
                    }
                }
                if ($patients.Count -gt 0) {
                    $connectedInfo = "$inst ($db, Windows Auth)"
                    break
                }
            }
        } catch {}
        if ($patients.Count -eq 0) {
            foreach ($pass in $passwords) {
                $connStr = "Server=$inst;Database=$db;User Id=sa;Password=$pass;Connect Timeout=2;"
                try {
                    $conn = New-Object System.Data.SqlClient.SqlConnection($connStr)
                    $conn.Open()
                    if ($conn.State -eq "Open") {
                        $sql = "SELECT s.UID AS SampleUID, COALESCE(s.SampleID, '') AS SampleID, COALESCE(p.Name, '') AS PatientName, s.SampleTime, c.ShortName AS ChemCode, r.ConcResult AS ResultVal FROM PtSample s WITH (NOLOCK) LEFT JOIN Patient p WITH (NOLOCK) ON s.PtUID = p.UID JOIN CCTestResult r WITH (NOLOCK) ON r.SampleUID = s.UID JOIN Chemistry c WITH (NOLOCK) ON r.ChemUID = c.UID ORDER BY s.SampleTime ASC"
                        $cmd = New-Object System.Data.SqlClient.SqlCommand($sql, $conn)
                        $adapter = New-Object System.Data.SqlClient.SqlDataAdapter($cmd)
                        $table = New-Object System.Data.DataTable
                        $adapter.Fill($table) | Out-Null
                        $conn.Close()
                        foreach ($row in $table.Rows) {
                            $patients += [PSCustomObject]@{
                                SampleID = "$($row.SampleID)".Trim()
                                PatientName = "$($row.PatientName)".Trim()
                                SampleTime = "$($row.SampleTime)"
                                ChemCode = "$($row.ChemCode)".ToUpper()
                                ResultVal = "$($row.ResultVal)".Trim()
                            }
                        }
                        if ($patients.Count -gt 0) {
                            $connectedInfo = "$inst ($db, sa)"
                            break
                        }
                    }
                } catch {}
            }
        }
    }
}
if ($patients.Count -gt 0) {
    [PSCustomObject]@{ Status = "OK"; Info = $connectedInfo; Data = $patients } | ConvertTo-Json -Compress -Depth 5
}
'''
    try:
        proc = subprocess.run(["powershell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-Command", ps_script], capture_output=True, text=True, timeout=25)
        out = proc.stdout.strip()
        if out and (out.startswith("{") or out.startswith("[")):
            res_obj = json.loads(out)
            info = res_obj.get("Info", "SQL")
            raw_list = res_obj.get("Data", [])
            sql_map = {}
            glu_cnt, ggt_cnt = 0, 0
            for item in raw_list:
                sid = str(item.get("SampleID", "")).strip()
                pname = str(item.get("PatientName", "")).strip()
                stime = str(item.get("SampleTime", ""))
                chem = str(item.get("ChemCode", "")).upper()
                val = str(item.get("ResultVal", "")).strip()
                dstr, tstr = "", ""
                if stime:
                    try:
                        parts = stime.split()
                        if len(parts) >= 1: dstr = parts[0]
                        if len(parts) >= 2: tstr = parts[1]
                    except Exception: pass
                key = f"{dstr}_{sid}_{pname}"
                if key not in sql_map:
                    sql_map[key] = {"SampleID": sid, "PatientName": pname, "Date": dstr, "Time": tstr, "Glu": "", "GGT": ""}
                if "GLU" in chem:
                    sql_map[key]["Glu"] = val
                    glu_cnt += 1
                elif "GT" in chem or "GGT" in chem:
                    sql_map[key]["GGT"] = val
                    ggt_cnt += 1
            if sql_map:
                log(f"🟢 УСПЕХ: База данных SQL подключена ({info})!")
                log(f"   -> Всего пациентов в базе: {len(sql_map)}")
                log(f"   -> Найдено анализов Глюкозы (Glu): {glu_cnt}")
                log(f"   -> Найдено анализов ГГТ (GGT): {ggt_cnt}")
                return sql_map
    except Exception as e:
        log(f"Ошибка запроса к базе SQL: {e}")
    return {}

def extract_from_all_files():
    patients = {}
    found_files = []
    for drive in ["D:\\", "C:\\", "E:\\"]:
        if os.path.exists(drive):
            for pattern in ["Mindray/**/*.out", "mindray/**/*.out", "BS230/**/*.out", "BS240/**/*.out", "PrintOutput/**/*.out"]:
                files = glob.glob(os.path.join(drive, pattern), recursive=True)
                for f in files:
                    if f not in found_files and os.path.isfile(f):
                        found_files.append(f)
    if found_files:
        log(f"Найдено {len(found_files)} файлов анализов на диске")
        found_files.sort(key=os.path.getmtime)
        for fpath in found_files:
            try:
                with open(fpath, "r", encoding="cp1251", errors="ignore") as f:
                    lines = f.readlines()
                sid, pname, dstr, tstr, glu, ggt = "", "", "", "", "", ""
                curr_name, curr_val = "", ""
                for line in lines:
                    if "Str=" in line:
                        idx = line.find("Str=")
                        val_str = line[idx + 4:].strip()
                        if "ID=00050" in line: sid = val_str
                        elif "ID=00020" in line: pname = val_str
                        elif "ID=03002" in line: dstr = val_str
                        elif "ID=00018" in line:
                            parts = val_str.split()
                            if len(parts) == 2: dstr, tstr = parts[0], parts[1]
                            else: tstr = val_str
                        elif "ID=00090" in line: curr_name = val_str
                        elif "ID=00092" in line: curr_val = val_str
                        elif "ID=00094" in line:
                            if curr_name and curr_val:
                                if "Glu" in curr_name or "GLU" in curr_name: glu = curr_val
                                elif "GT" in curr_name or "GGT" in curr_name: ggt = curr_val
                                curr_name, curr_val = "", ""
                if sid or pname or glu or ggt:
                    key = f"{dstr}_{sid}_{pname}"
                    if key not in patients:
                        patients[key] = {"SampleID": sid, "PatientName": pname, "Date": dstr, "Time": tstr, "Glu": glu, "GGT": ggt}
                    else:
                        if glu: patients[key]["Glu"] = glu
                        if ggt: patients[key]["GGT"] = ggt
            except Exception: pass
    return patients

def get_complete_database():
    patients = extract_all_from_sql()
    file_patients = extract_from_all_files()
    for k, p_file in file_patients.items():
        if k not in patients:
            patients[k] = p_file
        else:
            if p_file["Glu"] and not patients[k]["Glu"]: patients[k]["Glu"] = p_file["Glu"]
            if p_file["GGT"] and not patients[k]["GGT"]: patients[k]["GGT"] = p_file["GGT"]
    return patients

def export_to_drive(drive_path):
    target_dir = os.path.join(drive_path, "SCAN_00")
    if not os.path.exists(target_dir):
        try:
            os.makedirs(target_dir, exist_ok=True)
            log(f"📁 Создана папка SCAN_00 на флешке: {target_dir}")
        except Exception as e:
            log(f"Ошибка создания папки {target_dir}: {e}")
            return 0, 0

    patients = get_complete_database()
    today_str = datetime.datetime.now().strftime("%Y-%m-%d")
    csv_path = os.path.join(target_dir, f"SampleInfo_Biochem_{today_str}.csv")

    existing_map = {}
    if os.path.exists(csv_path):
        try:
            with open(csv_path, "r", encoding="utf-8-sig", errors="ignore") as f:
                lines = f.readlines()
            for line in lines[1:]:
                line = line.strip()
                if line:
                    parts = [p.strip('"\n\r') for p in line.split(",")]
                    if len(parts) >= 8:
                        e_sid, _, _, e_name, e_date, e_time, e_glu, e_ggt = parts[:8]
                        k = f"{e_date}_{e_sid}_{e_name}"
                        existing_map[k] = {"SampleID": e_sid, "PatientName": e_name, "Date": e_date, "Time": e_time, "Glu": e_glu, "GGT": e_ggt}
        except Exception: pass

    new_count = 0
    for k, p_new in patients.items():
        if k not in existing_map:
            existing_map[k] = p_new
            new_count += 1
        else:
            if p_new["Glu"] and not existing_map[k]["Glu"]:
                existing_map[k]["Glu"] = p_new["Glu"]
                new_count += 1
            if p_new["GGT"] and not existing_map[k]["GGT"]:
                existing_map[k]["GGT"] = p_new["GGT"]
                new_count += 1

    csv_lines = ['"ID образца.","Фамилия","Имя","ФИО","Дата","Время","Glu","GGT","Тип_анализа"\n']
    for p in existing_map.values():
        full_name = p["PatientName"]
        parts = full_name.split(" ", 1)
        last_name = parts[0] if len(parts) > 0 else ""
        first_name = parts[1] if len(parts) > 1 else ""
        line = f'"{p["SampleID"]}","{last_name}","{first_name}","{full_name}","{p["Date"]}","{p["Time"]}","{p["Glu"]}","{p["GGT"]}","BIOCHEM"\n'
        csv_lines.append(line)

    with open(csv_path, "w", encoding="utf-8-sig") as f:
        f.writelines(csv_lines)

    log(f"✅ УСПЕШНО СОХРАНЕНО: {len(existing_map)} пациентов (новых: {new_count}) -> {csv_path}")
    return len(existing_map), new_count

def main():
    once = "--once" in sys.argv
    print("=" * 70)
    print("      АВТОЭКСПОРТ ВСЕЙ БАЗЫ MINDRAY BS-230 (PYTHON)")
    print("=" * 70)
    if once:
        log("--- РЕЖИМ ДИАГНОСТИКИ ---")
        drives = get_usb_drives()
        if not drives:
            log(f"⚠️ Флешка не найдена. Тестовый экспорт в {os.path.join(SCRIPT_DIR, 'SCAN_00')}")
            total, new = export_to_drive(SCRIPT_DIR)
            log(f"Готово: {total} записей (новых: {new})")
            play_chime()
            speak("Тестовый экспорт завершен")
        else:
            for d in drives:
                log(f"🚀 Найдена флешка: {d}")
                total, new = export_to_drive(d)
                play_chime()
                speak("Биохимия скопирована на флешку")
        log("--- ДИАГНОСТИКА ЗАВЕРШЕНА ---")
        return
    log("⏳ Ожидание подключения любой USB-флешки...")
    processed_drives = set()
    while True:
        try:
            current_drives = get_usb_drives()
            for d in current_drives:
                if d not in processed_drives:
                    processed_drives.add(d)
                    log(f"🚀 Вставлена новая флешка: {d}")
                    try:
                        total, new = export_to_drive(d)
                        play_chime()
                        speak("Биохимия скопирована на флешку")
                    except Exception as e:
                        log(f"Ошибка экспорта на {d}: {e}")
            to_remove = [p for p in processed_drives if p not in current_drives]
            for r in to_remove:
                log(f"⏏️ Флешка извлечена: {r}")
                processed_drives.remove(r)
        except Exception as e:
            log(f"Ошибка в цикле: {e}")
        time.sleep(2)

if __name__ == "__main__":
    main()
