<#

	.SYNOPSIS

	.DESCRIPTION

	.EXAMPLE

	.NOTES
	Put some notes here.

	.LINK
	https://github.com/sdaaish/powershell-stuff

	From Technet: https://msdn.microsoft.com/en-us/powershell/reference/5.1/microsoft.powershell.core/about/about_comment_based_help
#>

param (
    [string] $web = $null
)
$uri = "http://www." + $web + "/favicon.ico"
# "$uri"

if ($uri.count -eq 1 ) {
    Invoke-Webrequest -Uri $uri -OutFile ~/Downloads/favicion.ico
}
else {
    "Usage: $0 domain"
}
