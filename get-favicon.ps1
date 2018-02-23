<#

	.SYNOPSIS
  Downloads a favicon.ico-file from a domain.

	.DESCRIPTION

	.EXAMPLE

	.NOTES
	Put some notes here.

	.LINK
	https://github.com/sdaaish/powershell-stuff

	From Technet: https://msdn.microsoft.com/en-us/powershell/reference/5.1/microsoft.powershell.core/about/about_comment_based_help
#>

# Read the domain
param (
    [string] $domain = $null,
    [string] $outfile = "~/Downloads/favicon.ico"
)

function usage {
    Write-Host "Usage: ./get-fav -domain domainname"
}

if ($domain){
    if ($domain -like "www*") {
        $uri = "http://" + $domain + "/favicon.ico"
    }
    else {
        $uri = "http://www." + $domain + "/favicon.ico"
    }
    try {
        Invoke-Webrequest -Uri $uri -OutFile $outfile -Timeout 3 -Erroraction:Stop
    }
    catch {
        Write-Host -Foreground:red "Could not download $uri"
        Break
    }
    Write-host -Foreground:green "Done downloading $outfile"
}
else {
        usage
}
