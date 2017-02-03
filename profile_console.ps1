<#
        .SYNOPSIS
        Default settings for Powershell Console

        .NOTES

	2017-01-16/SDAA
#>
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

# Escape-colors
$Host.PrivateData.VerboseForegroundColor = "white"
$Host.PrivateData.VerboseBackgroundColor = "blue"
$Host.PrivateData.WarningForegroundColor = "yellow"
$Host.PrivateData.WarningBackgroundColor = "darkgreen"
$Host.PrivateData.ErrorForegroundColor = "white"
$Host.PrivateData.ErrorBackgroundColor = "red"

# Clear terminal
Clear-Host
Write-Output "Hello ($name)!"

