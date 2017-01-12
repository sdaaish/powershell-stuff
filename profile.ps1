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

Write-Output Hello
set-location c:
$Shell.WindowTitle = "SysadminGeek"
$Shell = $Host.UI.RawUI
$size = $Shell.WindowSize
$size.width=120
$size.height=50
$Shell.WindowSize = $size
$size = $Shell.BufferSize
$size.width=120
$size.height=5000
$Shell.BufferSize = $size
$shell.BackgroundColor = "Gray"
$shell.ForegroundColor = "Black"
new-item alias:np -value C:\Windows\System32\notepad.exe
#Clear-Host
