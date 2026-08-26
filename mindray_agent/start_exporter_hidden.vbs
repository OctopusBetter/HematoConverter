' ==============================================================================
' Mindray BS-230 Silent Launcher (start_exporter_hidden.vbs)
' Запускає скрипт експорту у фоновому режимі без відображення чорного вікна консолі
' ==============================================================================
Set WshShell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")
currentDir = fso.GetParentFolderName(WScript.ScriptFullName)

pyScript = currentDir & "\mindray_usb_exporter.py"
ps1Script = currentDir & "\mindray_export_engine.ps1"

On Error Resume Next
errCode = WshShell.Run("python --version", 0, True)
On Error GoTo 0

If errCode = 0 Then
    WshShell.Run "pythonw.exe """ & pyScript & """", 0, False
Else
    WshShell.Run "powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File """ & ps1Script & """", 0, False
End If
