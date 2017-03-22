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

# Output-file
if (!(Test-Path $outfile))
{
	New-Item output-file.txt -type file -value "Directory listing for $hostname`n"
	Write-Host "Created new file"
}
else
{
	Clear-Content output-file.txt
	Add-Content output-file.txt -value "Directory listing for $hostname`n"
	Write-Host "File already existed, cleared the file"
}

# Set up an array with the directories
[Array] $dirs = ${env:ProgramFiles} , ${env:ProgramFiles(x86)}, `
	      ${env:ProgramData}, ${env:AppData}, ${env:LocalAppData}, ${env:UserProfile}, "C:\";

# List the files, redirect to output-file
foreach($dir in $dirs) {
     Write-Output "`n--- ${dir} ---"|Add-Content $outfile;
     Get-ChildItem -Path ${dir}|Add-Content $outfile;
}
