<#

	.SYNOPSIS
	Checks the ip-address and namefor active interfaces

	.DESCRIPTION
	Does a forward lookup for the hostname and a reverse lookup for the ip-addresses for active interfaces

	.EXAMPLE
	./

	.NOTES
	[system.net.dns]::GetHostByName is obsolete, but still works
	GetHostByName still resolves local addresses

	.LINK
	
	
#>

$hostname = [system.net.dns]::GetHostByName((hostname)).Hostname
$interfaces = (Get-NetAdapter| select Name,ifIndex,Status| where Status -eq Up)
Write-Output "Local hostname:`t`t$hostname`n"

# Get interfaces that are up and print there ip-address
foreach  ($if in $interfaces) {
    $ipv4 = (Get-NetIPAddress -ifIndex ($if).ifIndex -Type Unicast -AddressFamily IPv4).IPAddress
    $ifName = ($if).Name
    $ifIndex = ($if).ifIndex
    Write-Output "Interface $ifName ($ifIndex) has address:`t$ipv4"
    $dnshost = [System.net.dns]::getHostByAddress("$ipv4").HostName #Reverse lookup
    Write-Output "DNS lookup for $ipv4 :`t`t$dnshost`n"
}

foreach ($address in [System.Net.Dns]::GetHostByName(($hostname)).Addresslist.IPAddressToString) {
    Write-Output "DNS lookup for $hostname `t$address"
}
