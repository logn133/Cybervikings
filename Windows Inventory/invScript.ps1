#Getting possible parameters or setting to false if not present
param (
  [switch]$CheckUp = $false,
  [string]$Path = "C:\Windows\Logs"
)

$Date = (Get-Date).ToString().Replace(':', '-').Replace('/', '-').Replace(' ', '_')
#Check to see if checkup is being run
$Scan = ""
if ($CheckUp) {
  $Scan = "Checkup-Scan"
}
Else {
   $Scan = "Base-Scan"
   $TPath = $Path.TrimEnd('\')
   #Setting the script to run automatically every 30 machines
   #$TAction = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument "-ExecutionPolicy RemoteSigned -file $TPath\invScript.ps1 -dir $Path -CheckUp $True"
   $TAction = New-ScheduledTaskAction -Execute "$TPath\Run-CheckUp.bat"
   $TTrigger = New-ScheduledTaskTrigger -Once -At (([DateTime]::Now).AddMinutes(30))  -RepetitionInterval (New-TimeSpan -Minutes 30) -RepetitionDuration (([DateTime]::Now).AddYears(4) - ([DateTime]::Now))
   #$TPrincipal = New-ScheduledTaskPrincipal -UserId SYSTEM -LogonType ServiceAccount -RunLevel Highest
   Register-ScheduledTask -Action $TAction -Trigger $TTrigger -TaskName "IS"
}
if (-Not [System.IO.File]::Exists("$Path\$Date-$Scan.txt")) {
    New-Item -Path $Path -Name "$Date-$Scan.txt" -ItemType "file"
}



$Agent = Read-Host -Prompt 'Agent Name'
$Title = 'System Inventory Report'

$AgentHeading = "Created by $Agent"

$DateHeading = "Date Created: $Date"

$Srvc = Get-Service | Sort-Object -Property Status, DisplayName | Format-Table @{L='Display Name';E={$_.DisplayName}}, Status #| Out-File -Path E:\Process-ServicesInventory-$Date.txt
$Prcs = tasklist -V
$hstnme = (Get-WmiObject Win32_OperatingSystem).CSName
$hstos = (Get-WmiObject Win32_OperatingSystem).Caption
$hstarc = (Get-WmiObject Win32_OperatingSystem).OSArchitecture
$hstosversion = (Get-WmiObject Win32_OperatingSystem).Version
$instSoft = Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate | Sort-Object Publisher, DisplayName, DisplayVersion, InstallDate | Format-Table –AutoSize
$localusr = Get-WmiObject -Class Win32_UserAccount -Filter "LocalAccount='True'" | Select PSComputername, Name, Status, Disabled, AccountType, Lockout, PasswordRequired, PasswordChangeable, SID | Format-Table –AutoSize


Write-Output "---------------------------------------------------" | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"
Write-Output "              $Title               " | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"
Write-Output "---------------------------------------------------" | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"
Write-Output " "

Write-Output $AgentHeading  | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"
Write-Output $DateHeading  | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"
Write-Output " " | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"

Write-Output "---------------------------------------------------" | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"
Write-Output "          Operating System Information            "  | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"
Write-Output "---------------------------------------------------" | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"
Write-Output " " | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"

Write-Output "Operating System: $hstos $hstarc" | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"
Write-Output "Version Number: $hstosversion" | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"
Write-Output "Computer Name: $hstnme" | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"
Write-Output " " | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"


Write-Output "                Installed Services                 "  | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"
Write-Output "---------------------------------------------------" | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"
Write-Output " " | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"
Write-Output $Srvc   | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"
Write-Output " " | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"
Write-Output "                Running Processes                  "  | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"
Write-Output "---------------------------------------------------" | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"
Write-Output " " | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"
Write-Output $Prcs  | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"
Write-Output " " | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"
Write-Output "                Installed Software                  "  | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"
Write-Output "---------------------------------------------------" | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"
Write-Output " " | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"
Write-Output $instSoft | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"
Write-Output " " | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"

Write-Output "---------------------------------------------------" | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"
Write-Output "                 User Information                  "  | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"
Write-Output "---------------------------------------------------" | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"
Write-Output " " | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"

Write-Output "                Local User Accounts                "  | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"
Write-Output "---------------------------------------------------" | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"
Write-Output " " | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"

Write-Output $localusr | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"


Write-Output "              User Accounts by Group               "  | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"
Write-Output "---------------------------------------------------" | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"
Write-Output " " | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"

function Get-Accounts {
$localadmgrp = net localgroup administrators |
 where {$_ -AND $_ -notmatch "command completed successfully"} |
 select -skip 4
New-Object PSObject -Property @{
 Computername = $env:COMPUTERNAME
 Group = "Administrators"
 Members=$localadmgrp
 } 

$localusrgrp = net localgroup users |
 where {$_ -AND $_ -notmatch "command completed successfully"} |
 select -skip 4
New-Object PSObject -Property @{
 Computername = $env:COMPUTERNAME
 Group = "Users"
 Members = $localusrgrp
 }

 $localrmtdskgrp = net localgroup "Remote Desktop Users"|
 where {$_ -AND $_ -notmatch "command completed successfully"} |
 select -skip 4
New-Object PSObject -Property @{
 Computername = $env:COMPUTERNAME
 Group = "Remote Desktop Users"
 Members = $localrmtdskgrp
 }

 $localrmtmntgrp = net localgroup "Remote Management Users"|
 where {$_ -AND $_ -notmatch "command completed successfully"} |
 select -skip 4
New-Object PSObject -Property @{
 Computername = $env:COMPUTERNAME
 Group = "Remote Management Users"
 Members = $localrmtmntgrp
 }

 $localsmagrp = net localgroup "System Managed Accounts Group"|
 where {$_ -AND $_ -notmatch "command completed successfully"} |
 select -skip 4
New-Object PSObject -Property @{
 Computername = $env:COMPUTERNAME
 Group = "System Managed Accounts Group"
 Members = $localsmagrp
 }

 $localpowusrgrp = net localgroup "Power Users"|
 where {$_ -AND $_ -notmatch "command completed successfully"} |
 select -skip 4
New-Object PSObject -Property @{
 Computername = $env:COMPUTERNAME
 Group = "Power Users"
 Members = $localpowusrgrp
 }

  $localgstgrp = net localgroup "Guests"|
 where {$_ -AND $_ -notmatch "command completed successfully"} |
 select -skip 4
New-Object PSObject -Property @{
 Computername = $env:COMPUTERNAME
 Group = "Guests"
 Members = $localgstgrp
 } 

 }

Get-Accounts | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"

Write-Output " "  | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"
Write-Output "                 Logged on Users                   "  | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"
Write-Output "---------------------------------------------------" | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"
Write-Output " " | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"

query USER | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"

Write-Output "---------------------------------------------------" | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"
Write-Output "              Networking Information               "  | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"
Write-Output "---------------------------------------------------" | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"
Write-Output " " | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"

Write-Output " " | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"
Write-Output "              IPAddress Information                "  | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"
Write-Output "---------------------------------------------------" | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"
Write-Output " " | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"

Get-NetIPAddress | Sort-Object -Property AddressFamily,AddressState |Format-Table -Property IPAddress,AddressFamily,InterfaceAlias,AddressState,InterfaceIndex -AutoSize  | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"


Write-Output " " | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"
Write-Output "              MACAddress Information                "  | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"
Write-Output "---------------------------------------------------" | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"
Write-Output " " | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"

Get-WmiObject win32_networkadapterconfiguration | Format-List -Property Caption,IPAddress,MACAddress | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"

Write-Output " " | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"
Write-Output "                  Routing Table                    "  | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"
Write-Output "---------------------------------------------------" | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"
Write-Output " " | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"

Get-NetRoute |Sort-Object -Descending -Property AddressFamily,NextHop,InterfaceAlias | Format-Table -Property AddressFamily,State,ifIndex,InterfaceAlias,NextHop | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"

Write-Output " " | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"
Write-Output "                   Open Ports                      "  | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"
Write-Output "---------------------------------------------------" | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"
Write-Output " " | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"

Get-NetTCPConnection | Sort-Object -Property State,RemoteAddress | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"

Write-Output " " | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"
Write-Output "                  Firewall Rules                   "  | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"
Write-Output "---------------------------------------------------" | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"
Write-Output " " | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"

Get-NetFirewallRule -PolicyStore ActiveStore | Format-Table -Property DisplayName,Enabled,Direction,Owner,PolicyStoreSource | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"

cat C:\Windows\System32\drivers\etc\hosts | Out-File -Append -FilePath "$Path\$Date-$Scan.txt"
if ($CheckUp) {
    $ls = Get-ChildItem -path $Path -Name | where {! $_.PSIsContainer} | Sort-Object lastaccesstime -Descending 
    $bs = ""
    $as = ""
    foreach ($l in $ls) {
        if ("$l" -like "*Base-Scan.txt" -and $bs -eq "") {
            $bs = "$Path" + "$l"
            echo "Base Scan File: $bs"
        }
        elseif ("$l" -like "*Checkup-Scan.txt" -and $as -eq "") {
            $as = "$Path" + "$l"
            echo "Newest checkup file: $as"
        }
    }
    if (-Not [System.IO.File]::Exists("$Date-Checked-Difference.txt")) {
        New-Item -Path $Path -Name "$Date-Checked-Difference.txt" -ItemType "file"
    }
    $CO = (Compare-Object -ReferenceObject $(Get-Content $bs) -DifferenceObject $(Get-Content $as) | select -ExpandProperty inputobject)
    echo $CO | Out-File -Append -FilePath "$Path\$Date-Checked-Difference.txt"
    Start-Process 'notepad.exe' "$Path\$Date-$Scan.txt"
    Start-Process 'notepad.exe' "$Path\$Date-Checked-Difference.txt"
}
else {
    Start-Process 'notepad.exe' "$Path\$Date-$Scan.txt"
}
