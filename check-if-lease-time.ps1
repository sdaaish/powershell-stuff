<#

	.SYNOPSIS
	Checks the lease-time for active (up) interfaces.

	.DESCRIPTION
	Checks the Get-NetIPAddress.ValidLifeTime for IPv4-interfaces that are up.

	.EXAMPLE
	./

	.NOTES

	.LINK
	https://technet.microsoft.com/en-us/itpro/powershell/windows/tcpip/get-netipaddress
	
#>
$interfaces = (Get-NetAdapter| select Name,ifIndex,Status| where Status -eq Up)
"Valid DHCP lifetime per interface (Name,Index):"
foreach ($if in ($interfaces)){
    $lease = (((Get-NetIPAddress -ifIndex ($if).ifIndex -AddressFamily IPv4).ValidLifetime))
    $ifName = ($if).Name
    $ifIndex = ($if).ifIndex
    $lday = $lease.Days
    $lhour = $lease.Hours
    $lmin= $lease.Minutes
    $lsec= $lease.Seconds
    #Write-Host "$ifname $ifIndex $lday $lhour $lmin"
    "{0,-10}{1,-30}{2,3}{3,16}{4,10}" -f "Interface ",$ifname, $ifIndex, "$lday Days", "$lhour`:$lmin`:$lsec"
}
