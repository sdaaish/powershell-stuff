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

# Info from https://github.com/dahlbyk/posh-git/wiki/Customizing-Your-PowerShell-Prompt
# This works with 1.0 of Posh-Git
Import-Module Posh-Git

# Oh-my-PoSH https://ohmyposh.dev/docs/upgrading/
Import-Module oh-my-posh
try {Set-PoshPrompt -Theme ${env:USERPROFILE}\.config\oh-my-posh\my-posh-theme.omp.json}
catch {Set-PoshPrompt -Theme Paradox}

# $GitPromptSettings.DefaultPromptAbbreviateHomeDirectory = $true
# $GitPromptSettings.DefaultPromptWriteStatusFirst = $true
# $GitPromptSettings.DefaultPromptPrefix = "`n"
# $GitPromptSettings.DefaultPromptBeforeSuffix.Text = '`n$([DateTime]::now.ToString("MM-dd HH:mm:ss"))'
# $GitPromptSettings.DefaultPromptBeforeSuffix.ForegroundColor = 0xdaa520
# $GitPromptSettings.DefaultPromptSuffix = ' $((Get-History -Count 1).id + 1)$(" >" * ($nestedPromptLevel + 1)) '

# Clear terminal
#Clear-Host
Write-Output "Hello ($name)!"

