<#

	.SYNOPSIS
	This script looks for modified files in local reposotories

	.DESCRIPTION
	The script searches for directories under %UserProfile%\Repos with a .git directory and makes a git status.

	.EXAMPLE
	./update-status.ps1

	.NOTES
	The location of repositories is in $env:UserProfile\Repos.
  Git must be in the current PATH.

	.LINK

#>

$repodir = $env:Userprofile + "\Repos"

[Array] $gitdirs = (Get-ChildItem -Path $repodir -Name .git -Recurse -Directory -Attributes Hidden,!Hidden)

foreach($dir in $gitdirs){
    $cdir = (Split-Path (${repodir} + "\" + ${dir}))
    "`nChecking ${cdir}"
    cmd /c "git -C ${cdir} status -sb"
}
