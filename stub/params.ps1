param (
    [string]$browser = "default"
)

function Get-Info {
    $MyInvocation.PSCommandPath
}

if ($browser -eq "default" ) {
    Write-Host "Usage: $prog -browser <ff|chrome|safari|ie|op>"
}
else {
    Write-Host "Else browser=$browser"
}

Get-Info
