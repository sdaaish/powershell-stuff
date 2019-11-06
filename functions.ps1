# Place for functions

# Docker
Function dkil {
    docker image ls
}
Function dkcl {
    docker container ls
}
Function dkps {
    docker ps
}
# List docker containers
Function Get-DockerContainer {
    docker container ls --all|ConvertFrom-Docker
}
# List docker images
Function Get-DockerImage {
    docker image ls|ConvertFrom-Docker
}
# Remove old images with none
Function Remove-DockerNone {
    Get-DockerImage|? tag -Like "<none>"|% {docker image rm $_.ImageID}
}
# Upgrade docker images
Function Update-DockerImage {
    Get-DockerImage |
      Foreach-Object {docker pull $_.Repository}
}

# mitmproxy
# https://hub.docker.com/r/mitmproxy/mitmproxy/
Function Start-MitmProxy {
    [cmdletbinding()]
    Param (
        [Parameter(Mandatory)]
        $Path = "$env:USERPROFILE/Downloads",
        [int]$LocalPort = 8080,
        [string[]]$MitmOpts
    )

    try {
        Test-Path ~/.mitmproxy -PathType Container|Out-Null
    }
    catch {
        New-Item -Path ~/.mitmproxy -ItemType Directory
    }
    Write-Verbose "Starting mitmproxy on port $LocalPort"
    $MitmConfig = Convert-Path ~/.mitmproxy
    $Download = Convert-Path $Path
    $EXE = "docker"

    # Define parameters
    $params = "run","--rm","-it"
    $params += "-v", "$($MitmConfig -replace '\\','/'):/home/mitmproxy/.mitmproxy"
    $params += "-v", "$($Download -replace '\\','/'):/home/mitmproxy/tmp"
    $params += "-p", "127.0.0.1:${LocalPort}:8080"
    $params += "mitmproxy/mitmproxy", "mitmproxy", "${MitmOpts}"

    Write-Verbose "docker $params"
    pause
    & $EXE @params
}

# Censys domain lookup
Function Search-Censys {
    param (
        $domain,
        $apifile = "~/.settings/censys.api"
    )

    try {
        $censys = Get-Content $apifile -ErrorAction Stop| ConvertFrom-Json
    }
    catch [System.IO.DirectoryNotFoundException],[System.IO.FileNotFoundException] {
        Write-Error "No such file, $apifile" -ErrorAction Stop
    }
    catch {
        Write-Error "Some error occured, $apifile" -ErrorAction Stop
    }

    $id = $censys.CENSYS_API_ID
    $secret = $censys.CENSYS_API_SECRET

    docker run --rm -e CENSYS_API_SECRET=$secret -e CENSYS_API_ID=$id --name censys sdaaish/censys_subdomain_finder $domain
}
# Runs shodan as container
Function shodan {
    $shodandir = "~/.shodan"
    try {
        $shodandir = Convert-Path $shodandir -ErrorAction Stop
    }
    catch {
        $shodanfile = $shodandir + ".shodan"
        New-Item -Path $shodandir -ItemType Directory
        New-Item -Path $shodanfile  -ItemType File
    }
    docker run --rm -it -v ${shodandir}:/home/shodan/.shodan -e PAGER=cat sdaaish/shodan:latest $args
}
