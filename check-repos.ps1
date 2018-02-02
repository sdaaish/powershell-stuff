<#

	.SYNOPSIS
	This checks the git repositories with "git remote -v"

	.DESCRIPTION
	The script searches for directories in the given folder with a .git directory and makes a "git remote -v"

  .PARAMETER
  -Folder

	.EXAMPLE
	./check-repos.ps1

	.NOTES
  The program "git" must be in the current PATH.

	.LINK
#>

param (
    [string]$folder = "."
)

Function check-git {
    [Array] $gitdirs = (Get-ChildItem -Path $repodir -Name .git -Recurse -Directory -Attributes Hidden, !Hidden)

    foreach($dir in $gitdirs){
        $cdir = (Split-Path (${repodir} + "\" + ${dir}))
        Write-Host "Checking remote for ${cdir}" -foregroundcolor green
        cmd /c "git -C ${cdir} remote -v"
        "`n"
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
