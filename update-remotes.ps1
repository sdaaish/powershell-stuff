<#

.SYNOPSIS
This checks remote git repositories for uopdates.

.DESCRIPTION
The script searches for directories with a .git directory and makes a "git remote -v".

.EXAMPLE
./update-remotes.ps1
./update-remotes.ps1 Myfolder
./update-remotes.ps1 -Folder ~/repos

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
        # Trim trailing slash
        $cdir = $cdir.Trim('\')

        #If it is a WSL directory, lxss, dont update since bad things happens.
        if ($cdir -match  "AppData\\local\\lxss" -or $cdir -match "\\Appdata\\local\\Packages") {
            Write-Host "Will not update git in $cdir`n" -ForegroundColor red
        }
        else {
            "Checking ${cdir}"
            Invoke-Expression 'git -C $cdir remote -v update'
            "Done checking ${cdir}`n"
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
