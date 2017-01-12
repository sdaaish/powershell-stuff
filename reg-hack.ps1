#
## Various registry hacks
#

## 2016-01-15/SDAA

# Set HOME-environment
reg add HKCU\Environment /v HOME /t REG_EXPAND_SZ /d ^%USERPROFILE^% /f

# Set emacs as editor
reg add HKCR\*\Shell\Emacs\Command /ve /t REG_SZ /d "c:\local\bin\emacs\bin\runemacs"  /f
