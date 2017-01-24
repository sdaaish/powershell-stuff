<#
	.SYNOPSIS
	Initial setup to use Powershell profiles located in git repository.

	.NOTES
	2017-01-16/SDAA
#>

# define the different User-profiles
$shared_profile = $Profile.CurrentUserAllHosts
$local_profile = $Profile.CurrentUserCurrentHost

# Links to the profiles from repository
$DirScripts = "$env:Userprofile\Repos\powershell-stuff"
$console_profile = "$DirScripts\profile_console.ps1"
$ise_profile = "$DirScripts\profile_ise.ps1"
$common_profile = "$DirScripts\profile.ps1"

# Create the common profile for both Console and ISE (same file)
if (! (Test-Path -Path $shared_profile)) {
    Write-Host "Profile don't exist, creating new file"
    New-Item -Path $shared_profile > $null
    Add-Content -Path $shared_profile -Value "`$DirScripts `= `"$DirScripts`""
    Add-Content -Path $shared_profile -Value '. "$DirScripts\profile.ps1"'
    Write-Host -ForegroundColor DarkCyan "Created profile in $shared_profile."
}
else {
    Write-Host -ForeGroundColor Yellow "There is already an profile located at: $shared_profile."
}

# Create the local profile for Console or ISE depending of the console run
if (! (Test-Path -Path $local_profile)) {
    Write-Host "Profile don't exist, creating new file"
    New-Item -Path $local_profile > $null
    # If this is a console and not ISE
    if ($host.name -eq 'ConsoleHost'){
	Add-Content -Path $local_profile -Value '. "$DirScripts\profile_console.ps1"'
    }
    else {
	Add-Content -Path $local_profile -Value '. "$DirScripts\profile_ise.ps1"' # Assume ISE
    }
    Write-Host -ForegroundColor DarkCyan "Created ISE profile in $local_profile."
}
else {
    Write-Host -ForeGroundColor Yellow "There is already an profile located at: $local_profile."
}

