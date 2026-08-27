<#
==============================================================================
 MINDRAY BS-230 ROCK-SOLID STANDALONE EXPORT ENGINE (PowerShell / .NET Native)
==============================================================================
 1. 100% АВТОНОМНИЙ (PowerShell + .NET Native, без сторонніх залежностей)
 2. ПОВНЕ АВТОМАТИЧНЕ ВИЗНАЧЕННЯ SQL SERVER (служби, реєстр, автозапуск)
 3. РОЗУМНИЙ ІНКРЕМЕНТНИЙ ЕКСПОРТ (дозаписує тільки нові/змінені аналізи)
 4. АУДІО ТА ГОЛОСОВЕ СПОВІЩЕННЯ (Windows System Chime + TTS Speech)
 5. АВТОМАТИЧНЕ СТВОРЕННЯ SCAN_00 на будь-якій USB-флешці
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
    try {
        $proc = Get-Process WorkStation, BS230, BS240 -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($proc -and $proc.Path) {
            $pDir = Split-Path $proc.Path -Parent
            if ([System.IO.Directory]::Exists($pDir)) {
                return $pDir
            }
        }
    } catch {}

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

# 2. Надійне виявлення USB-флешок (Removable + Fixed USB + будь-які знімні носії)
function Get-TargetUsbDrives {
    $targetRoots = @()
    $sysDrive = ($env:SystemDrive + "\").ToUpper()

    try {
        $logicalRemovables = Get-CimInstance Win32_LogicalDisk -ErrorAction SilentlyContinue | Where-Object { $_.DriveType -eq 2 }
        foreach ($d in $logicalRemovables) {
            $r = ($d.DeviceID + "\").ToUpper()
            if ($r -ne $sysDrive -and $targetRoots -notcontains $r) {
                $targetRoots += $r
            }
        }
    } catch {}

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

# 3. Аудіо, Голосове та Візуальне Сповіщення
function Notify-ExportComplete($title, $msg, $spokenText = "Биохимия скопирована на флешку") {
    try {
        [System.Media.SystemSounds]::Asterisk.Play()
    } catch {}

    try {
        [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Speech")
        $synth = New-Object System.Speech.Synthesis.SpeechSynthesizer
        $synth.SpeakAsync($spokenText) | Out-Null
    } catch {}

    try {
        [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
        $notify = New-Object System.Windows.Forms.NotifyIcon
        $notify.Icon = [System.Drawing.SystemIcons]::Information
        $notify.Visible = $true
        $notify.ShowBalloonTip(6000, $title, $msg, [System.Windows.Forms.ToolTipIcon]::Info)
        Start-Sleep -Seconds 2
        $notify.Dispose()
    } catch {}
}

# 4. Виконання SQL-запиту до відкритих з'єднань
function Query-MindraySqlTable($conn) {
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
    $cmd.CommandTimeout = 10
    $adapter = New-Object System.Data.SqlClient.SqlDataAdapter($cmd)
    $table = New-Object System.Data.DataTable
    $adapter.Fill($table) | Out-Null

    $resMap = @{}
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
        if (-not $resMap.ContainsKey($key)) {
            $resMap[$key] = [PSCustomObject]@{
                SampleID = $sid
                PatientName = $pname
                Date = $dstr
                Time = $tstr
                Glu = ""
                GGT = ""
            }
        }

        if ($chem.Contains("GLU")) { $resMap[$key].Glu = $val }
        elseif ($chem.Contains("GT") -or $chem.Contains("GGT")) { $resMap[$key].GGT = $val }
    }
    return $resMap
}

# 5. Повний автоматичний пошук та підключення до MS SQL Server
function Get-MindraySqlPatients {
    $foundServiceInstances = @()

    # 5.1. Пошук запущених служб SQL Server у Windows
    try {
        $services = Get-Service | Where-Object { $_.Name -like "MSSQL*" -or $_.DisplayName -like "*SQL Server*" }
        foreach ($svc in $services) {
            if ($svc.Status -ne "Running") {
                try { Start-Service $svc.Name -ErrorAction SilentlyContinue } catch {}
            }
            if ($svc.Name -match "MSSQL\$(.*)") {
                $instName = $matches[1]
                $foundServiceInstances += ".\$instName"
                $foundServiceInstances += "(local)\$instName"
                $foundServiceInstances += "$($env:COMPUTERNAME)\$instName"
            } elseif ($svc.Name -eq "MSSQLSERVER") {
                $foundServiceInstances += "."
                $foundServiceInstances += "(local)"
                $foundServiceInstances += "$($env:COMPUTERNAME)"
            }
        }
    } catch {}

    # 5.2. Вибір цільових екземплярів
    $instances = if ($foundServiceInstances.Count -gt 0) { 
        $foundServiceInstances 
    } else { 
        @(".\BS240", "(local)\BS240", ".\BS230", "(local)\BS230", ".\BS200", ".\BA80", ".\SQLEXPRESS", "(local)", ".") 
    }

    $passwords = @("MINDRAY#BS800", "MINDRAY#BS200", "Mindray#BS800", "Mindray#BS200", "mindray#bs800", "mindray", "MINDRAY", "123456", "sa", "")
    $databases = @("BA80", "BS240", "BS230", "BS200", "MindrayBA", "BA40")

    $connected = $false
    $lastErr = ""

    foreach ($inst in $instances) {
        if ($connected) { break }
        
        # 1. Спроба Windows Authentication
        foreach ($db in $databases) {
            if ($connected) { break }
            $connStr = "Server=$inst;Database=$db;Integrated Security=True;Connect Timeout=1;"
            try {
                $conn = New-Object System.Data.SqlClient.SqlConnection($connStr)
                $conn.Open()
                $map = Query-MindraySqlTable -conn $conn
                $conn.Close()
                if ($map -ne $null) {
                    Write-Log "🟢 УСПІХ: Зчитано $($map.Count) пацієнтів напряму з бази SQL ($inst, база $db, Windows Auth)!" "Green"
                    return $map
                }
            } catch {
                $lastErr = $_.Exception.Message
            }
        }

        # 2. Спроба SQL Authentication (sa)
        foreach ($pass in $passwords) {
            if ($connected) { break }
            foreach ($db in $databases) {
                if ($connected) { break }
                $connStr = "Server=$inst;Database=$db;User Id=sa;Password=$pass;Connect Timeout=1;"
                try {
                    $conn = New-Object System.Data.SqlClient.SqlConnection($connStr)
                    $conn.Open()
                    $map = Query-MindraySqlTable -conn $conn
                    $conn.Close()
                    if ($map -ne $null) {
                        Write-Log "🟢 УСПІХ: Зчитано $($map.Count) пацієнтів напряму з бази SQL ($inst, база $db, пароль sa)!" "Green"
                        return $map
                    }
                } catch {
                    $lastErr = $_.Exception.Message
                }
            }
        }
    }

    Write-Log "⚠️ Не вдалося підключитися до SQL: $lastErr" "Yellow"
    return @{}
}

# 6. Збір та Розумний Інкрементний Експорт Даних
function Export-MindrayDataToDrive {
    param(
        [Parameter(Mandatory=$true)][string]$driveRoot,
        [Parameter(Mandatory=$true)][string]$mindrayDir
    )

    $targetDir = [System.IO.Path]::Combine($driveRoot, "SCAN_00")
    if (-not [System.IO.Directory]::Exists($targetDir)) {
        try {
            [System.IO.Directory]::CreateDirectory($targetDir) | Out-Null
            Write-Log "Створено папку SCAN_00 на флешці ($targetDir)" "DarkGray"
        } catch {
            Write-Log "Попередження: не вдалося створити $targetDir : $_" "Yellow"
        }
    }

    # 6.1. ПРЯМИЙ ЕКСПОРТ З БАЗИ ДАНИХ SQL SERVER
    $patientsMap = Get-MindraySqlPatients

    # 6.2. Резервний парсинг PrintOutput тільки якщо SQL повернув 0
    if ($patientsMap.Count -eq 0) {
        Write-Log "SQL не повернув даних, зчитування з локального буфера: $mindrayDir" "Yellow"
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

                            if ($line.Contains("ID=00050")) { $sid = $valStr }
                            elseif ($line.Contains("ID=00020")) { $pname = $valStr }
                            elseif ($line.Contains("ID=03002")) { $dstr = $valStr }
                            elseif ($line.Contains("ID=00018")) {
                                $pts = $valStr.Split(' ')
                                if ($pts.Length -eq 2) { $dstr = $pts[0]; $tstr = $pts[1] } else { $tstr = $valStr }
                            }
                            elseif ($line.Contains("ID=00090")) { $currName = $valStr }
                            elseif ($line.Contains("ID=00092")) { $currVal = $valStr }
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

    # 6.3. РОЗУМНИЙ ІНКРЕМЕНТНИЙ ЗАПИС У CSV
    $todayStr = (Get-Date).ToString("yyyy-MM-dd")
    $csvPath = [System.IO.Path]::Combine($targetDir, "SampleInfo_Biochem_$todayStr.csv")
    
    $existingMap = @{}
    if ([System.IO.File]::Exists($csvPath)) {
        try {
            $existingLines = [System.IO.File]::ReadAllLines($csvPath, [System.Text.Encoding]::UTF8)
            for ($i = 1; $i -lt $existingLines.Length; $i++) {
                $line = $existingLines[$i].Trim()
                if ($line) {
                    $parts = $line.Split(',')
                    if ($parts.Length -ge 8) {
                        $eSid = $parts[0].Trim('"')
                        $eName = $parts[3].Trim('"')
                        $eDate = $parts[4].Trim('"')
                        $eTime = $parts[5].Trim('"')
                        $eGlu = $parts[6].Trim('"')
                        $eGgt = $parts[7].Trim('"')
                        $eKey = "${eDate}_${eSid}_${eName}"
                        $existingMap[$eKey] = [PSCustomObject]@{
                            SampleID = $eSid
                            PatientName = $eName
                            Date = $eDate
                            Time = $eTime
                            Glu = $eGlu
                            GGT = $eGgt
                        }
                    }
                }
            }
        } catch {}
    }

    $newCount = 0
    foreach ($k in $patientsMap.Keys) {
        $pNew = $patientsMap[$k]
        if (-not $existingMap.ContainsKey($k)) {
            $existingMap[$k] = $pNew
            $newCount++
        } else {
            if ($pNew.Glu -and -not $existingMap[$k].Glu) { $existingMap[$k].Glu = $pNew.Glu; $newCount++ }
            if ($pNew.GGT -and -not $existingMap[$k].GGT) { $existingMap[$k].GGT = $pNew.GGT; $newCount++ }
        }
    }

    $csvLines = @()
    $csvLines += '"ID образца.","Фамилия","Имя","ФИО","Дата","Время","Glu","GGT","Тип_анализа"'
    foreach ($p in $existingMap.Values) {
        $fullName = $p.PatientName
        $parts = $fullName.Split(' ', 2)
        $lastName = if ($parts.Length -gt 0) { $parts[0] } else { "" }
        $firstName = if ($parts.Length -gt 1) { $parts[1] } else { "" }

        $line = '"{0}","{1}","{2}","{3}","{4}","{5}","{6}","{7}","BIOCHEM"' -f $p.SampleID, $lastName, $firstName, $fullName, $p.Date, $p.Time, $p.Glu, $p.GGT
        $csvLines += $line
    }

    $utf8WithBom = New-Object System.Text.UTF8Encoding($true)
    [System.IO.File]::WriteAllLines($csvPath, $csvLines, $utf8WithBom)

    Write-Log "✅ Успішно збережено $($existingMap.Count) пацієнтів (нових: $newCount) у файл: $csvPath" "Green"
    return [PSCustomObject]@{ Total = $existingMap.Count; New = $newCount }
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
        $res = Export-MindrayDataToDrive -driveRoot $ScriptDir -mindrayDir $MindrayDir
        Write-Log "Тестовий експорт виконано успішно: $($res.Total) записів (нових: $($res.New))" "Green"
        Notify-ExportComplete -title "Mindray BS-230 Exporter" -msg "Тестовий експорт: $($res.Total) записів." -spokenText "Тестовый экспорт биохимии завершен"
    } else {
        foreach ($d in $drives) {
            $destFolder = [System.IO.Path]::Combine($d, "SCAN_00")
            Write-Log "Виявлено диск: $d" "Green"
            $res = Export-MindrayDataToDrive -driveRoot $d -mindrayDir $MindrayDir
            Write-Log "Успішно експортовано $($res.Total) записів (нових: $($res.New)) на $destFolder" "Green"
            Notify-ExportComplete -title "Mindray BS-230 Exporter" -msg "Експорт завершено ($destFolder): $($res.Total) записів." -spokenText "Биохимия скопирована на флешку"
        }
    }
    Write-Log "--- ДІАГНОСТИКУ ЗАВЕРШЕНО УСПІШНО ---" "Cyan"
    exit 0
}

# ==============================================================================
# ГОЛОВНИЙ ФОНОВИЙ ЦИКЛ СЛУЖБИ (З анти-спам захистом та чистим виводом)
# ==============================================================================
Write-Log " Очікування підключення USB-флешки..." "Gray"
Write-Log "============================================================" "Cyan"

$processedDrives = [System.Collections.Generic.HashSet[string]]::new()

while ($true) {
    try {
        $drives = Get-TargetUsbDrives
        
        foreach ($d in $drives) {
            if (-not $processedDrives.Contains($d)) {
                $processedDrives.Add($d) | Out-Null
                
                $destFolder = [System.IO.Path]::Combine($d, "SCAN_00")
                Write-Log "🚀 Виявлено нову USB-флешку: $d" "Green"
                
                try {
                    $res = Export-MindrayDataToDrive -driveRoot $d -mindrayDir $MindrayDir
                    Notify-ExportComplete -title "Mindray BS-230 Exporter" -msg "Аналізи біохімії скопійовано на флешку: $($res.Total) пацієнтів (нових: $($res.New))." -spokenText "Биохимия скопирована на флешку"
                } catch {
                    Write-Log "Помилка експорту на $d : $_" "Red"
                }
            }
        }

        # Очищення витягнутих флешок (коли користувач виймає флешку з порту)
        $toRemove = @()
        foreach ($p in $processedDrives) {
            if ($drives -notcontains $p) {
                $toRemove += $p
            }
        }
        foreach ($r in $toRemove) {
            Write-Log "⏏️ USB-флешку відключено: $r" "DarkGray"
            $processedDrives.Remove($r) | Out-Null
        }
    } catch {
        Write-Log "Помилка в циклі моніторингу: $_" "Red"
    }

    Start-Sleep -Seconds 3
}
