<#

	.SYNOPSIS
	Checks the ip-address and resolves name(s) for active interface(s)

	.DESCRIPTION
	Does a forward lookup for the hostname and a reverse lookup for the ip-addresses for active interfaces

	.EXAMPLE
	./

	.NOTES
	Results differ depending if computer is AD-connected, have several active interfaces and have ipv6-addresses.
	Prints the Primary-domain suffix and Primary-NVdomain suffix, just in case....
	Domain is the current domain, NV-domain is one the after reboot.

	Needs some better errorhandling
	Some dead code currently in there.....

	.LINK
	http://virot.eu/getting-the-computername-in-powershell/
	
#>

#$hostname = ($env:ComputerName + "." + $env:UserDnsDomain).ToLower()
$hostname = (Get-CIMInstance CIM_ComputerSystem).Name.ToLower()
$primarydomain = (Get-CIMInstance CIM_ComputerSystem).Domain.ToLower()
$interfaces = (Get-NetAdapter| select Name,ifIndex,Status| where Status -eq Up)
# Stupid stuff, Primary DNS-suffix and Non Volatile Domain
$domain= (Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\").Domain
$nvdomain = (Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\")."NV Domain"

"{0,-20}{1,-30}" -f "Local hostname          = ","$hostname"
"{0,-20}{1,-30}" -f "Primary AD-domain       = ","$primarydomain"
"{0,-20}{1,-30}" -f "Primary domain suffix   = ","$domain"
"{0,-20}{1,-30}" -f "Primary nvdomain suffix = ","$nvdomain`n"

# Get interfaces that are up and print the ip-address
foreach  ($if in $interfaces) {
    $ipv4 = (Get-NetIPAddress -ifIndex ($if).ifIndex -Type Unicast -AddressFamily IPv4).IPAddress
    $ipv6 = (Get-NetIPAddress -ifIndex ($if).ifIndex -Type Unicast -AddressFamily IPv6).IPAddress
    $ifName = ($if).Name
    $ifIndex = ($if).ifIndex
    $conspecsuffix = (Get-DnsClient -InterfaceIndex $ifIndex).ConnectionSpecificSuffix

    # If there is a domain suffix for interface, print it.
    if ($conspecsuffix) {
	"{0,-54}{1,-3}{2,-35}" -f "Conn. specific suffix for $ifName ($ifIndex)"," = ","$conspecsuffix"
    }
    "{0,-54}{1,-3}{2,-15}" -f "Interface $ifName ($ifIndex) has ipv4-address"," = ","$ipv4"
    # Write every ipv6 address for the interface on a separate line
    foreach ($addr_6 in $ipv6) {
	"{0,-54}{1,-3}{2,-30}" -f "Interface $ifName ($ifIndex) has ipv6-address"," = ","$addr_6"
    }

    # Check for the reverse record in DNS
    $dnshost = (Resolve-DnsName -Name $ipv4 -DnsOnly -ErrorAction Ignore).NameHost #Reverselookup
    if ($dnshost) {
	$dnshost= $dnshost.ToLower()
	"{0,-54}{1,-3}{2,-40}" -f "Reverse DNS lookup for $ipv4"," = ", "$dnshost"

	# In case there is no name for dnshost
	try {
	    $faddr = (Resolve-DnsName -Name $dnshost -DnsOnly -ErrorAction Stop).IpAddress #Forward Lookup
	}
	# This part is probably dead
	catch {
	    Write-Output "No name for $ipv4"
	    Break
	}
	# For every ip-address in the forward lookup, resolve to a name (reverse lookup)
	finally {
	    foreach ($name in $faddr) {
		"{0,-54}{1,-3}{2,-40}" -f "Forward DNS lookup for $dnshost", " = ", "$name"
	    }
	    Write-Output ""
	}
    }
    else {
	# The ip-address has no record in DNS
        Write-Output "No reverse lookup for $ipv4 in DNS.`n"
    }
}

