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

	.LINK
#>


param (
    [string]$folder = "."
)

Function check-git {
    [Array] $gitdirs = (Get-ChildItem -Path $repodir -Name .git -Recurse -Directory -Attributes Hidden, !Hidden)

    foreach($dir in $gitdirs){
        $cdir = (Split-Path (${repodir} + "\" + ${dir}))
        "Updating ${cdir}"
        cmd /c "git -C ${cdir} pull"
        "Done updating ${cdir}`n"
    }
}

# Main
if (Test-Path -Path $folder -PathType Container){
    $repodir = $folder
    check-git
    }
else {
    "$folder is not a valid directory. Exiting."
    break
}

