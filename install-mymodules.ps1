# Install my preferred modules
Function Install-MyModules {
    [cmdletbinding()]
    param()

    $StableModules = @(
        "Get-ChildItemColor"
        "PSReadline"
        "BuildHelpers"
        "PSScaffold"
        "Posh-Docker"
    )

    $BetaModules = @(
        "Posh-Git"
    )

    foreach ($module in $StableModules){
        Write-Host "Installing module $module"
        Install-Module -Name $module -Scope CurrentUser
    }

    foreach ($module in $BetaModules){
        Write-Host "Installing module $module"
        Install-Module -Name $module -Scope CurrentUser -AllowPrerelease -Force
    }
}
