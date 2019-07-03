# Install scoop.sh
# Works in Powershell 6
Function Install-Scoop {
    [cmdletbinding()]
    iex (new-object net.webclient).downloadstring('https://get.scoop.sh')
}
