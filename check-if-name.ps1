<#

	.SYNOPSIS
	Checks the ip-address and namefor active interfaces

	.DESCRIPTION
	Does a forward lookup for the hostname and a reverse lookup for the ip-addresses for active interfaces

	.EXAMPLE
	./

	.NOTES
	Need some better errorhandling

	.LINK
	
	
#>

#$hostname = ($env:ComputerName + "." + $env:UserDnsDomain).ToLower()
$hostname = (Get-CIMInstance CIM_ComputerSystem).Name.tolower()
$primarydomain = (Get-CIMInstance CIM_ComputerSystem).Domain.tolower()
$interfaces = (Get-NetAdapter| select Name,ifIndex,Status| where Status -eq Up)

Write-Output "Local hostname =`t$hostname"
Write-Output "Primary domain =`t$primarydomain`n"

# Get interfaces that are up and print there ip-address
foreach  ($if in $interfaces) {
    $ipv4 = (Get-NetIPAddress -ifIndex ($if).ifIndex -Type Unicast -AddressFamily IPv4).IPAddress
    $ifName = ($if).Name
    $ifIndex = ($if).ifIndex
    #Get-DnsClient -InterfaceIndex $ifIndex| select ConnectionSpecificSuffix
        Write-Output "Interface $ifName ($ifIndex) has address =`t$ipv4"

    # Check for the reverse recordin DNS
    $dnshost = (Resolve-DnsName -Name $ipv4 -DnsOnly -ErrorAction Ignore).NameHost #Reverselookup
    if ($dnshost) {
	Write-Output "Reverse lookup for $ipv4 =`t$dnshost"

	# In case there is no name for dnshost
	try {
	    $revname = (Resolve-DnsName -Name $dnshost -DnsOnly -ErrorAction Stop).IpAddress #Forward Lookup
	}
	catch {
	    Write-Output "No name for $ipv4"
	    Break
	}
	finally {
	    Write-Output "Forward lookup for $dnshost = $revname`n"
	}
    }
    else {
	# The ip-address has no record in DNS
        Write-Output "No reverse lookup for $ipv4`n"
    }
}

