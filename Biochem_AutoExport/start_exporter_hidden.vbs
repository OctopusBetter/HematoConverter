' ==============================================================================
' Mindray BS-230 Rock-Solid Silent Launcher
' ==============================================================================
Set WshShell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")
currentDir = fso.GetParentFolderName(WScript.ScriptFullName)

cmd = "C:\tools\python\pythonw.exe """ & currentDir & "\biochem_usb_exporter.py"""
WshShell.CurrentDirectory = currentDir
WshShell.Run cmd, 0, False
