# Aliases

#New-Alias -Name np -Value C:\Windows\System32\notepad.exe
#New-Item alias:x -value "exit"

# Remove built in aliases
Remove-Item alias:curl
Remove-Item alias:wget
Remove-Item alias:diff -Force

# Set own aliases
Set-Alias -Name src -Value reload-powershell-profile
Set-Alias -Name alias -Value Get-Alias
Set-Alias -Name upr -Value ~\Repos\powershell-stuff\update-repos.ps1
Set-Alias -Name ups -Value ~\Repos\powershell-stuff\update-status.ps1
Set-Alias -Name em -Value emacs-client

Set-Alias -Name emacs -Value emacs-client

#Functions
function .. {
    cd ..
}
function ... {
    cd ..\..
}
function cdh {
    Set-Location $Env:UserProfile\
}
function cdr {
    Set-Location $Env:UserProfile\Repos
}
function cdw {
    Set-Location $Env:UserProfile\Downloads
}
function cdv {
    Set-Location $Env:UserProfile\Vagrantdir
}
function emacs-client() {
    # Starts emacsclient and daemon if not started
    if ($args.count -eq 0 ) {
        # Create a new frame if no files as argument
        emacsclientw --quiet --alternate-editor="" --create-frame
    }
    else {
        # Dont create a new frame if files exists as argument
        emacsclientw --quiet --alternate-editor="" "$args"
    }
}
function reload-powershell-profile {
    . $profile.CurrentUserAllHosts
    . $DirScripts\aliases.ps1
}
function show-profiles {
    $profile|Get-Member -MemberType NoteProperty
}
function show-colors {
    [enum]::GetValues([System.ConsoleColor]) | Foreach-Object {Write-Host $_ -ForegroundColor $_}
}
function show-path {
    $env:Path.split(";")
}
function ipv4 {
    $interfaces = (Get-NetAdapter| select Name,ifIndex,Status| where Status -eq Up)
    foreach  ($if in $interfaces) {
	$ipv4 = (Get-NetIPAddress -ifIndex ($if).ifIndex -Type Unicast -AddressFamily IPv4).IPAddress
	$ifName = ($if).Name
	$ifIndex = ($if).ifIndex

	# Write every ipv6 address for the interface on a separate line
	foreach ($addr in $ipv4) {
	    # Format for ipv4-address, and longest interfacename, Virtualbox
	    "{0,-62} {1,-15}" -f "Interface $ifName ($ifIndex) has ipv4-address =",$addr
	}
    }
}
function ipv6 {
    $interfaces = (Get-NetAdapter| select Name,ifIndex,Status| where Status -eq Up)
    foreach  ($if in $interfaces) {
	$ipv6 = (Get-NetIPAddress -ifIndex ($if).ifIndex -Type Unicast -AddressFamily IPv6).IPAddress
	$ifName = ($if).Name
	$ifIndex = ($if).ifIndex

	# Write every ipv6 address for the interface on a separate line
	foreach ($addr in $ipv6) {
	    # Format for ipv6-address, and longest interfacename, Virtualbox
	    "{0,-62} {1,-39}" -f "Interface $ifName ($ifIndex) has ipv6-address =",$addr
	}
    }
}
# Package mgmt functions
function apc($application) {
    choco search $application
}
function apd {
    choco upgrade all  -y
}
function apo {
    choco outdated
}
function api {
    choco list -LocalOnly
}
