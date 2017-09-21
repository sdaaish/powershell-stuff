# See http://edgylogic.com/blog/powershell-and-external-commands-done-right/ for more info about handling arguments
if ($args.count -eq 0 ) {
    Write-Host "No args"
}
else {
    Write-Host "This is the args $args"
}

