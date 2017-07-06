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
