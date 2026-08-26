' ==============================================================================
' Mindray BS-230 Rock-Solid Silent Launcher
' ==============================================================================
Set WshShell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")
currentDir = fso.GetParentFolderName(WScript.ScriptFullName)
ps1Script = currentDir & "\mindray_export_engine.ps1"

cmd = "powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File """ & ps1Script & """"
WshShell.Run cmd, 0, False
