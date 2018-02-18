<#

	.SYNOPSIS
This disables Internet Explorer

.DESCRIPTION
The script shows if Internet Explorer.

.EXAMPLE
./disable-ie.ps1

.NOTES
Put some notes here.

.LINK
#>

Disable-WindowsOptionalFeature -Online -FeatureName Internet-Explorer-Optional-amd64 -NoRestart
