<#
.SYNOPSIS
A script to register file_extensions to open with emacs.

.DESCRIPTION
This scripts registers emacsclient as the default editor to open certain filetypes with.

.EXAMPLE
./my-file-extensions.ps1

.NOTES
Does not work at the moment

.TODO
- If not admin, request privileges.
- Register the stuff
#>
[string]$emacs = $env:UserProfile + "\bin\emx.cmd"
[string[]] $fileexts = @("txtfile", "xmlfile", "Microsoft.PowerShellScript.1", "Microsoft.PowerShellData.1", "Microsoft.PowerShellModule.1", "inffile","inifile","scriptletfile","Windows.CompositeFont","textfile")

if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
  [Security.Principal.WindowsBuiltInRole] "Administrators"))
{
    Write-Warning "You do not have Administrator rights to run this script!"
    Write-Warning "Please re-run this script as an Administrator!"
    Break
}

if ( -not (Test-Path $emacs)){
   throw  "$emacs doesnt exist!"
}
foreach ($extension in $fileexts)
{
    Write-Host "Changing $extension"
    cmd /c "ftype $extension=`"$emacs`" `"%1`""
}

# To fix for htmlfile
#  cmd /c "ftype htmlfile=`"C:\Program Files\Mozilla Firefox\firefox.exe`" -osint -url `"%1`""
