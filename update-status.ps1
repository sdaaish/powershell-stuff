<#

	.SYNOPSIS
	This script looks for modified files in local repositories

	.DESCRIPTION
	The script searches for directories  with a ".git" directory and makes a git "status".

	.EXAMPLE
	./update-status.ps1 myfolder
	./update-status.ps1 -Folder myfolder

  .PARAMETERS
    -Folder

	.NOTES
  Git must be in the current PATH.

	.LINK

#>

param (
    [string]$folder = "."
)

Function check-git {
    [Array] $gitdirs = (Get-ChildItem -Path $repodir -Name .git -Recurse -Directory -Attributes Hidden, !Hidden)

    foreach($dir in $gitdirs){

        # Add .git to the path and convert to absolute
        $cdir = (Convert-Path (Split-Path (${repodir} + "\" + ${dir})))

        #If it is a WSL directory, lxss, dont update since bad things happens.
        if ($cdir -match  "AppData\\local\\lxss" -or $cdir -match "\\Appdata\\local\\Packages" ) {
            Write-Host "Will not check git in $cdir`n" -ForegroundColor red
        }
        else {
            $gitstatus=(git -C ${cdir} status --porcelain)

            # Check if there were any modified files
            if ($gitstatus|where {$_ -match '^\?\?|^A|^M|^R'}) {
                Write-Host "`nRepo " -Foregroundcolor Green -NoNewLine
                Write-Host "${cdir} "  -Foregroundcolor Cyan -NoNewLine
                Write-Host "modified:"  -Foregroundcolor Green

                # Print the modified files
                foreach($file in $gitstatus){
                    Write-Host "${file}" -Foregroundcolor Yellow
                }
            }
        }
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
