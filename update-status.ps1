<#

	.SYNOPSIS
	This script looks for modified files in local repositories

	.DESCRIPTION
	The script searches for directories under %UserProfile%\Repos with a .git directory and makes a git status.

	.EXAMPLE
	./update-status.ps1

	.NOTES
	The location of repositories is in $env:UserProfile\Repos.
  Git must be in the current PATH.

  Could be more generic regarding input directory

	.LINK

#>

$repodir = $env:Userprofile + "\Repos"

[Array] $gitdirs = (Get-ChildItem -Path $repodir -Name .git -Recurse -Directory -Attributes Hidden,!Hidden)

foreach($dir in $gitdirs){
    $cdir = (Split-Path (${repodir} + "\" + ${dir}))
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
