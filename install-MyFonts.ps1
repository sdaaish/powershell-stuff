# Install preferred fonts with scoop
scoop bucket add nerd-fonts
scoop install sudo
$fonts = @(
    "AnonymousPro-NF",
    "Cascadia-Code",
    "Cascadia-Mono",
    "CodeNewRoman-NF",
    "DejaVuSansMono-NF",
    "Delugia-Nerd-Font",
    "FiraCode-NF",
    "FiraMono-NF",
    "Inconsolata-NF",
    "RobotoMono-NF",
    "SourceCodePro-NF",
    "Terminus-NF",
    "Ubuntu-NF"
)

foreach($font in $fonts){
    Write-Host "Installing {0}" -f $font
    sudo scoop install --global $font
}
