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
    docker image ls| ConvertFrom-Docker|? tag -Like "<none>"|% {docker image rm $_.ImageID}
}

# mitmproxy
# https://hub.docker.com/r/mitmproxy/mitmproxy/
Function mitmproxy {
    try {
        Test-Path ~/.mitmproxy -PathType Container|out-null
    }
    catch {
        New-Item -Path ~/.mitmproxy -ItemType Directory
    }
    Write-Output "Starting the mitmproxy on port 8080"
    $mitmconfig = Convert-Path ~/.mitmproxy
    docker run --rm -it -v ${mitmconfig}:/home/mitmproxy/.mitmproxy -p 127.0.0.1:8080:8080 mitmproxy/mitmproxy mitmproxy ssl-insecure
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
