<#
	.SYNOPSIS
	Sets default browser for web-protocols
	Invoke with "./set-default-browser <browsername>"

	.NOTES

	2017-01-17/SDAA
#>

function Set-DefaultBrowser
{
    param($defaultBrowser)

    $regKey      = "HKCU:\Software\Microsoft\Windows\Shell\Associations\UrlAssociations\{0}\UserChoice"
    $regKeyFtp   = $regKey -f 'ftp'
    $regKeyHttp  = $regKey -f 'http'
    $regKeyHttps = $regKey -f 'https'

    switch -Regex ($defaultBrowser.ToLower())
    {
        # Internet Explorer
        'ie|internet|explorer' {
            Set-ItemProperty $regKeyFtp   -name ProgId IE.FTP
            Set-ItemProperty $regKeyHttp  -name ProgId IE.HTTP
            Set-ItemProperty $regKeyHttps -name ProgId IE.HTTPS
            break
        }
        # Firefox
        'ff|firefox' {
            Set-ItemProperty $regKeyFtp   -name ProgId FirefoxURL
            Set-ItemProperty $regKeyHttp  -name ProgId FirefoxURL
            Set-ItemProperty $regKeyHttps -name ProgId FirefoxURL
            break
        }
        # Google Chrome
        'cr|google|chrome' {
            Set-ItemProperty $regKeyFtp   -name ProgId ChromeHTML
            Set-ItemProperty $regKeyHttp  -name ProgId ChromeHTML
            Set-ItemProperty $regKeyHttps -name ProgId ChromeHTML
            break
        }
        # Safari
        'sa*|apple' {
            Set-ItemProperty $regKeyFtp   -name ProgId SafariURL
            Set-ItemProperty $regKeyHttp  -name ProgId SafariURL
            Set-ItemProperty $regKeyHttps -name ProgId SafariURL
            break
        }
        # Opera
        'op*' {
            Set-ItemProperty $regKeyFtp   -name ProgId Opera.Protocol
            Set-ItemProperty $regKeyHttp  -name ProgId Opera.Protocol
            Set-ItemProperty $regKeyHttps -name ProgId Opera.Protocol
            break
        }
    } 
}

# thanks to http://newoldthing.wordpress.com/2007/03/23/how-does-your-browsers-know-that-its-not-the-default-browser/
# Errorhandling tips: https://blogs.technet.microsoft.com/heyscriptingguy/2015/04/03/catch-powershell-errors-related-to-reading-the-registry/

# If there is no keys present, create them
$ErrorActionPreference = "stop"
try {
    (Get-ItemProperty 'HKCU:\Software\Microsoft\Windows\Shell\Associations\UrlAssociations\ftp\UserChoice').ProgId
}
catch [System.Management.Automation.ItemNotFoundException] {
    New-Item 'HKCU:\Software\Microsoft\Windows\Shell\Associations\UrlAssociations\ftp' -force|Out-Null
    New-Item 'HKCU:\Software\Microsoft\Windows\Shell\Associations\UrlAssociations\ftp\UserChoice' -force|Out-Null
}
finally  {
    $ErrorActionPreference = "Continue"
}

    
<#Try {
    (Get-ItemProperty 'HKCU:\Software\Microsoft\Windows\Shell\Associations\UrlAssociations\http\UserChoice').ProgId
}
catch [System.Management.Automation.ItemNotFoundException] {
    New-Item $regKeyHttp
}
Try {
    (Get-ItemProperty 'HKCU:\Software\Microsoft\Windows\Shell\Associations\UrlAssociations\https\UserChoice').ProgId
}
catch [System.Management.Automation.ItemNotFoundException] {
    New-Item $regKeyHttps
}
#>
param (
    [string]$browser = default
)

if ($browser -eq "default") {
    Write-Host "Usage: ./set-default-browser -browser <ff|ie|cr|op|sa>"
}
else {
    Set-DefaultBrowser $browser
}


# Set-DefaultBrowser cr
# Set-DefaultBrowser ff
# Set-DefaultBrowser ie
# Set-DefaultBrowser op
# Set-DefaultBrowser sa
