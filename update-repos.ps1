<#

	.SYNOPSIS
	This updates git repositories with a git pull

	.DESCRIPTION
	The script searches for directories with a .git directory and makes a "git pull".

	.EXAMPLE
	./update-repos.ps1
	./update-repos.ps1 Myfolder
	./update-repos.ps1 -Folder ~/repos

	.NOTES
  "git" must be in the current PATH.
  It won't update files that belong to lxss, ie Windows Linux Subshell (WSL), which is a bad idea.

	.LINK
#>


param (
    [string]$folder = "."
)

Function check-git {
    [Array] $gitdirs = (Get-ChildItem -Path $folder -Name .git -Recurse -Directory -Attributes Hidden, !Hidden)

    foreach($dir in $gitdirs){

        # Add .git to the path and convert to absolute
        $cdir = (Convert-Path ((Split-Path (${folder} + "\" + ${dir}))))

        #If it is a WSL directory, lxss, dont update since bad things happens.
        if ($cdir -match "AppData\\local\\lxss" ) {
            Write-Host "Will not update git in $cdir`n" -ForegroundColor red
        }
        else {
            "Updating ${cdir}"
            cmd /c "git -C ${cdir} pull"
            "Done updating ${cdir}`n"
        }
    }
}

# Main
if (Test-Path -Path $folder -PathType Container){
    check-git
    }
else {
    "$folder is not a valid directory. Exiting."
    break
}

