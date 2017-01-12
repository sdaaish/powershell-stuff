#
## Example code for if,else
#

## 2016-01-15/SDAA

$version = (Get-WmiObject -class Win32_OperatingSystem).Caption

if ( $version  -match "7" ) {
	Write-Host "Host is Seven"
    }
else {
	Write-Host "Host is $version"
}
