<#
.SYNOPSIS
Script that adds "Emacs" as option in explorer "Open" contextual menu

.DESCRIPTION
Requires that emacs64 is installed and the command-file weasel.cmd, from https://raw.githubusercontent.com/sdaaish/winstuff/master/weasel.cmd.

.NOTES
This script starts emacsclientw and emacs as server plus opens the file given as argument.
I found this the best way to open a file with emacs at the moment.
#>

# HKEY_CLASSES_ROOT is equal to HKLM:\Software\Classes
$registryPath = 'HKLM:\Software\Classes\*\Shell\Weasel\Command'
$mycmd = "weasel.cmd"

# Test for admin privs
function Test-Admin
{
    $wid = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $prp = New-Object System.Security.Principal.WindowsPrincipal($wid)
    $adm = [System.Security.Principal.WindowsBuiltInRole]::Administrator
    $prp.IsInRole($adm)
}

# Find the command-script
function find-command {
    try  {
        $exe = (Get-Command -ErrorAction Stop $mycmd).source
    }
    catch {
        Write-Host -ForeGroundColor Red "Could not find weasel.cmd"
        break
    }
    # Set the value to register for emacsclient and parameters
    $exe = "$exe `"%1`""
    return $exe
}

#Main
$admincheck = Test-Admin
if ( $admincheck ){

    $emacs = find-command

    if (!(Test-Path -LiteralPath $registryPath)) {
        New-Item -Path $registryPath -Force |Out-Null
        New-ItemProperty -LiteralPath $registryPath -Name "(default)" -value $emacs -PropertyType string |OUT-Null
    }
    else {
        Set-ItemProperty -LiteralPath $registryPath -Name "(default)" -value $emacs -Force|OUT-Null
    }

    # Read the actual value
    Write-Host -ForeGroundColor Yellow "New value for $registryPath.default: " -nonewline
    $var = (Get-ItemProperty -LiteralPath $registryPath).'(default)'
    Write-Host $var -ForeGroundColor DarkMagenta
}
else {
    Write-Host -ForeGroundColor Red "You dont have administrative rights to change this!"
}

