<#
==============================================================================
MINDRAY BS-230 STANDALONE EXPORT ENGINE (PowerShell / .NET Native)
==============================================================================
Працює АВТОНОМНО на будь-якій версії Windows БЕЗ встановлення Python!
==============================================================================
#>

$CandidateDirs = @(
    "D:\mindray\Mindray\BS230\OperationSoft",
    "D:\Mindray\BS230\OperationSoft",
    "C:\Mindray\BS230\OperationSoft",
    "C:\Mindray\BS240\OperationSoft",
    "D:\Mindray\BS240\OperationSoft"
)

$MindrayInstallDir = $CandidateDirs[0]
foreach ($p in $CandidateDirs) {
    if ((Test-Path (Join-Path $p "PrintOutput")) -or (Test-Path (Join-Path $p "DataBase"))) {
        $MindrayInstallDir = $p
        break
    }
}
$SqlInstance = ".\BS240"
$SqlDb = "BA80"
$SqlUser = "sa"
$SqlPass = "MINDRAY#BS800"
$ExportFolderName = "Mindray_BS230_Export"

$processedDrives = [System.Collections.Generic.HashSet[string]]::new()

function Show-TrayNotification($title, $msg) {
    try {
        [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
        $notify = New-Object System.Windows.Forms.NotifyIcon
        $notify.Icon = [System.Drawing.SystemIcons]::Information
        $notify.Visible = $true
        $notify.ShowBalloonTip(5000, $title, $msg, [System.Windows.Forms.ToolTipIcon]::Info)
        Start-Sleep -Seconds 3
        $notify.Dispose()
    } catch {}
}

function Get-RemovableUsbDrives {
    $drives = [System.IO.DriveInfo]::GetDrives() | Where-Object { $_.DriveType -eq [System.IO.DriveType]::Removable -and $_.IsReady }
    return $drives
}

function Export-MindrayDataToDrive($driveRoot) {
    $targetDir = Join-Path $driveRoot $ExportFolderName
    if (-not (Test-Path $targetDir)) {
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
    }

    $patientsMap = @{}

    # 1. Спроба прямого запиту до MS SQL Server
    $connStr = "Server=$SqlInstance;Database=$SqlDb;User Id=$SqlUser;Password=$SqlPass;Connect Timeout=8;"
    $sqlSuccess = $false
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
    } catch {
        Write-Warning "SQL connect failed: $_"
    }

    # 2. Fallback PrintOutput *.out files
    if (-not $sqlSuccess -or $patientsMap.Count -eq 0) {
        $outFiles = Get-ChildItem (Join-Path $MindrayInstallDir "PrintOutput\*.out") -ErrorAction SilentlyContinue | Sort-Object LastWriteTime
        foreach ($f in $outFiles) {
            try {
                $lines = Get-Content $f.FullName -Encoding Default
                $sid = ""
                $pname = ""
                $dstr = ""
                $tstr = ""
                $glu = ""
                $ggt = ""
                $currName = ""
                $currVal = ""

                foreach ($line in $lines) {
                    if ($line -match "ID=00050.*Str=(.*)") { $sid = $matches[1].Trim() }
                    elseif ($line -match "ID=00020.*Str=(.*)") { $pname = $matches[1].Trim() }
                    elseif ($line -match "ID=03002.*Str=(.*)") { $dstr = $matches[1].Trim() }
                    elseif ($line -match "ID=00018.*Str=(.*)") {
                        $full = $matches[1].Trim()
                        $pts = $full.Split(' ')
                        if ($pts.Length -eq 2) { $dstr = $pts[0]; $tstr = $pts[1] } else { $tstr = $full }
                    }
                    elseif ($line -match "ID=00090.*Str=(.*)") { $currName = $matches[1].Trim() }
                    elseif ($line -match "ID=00092.*Str=(.*)") { $currVal = $matches[1].Trim() }
                    elseif ($line -match "ID=00094.*Str=(.*)") {
                        if ($currName -and $currVal) {
                            if ($currName.Contains("Glu")) { $glu = $currVal }
                            elseif ($currName.Contains("GT") -or $currName.Contains("GGT")) { $ggt = $currVal }
                            $currName = ""
                            $currVal = ""
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

    # 3. Запис CSV
    $todayStr = (Get-Date).ToString("yyyy-MM-dd")
    $csvPath = Join-Path $targetDir "SampleInfo_Biochem_$todayStr.csv"
    
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
    [System.IO.File]::WriteAllLines($csvPath, $csvLines, [System.Text.Encoding]::UTF8)

    return $patientsMap.Count
}

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host " MINDRAY BS-230 NATIVE USB EXPORTER ACTIVE" -ForegroundColor Cyan
Write-Host " Очікування підключення USB-флешки..." -ForegroundColor Gray
Write-Host "============================================================" -ForegroundColor Cyan

while ($true) {
    try {
        $drives = Get-RemovableUsbDrives
        $currentLetters = @($drives | ForEach-Object { $_.RootDirectory.FullName })

        foreach ($d in $drives) {
            $path = $d.RootDirectory.FullName
            if (-not $processedDrives.Contains($path)) {
                Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Виявлено USB-флешку: $path" -ForegroundColor Green
                $count = Export-MindrayDataToDrive $path
                Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Скопійовано $count аналізів на $path" -ForegroundColor Green
                Show-TrayNotification "Mindray BS-230 Exporter" "✅ Аналізи біохімії скопійовано на флешку ($path): $count записів."
                $processedDrives.Add($path) | Out-Null
            }
        }

        # Очищення відключених флешок
        $toRemove = @()
        foreach ($p in $processedDrives) {
            if ($currentLetters -notcontains $p) {
                $toRemove += $p
            }
        }
        foreach ($r in $toRemove) {
            $processedDrives.Remove($r) | Out-Null
        }
    } catch {
        Write-Error $_
    }
    Start-Sleep -Seconds 3
}
