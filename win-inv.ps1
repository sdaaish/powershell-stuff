#
## Inventing installed software
#

## 2015-01-16/SDAA

Write-Host "--- ${env:ProgramFiles} ---" |Add-Content 'output-file.txt'
Get-ChildItem -Path ${env:ProgramFiles} -Name|Add-Content 'output-file.txt'
Write-Host "--- ${env:ProgramFiles(x86)} ---" |Add-Content 'output-file.txt'
Get-ChildItem -Path ${env:ProgramFiles(x86)} -Name|Add-Content 'output-file.txt'
Write-Host "--- ${env:ProgramFiles} ---" |Add-Content 'output-file.txt'
Get-ChildItem -Path ${env:ProgramData} -Name|Add-Content 'output-file.txt'
Get-ChildItem -Path C:\ -Name|Add-Content 'output-file.txt'
Get-ChildItem -Path ${env:AppData} -Name|Add-Content 'output-file.txt'
Get-ChildItem -Path ${env:LocalAppData} -Name|Add-Content 'output-file.txt'

$variable = "En text med lite mellanrum"
$x = ${env:ProgramFiles(x86)}

#Write-Host "$variable"
#Write-Host ${x}
