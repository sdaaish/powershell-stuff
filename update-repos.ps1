<#

	.SYNOPSIS
	This updates git repositories with a git pull

	.DESCRIPTION
	The script searches for directories under %UserProfile%\Repos with a .git directory and makes a git pull

	.EXAMPLE
	./update-repos.ps1

	.NOTES
	The location of repositories is in $env:UserProfile\Repos.
        git must be in the current PATH.

	.LINK

#>

$repodir = $env:Userprofile + "\Repos"

[Array] $gitdirs = (Get-ChildItem -Path $repodir -Name .git -Recurse -Directory -Attributes h)

foreach($dir in $gitdirs){
    $cdir = (Split-Path (${repodir} + "\" + ${dir}))
    "Updating ${cdir}"
    cmd /c "git -C ${cdir} pull"
    "Done updating ${cdir}`n"
}
