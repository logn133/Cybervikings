Powershell.exe -noexit -ExecutionPolicy Bypass -command "Start-Process PowerShell -verb runAs" "'-noexit -ExecutionPolicy Bypass -File %~dp0invScript.ps1 -Path %~dp0 '"