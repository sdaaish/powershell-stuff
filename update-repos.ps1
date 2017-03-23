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

$homedir = $env:Userprofile + "\Repos"
$currentpath = (Get-Location).Path

[Array] $dirs = (Get-ChildItem -Path $homedir -name .git -Recurse -Directory -Attributes h)

foreach($dir in $dirs){
    $gitdir = (Split-Path $dir)
    "Updating ${gitdir}"
    cd $gitdir
    cmd /c "git pull"
    cd $currentpath
    "Done updating ${gitdir}`n"
}
