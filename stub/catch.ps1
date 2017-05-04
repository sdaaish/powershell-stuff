param (
   [string]$browser = "default"
)

<#
catch [System.Management.Automation.ParameterBindingException] {
    Write-Host "Some message"
}
finally {
    Write-Host "Finally"
}
#>

Write-Host $browser $args[0] $args[1]


