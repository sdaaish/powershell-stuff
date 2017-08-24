<#

	.SYNOPSIS
  Starts a video with VLC, or the program thats associated with videofile appendix

	.DESCRIPTION

	.EXAMPLE

	.NOTES

	.LINK
	https://github.com/sdaaish/powershell-stuff
#>
param (
    [string] $video = $null
)

function usage {
    Write-Host "Usage: ./openvlc -video videofile"
}

$vlc = 'C:/Program Files/VideoLAN/VLC/vlc.exe'

if ($video) {
    Invoke-Item $video
}
else {
    usage
}
