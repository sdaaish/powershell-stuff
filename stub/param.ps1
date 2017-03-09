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
    [string]$path = "."
)

Write-Host "The path is $path"
Get-ChildItem -Path $path
