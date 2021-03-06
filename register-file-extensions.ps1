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

# Set variables
[string]$emacs = $env:UserProfile + "\bin\emx.cmd"
[string[]] $fileexts = @("txtfile", "xmlfile", "Microsoft.PowerShellScript.1", "Microsoft.PowerShellData.1", "Microsoft.PowerShellModule.1", "inffile","inifile","scriptletfile","Windows.CompositeFont","textfile","OrgFile")

function Test-Admin
{
  $wid = [System.Security.Principal.WindowsIdentity]::GetCurrent()
  $prp = New-Object System.Security.Principal.WindowsPrincipal($wid)
  $adm = [System.Security.Principal.WindowsBuiltInRole]::Administrator
  $prp.IsInRole($adm)  
}

# Add .org as OrgFile.
Function add-ext {
    Write-Host "Associate .org as Org-mode"
    cmd /c "assoc .org=OrgFile"
}

# Add all filextensions to open with emx.cmd.
Function change-ext {
    if ( -not (Test-Path $emacs)){
        #TODO: throw  "$emacs doesnt exist!"
    }
    foreach ($extension in $fileexts)
    {
        Write-Host "Changing $extension"
        cmd /c "ftype $extension=`"$emacs`" `"%1`""
    }
}

#Main
$user=$env:USERNAME
$admincheck = Test-Admin

if ( $admincheck ){
    Write-Host "$user is admin"
    add-ext
    change-ext
}
else {
    Write-Host -ForeGroundColor Red "You dont have administrative rights to change this!"
}

# To fix for htmlfile
#  cmd /c "ftype htmlfile=`"C:\Program Files\Mozilla Firefox\firefox.exe`" -osint -url `"%1`""
