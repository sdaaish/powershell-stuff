<#

	.SYNOPSIS
	Checks the ip-address and resolves name(s) for active interface(s)

	.DESCRIPTION
	Does a forward lookup for the hostname and a reverse lookup for the ip-addresses for active interfaces

	.EXAMPLE
	./

	.NOTES
	Results differ depending if computer is AD-connected, have several active interfaces and have ipv6-addresses.

	Needs some better errorhandling
	Needs better handling of multiple ip-addresses per interface and ipv6
	Some dead code currently in there.....

	.LINK
	http://virot.eu/getting-the-computername-in-powershell/
	
#>

#$hostname = ($env:ComputerName + "." + $env:UserDnsDomain).ToLower()
$hostname = (Get-CIMInstance CIM_ComputerSystem).Name.ToLower()
$primarydomain = (Get-CIMInstance CIM_ComputerSystem).Domain.ToLower()
$interfaces = (Get-NetAdapter| select Name,ifIndex,Status| where Status -eq Up)

Write-Output "Local hostname    =`t$hostname"
Write-Output "Primary AD-domain =`t$primarydomain`n"

# Get interfaces that are up and print there ip-address
foreach  ($if in $interfaces) {
    $ipv4 = (Get-NetIPAddress -ifIndex ($if).ifIndex -Type Unicast -AddressFamily IPv4).IPAddress
    $ipv6 = (Get-NetIPAddress -ifIndex ($if).ifIndex -Type Unicast -AddressFamily IPv6).IPAddress
    $ifName = ($if).Name
    $ifIndex = ($if).ifIndex
    $conspecsuffix = (Get-DnsClient -InterfaceIndex $ifIndex).ConnectionSpecificSuffix

    # If there is a domain suffix for interface, print it.
    if ($conspecsuffix) {
	Write-Output "Conn. specific suffix for $ifName ($ifIndex)  =`t$conspecsuffix"
    }
    Write-Output "Interface $ifName ($ifIndex) has ipv4-address =`t$ipv4"
    # Write every ipv6 address for the interface on a separate line
    foreach ($addr_6 in $ipv6) {
	Write-Output "Interface $ifName ($ifIndex) has ipv6-address =`t$addr_6"
    }

    # Check for the reverse record in DNS
    $dnshost = (Resolve-DnsName -Name $ipv4 -DnsOnly -ErrorAction Ignore).NameHost #Reverselookup
    if ($dnshost) {
	$dnshost= $dnshost.ToLower()
	Write-Output "Reverse lookup for $ipv4 =`t$dnshost"

	# In case there is no name for dnshost
	try {
	    $revname = (Resolve-DnsName -Name $dnshost -DnsOnly -ErrorAction Stop).IpAddress #Forward Lookup
	}
	catch {
	    Write-Output "No name for $ipv4"
	    Break
	}
	# Currently dead code...
	finally {
	    Write-Output "Forward lookup for $dnshost = $revname`n"
	}
    }
    else {
	# The ip-address has no record in DNS
        Write-Output "No reverse lookup for $ipv4 in DNS.`n"
    }
}

