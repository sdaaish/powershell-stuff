<#
.SYNOPSIS
Tests for admin rights

.DESCRIPTION

.PARAMETER Foobar

.EXAMPLE

.NOTES
#>
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
  [Security.Principal.WindowsBuiltInRole] "Administrators"))
{
    Write-Warning "You do not have Administrator rights to run this script!"
    Write-Warning "Please re-run this script as an Administrator!"
    Break
}

