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

# Starts local portainer image with docker
# Based on this: https://lemariva.com/blog/2018/05/tutorial-portainer-for-local-docker-environments-on-windows-10
# The above dont work on my machine, however this does:
# https://github.com/Microsoft/Docker.DotNet/issues/109
# This don't need any firewall-rules to work but depends on Go
Function Start-Portainer {
    try {
        docker volume ls| ConvertFrom-Docker| Where-Object Volumename -like portainer_data
    }
    catch {
        docker volume create portainer_data
    }

    # Starts the proxy before portainer
    # https://github.com/sdaaish/golang-tools/tree/master/tcpproxy
    Start-Process Resolve-Path ~\go\bin\tcpproxy.exe -WindowStyle Hidden
    docker run -p 9000:9000 -v portainer_data:/data portainer/portainer -H tcp://10.0.75.1:2375
}

# Create a new local modulepath and add it to PSModulePath
Function Set-LocalModulePath {

    [cmdletbinding()]
    param()

    begin {
        # Current Documents folder
        $Documents = [System.Environment]::GetFolderPath("MyDocuments")
        Write-Verbose "Documents-path: $Documents"
    }

    process {
        if ($isLinux){
            # Dont do anything at the moment
            Write-Verbose "$env:PSModulePath"
        }
        else {

            # Check wich version of Powershell
            switch ($PSVersionTable.PSEdition){
                "Core" {$version = "PowerShell/Modules"}
                "Desktop" { $version = "WindowsPowerShell/Modules"}
            }

            # Resolve the path to modules depending on version of Powershell
            $LocalDirectory = [System.IO.Path]::GetFullPath((Join-Path -Path $env:USERPROFILE -ChildPath ".local"))
            $NewModuleDirectory = Join-Path -Path $LocalDirectory -ChildPath $version
            Write-Verbose "New module directory: $NewModuleDirectory"

            try {
                Test-Path $NewModuleDirectory -ErrorAction Stop-Process
            }
            catch {
                New-Item -Path $NewModuleDirectory -ItemType Directory -Force|Out-Null
            }

            $OldModulePath = $env:PSModulePath -split(";")
            [string[]]$NewModulePath = $NewModuleDirectory
            $NewModulePath += $OldModulePath
        }
    }
    end {
        $NewModulePath -join(";")
        Write-Verbose "Old module path: $env:PSModulePath"
        Write-Verbose "New module path: $NewModulePath"
    }
}
# Start vcxsrv in Windows (XLaunch)
Function startx {
    if ($PSVersionTable.PSEdition = "Desktop" -or $isWindows ){
        try {
            # Multiply window scaling with 96 to get DPI. 150 -> 144, 125 -> 120 and so on.
            # Export GDK_DPI_SCALING=1.50 in wsl to reflect the above.
            # From https://medium.comto/@promiselchin/fixing-blurry-fonts-on-wsl-with-x-server-816b4a4f855f
            xlaunch.exe -run $(Resolve-Path "~/OneDrive/.config/config.xlaunch") -dpi 144
        }
        catch {
            Write-Error "Starting xlaunch failed."
        }
    }
    else {
        startx
    }
}
