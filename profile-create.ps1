<#
	.SYNOPSIS
	Initial setup to use Powershell profiles located in git repository.

	.NOTES
	2017-01-16/SDAA
#>

$ise_profile = $Profile.CurrentUserCurrentHost
if (! (Test-Path -Path $ise_profile)) {
    Write-Host "ISE profile don't exist, creating new file"
    New-Item -Path $ise_profile > $null
    Add-Content -Path $ise_profile -Value '$DirScripts = "$env:Userprofile\Repos\powershell-stuff"'
    Add-Content -Path $ise_profile -Value '. "$DirScripts\profile_ise.ps1"'
    Write-Host -ForegroundColor DarkMagenta "Created ISE profile in $ise_profile."
}
else {
    Write-Host "There is already an ISE profile located at: $ise_profile."
}
