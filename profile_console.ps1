<#
.SYNOPSIS
Default settings for Powershell Console

.NOTES
This user-profile loads after the common profile.
2017-01-16/SDAA
#>

# Window and buffersize
$Host.UI.RawUI.WindowSize.width=120
$Host.UI.RawUI.WindowSize.height=70
$Host.UI.RawUI.BufferSize.width=120
$Host.UI.RawUI.BufferSize.height=5000

# Oh-my-PoSH https://ohmyposh.dev/docs/upgrading/
$Theme = Join-Path ${env:USERPROFILE} ".config\oh-my-posh\my-posh-theme.omp.json"
oh-my-posh.exe --init --shell pwsh --config $Theme | Invoke-Expression
Enable-PoshTransientPrompt
${env:POSH_GIT_ENABLED} = $true

$ColorTheme = Join-Path ${env:UserProfile} ".config\ColorThemes\MyColorTheme.psd1"
Add-TerminalIconsColorTheme -Path $ColorTheme -Force
Set-TerminalIconsTheme -ColorTheme MyColorTheme

# Clear terminal
#Clear-Host
Write-Output "Hello ($name)!"

"Time taken {0} ms." -f ((Get-Date) - ($starttime)).MilliSeconds
