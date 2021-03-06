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
    [Array] $gitdirs = (Get-ChildItem -Path $folder -Name .git -Recurse -Directory -Attributes Hidden, !Hidden)

    foreach($dir in $gitdirs){
        # Add .git to the path and convert to absolute
        $cdir = (Convert-Path ((Split-Path (${folder} + "\" + ${dir}))))
        # Remove trailing slash
        $cdir = $cdir.Trim('\')

        if ($cdir -match "AppData\\local\\lxss" ) {
            Write-Host "Will not check git in $cdir`n" -ForegroundColor red
        }
        else {
            Write-Host "Checking remote for ${cdir}" -foregroundcolor green
            Invoke-expression 'git -C ${cdir} remote -v'
            "`n"
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
