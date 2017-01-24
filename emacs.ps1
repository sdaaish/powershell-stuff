<#
	.SYNOPSIS
	Script that adds "Emacs" as option in explorer "Open" contextual menu

	.DESCRIPTION
	Requires Chocolatay and that emacs64 is installed. Otherwise change the URL for $emacs.

	.NOTES
	Problems and registry:
	http://stackoverflow.com/questions/29267307/set-registry-key-to-open-notepad

	Good Howto:
	https://en.wikiversity.org/wiki/Windows_PowerShell/Registry
#>	

# HKEY_CLASSES_ROOT is equal to HKLM:\Software\Classes
$registryPath = 'HKLM:\Software\Classes\*\Shell\Emacs\Command'
$emacs = "C:\ProgramData\chocolatey\bin\runemacs.exe `"%1`""

if (!(Test-Path -LiteralPath $registryPath)) {
    New-Item -Path $registryPath -Force |Out-Null
    New-ItemProperty -LiteralPath $registryPath -Name "(default)" -value $emacs -PropertyType string |OUT-Null
}
else {
    Set-ItemProperty -LiteralPath $registryPath -Name "(default)" -value $emacs -Force|OUT-Null
}

# Read the actual value
Write-Host "New value for $registryPath.default is:"
(Get-ItemProperty -LiteralPath $registryPath).'(default)'
