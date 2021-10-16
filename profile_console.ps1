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

# $GitPromptSettings.DefaultPromptAbbreviateHomeDirectory = $true
# $GitPromptSettings.DefaultPromptWriteStatusFirst = $true
# $GitPromptSettings.DefaultPromptPrefix = "`n"
# $GitPromptSettings.DefaultPromptBeforeSuffix.Text = '`n$([DateTime]::now.ToString("MM-dd HH:mm:ss"))'
# $GitPromptSettings.DefaultPromptBeforeSuffix.ForegroundColor = 0xdaa520
# $GitPromptSettings.DefaultPromptSuffix = ' $((Get-History -Count 1).id + 1)$(" >" * ($nestedPromptLevel + 1)) '

# Clear terminal
#Clear-Host
Write-Output "Hello ($name)!"

