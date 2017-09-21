[string]$emacs = $env:UserProfile + "\bin\emx.cmd"
[string]$fileexts = @("txtfile", "xmlfile", "Microsoft.PowerShellScript.1", "Microsoft.PowerShellData.1", "Microsoft.PowerShellModule.1")

if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
  [Security.Principal.WindowsBuiltInRole] "Administrator"))
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
    Write-Host "$extension"
    cmd /c "ftype $extension=`"$emacs`" `"%1`""
}
