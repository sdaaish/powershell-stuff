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
        "Posh-Git"
    )

    $BetaModules = @(
    )
}
Set-PSRepository -name PSGallery -InstallationPolicy Trusted

foreach ($module in $StableModules){
    Write-Host "Installing module $module"
    Install-Module -Name $module -Scope CurrentUser
}

foreach ($module in $BetaModules){
    Write-Host "Installing module $module"
    Install-Module -Name $module -Scope CurrentUser -AllowPrerelease -Force
}

