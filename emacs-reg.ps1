#
## Emacs registry hacks
#

## 2016-01-15/SDAA

$outfile = ${env:userprofile} + {\Google Drive\Kod\emacs.reg}
Write-Host ${outfile}

reg query HKCU\Software\Gnu\Emacs
#reg query HKCU\Software\WoW6432Node\Gnu\Emacs

# Set HOME-environment
#reg add HKCU\Environment /v HOME /t REG_EXPAND_SZ /d ^%USERPROFILE^% /f

# Set emacs as editor
#reg add HKCR\*\Shell\Emacs\Command /ve /t REG_SZ /d "c:\local\bin\emacs\bin\runemacs"  /f
