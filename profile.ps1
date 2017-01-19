<#
        .SYNOPSIS
        Default settings for Powershell. 
	Common settings for both console and ISE.
	Call this script from profile in windows directory

	.NOTES	
        - Added initial stuff
	- From http://www.howtogeek.com/50236/customizing-your-powershell-profile/
	- More info https://technet.microsoft.com/en-us/library/2008.10.windowspowershell.aspx
	- And of course http://ss64.com/ps/syntax-profile.html
	- https://www.interworks.com/blog/jpoehls/2011/03/25/scripting-tips-take-your-powershell-profile-everywhere-dropbox
	- Only common stuff in this file for Console and ISE. Use profile_console and profile_ise for specific features

	2017-01-12/SDAA
#>

# Standard home dir
Set-Location ($env:UserProfile)

# No bell sound
Set-PSReadlineOption -BellStyle None

# Get info about current user
$id = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$name = ($id).Name
$p = New-Object System.Security.Principal.WindowsPrincipal($id)
if ($p.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)) {
    $Host.UI.RawUI.WindowTitle = "Administrator: " + $Host.UI.RawUI.WindowTitle
}
else {
    $Host.UI.RawUI.WindowTitle = "Powershell " + ($name)
}

#Aliases
New-Alias -Name np -Value C:\Windows\System32\notepad.exe
#New-Item alias:x -value "exit"
Set-Alias -Name src -Value reload-powershell-profile
Set-Alias -Name alias -Value Get-Alias

# Clear terminal
Clear-Host
Write-Output "Hello ($name)!"

#Functions
function cdh {
    Set-Location $Env:UserProfile\
}
function cdr {
    Set-Location $Env:UserProfile\Repos
}
function cdw {
    Set-Location $Env:UserProfile\Downloads
}
function cdv {
    Set-Location $Env:UserProfile\Vagrantdir
}
function reload-powershell-profile {
	. $profile
}
function show-profiles {
    $profile|Get-Member -MemberType NoteProperty
}
function show-colors {
    [enum]::GetValues([System.ConsoleColor]) | Foreach-Object {Write-Host $_ -ForegroundColor $_}
}
