<#

	.SYNOPSIS
	This is a simple Powershell script to explain how to use param

	.DESCRIPTION
	The script itself will print take a path as argument and write that path, plus listing the files in the path.
	

	.EXAMPLE
	./param.ps1

	.NOTES
	To test how to use param in powershell

	.LINK
	https://github.com/sdaaish/powershell-stuff
	http://kevinpelgrims.wordpress.com
#>

param (
    [string]$path = ".",
    [switch]$arg2
)

# All other parameters are counted here
$psboundparameters.count

Write-Host "The `$path is $path and `$arg2 is $arg2"
Get-ChildItem -Path $path
