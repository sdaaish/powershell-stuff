# powershell-stuff
Different powershellscripts

### Create a Powershell profile
Check if you have a Powershell profile with ```Test-Path $profile```.
If you don't have that, the output is false, initialise the file with
```
New-Item -type file -force $profile
notepad $profile
```
Content of that file should be:
```
$DirScripts = "$env:Userprofile\Repos\powershell-stuff"
. "$DirScripts\profile.ps1"
```
if you have your files in Repos/Powershell in your home-directory.
