<#
==============================================================================
 MINDRAY BS-230 ROCK-SOLID STANDALONE EXPORT ENGINE (PowerShell / .NET Native)
==============================================================================
 Працює 100% АВТОНОМНО на будь-якій версії Windows БЕЗ стороннього ПЗ!
 Автоматично виявляє USB-флешки будь-якого типу (Removable / Fixed / USB SCSI)
==============================================================================
#>
param(
    [switch]$Once
)

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$LogFile = [System.IO.Path]::Combine($ScriptDir, "agent_log.txt")

function Write-Log($msg, $color = "White") {
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $line = "[$timestamp] $msg"
    Write-Host $line -ForegroundColor $color
    try {
        Add-Content -Path $LogFile -Value $line -Encoding UTF8 -ErrorAction SilentlyContinue
    } catch {}
}

# 1. Пошук шляху встановлення Mindray
function Get-MindrayInstallationPath {
    # 1.1. Перевірка активного процесу WorkStation
    try {
        $proc = Get-Process WorkStation, BS230, BS240 -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($proc -and $proc.Path) {
            $pDir = Split-Path $proc.Path -Parent
            if ([System.IO.Directory]::Exists($pDir)) {
                return $pDir
            }
        }
    } catch {}

    # 1.2. Перевірка стандартних шляхів
    $candidates = @(
        "D:\Mindray\BS230\OperationSoft",
        "D:\mindray\Mindray\BS230\OperationSoft",
        "C:\Mindray\BS230\OperationSoft",
        "C:\Mindray\BS240\OperationSoft",
        "D:\Mindray\BS240\OperationSoft",
        "E:\Mindray\BS230\OperationSoft",
        "E:\Mindray\BS240\OperationSoft",
        "D:\BS230\OperationSoft",
        "C:\BS230\OperationSoft",
        "D:\mindray\BS230\OperationSoft"
    )
    foreach ($p in $candidates) {
        if ([System.IO.Directory]::Exists($p)) {
            $pOut = [System.IO.Path]::Combine($p, "PrintOutput")
            $pDb = [System.IO.Path]::Combine($p, "DataBase")
            if ([System.IO.Directory]::Exists($pOut) -or [System.IO.Directory]::Exists($pDb)) {
                return $p
            }
        }
    }

    # 1.3. Швидкий пошук по готових дисках
    $drives = [System.IO.DriveInfo]::GetDrives() | Where-Object { $_.IsReady }
    foreach ($d in $drives) {
        try {
            $r = $d.RootDirectory.FullName
            $found = Get-ChildItem -Path $r -Filter "OperationSoft" -Directory -Recurse -Depth 3 -ErrorAction SilentlyContinue | Select-Object -First 1
            if ($found -and [System.IO.Directory]::Exists($found.FullName)) {
                return $found.FullName
            }
        } catch {}
    }

    return $candidates[0]
}

# 2. Надійне виявлення USB-флешок (Removable + Fixed USB + будь-які знімні диски)
function Get-TargetUsbDrives {
    $targetRoots = @()
    $sysDrive = ($env:SystemDrive + "\").ToUpper()

    # 2.1. Логічні диски з DriveType = 2 (Знімні флешки)
    try {
        $logicalRemovables = Get-CimInstance Win32_LogicalDisk -ErrorAction SilentlyContinue | Where-Object { $_.DriveType -eq 2 }
        foreach ($d in $logicalRemovables) {
            $r = ($d.DeviceID + "\").ToUpper()
            if ($r -ne $sysDrive -and $targetRoots -notcontains $r) {
                $targetRoots += $r
            }
        }
    } catch {}

    # 2.2. Фізичні диски на шині USB (флешки з типом Fixed/SCSI)
    try {
        $usbDisks = Get-CimInstance Win32_DiskDrive -ErrorAction SilentlyContinue | Where-Object { 
            $_.InterfaceType -eq "USB" -or 
            $_.MediaType -match "Removable" -or 
            $_.MediaType -match "External" -or 
            $_.Caption -match "USB" -or 
            $_.Model -match "USB"
        }
        foreach ($disk in $usbDisks) {
            $partitions = Get-CimAssociatedInstance -InputObject $disk -ResultClassName Win32_DiskPartition -ErrorAction SilentlyContinue
            foreach ($part in $partitions) {
                $logical = Get-CimAssociatedInstance -InputObject $part -ResultClassName Win32_LogicalDisk -ErrorAction SilentlyContinue
                foreach ($ld in $logical) {
                    $root = ($ld.DeviceID + "\").ToUpper()
                    if ($root -ne $sysDrive -and $targetRoots -notcontains $root) {
                        $targetRoots += $root
                    }
                }
            }
        }
    } catch {}

    # 2.3. Резерв: Будь-який готовий диск крім C:, який містить папку SCAN_00
    try {
        $allDrives = [System.IO.DriveInfo]::GetDrives() | Where-Object { $_.IsReady -and $_.Name.ToUpper() -ne $sysDrive }
        foreach ($d in $allDrives) {
            $r = $d.RootDirectory.FullName.ToUpper()
            if ($targetRoots -notcontains $r) {
                $scanDir = [System.IO.Path]::Combine($r, "SCAN_00")
                if ([System.IO.Directory]::Exists($scanDir)) {
                    $targetRoots += $r
                }
            }
        }
    } catch {}

    return $targetRoots
}

# 3. Сповіщення у треї Windows
function Show-TrayNotification($title, $msg) {
    try {
        [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
        $notify = New-Object System.Windows.Forms.NotifyIcon
        $notify.Icon = [System.Drawing.SystemIcons]::Information
        $notify.Visible = $true
        $notify.ShowBalloonTip(6000, $title, $msg, [System.Windows.Forms.ToolTipIcon]::Info)
        Start-Sleep -Seconds 3
        $notify.Dispose()
    } catch {}
}

# 4. Збір та експорт даних пацієнтів
function Export-MindrayDataToDrive {
    param(
        [Parameter(Mandatory=$true)][string]$driveRoot,
        [Parameter(Mandatory=$true)][string]$mindrayDir
    )

    $targetDir = [System.IO.Path]::Combine($driveRoot, "SCAN_00")
    if (-not [System.IO.Directory]::Exists($targetDir)) {
        [System.IO.Directory]::CreateDirectory($targetDir) | Out-Null
    }

    $patientsMap = @{}
    $sqlSuccess = $false

    # 4.1. Спроба підключення до MS SQL Server
    $candidateInstances = @(".\BS240", "(local)\BS240", ".\BS230", ".")
    $passwords = @("MINDRAY#BS800", "MINDRAY#BS200")

    foreach ($inst in $candidateInstances) {
        if ($sqlSuccess) { break }
        foreach ($pass in $passwords) {
            $connStr = "Server=$inst;Database=BA80;User Id=sa;Password=$pass;Connect Timeout=1;"
            try {
                $conn = New-Object System.Data.SqlClient.SqlConnection($connStr)
                $conn.Open()
                $sql = @"
                SELECT 
                    s.UID AS SampleUID,
                    COALESCE(s.SampleID, '') AS SampleID,
                    COALESCE(p.Name, '') AS PatientName,
                    s.SampleTime,
                    c.ShortName AS ChemCode,
                    c.Name AS ChemName,
                    r.ConcResult AS ResultVal,
                    r.ResultUnit AS Unit,
                    r.ResultFlag AS Flag
                FROM PtSample s WITH (NOLOCK)
                LEFT JOIN Patient p WITH (NOLOCK) ON s.PtUID = p.UID
                JOIN CCTestResult r WITH (NOLOCK) ON r.SampleUID = s.UID
                JOIN Chemistry c WITH (NOLOCK) ON r.ChemUID = c.UID
                ORDER BY s.SampleTime DESC, s.SampleID ASC
"@
                $cmd = New-Object System.Data.SqlClient.SqlCommand($sql, $conn)
                $adapter = New-Object System.Data.SqlClient.SqlDataAdapter($cmd)
                $table = New-Object System.Data.DataTable
                $adapter.Fill($table) | Out-Null
                $conn.Close()

                foreach ($row in $table.Rows) {
                    $sid = "$($row.SampleID)".Trim()
                    $pname = "$($row.PatientName)".Trim()
                    $stime = "$($row.SampleTime)"
                    $chem = "$($row.ChemCode)".ToUpper()
                    $val = "$($row.ResultVal)".Trim()

                    $dstr = ""
                    $tstr = ""
                    if ($stime) {
                        try {
                            $dt = [datetime]::Parse($stime)
                            $dstr = $dt.ToString("dd.MM.yyyy")
                            $tstr = $dt.ToString("HH:mm:ss")
                        } catch {
                            $pts = $stime.Split(' ')
                            if ($pts.Length -ge 1) { $dstr = $pts[0] }
                            if ($pts.Length -ge 2) { $tstr = $pts[1] }
                        }
                    }

                    $key = "${dstr}_${sid}_${pname}"
                    if (-not $patientsMap.ContainsKey($key)) {
                        $patientsMap[$key] = [PSCustomObject]@{
                            SampleID = $sid
                            PatientName = $pname
                            Date = $dstr
                            Time = $tstr
                            Glu = ""
                            GGT = ""
                        }
                    }

                    if ($chem.Contains("GLU")) { $patientsMap[$key].Glu = $val }
                    elseif ($chem.Contains("GT") -or $chem.Contains("GGT")) { $patientsMap[$key].GGT = $val }
                }
                $sqlSuccess = $true
                Write-Log "SQL Server успішно підключено ($inst): знайдено $($patientsMap.Count) записів" "Green"
                break
            } catch {}
        }
    }

    # 4.2. Резервний парсинг PrintOutput *.out файлів (Безпечний строковий парсер без regex)
    if (-not $sqlSuccess -or $patientsMap.Count -eq 0) {
        Write-Log "SQL недоступний, миттєвий парсинг PrintOutput файлів з: $mindrayDir" "Yellow"
        $printOutDir = [System.IO.Path]::Combine($mindrayDir, "PrintOutput")
        if ([System.IO.Directory]::Exists($printOutDir)) {
            $outFiles = Get-ChildItem -Path $printOutDir -Filter "*.out" -File -ErrorAction SilentlyContinue | Sort-Object LastWriteTime
            foreach ($f in $outFiles) {
                try {
                    $lines = Get-Content $f.FullName -Encoding Default -ErrorAction SilentlyContinue
                    $sid = ""
                    $pname = ""
                    $dstr = ""
                    $tstr = ""
                    $glu = ""
                    $ggt = ""
                    $currName = ""
                    $currVal = ""

                    foreach ($line in $lines) {
                        if ($line.Contains("Str=")) {
                            $idx = $line.IndexOf("Str=")
                            $valStr = $line.Substring($idx + 4).Trim()

                            if ($line.Contains("ID=00050")) {
                                $sid = $valStr
                            }
                            elseif ($line.Contains("ID=00020")) {
                                $pname = $valStr
                            }
                            elseif ($line.Contains("ID=03002")) {
                                $dstr = $valStr
                            }
                            elseif ($line.Contains("ID=00018")) {
                                $pts = $valStr.Split(' ')
                                if ($pts.Length -eq 2) {
                                    $dstr = $pts[0]
                                    $tstr = $pts[1]
                                } else {
                                    $tstr = $valStr
                                }
                            }
                            elseif ($line.Contains("ID=00090")) {
                                $currName = $valStr
                            }
                            elseif ($line.Contains("ID=00092")) {
                                $currVal = $valStr
                            }
                            elseif ($line.Contains("ID=00094")) {
                                if ($currName -and $currVal) {
                                    if ($currName.Contains("Glu")) { $glu = $currVal }
                                    elseif ($currName.Contains("GT") -or $currName.Contains("GGT")) { $ggt = $currVal }
                                    $currName = ""
                                    $currVal = ""
                                }
                            }
                        }
                    }

                    if ($sid -or $pname -or $glu -or $ggt) {
                        $key = "${dstr}_${sid}_${pname}"
                        if (-not $patientsMap.ContainsKey($key)) {
                            $patientsMap[$key] = [PSCustomObject]@{
                                SampleID = $sid
                                PatientName = $pname
                                Date = $dstr
                                Time = $tstr
                                Glu = $glu
                                GGT = $ggt
                            }
                        } else {
                            if ($glu) { $patientsMap[$key].Glu = $glu }
                            if ($ggt) { $patientsMap[$key].GGT = $ggt }
                        }
                    }
                } catch {}
            }
        }
    }

    # 4.3. Запис у CSV
    $todayStr = (Get-Date).ToString("yyyy-MM-dd")
    $csvPath = [System.IO.Path]::Combine($targetDir, "SampleInfo_Biochem_$todayStr.csv")
    
    $csvLines = @()
    $csvLines += '"ID образца.","Фамилия","Имя","ФИО","Дата","Время","Glu","GGT","Тип_анализа"'
    foreach ($p in $patientsMap.Values) {
        $fullName = $p.PatientName
        $parts = $fullName.Split(' ', 2)
        $lastName = if ($parts.Length -gt 0) { $parts[0] } else { "" }
        $firstName = if ($parts.Length -gt 1) { $parts[1] } else { "" }

        $line = '"{0}","{1}","{2}","{3}","{4}","{5}","{6}","{7}","BIOCHEM"' -f $p.SampleID, $lastName, $firstName, $fullName, $p.Date, $p.Time, $p.Glu, $p.GGT
        $csvLines += $line
    }

    # Запис з UTF-8 BOM для бездоганного розпізнавання кирилиці
    $utf8WithBom = New-Object System.Text.UTF8Encoding($true)
    [System.IO.File]::WriteAllLines($csvPath, $csvLines, $utf8WithBom)

    Write-Log "Успішно збережено $($patientsMap.Count) пацієнтів у файл: $csvPath" "Green"
    return $patientsMap.Count
}

# ==============================================================================
# ГОЛОВНИЙ БЛОК ВИКОНАННЯ
# ==============================================================================
Write-Log "============================================================" "Cyan"
Write-Log " MINDRAY BS-230 ROCK-SOLID EXPORTER" "Cyan"
$MindrayDir = Get-MindrayInstallationPath
Write-Log " Директорія Mindray: $MindrayDir" "Gray"

if ($Once) {
    Write-Log "--- РЕЖИМ ПРЯМОГО ДІАГНОСТИЧНОГО ТЕСТУ ---" "Yellow"
    $drives = Get-TargetUsbDrives
    if ($drives.Count -eq 0) {
        $testTarget = [System.IO.Path]::Combine($ScriptDir, "SCAN_00")
        Write-Log "[!] Зовнішніх USB-флешок не виявлено. Тестовий експорт виконується в ($testTarget)..." "Yellow"
        $count = Export-MindrayDataToDrive -driveRoot $ScriptDir -mindrayDir $MindrayDir
        Write-Log "Тестовий експорт виконано успішно: $count записів" "Green"
    } else {
        foreach ($d in $drives) {
            $destFolder = [System.IO.Path]::Combine($d, "SCAN_00")
            Write-Log "Виявлено диск: $d" "Green"
            $count = Export-MindrayDataToDrive -driveRoot $d -mindrayDir $MindrayDir
            Write-Log "Успішно експортовано $count записів на $destFolder" "Green"
            Show-TrayNotification "Mindray BS-230 Exporter" "Експорт завершено: $count записів."
        }
    }
    Write-Log "--- ДІАГНОСТИКУ ЗАВЕРШЕНО УСПІШНО ---" "Cyan"
    exit 0
}

# ==============================================================================
# ГОЛОВНИЙ ФОНОВИЙ ЦИКЛ СЛУЖБИ
# ==============================================================================
Write-Log " Очікування підключення USB-флешки..." "Gray"
Write-Log "============================================================" "Cyan"

$processedDrives = [System.Collections.Generic.HashSet[string]]::new()

while ($true) {
    try {
        $drives = Get-TargetUsbDrives
        
        foreach ($d in $drives) {
            if (-not $processedDrives.Contains($d)) {
                $destFolder = [System.IO.Path]::Combine($d, "SCAN_00")
                Write-Log "Виявлено нову USB-флешку: $d" "Green"
                $count = Export-MindrayDataToDrive -driveRoot $d -mindrayDir $MindrayDir
                Show-TrayNotification "Mindray BS-230 Exporter" "Аналізи біохімії скопійовано на флешку: $count записів."
                $processedDrives.Add($d) | Out-Null
            }
        }

        # Очищення витягнутих флешок
        $toRemove = @()
        foreach ($p in $processedDrives) {
            if ($drives -notcontains $p) {
                $toRemove += $p
            }
        }
        foreach ($r in $toRemove) {
            Write-Log "USB-флешку відключено: $r" "DarkGray"
            $processedDrives.Remove($r) | Out-Null
        }
    } catch {
        Write-Log "Помилка в циклі моніторингу: $_" "Red"
    }

    Start-Sleep -Seconds 3
}
