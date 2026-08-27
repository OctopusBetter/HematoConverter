# -*- coding: utf-8 -*-
"""
MINDRAY BS-230 / BS-240 USB AUTO-EXPORTER (PYTHON NATIVE)
- Прямой стриминг 433+ анализов из MS SQL Server (BA80) через SqlDataReader.
- Моментальная группировка и сохранение в SCAN_00 на USB-флешку.
- Звуковой сигнал + голосовое оповещение Windows.
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

def fetch_patients_from_sql():
    inst = get_sql_instance()
    log(f"🔍 Запрос к базе данных SQL ({inst} -> BA80)...")
    ps_script = '''
$inst = "''' + inst + '''"
$db = "BA80"
$passwords = @("MINDRAY#BS800", "MINDRAY#BS200", "MINDRAY#BA80", "mindray", "sa", "")
$sql = "SELECT s.UID AS SampleUID, COALESCE(s.SampleID, '') AS SampleID, COALESCE(p.Name, '') AS PatientName, s.SampleTime, c.ShortName AS ChemCode, r.ConcResult AS ResultVal FROM PtSample s WITH (NOLOCK) LEFT JOIN Patient p WITH (NOLOCK) ON s.PtUID = p.UID JOIN CCTestResult r WITH (NOLOCK) ON r.SampleUID = s.UID JOIN Chemistry c WITH (NOLOCK) ON r.ChemUID = c.UID ORDER BY s.SampleTime ASC"
$connected = $false
$conn = $null
# 1. Windows Auth
try {
    $conn = New-Object System.Data.SqlClient.SqlConnection("Server=$inst;Database=$db;Integrated Security=True;Connect Timeout=3;")
    $conn.Open()
    if ($conn.State -eq "Open") { $connected = $true }
} catch {}
# 2. sa passwords
if (-not $connected) {
    foreach ($pwd in $passwords) {
        try {
            $conn = New-Object System.Data.SqlClient.SqlConnection("Server=$inst;Database=$db;User Id=sa;Password=$pwd;Connect Timeout=2;")
            $conn.Open()
            if ($conn.State -eq "Open") { $connected = $true; break }
        } catch {}
    }
}
if ($connected) {
    $cmd = New-Object System.Data.SqlClient.SqlCommand($sql, $conn)
    $reader = $cmd.ExecuteReader()
    while ($reader.Read()) {
        $uid = $reader["SampleUID"]
        $sid = $reader["SampleID"]
        $pname = $reader["PatientName"]
        $stime = $reader["SampleTime"]
        $chem = $reader["ChemCode"]
        $val = $reader["ResultVal"]
        [Console]::WriteLine("ROW|$uid|$sid|$pname|$stime|$chem|$val")
    }
    $reader.Close()
    $conn.Close()
} else {
    Write-Host "SQL_CONNECTION_FAILED"
}
'''
    patients = {}
    glu_cnt, ggt_cnt = 0, 0
    try:
        proc = subprocess.run(["powershell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-Command", ps_script], capture_output=True, text=True, timeout=15)
        lines = proc.stdout.splitlines()
        for line in lines:
            line = line.strip()
            if line.startswith("ROW|"):
                parts = line.split("|")
                if len(parts) >= 7:
                    _, uid, sid, pname, stime, chem, val = parts[:7]
                    sid = sid.strip()
                    pname = pname.strip()
                    chem = chem.strip().upper()
                    val = val.strip()
                    dstr, tstr = "", ""
                    if stime:
                        sp = stime.split()
                        if len(sp) >= 1: dstr = sp[0]
                        if len(sp) >= 2: tstr = sp[1]
                    key = f"{uid}_{dstr}_{sid}_{pname}"
                    if key not in patients:
                        patients[key] = {"SampleID": sid, "PatientName": pname, "Date": dstr, "Time": tstr, "Glu": "", "GGT": ""}
                    if "GLU" in chem:
                        patients[key]["Glu"] = val
                        glu_cnt += 1
                    elif "GT" in chem or "GGT" in chem:
                        patients[key]["GGT"] = val
                        ggt_cnt += 1
        if patients:
            log(f"🟢 УСПЕХ: Извлечено из SQL Server {len(patients)} пациентов (Glu: {glu_cnt}, GGT: {ggt_cnt})!")
            return patients
        else:
            log(f"Ответ SQL: {proc.stdout.strip()[:100]}")
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
    csv_lines = ['"ID образца.","Фамилия","Имя","ФИО","Дата","Время","Glu","GGT","Тип_анализа"\n']
    for p in patients.values():
        full_name = p["PatientName"]
        parts = full_name.split(" ", 1)
        last_name = parts[0] if len(parts) > 0 else ""
        first_name = parts[1] if len(parts) > 1 else ""
        line = f'"{p["SampleID"]}","{last_name}","{first_name}","{full_name}","{p["Date"]}","{p["Time"]}","{p["Glu"]}","{p["GGT"]}","BIOCHEM"\n'
        csv_lines.append(line)
    with open(csv_path, "w", encoding="utf-8-sig") as f:
        f.writelines(csv_lines)
    log(f"✅ УСПЕШНО СОХРАНЕНО: {len(patients)} пациентов -> {csv_path}")
    return len(patients)

def main():
    once = "--once" in sys.argv
    print("=" * 70)
    print("      АВТОЭКСПОРТ ВСЕЙ БАЗЫ MINDRAY BS-230 / BS-240 (PYTHON)")
    print("=" * 70)
    if once:
        log("--- РЕЖИМ ДИАГНОСТИКИ ---")
        drives = get_usb_drives()
        if not drives:
            log(f"⚠️ Флешка не найдена. Тестовый экспорт в {os.path.join(SCRIPT_DIR, 'SCAN_00')}")
            cnt = export_to_drive(SCRIPT_DIR)
            log(f"Готово: {cnt} записей")
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
    while True:
        try:
            current_drives = get_usb_drives()
            for d in current_drives:
                if d not in processed_drives:
                    processed_drives.add(d)
                    log(f"🚀 Вставлена новая флешка: {d}")
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
        except Exception as e:
            log(f"Ошибка в цикле: {e}")
        time.sleep(2)

if __name__ == "__main__":
    main()
