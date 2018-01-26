<#
  .Synopsis
Disables any active proxy

.Description
Removes proxysettings from the registry

.Example

#>
[CmdletBinding()]
param()

Begin
{
    $regKey="HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
}

Process
{
    Set-ItemProperty -path $regKey ProxyEnable -value 0
    Set-ItemProperty -path $regKey ProxyServer -value ""
    Set-ItemProperty -path $regKey AutoConfigURL -Value ""
}

End
{
    Write-Output "Proxy is now disabled"
}
