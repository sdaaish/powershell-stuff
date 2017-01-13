<#
        .SYNOPSIS
        Default settings for Powershell

        .NOTES
        - Added initial stuff
	- From http://www.howtogeek.com/50236/customizing-your-powershell-profile/
	- More info https://technet.microsoft.com/en-us/library/2008.10.windowspowershell.aspx
	- And of course http://ss64.com/ps/syntax-profile.html
	- https://www.interworks.com/blog/jpoehls/2011/03/25/scripting-tips-take-your-powershell-profile-everywhere-dropbox

	2017-01-12/SDAA
#>

# Standard home dir
Set-Location C:\

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

# Window and buffersize
$Host.UI.RawUI.WindowSize.width=120
$Host.UI.RawUI.WindowSize.height=70
$Host.UI.RawUI.BufferSize.width=120
$Host.UI.RawUI.BufferSize.height=5000

# Color
if ($host.UI.RawUI.WindowTitle -match "Administrator") {
    # Admin colors
    $host.UI.RawUI.BackgroundColor = "Darkred"
    $host.UI.RawUI.ForegroundColor = "White"
}
else {
    # Normal colors
    $Host.UI.RawUI.BackgroundColor = "Gray"
    $Host.UI.RawUI.ForegroundColor = "Black"
}

#Aliases
New-Item alias:np -value C:\Windows\System32\notepad.exe
#New-Item alias:x -value "exit"

# Clear terminal
Clear-Host
Write-Output "Hello ($name)!"
