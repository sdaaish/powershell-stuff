# Aliases

#New-Alias -Name np -Value C:\Windows\System32\notepad.exe
#New-Item alias:x -value "exit"
#Set-Location ~

Import-Module Get-ChildItemColor

# Add the path to my powershell-scripts
$env:Path += ";$env:UserProfile\Repos\powershell-stuff"

# Remove built in aliases
Remove-Item alias:curl 2>$null
Remove-Item alias:wget 2>$null
Remove-Item alias:diff -Force 2>$null
Remove-Item alias:ls -Force 2>$null

# Set own aliases
Set-Alias -Name src -Value reload-powershell-profile
Set-Alias -Name alias -Value Search-Alias
Set-Alias -Name crep -value ~\repos\powershell-stuff\check-repos.ps1
Set-Alias -Name upr -Value ~\Repos\powershell-stuff\update-repos.ps1
Set-Alias -Name ups -Value ~\Repos\powershell-stuff\update-status.ps1
Set-Alias -Name em -Value emacs-client
Set-Alias -Name emx -Value emacs-client
Set-Alias -Name emacs -Value emacs-client
Set-Alias -Name l -Value Get-Content
Set-Alias -Name du -Value disk-usage
Set-Alias -Name oc -Value org-commit
Set-Alias -Name poff -Value my-shutdown
Set-Alias -Name poffr -Value my-reboot
Set-Alias -name pwsh -value Find-pwsh
Set-Alias -Name ql -Value New-List
Set-Alias -name st -value Start-Transcript
Set-Alias -name which -value Get-Command

Set-Alias -Name gnc -Value Get-NetConnectionProfile
Set-Alias -Name kb -Value keybase
Set-Alias -Name yodl -Value youtube-dl

Set-Alias -Name lll -Value Find-Links

Set-Alias -Name lok -Value find-dropbox-conflicts

Set-Alias -Name ra -Value resolve-address

Set-alias -Name gts -Value Get-MyGitStatus
Set-Alias -Name gtl -value Get-MyGitLog

Set-Alias -Name tshark -Value 'C:\Program Files\Wireshark\tshark.exe'

Set-Alias -Name dk -value 'docker.exe'
Set-Alias -Name dc -value 'docker-compose.exe'

#Functions
function .. {
    cd ..
}
function ... {
    cd ..\..
}
function cdh {
    Set-Location ~
}
function cdm {
    Set-Location ~\Videos
}
function cdr {
    Set-Location ~\repos
}
function cdrw {
    Set-Location ~\Work
}
function cdw {
    Set-Location ~\Downloads
}
function cdv {
    Set-Location ~\Vagrantdir
}
function ls {
    if (Get-Module Get-ChildItemColor) {
        Get-ChildItemColorFormatWide "$args"
    }
    else {
        Get-ChildItem "$args" -Attributes H,!H,A,!A,S,!S
    }
}
function ll {
    if (Get-Module Get-ChildItemColor) {
        Get-ChildItemColor "$args"
    }
    else {
        Get-ChildItem "$args" -Attributes H,!H,A,!A,S,!S
    }
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
Function disk-usage {
    param(
        $Path
    )
    Get-ChildItem -Path $Path -File -Recurse |
      Measure-Object -Property Length -Sum
}

# Alias for help-command
function gh([string]$help) {
    $ErrorActionPreference = "Ignore"
    Get-Help -Name $help -Online
}
# Alias for help-command local window
function ghl([string]$help) {
    $ErrorActionPreference = "Ignore"
    Get-Help -Name $help -ShowWindow
}
# Shortcut to create an array
Function New-List {
    $args
}

# Equivalent of linux wc, word counts
Function wc {
    Get-Content "$args"| Measure-Object -Character -Line -Word| select lines,words,characters
}

# Search an alias or display all of them
Function Search-Alias {
    param (
        [string]$alias
    )

    if ($alias){
        Get-Alias| Where DisplayName -Match $alias
    }
    else {
        Get-Alias
    }
}

# Show aliases online
Function check-alias {
    $tmp = New-TemporaryFile
    Rename-Item -Path $tmp  -NewName "$tmp.html"
    $tmp="$tmp.html"
    Get-Alias|Sort-Object Definition|ConvertTo-Html -Property Name,Definition -Title "Powershell aliases"> $tmp
    Invoke-Item $tmp
    # Sleep before removal
    Start-Sleep 2
    Remove-Item $tmp
}

# Debug emacs
Function emdi {
    emacs.exe --debug-init
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
    . $DirScripts\functions.ps1
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
    Push-Location ~/Dropbox/emacs
    $files = @()
    $files += Resolve-Path org/*.org
    $files += Resolve-Path org/archive/*
    $files += Resolve-Path bookmarks
    git add $files
    git commit -m "Comitting changes $date"
    git push -q --all
    Pop-Location
}

# Check for admin
function Test-Admin
{
    $wid = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $prp = New-Object System.Security.Principal.WindowsPrincipal($wid)
    $adm = [System.Security.Principal.WindowsBuiltInRole]::Administrator
    $prp.IsInRole($adm)
}

# Alias for git status
Function Get-MyGitStatus {
    git status -sb
}
# Alias for git log
Function Get-MyGitLog {
    param(
        $path = ".",
        $count = 40
    )
    $path = Convert-Path $path
    if ( Test-Path $path -Type Leaf){
        $path=Split-Path $path -Parent
    }
    git -C $path log --oneline --all --graph --decorate --max-count=$count
}

# Create a .gitattributes-file if it doesnt exist
function Add-GitAttributesFile {

    # Text to add in the file
    $text = @"
# Set the default behavior, in case people don't have core.autocrlf set.
* text=auto

# Explicitly declare text files you want to always be normalized and converted
# to native line endings on checkout.
*.c text
*.h text

# Declare files that will always have LF line endings on checkout.
*.sh text eol=lf
*.ps1 text eol=lf
*.psd1 text eol=lf
*.psm1 text eol=lf

# Denote all files that are truly binary and should not be modified.
*.png binary
*.jpg binary
"@

    if (Test-Path -Path .git -PathType Container) {
        if (-not (Test-Path -Path .gitattributes -PathType Leaf)){
            Set-Content -Path .gitattributes -Value $text
            Write-Output "Added a new .gitattributesfile"
        }
        else {
            Write-Output "A .gitattributesfile already exists."
        }
    }
    else {
        Write-Output "Not a repository."
    }
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
    Set-ItemProperty $key AlwaysShowMenus 1
    Set-ItemProperty $key AutoCheckSelect 1
    Set-ItemProperty $key DisablePreviewDesktop 0
    Set-ItemProperty $key DontPrettyPath 0
    Set-ItemProperty $key DontUsePowerShellOnWinX 0
    Set-ItemProperty $key Filter 0
    Set-ItemProperty $key Hidden 1
    Set-ItemProperty $key HideDrivesWithNoMedia 0
    Set-ItemProperty $key HideDrivesWithNoMedia 1
    Set-ItemProperty $key HideFileExt 0
    Set-ItemProperty $key HideIcons 0
    Set-ItemProperty $key HideMergeConflicts 0
    Set-ItemProperty $key IconsOnly 0
    Set-ItemProperty $key ListviewAlphaSelect 1
    Set-ItemProperty $key ListviewShadow 1
    Set-ItemProperty $key MMTaskbarEnabled 0
    Set-ItemProperty $key MapNetDrvBtn 0
    Set-ItemProperty $key NavPaneExpandToCurrentFolder 1
    Set-ItemProperty $key NavPaneShowAllFolders 1
    Set-ItemProperty $key ReindexedProfile 1
    Set-ItemProperty $key SeparateProcess 0
    Set-ItemProperty $key ServerAdminUI 0
    Set-ItemProperty $key SharingWizardOn 0
    Set-ItemProperty $key ShellViewReentered 1
    Set-ItemProperty $key ShowCompColor 1
    Set-ItemProperty $key ShowEncryptCompressedColor 1
    Set-ItemProperty $key ShowInfoTip 1
    Set-ItemProperty $key ShowStatusBar 1
    Set-ItemProperty $key ShowStatusBar 1
    Set-ItemProperty $key ShowSuperHidden 1
    Set-ItemProperty $key ShowTypeOverlay 1
    Set-ItemProperty $key Start_SearchFiles 2
    Set-ItemProperty $key StoreAppsOnTaskbar 1
    Set-ItemProperty $key TaskbarAnimations 1
    Set-ItemProperty $key TaskbarSmallIcons 1
    Set-ItemProperty $key WebView 1
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

# Show services
Function my-service {
    Get-Service| Sort -Property @{Expression = "Status"; Descending = "True"},@{Expression = "Name"}|Out-GridView
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
function Resolve-Address($address) {

    # Test if address is an IP
    try {
        $ip = ([ipaddress]$address).IPAddressToString
    }
    catch {
        # Otherwise check for a name
        try {
            ([System.Net.Dns]::GetHostByName($address)).
            AddressList.
            IPAddressToString
        }
        catch {
        }
    }

    # Check the IP for a name
    try {
        ([System.Net.Dns]::GetHostByAddress($ip)).Hostname
    }
    catch {
    }
}

# Find the path of powershell-core.
# If there are more versions, start the first one.
Function find-pwsh {
    $pwsh = Resolve-Path "\Program Files\Powershell\*\Pwsh.exe"
    "$pwsh"
    if (Test-Path $pwsh.path){
        & $pwsh[0].path
    }
    else {
        Write-Host "No such file, $pwsh" -ForegroundColor Yellow
    }
}

# Find orgmode conflicts in Dropbox
Function find-dropbox-conflicts {
    Get-ChildItem -r -Path ~/Dropbox -Name *konflikt*
}

# Search bing for powershell examples
# Bing has preview of powershell code which is nice
Function Search-PowershellBing {
    $search = "powershell+"
    $search += $args -join "+"

    if($search){
        $uri = "https://www.bing.com/search?q=" + "$search"
    }
    else {
        $uri = "https://www.bing.com/search"
    }

    Start-Process $uri
}

# Search google for stuff
Function Search-Google {
    $search += $args -join "+"

    if($search){
        $uri = "https://www.google.com/search?q=" + "$search"
    }
    else {
        $uri = "https://www.google.com/search"
    }

    Start-Process $uri
}

# Search StackExchange for Emacs stuff
Function Search-EmacsSX {
    $search += $args -join "+"

    if($search){
        $uri ="https://emacs.stackexchange.com/search?q=" + "$search"
    }
    else {
        $uri = "https://emacs.stackexchange.com/search"
    }

    Start-Process $uri
}

# Search StackOverFlow for Powershell stuff
Function Search-PowershellSX {
    $search += $args -join "+"

    if($search){
        $uri = "https://stackoverflow.com/search?q=%5Bpowershell%5D+" + "$search"
    }
    else {
        $uri = "https://stackoverflow.com/search?q=%5Bpowershell%5D+"
    }

    Start-Process $uri
}

# Start hugo locally and fire up a webpage
Function test-hugo {
    Start-Job -ScriptBlock {& hugo server -D --disableFastRender}
    Start-Process http://localhost:1313/
}

# Create a module base directory
# From https://ramblingcookiemonster.github.io/Building-A-PowerShell-Module/
# and https://kevinmarquette.github.io/2017-05-27-Powershell-module-building-basics/
Function New-ModuleDir {
    param(
        [Parameter(Mandatory=$True)]
        $Path,
        [Parameter(Mandatory=$True)]
        $ModuleName,
        [Parameter(Mandatory=$True)]
        $Author,
        [Parameter(Mandatory=$True)]
        $Description
    )

    $ModuleDir = "$Path\$ModuleName"

    # Create the module and private function directories
    New-Item "$ModuleDir" -ItemType Directory
    New-Item "$ModuleDir\Private" -ItemType Directory
    New-Item "$ModuleDir\Public" -ItemType Directory
    New-Item "$ModuleDir\en-US" -ItemType Directory # For about_Help files
    New-Item "$Path\Tests" -ItemType Directory

    #Create the module and related files
    New-Item "$ModuleDir\$ModuleName.psm1" -ItemType File
    New-Item "$ModuleDir\$ModuleName.Format.ps1xml" -ItemType File
    New-Item "$ModuleDir\en-US\about_$ModuleName.help.txt" -ItemType File
    New-Item "$ModuleDir\Tests\$ModuleName.Tests.ps1" -ItemType File

    $manifest = @{
        Path              = "$ModuleDir\$ModuleName.psd1"
        RootModule        = "$MyModuleName.psm1"
        Author            = "$Author"
        Description       = "$Description"
        FormatsToProcess  = "$ModuleName.Format.ps1xml"
    }
    New-ModuleManifest @manifest
}

# Fix for Outlook/Office that cannot open links in Windows 10,
# and you don't want to install IE.
# https://support.microsoft.com/sv-se/help/310049/hyperlinks-are-not-working-in-outlook
# https://answers.microsoft.com/en-us/msoffice/forum/msoffice_outlook-mso_win10/outlook-2013-email-links-arent-working/7122799b-798e-4439-8108-69fa86900a16
# And my preferred browser is Firefox.

function fix-outlook-hyperlink-error {
    [cmdletbinding()]

    $admincheck = Test-Admin
    if ( $admincheck ){
        Write-Output "User $env:USERNAME has admin rights."

        # Create a list of htmlfiles
        $htmlfiles =  @(
            ".html",
            ".htm",
            ".shtm",
            ".shtml"
        )

        ### This part needs administrative privileges

        # Create a PSDrive for HKCR if it doesn't exist
        if (-not (Test-Path HKCR:)){
            New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-Null
        }

        # Change the suffixes to be of type "htmlfile"
        foreach($suffix in $htmlfiles){
            $path = "HKCR:" + $suffix
            Set-ItemProperty -Path $path -Name '(Default)' -Value "htmlfile"
            Set-ItemProperty -Path $path -Name 'Content Type' -Value "text/html"
            Set-ItemProperty -Path $path -Name 'PercievedType' -Value "text"
        }

        # Create the registry key and set its value to the preferred browser
        New-Item HKCR:\htmlfile\shell\open\command -Force | Out-Null
        New-ItemProperty -LiteralPath HKCR:\htmlfile\shell\open\command -Name '(Default)' -Value '"C:\Program Files\Mozilla Firefox\firefox.exe" -osint -url "%1"' -Force | Out-Null

        # Print results
        Write-Output "Changed settings to:"
        foreach($suffix in $htmlfiles){
            $path = "HKCR:" + $suffix
            Get-ItemProperty -Path $path | Select-Object "PSPath","(default)","Content Type","PercievedType"
        }
        Get-ItemProperty -LiteralPath HKCR:\htmlfile\shell\open\command -Name '(Default)'| Select-Object "PSPath","(default)"
    }
    else {
        Write-Output "You dont have administrative rights to change this!"
    }
}

# Get som Powershell books for reference, put them in ~\Documents.
Function Get-Books {
    param(
        $path =  "~\Documents\Books"
    )

    $path = Convert-Path $path

    if (Test-Path $path) {
        # Lee Holmes
        git -C $path clone https://resources.oreilly.com/examples/0636920024132.git "PowerShell CookBook Examples"

        # Douglas Finke
        git -C $path clone https://github.com/dfinke/powershell-for-developers.git "PowerShell for Developers"

        # Adam Bertram
        git -C $path clone https://github.com/adbertram/Automate-The-Boring-Stuff-With-PowerShell.git "Automate the Boring Stuff with Powershell"
    }
    else {
        Write-Output "No such path: $path"
    }
}

# Enables WSL
Function Enable-WSL {
    Enable-WindowsOptionalFeature -Online -NoRestart -FeatureName Microsoft-Windows-Subsystem-Linux
}

# Install WSL
# From https://blogs.msdn.microsoft.com/commandline/2018/11/05/whats-new-for-wsl-in-the-windows-10-october-2018-update/
# For other distros, https://docs.microsoft.com/en-us/windows/wsl/install-manual
Function Get-WSL {
    Invoke-WebRequest -Uri "https://aka.ms/wsl-ubuntu-1804" -OutFile ~/Ubuntu.appx -UseBasicParsing
    Add-AppxPackage -Path ~/Ubuntu.appx
    RefreshEnv
    Ubuntu1804 install --root
    Ubuntu1804 run apt update
    Ubuntu1804 run apt upgrade -y
    Ubuntu1804 run apt install -y git make
    Ubuntu1804 run printf "[automount]\nroot = /\noptions = \"metadata\"\n" > /etc/wsl.conf
    Remove-Item -Force ~/Ubuntu.appx
}

# Get Windows Colortool
Function Install-ColorTool {
    [cmdletbinding()]
    Param (
        $uri = "https://github.com/Microsoft/console/releases/download/1810.02002/ColorTool.zip",
        $tmp =  "~\Downloads\ColorTool.zip"
    )
    $dest = Convert-Path "~/bin"
    $start_time = Get-Date

    Write-Verbose "Downloading $uri"
    Invoke-WebRequest -Uri $uri -OutFile $tmp -UseBasicParsing

    Expand-Archive $tmp $dest -Force
    Write-Verbose "Extracted $tmp to $dest"

    $time = $((Get-Date).subtract($start_time).seconds)
    Write-Output "Downloaded Colorest.exe to $dest\ColorTool.exe in $time seconds"
}

# Install modules
Function Install-MyModules {
    Install-Module -Name Get-ChildItemColor -Scope CurrentUser
    Install-Module -Name PSReadline -Scope CurrentUser
    Install-Module -Name Posh-Git -Scope CurrentUser -AllowPrerelease -Force
    Install-Module -Name BuildHelpers -Scope CurrentUser
    Install-Module -Name PSScaffold -Scope CurrentUser
    Install-Module -Name Posh-Docker -Scope CurrentUser
}

# Install scoop.sh
# Works in Powershell 6
Function Get-Scoop {
    iex (new-object net.webclient).downloadstring('https://get.scoop.sh')
}

# Step buildnumber and store as UTF8
Function My-Step {
    #Requires -Modules Buildhelpers
    param(
        [Parameter(Mandatory=$True)]
        $ModuleFile,
        [ValidateSet("Build", "Major","Minor","Patch")]
        [string]$Step = "Patch"
    )
    Import-module Buildhelpers

    if (Test-Path $ModuleFile){
        Step-ModuleVersion -Path $modulefile -By $Step
        $content = Get-Content $modulefile
        Set-Content -Path $modulefile -Value $content -Encoding UTF8
    }
    else {
        Write-Host "No such file $ModuleFile"
    }
}

# Starts VS Code with a profile. It creates a new profile if -Config don't exists
Function Start-VSCode {
    [cmdletbinding()]
    param(
        [Parameter(Mandatory)]
        $Path,
        [Parameter(Mandatory)]
        $Config,
        [string[]]$File
    )

    Write-Verbose "Checking for VS Code."
    if ($code = Get-Command code -ErrorAction SilentlyContinue){
        $code = $code.source
        Write-Verbose "VS Code executable is: $code"
    }
    else
    {
        Throw "VS Code is not in current path."
    }

    if (Test-Path $Path){
        Write-Verbose "Start VScode in $Path with profile: `'$Config`'"

        $ext = Join-Path -Path $(Convert-Path $Path) -ChildPath $Config -AdditionalChildPath "ext"
        $data = Join-Path -Path $(Convert-Path $Path) -ChildPath $Config -AdditionalChildPath "data"

        Write-Verbose "Read extensions from: $ext"
        Write-Verbose "Read user-data from: $data"

        Write-Verbose "Start VScode with file: `'$File`'"
        & $code --extensions-dir $ext --user-data-dir $data $File
    }
    else {
        Throw "No such directory, $Path"
    }
}

# Start VScode with a default settings
Function vsd {
    [cmdletbinding()]
    param(
        $File
    )
    Start-VSCode -Path ~/repos/code -Config default -File $File
}

# Start VScode with powershell settings
Function vsp {
    [cmdletbinding()]
    param(
        $File
    )
    Start-VSCode -Path ~/repos/code -Config powershell -File $File
}
