<#

	.SYNOPSIS
	This checks which versions of SMB that are enabled.

	.DESCRIPTION
	The script shows if SMBv1 and SMBv2 are enabled or not.

	.EXAMPLE
	./check-smb-version.ps1

	.NOTES
	Put some notes here.

	.LINK
#>

Get-SmbServerConfiguration | Select EnableSMB1Protocol, EnableSMB2Protocol
