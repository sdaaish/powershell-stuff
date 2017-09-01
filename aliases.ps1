# Aliases

#New-Alias -Name np -Value C:\Windows\System32\notepad.exe
#New-Item alias:x -value "exit"

# Add the path to my powershell-scripts
$env:Path += ";$env:UserProfile\Repos\powershell-stuff"

# Remove built in aliases
Remove-Item alias:curl 2>null
Remove-Item alias:wget 2>null
Remove-Item alias:diff -Force 2>null

# Set own aliases
Set-Alias -Name src -Value reload-powershell-profile
Set-Alias -Name alias -Value Get-Alias
Set-Alias -Name upr -Value ~\Repos\powershell-stuff\update-repos.ps1
Set-Alias -Name ups -Value ~\Repos\powershell-stuff\update-status.ps1
Set-Alias -Name em -Value emacs-client
Set-Alias -Name emacs -Value emacs-client

Set-Alias -Name gnc -Value Get-NetConnectionProfile

Set-Alias -Name yodl -Value youtube-dl

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
function cdm {
    Set-Location $Env:UserProfile\Videos
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
function llt {
    Get-ChildItem| Sort-Object lastwritetime
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
# Show dns search suffix
function get-suffix() {
    (Get-DnsClientGlobalSetting).SuffixSearchList
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
function check-software {
    Get-ItemProperty HKLM:\Software\WoW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*| Select-Object Displayname,DisplayVersion,Publisher,Installdate|Sort-Object -Property DisplayName
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
# Function to commit changes to org-files quickly
function org-commit {
    Write-host -ForeGroundColor green "Commiting changes to org-files to local repo."
    cd ~/Dropbox/emacs/org
    git add *.org
    git add *.org_archive
    git commit -m "Comitting changes with `"org-commit`""
}
# Reset the terminal settings. From http://windowsitpro.com/powershell/powershell-basics-console-configuration
function fix-tty {
    $console.ForegroundColor = "white"
    $console.BackgroundColor = "black"
    Clear-Host
}
