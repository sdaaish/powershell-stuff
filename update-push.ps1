<#

	.SYNOPSIS
	This will do a dry-run push to remote repositories.

	.DESCRIPTION
	The script searches for directories under %UserProfile%\Repos with a .git directory and makes a git push --dry-run.

	.EXAMPLE
	./update-push.ps1

	.NOTES
	The location of repositories is in $env:UserProfile\Repos.
        git must be in the current PATH.

	.LINK
        About Get-ChildItem:
        https://msdn.microsoft.com/en-us/powershell/reference/5.1/microsoft.powershell.core/providers/filesystem-provider/get-childitem-for-filesystem
        https://msdn.microsoft.com/powershell/reference/5.1/Microsoft.PowerShell.Management/Get-ChildItem
#>

$repodir = $env:Userprofile + "\Repos"

[Array] $gitdirs = (Get-ChildItem -Path $repodir -Name .git -Recurse -Directory -Attributes Hidden, !Hidden)

foreach($dir in $gitdirs){
    $cdir = (Split-Path (${repodir} + "\" + ${dir}))
    "Updating ${cdir}"
    cmd /c "git -C ${cdir} push --dry-run"
    "Done updating ${cdir}`n"
}
