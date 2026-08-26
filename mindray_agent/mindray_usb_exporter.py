#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
==============================================================================
MINDRAY BS-230 USB AUTO-EXPORTER AGENT (mindray_usb_exporter.py)
==============================================================================
Фоновий агент для автоматичного експорту результатів біохімічного аналізатора
Mindray BS-230 при підключенні будь-якої USB-флешки до комп'ютера.
==============================================================================
"""

import os
import sys
import time
import glob
import re
import csv
import shutil
import string
import datetime
import subprocess

CANDIDATE_DIRS = [
    r"D:\Mindray\BS230\OperationSoft",
    r"D:\mindray\Mindray\BS230\OperationSoft",
    r"C:\Mindray\BS230\OperationSoft",
    r"C:\Mindray\BS240\OperationSoft",
    r"D:\Mindray\BS240\OperationSoft"
]

def get_mindray_dir():
    for p in CANDIDATE_DIRS:
        if os.path.exists(p):
            return p
    return CANDIDATE_DIRS[0]

MINDRAY_INSTALL_DIR = get_mindray_dir()
SQL_INSTANCE = r".\BS240"
SQL_DB = "BA80"
SQL_USER = "sa"
SQL_PASS = "MINDRAY#BS800"

EXPORT_FOLDER_NAME = "Mindray_BS230_Export"
processed_drives = set()


def get_removable_drives():
    removable = []
    if sys.platform != "win32":
        return removable

    import ctypes
    kernel32 = ctypes.windll.kernel32
    bitmask = kernel32.GetLogicalDrives()
    
    for letter in string.ascii_uppercase:
        if bitmask & 1:
            drive_path = f"{letter}:\\"
            drive_type = kernel32.GetDriveTypeW(drive_path)
            if drive_type == 2:  # DRIVE_REMOVABLE
                try:
                    if os.path.exists(drive_path):
                        removable.append(drive_path)
                except Exception:
                    pass
        bitmask >>= 1
    return removable


def show_windows_notification(title, message):
    try:
        ps_cmd = (
            '[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms"); '
            '$notify = New-Object System.Windows.Forms.NotifyIcon; '
            '$notify.Icon = [System.Drawing.SystemIcons]::Information; '
            '$notify.Visible = $true; '
            f'$notify.ShowBalloonTip(5000, "{title}", "{message}", [System.Windows.Forms.ToolTipIcon]::Info); '
            'Start-Sleep -Seconds 3; '
            '$notify.Dispose();'
        )
        subprocess.Popen(["powershell", "-NoProfile", "-WindowStyle", "Hidden", "-Command", ps_cmd],
                         creationflags=subprocess.CREATE_NO_WINDOW if os.name == "nt" else 0)
    except Exception as e:
        print(f"[Notification] {title}: {message} ({e})")


def query_sql_server():
    ps_script = f"""
    $connStr = "Server={SQL_INSTANCE};Database={SQL_DB};User Id={SQL_USER};Password={SQL_PASS};Connect Timeout=4;"
    try {{
        $conn = New-Object System.Data.SqlClient.SqlConnection($connStr)
        $conn.Open()
        $sql = "SELECT s.UID AS SampleUID, COALESCE(s.SampleID, '') AS SampleID, COALESCE(p.Name, '') AS PatientName, s.SampleTime, c.ShortName AS ChemCode, c.Name AS ChemName, r.ConcResult AS ResultVal, r.ResultUnit AS Unit, r.ResultFlag AS Flag FROM PtSample s WITH (NOLOCK) LEFT JOIN Patient p WITH (NOLOCK) ON s.PtUID = p.UID JOIN CCTestResult r WITH (NOLOCK) ON r.SampleUID = s.UID JOIN Chemistry c WITH (NOLOCK) ON r.ChemUID = c.UID ORDER BY s.SampleTime DESC, s.SampleID ASC"
        $cmd = New-Object System.Data.SqlClient.SqlCommand($sql, $conn)
        $adapter = New-Object System.Data.SqlClient.SqlDataAdapter($cmd)
        $table = New-Object System.Data.DataTable
        $adapter.Fill($table) | Out-Null
        $conn.Close()
        $table | ConvertTo-Csv -NoTypeInformation
    }} catch {{
        Write-Error $_.Exception.Message
        exit 1
    }}
    """
    try:
        proc = subprocess.run(
            ["powershell", "-NoProfile", "-Command", ps_script],
            capture_output=True,
            text=True,
            timeout=8,
            creationflags=subprocess.CREATE_NO_WINDOW if os.name == "nt" else 0
        )
        if proc.returncode == 0 and proc.stdout.strip():
            csv_reader = csv.DictReader(proc.stdout.strip().splitlines())
            records = list(csv_reader)
            if records:
                return records
    except Exception as e:
        pass
    return None


def parse_print_output_files():
    base_dir = get_mindray_dir()
    out_pattern = os.path.join(base_dir, "PrintOutput", "*.out")
    files = glob.glob(out_pattern)
    if not files:
        return []

    samples_map = {}
    for filepath in sorted(files, key=os.path.getmtime):
        try:
            with open(filepath, "r", encoding="ansi", errors="ignore") as f:
                content = f.read()

            sample_id = ""
            patient_name = ""
            date_str = ""
            time_str = ""
            tests = {}

            lines = content.splitlines()
            current_name = None
            current_val = None

            for line in lines:
                if "ID=00050" in line:
                    m = re.search(r"Str=(.*)", line)
                    if m: sample_id = m.group(1).strip()
                elif "ID=00020" in line:
                    m = re.search(r"Str=(.*)", line)
                    if m: patient_name = m.group(1).strip()
                elif "ID=03002" in line:
                    m = re.search(r"Str=(.*)", line)
                    if m: date_str = m.group(1).strip()
                elif "ID=00018" in line:
                    m = re.search(r"Str=(.*)", line)
                    if m:
                        full_dt = m.group(1).strip()
                        parts = full_dt.split(" ")
                        if len(parts) == 2:
                            date_str, time_str = parts[0], parts[1]
                        else:
                            time_str = full_dt
                elif "ID=00090" in line:
                    m = re.search(r"Str=(.*)", line)
                    if m: current_name = m.group(1).strip()
                elif "ID=00092" in line:
                    m = re.search(r"Str=(.*)", line)
                    if m and current_name: current_val = m.group(1).strip()
                elif "ID=00094" in line:
                    m = re.search(r"Str=(.*)", line)
                    if m and current_name and current_val is not None:
                        unit = m.group(1).strip()
                        clean_code = "GGT" if "GT" in current_name else current_name
                        tests[clean_code] = current_val
                        current_name = None
                        current_val = None

            if sample_id or patient_name or tests:
                key = f"{date_str}_{sample_id}_{patient_name}"
                if key not in samples_map:
                    samples_map[key] = {
                        "sample_id": sample_id,
                        "patient_name": patient_name,
                        "date": date_str,
                        "time": time_str,
                        "Glu": tests.get("Glu", ""),
                        "GGT": tests.get("GGT", "")
                    }
                else:
                    if "Glu" in tests and tests["Glu"]: samples_map[key]["Glu"] = tests["Glu"]
                    if "GGT" in tests and tests["GGT"]: samples_map[key]["GGT"] = tests["GGT"]
        except Exception:
            continue

    return list(samples_map.values())


def collect_patient_data():
    sql_records = query_sql_server()
    if sql_records:
        patients_map = {}
        for r in sql_records:
            sid = r.get("SampleID", "").strip()
            name = r.get("PatientName", "").strip()
            raw_time = r.get("SampleTime", "").strip()
            
            date_str = ""
            time_str = ""
            if raw_time:
                try:
                    dt = datetime.datetime.fromisoformat(raw_time)
                    date_str = dt.strftime("%d.%m.%Y")
                    time_str = dt.strftime("%H:%M:%S")
                except Exception:
                    parts = raw_time.split(" ")
                    date_str = parts[0] if len(parts) > 0 else ""
                    time_str = parts[1] if len(parts) > 1 else ""

            key = f"{date_str}_{sid}_{name}"
            if key not in patients_map:
                patients_map[key] = {
                    "SampleID": sid,
                    "PatientName": name,
                    "Date": date_str,
                    "Time": time_str,
                    "Glu": "",
                    "GGT": ""
                }

            chem_code = r.get("ChemCode", "").upper()
            val = r.get("ResultVal", "").strip()
            if "GLU" in chem_code:
                patients_map[key]["Glu"] = val
            elif "GT" in chem_code or "GGT" in chem_code:
                patients_map[key]["GGT"] = val

        if patients_map:
            return list(patients_map.values())

    fallback_data = parse_print_output_files()
    transformed = []
    for item in fallback_data:
        transformed.append({
            "SampleID": item.get("sample_id", ""),
            "PatientName": item.get("patient_name", ""),
            "Date": item.get("date", ""),
            "Time": item.get("time", ""),
            "Glu": item.get("Glu", ""),
            "GGT": item.get("GGT", "")
        })
    return transformed


def export_to_drive(drive_root):
    target_dir = os.path.join(drive_root, EXPORT_FOLDER_NAME)
    os.makedirs(target_dir, exist_ok=True)

    patients = collect_patient_data()
    today_str = datetime.datetime.now().strftime("%Y-%m-%d")
    csv_filename = f"SampleInfo_Biochem_{today_str}.csv"
    csv_path = os.path.join(target_dir, csv_filename)

    with open(csv_path, "w", encoding="utf-8-sig", newline="") as f:
        writer = csv.writer(f)
        writer.writerow([
            "ID образца.", "Фамилия", "Имя", "ФИО", "Дата", "Время", "Glu", "GGT", "Тип_анализа"
        ])
        for p in patients:
            full_name = p["PatientName"]
            parts = full_name.split(" ", 1)
            last_name = parts[0] if len(parts) > 0 else ""
            first_name = parts[1] if len(parts) > 1 else ""

            writer.writerow([
                p["SampleID"],
                last_name,
                first_name,
                full_name,
                p["Date"],
                p["Time"],
                p["Glu"],
                p["GGT"],
                "BIOCHEM"
            ])

    base_dir = get_mindray_dir()
    bak_source = os.path.join(base_dir, "DataBase", "Backup", "BA80.bak")
    if not os.path.exists(bak_source):
        bak_source = os.path.join(base_dir, "DataBase", "BA80.bak")

    if os.path.exists(bak_source):
        bak_target = os.path.join(target_dir, "BA80_Backup.bak")
        try:
            shutil.copy2(bak_source, bak_target)
        except Exception:
            pass

    return len(patients)


def main():
    print("============================================================")
    print(" MINDRAY BS-230 USB AUTO-EXPORTER AGENT STARTED")
    print(" Очікування підключення USB-флешки...")
    print("============================================================")

    while True:
        try:
            current_drives = set(get_removable_drives())
            new_drives = current_drives - processed_drives

            for drive in new_drives:
                print(f"[{datetime.datetime.now().strftime('%H:%M:%S')}] Знайдено флешку: {drive}")
                count = export_to_drive(drive)
                print(f"[{datetime.datetime.now().strftime('%H:%M:%S')}] Експортовано {count} аналізів на {drive}")
                show_windows_notification(
                    "Mindray BS-230 Exporter",
                    f"✅ Аналізи біохімії скопійовано на флешку ({drive}): {count} записів."
                )

            processed_drives.intersection_update(current_drives)
            processed_drives.update(new_drives)

        except Exception as e:
            print(f"[Error] {e}")

        time.sleep(3)


if __name__ == "__main__":
    main()
