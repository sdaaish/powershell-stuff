# Install modules
Function Install-MyModules {
    [cmdletbinding()]
    Install-Module -Name Get-ChildItemColor -Scope CurrentUser
    Install-Module -Name PSReadline -Scope CurrentUser
    Install-Module -Name Posh-Git -Scope CurrentUser -AllowPrerelease -Force
    Install-Module -Name BuildHelpers -Scope CurrentUser
    Install-Module -Name PSScaffold -Scope CurrentUser
    Install-Module -Name Posh-Docker -Scope CurrentUser
}
