<#
	.SYNOPSIS
	A program that lists installed software and directories with software info

	.NOTES
	- Add info to outfile about when
	- Add option to select outfile
	2016-01-28/SDAA
#>

$hostname = $env:ComputerName
$outfile = "output-file.txt"

# Get the date formatted
$now = Get-Date -Format yyyyMMdd-HH:mm:ss

# Add some content
$content = @"
Directory listing for $hostname
Generated at $now
"@

# Output-file
if (!(Test-Path $outfile))
{
	  New-Item $outfile -Type File -Value $content
	  Write-Host "Created new file"
}
else
{
	  Clear-Content output-file.txt
	  Add-Content $outfile -Value $content
	  Write-Host "File already existed, cleared the file"
}

# Set up an array with the directories
[Array] $dirs = ${env:ProgramFiles} , ${env:ProgramFiles(x86)}, `
	${env:ProgramData}, ${env:AppData}, ${env:LocalAppData}, ${env:UserProfile}, "C:\", "C:\tools";

# List the files, redirect to output-file
foreach($dir in $dirs) {
    Write-Output "`n--- ${dir} ---"|Add-Content $outfile
    Get-ChildItem -Path ${dir}|Add-Content $outfile
}

# List all installed modules
$modules = Get-Module -ListAvailable|Select-Object Name,Version|Out-String
Add-Content $outfile -Value "`n--- Installed modules ---"
Add-Content $outfile -Value $modules

# List all package providers
$providers = Get-PackageProvider|Select-Object Name, Version|Out-String
Add-Content $outfile -Value "`n--- Installed providers ---"
Add-Content $outfile -Value $providers

# List all packages
$packages = Get-Package| Select-Object Name,Version,Source|Out-String
Add-Content $outfile -Value "`n--- Installed packages ---"
Add-Content $outfile -Value $packages

# End
Write-Host "Generated output in $outfile"
