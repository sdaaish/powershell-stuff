<#
.SYNOPSIS
Script that adds "Notepad" as option in explorer "Open" contextual menu

.DESCRIPTION
Requires that Notepad is installed. Otherwise change the URL for $Notepad.

.NOTES
Problems and registry:
http://stackoverflow.com/questions/29267307/set-registry-key-to-open-notepad

Good Howto:
https://en.wikiversity.org/wiki/Windows_PowerShell/Registry
#>

# HKEY_CLASSES_ROOT is equal to HKLM:\Software\Classes
$registryPath = 'HKLM:\Software\Classes\*\Shell\Notepad\Command'
$Notepad = "C:\Windows\System32\notepad.exe `"%1`""

# Test for admin privs
function Test-Admin
{
    $wid = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $prp = New-Object System.Security.Principal.WindowsPrincipal($wid)
    $adm = [System.Security.Principal.WindowsBuiltInRole]::Administrator
    $prp.IsInRole($adm)
}

$admincheck = Test-Admin
if ( $admincheck ){
    if (!(Test-Path -LiteralPath $registryPath)) {
        New-Item -Path $registryPath -Force |Out-Null
        New-ItemProperty -LiteralPath $registryPath -Name "(default)" -value $Notepad -PropertyType string |OUT-Null
    }
    else {
        Set-ItemProperty -LiteralPath $registryPath -Name "(default)" -value $Notepad -Force|OUT-Null
    }

    # Read the actual value
    Write-Host "New value for " -NoNewLine
    Write-Host -ForeGroundColor green "$registryPath.default is: " -Nonewline
    $var = (Get-ItemProperty -LiteralPath $registryPath).'(default)'
    Write-Host $var -ForeGroundColor DarkMagenta
}
else {
    Write-Host -ForeGroundColor Red "You dont have administrative rights to change this!"
}
