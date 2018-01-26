<#
.SYNOPSIS
Checks for admin and requests it if the user is not.

.DESCRIPTION
A stub for this

.PARAMETER Foobar
non

.EXAMPLE
none

.NOTES
none
#>
function Test-Admin
{
  $wid = [System.Security.Principal.WindowsIdentity]::GetCurrent()
  $prp = New-Object System.Security.Principal.WindowsPrincipal($wid)
  $adm = [System.Security.Principal.WindowsBuiltInRole]::Administrator
  $prp.IsInRole($adm)  
}

$admincheck = Test-Admin

if ( $admincheck ){
    Write-Host "Is admin $user $domain"
}
else {
    $Credential = Get-Credential
    Start-Process -FilePath PowerShell.exe -Credential $Credential -ArgumentList Get-ChildItem
    Write-Host "Is admin $user $domain"
}

