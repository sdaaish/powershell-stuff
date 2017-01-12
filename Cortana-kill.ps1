#
## Script to find and disable Cortana
#

## 2016-01-15/sdaa

#Clear Screen
Clear-Host

$version = [Environment]::OSVersion.Version.Major
#$version = (Get-WmiObject -class Win32_OperatingSystem).Caption
Write-Host "$version"

if ( $version  -eq "10" ) {
	Write-Host "Host.version is 10"
    }
else {
	Write-Host "Host.version is $version. Not supported"
	Exit
}

# Check name of directory - something like: "Microsoft.Windows.Cortana_xx5xxxxtxxxewy"
Get-ChildItem -Path $env:windir -Filter system -Recurse -Name
#taskkill /F /IM SearchUI.exe

#move /Y "%windir%\SystemApps\Microsoft.Windows.Cortana_cw5n1h2txyewy" "%windir%\SystemApps\Disable_Microsoft.Windows.Cortana_cw5n1h2txyewy.bak"

#Disable Cortana & Telemetry 
#reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d 0

# Hide the search box from taskbar. You can still search by pressing the Win key and start typing what you're looking for 
# 0 = hide completely, 1 = show only icon, 2 = show long search box
#reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d 0 /f

#PowerShell -Command "Get-AppxPackage *Cortana*"
#PowerShell -Command "Get-AppxPackage *Cortana* | Remove-AppxPackage"

# Just some random text
Write-Host "Press any key to continue..."
$x = $HOST.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
