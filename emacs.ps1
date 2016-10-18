# Script that tries to add "Emacs" as option in explorer "Open" contextual menu

#https://en.wikiversity.org/wiki/Windows_PowerShell/Registry

<#(get-itemproperty -literalpath HKLM:\SOFTWARE\Classes\.txt).'(default)'

To create a default value :
?
New-ItemProperty -LiteralPath HKLM:\SOFTWARE\Classes\.txt -name '(Default)' -Value "txtfile"

To set an existing default value :
?
Set-ItemProperty -LiteralPath HKLM:\SOFTWARE\Classes\.txt -name '(Default)' -Value "txtfile"
#>

$registryPath = 'HKLM:\Software\Classes\*\shell\Emacs\Command'

if (!(Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force |Out-Null
    New-ItemProperty -LiteralPath $registryPath -Name "(default)" -value "c:\local\bin\runemacs.exe `"%1`"" -PropertyType string |OUT-Null
}
else {
    New-ItemProperty -LiteralPath $registryPath -Name "(default)" -value "c:\local\bin\runemacs.exe `"%1`"" -PropertyType string -Force|OUT-Null
}

<#
(Get-ItemProperty -LiteralPath HKLM:\SOFTWARE\Classes\*\shell\Emacs\Command).'(default)'
Set-ItemProperty -LiteralPath HKLM:\SOFTWARE\Classes\*\shell\Emacs\Command -name Test -value start -type string
#>
