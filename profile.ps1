<#
.SYNOPSIS
Default settings for Powershell. 
Common settings for both console and ISE. This is the first user-profile to be loaded.
Call this script from profile in windows directory

.NOTES	
- Added initial stuff
- Only common stuff in this file for Console and ISE. Use profile_console and profile_ise for specific features

2017-01-12/SDAA

.LINKS
- From http://www.howtogeek.com/50236/customizing-your-powershell-profile/
- More info https://technet.microsoft.com/en-us/library/2008.10.windowspowershell.aspx
- And of course http://ss64.com/ps/syntax-profile.html
- https://www.interworks.com/blog/jpoehls/2011/03/25/scripting-tips-take-your-powershell-profile-everywhere-dropbox
#>

# Standard home dir
#Set-Location ($env:UserProfile)

# No bell sound
Set-PSReadlineOption -BellStyle None

# Get info about current user
if ( $PSVersionTable.Platform -notlike "Unix"){
    $id = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $name = ($id).Name
    $p = New-Object System.Security.Principal.WindowsPrincipal($id)

    if ($p.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)) {
        $Host.UI.RawUI.WindowTitle = "Administrator: " + $Host.UI.RawUI.WindowTitle
    }
    else {
        $Host.UI.RawUI.WindowTitle = "Powershell " + ($name)
    }
}
else {
    $name = $Env:USER
    $Host.UI.RawUI.WindowTitle = "Powershell " + $name
}


# Import functions
. $DirScripts\functions.ps1

# Add local module-path to `$PSModulePath
$env:PSModulePath = Set-LocalModulePath -Verbose

# Import aliases
. $DirScripts\aliases.ps1
