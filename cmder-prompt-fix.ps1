<#

	.SYNOPSIS
  Downloads files and fonts for cmder-powerline.

	.DESCRIPTION
	Downloads fonts and configuration file to make use of Powerline fonts for Cmder/Cmdermini.

	.EXAMPLE
	./cmder-prompt-fix

	.NOTES
  Note completely working at the moment.

	.LINK
	https://amreldib.com/blog/CustomizeWindowsCmderPrompt/
	https://github.com/AmrEldib/cmder-powerline-prompt

#>


Invoke-WebRequest -Uri "https://raw.githubusercontent.com/AmrEldib/cmder-powerline-prompt/master/powerline_prompt.lua" -OutFile "C:\tools\cmdermini\config\powerline_prompt.lua"

# Fonts needed, download to ~/Downloads
$myfonts = @(
    "https://github.com/powerline/fonts/blob/master/AnonymousPro/Anonymice%20Powerline%20Bold%20Italic.ttf",
    "https://github.com/powerline/fonts/blob/master/AnonymousPro/Anonymice%20Powerline%20Bold.ttf",
    "https://github.com/powerline/fonts/blob/master/AnonymousPro/Anonymice%20Powerline%20Italic.ttf",
    "https://github.com/powerline/fonts/blob/master/AnonymousPro/Anonymice%20Powerline.ttf"
)

foreach ($file in $myfonts) {
    $file
    Invoke-Webrequest -Uri $file -Outfile ~/Downloads/
}
