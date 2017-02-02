#Aliases
#New-Alias -Name np -Value C:\Windows\System32\notepad.exe
#New-Item alias:x -value "exit"
Set-Alias -Name src -Value reload-powershell-profile
Set-Alias -Name alias -Value Get-Alias

#Functions
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
function reload-powershell-profile {
	. $profile.CurrentUserAllHosts
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
