# Aliases

#New-Alias -Name np -Value C:\Windows\System32\notepad.exe
#New-Item alias:x -value "exit"
#Set-Location ~

# Add the path to my powershell-scripts
$env:Path += ";$env:UserProfile\Repos\powershell-stuff"

# Remove built in aliases
Remove-Item alias:curl 2>$null
Remove-Item alias:wget 2>$null
Remove-Item alias:diff -Force 2>$null

# Set own aliases
Set-Alias -Name src -Value reload-powershell-profile
Set-Alias -Name alias -Value Get-Alias
Set-Alias -Name crep -value ~\repos\powershell-stuff\check-repos.ps1
Set-Alias -Name upr -Value ~\Repos\powershell-stuff\update-repos.ps1
Set-Alias -Name ups -Value ~\Repos\powershell-stuff\update-status.ps1
Set-Alias -Name em -Value emacs-client
Set-Alias -Name emx -Value emacs-client
Set-Alias -Name emacs -Value emacs-client
Set-Alias -Name oc -Value org-commit
Set-Alias -Name poff -Value my-shutdown
Set-Alias -Name poffr -Value my-reboot
Set-Alias -name pwsh -value Find-pwsh

Set-Alias -Name gnc -Value Get-NetConnectionProfile
Set-Alias -Name kb -Value keybase
Set-Alias -Name yodl -Value youtube-dl

Set-Alias -Name lll -Value Find-Links

Set-Alias -Name lok -Value find-dropbox-conflicts

Set-Alias -Name ra -Value resolve-address

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
function cdrw {
    Set-Location $Env:UserProfile\Work
}
function cdw {
    Set-Location $Env:UserProfile\Downloads
}
function cdv {
    Set-Location $Env:UserProfile\Vagrantdir
}
function lls {
    Get-ChildItem "$args" -Attributes H,!H,A,!A,S,!S|Sort-Object Length
}
function llt {
    Get-ChildItem "$args" -Attributes H,!H,A,!A,S,!S| Sort-Object lastwritetime
}
function now {
    get-date -Format yyyyMMdd-HH:mm:ss
}
# Alias for help-command
function gh([string]$help) {
    $ErrorActionPreference = "Ignore"
    Get-Help -Name $help -Online
}
# Show aliases online
Function check-alias {
    $tmp = New-TemporaryFile
    Get-Alias|Sort-Object Definition|ConvertTo-Html -Property Name,Definition > $tmp.FullName
    Invoke-Item $tmp.FullName
    # Sleep before removal
    Start-Sleep 2 
    Remove-Item $tmp.FullName
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
function get-dns-suffix() {
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
# Check installed software
function check-software {
    Get-ItemProperty HKLM:\Software\WoW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*| Select-Object Displayname,DisplayVersion,Publisher,Installdate|Sort-Object -Property DisplayName
}
# Check windows optional packages
Function check-packages {
    Get-WindowsOptionalFeature -online|select FeatureName, State| where state -eq Enabled
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
    $date = (Get-Date -Format yyyyMMdd-HH:mm:ss)
    Write-Host -ForeGroundColor green "Commiting changes to org-files to local repo."
    Push-Location ~/Dropbox/emacs/org
    git add *.org
    git add *.org_archive
    git commit -m "Comitting changes $date"
    git push -q --all
    Pop-Location
}
# Reset the terminal settings. From http://windowsitpro.com/powershell/powershell-basics-console-configuration
function fix-tty {
    $console.ForegroundColor = "white"
    $console.BackgroundColor = "black"
    Clear-Host
}
function keybase {
    $prg = $env:LocalAppData + "\Keybase\keybase.exe"
    & $prg $args
}
# Checks for proxy settings
function get-proxy {
    $regKey="HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
    $proxysettings="ProxyEnable","ProxyServer","ProxyOverride","AutoConfigURL"
    $proxyenabled= (Get-ItemProperty -path $regKey).ProxyEnable

    if ( $proxyenabled -eq 0) {
        Write-Host "No proxy enabled"
    }
    else {
        Write-Host "Proxy enabled"
    }

    foreach ($setting in $proxysettings) {
        $value = (Get-ItemProperty -path $regKey).$setting
        "$setting is:`t$value"
    }

}
# Display current dns-servers for active interfaces
Function get-dns-servers {
    $interfaces = (Get-NetAdapter| select Name,ifIndex,Status| where Status -eq Up)
    foreach ($if in $interfaces){
        $dnsserver = (Get-DNSClientServerAddress -InterfaceIndex $if.ifIndex)
        Write-Host -NoNewLine "Interface: "
        $if.Name
        $dnsserver.ServerAddresses
    }
}

# Set my explorer preferences
# See also https://gallery.technet.microsoft.com/scriptcenter/8ac61441-1ad2-4334-b69c-f9189c605f83
function my-explorer {
    $key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
    Set-ItemProperty $key Hidden 1
    Set-ItemProperty $key HideFileExt 0
    Set-ItemProperty $key ShowSuperHidden 1
    Set-ItemProperty $key ShowEncryptCompressedColor 1
    Set-ItemProperty $key ShowCompColor 1
    Set-ItemProperty $key ShowStatusBar 1
    Set-ItemProperty $key HideMergeConflicts 0
    Set-ItemProperty $key HideIcons 0
    Set-ItemProperty $key HideDrivesWithNoMedia 0
    Set-ItemProperty $key AutoCheckSelect 1
    Set-ItemProperty $key HideDrivesWithNoMedia 1
    Set-ItemProperty $key NavPaneExpandToCurrentFolder 1
    Stop-Process -processname explorer
    Start-Process explorer
}
# Settings for TaskMgr
# Only stub for now, more info: https://msitpros.com/?p=1136
function my-taskmgr {
    $key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\TaskManager'
    Get-ItemProperty $key
    # reg export HKCU\Software\Microsoft\Windows\CurrentVersion\TaskManager .\conf\taskmgr.reg /y
    # reg import .\conf\taskmgr.reg
}
# Kill explorer and restart it
function pse {
    pskill -nobanner explorer
    explorer
    Write-Host "Explorer restarted"
}

# Shutdown the computer
Function my-shutdown {
    & shutdown.exe /s /t 1
}

# Restart the computer
Function my-reboot {
    & shutdown.exe /r /t 1
}

# Find links in the filesystem
function Find-Links([string]$path=".") {
    Get-ChildItem $path -ErrorAction SilentlyContinue| ?{$_.Linktype}| Select-Object FullName, Target,LastWriteTime,LinkType
}

# Get IP address for a hostname
function Get-HostToIP($hostname) {
    $result = [system.Net.Dns]::GetHostByName($hostname)
    $result.AddressList | ForEach-Object {$_.IPAddressToString }
}

# Do a DNS lookup
function resolve-address($address) {
    try {
        $ip = ([ipaddress]$address).IPAddressToString 
    }
    catch {
    }
    (Resolve-DnsName -DnsOnly $address -erroraction silentlycontinue)
}

# Find the path of powershell-core
Function find-pwsh {
    $pwsh = Convert-Path (Get-Childitem '\Program Files\Powershell\*\Pwsh.exe')
    $pwsh
    if (Test-Path $pwsh){
        & $pwsh
    }
    else {
        Write-Host "No such file, $pwsh" -ForegroundColor Yellow
    }
}

# Find orgmode conflicts in Dropbox
Function find-dropbox-conflicts {
    Get-ChildItem -r -Path ~/Dropbox -Name *konflikt*
}
