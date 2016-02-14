#lang pollen

◊(define-meta title "Windows 7 updates keep installing, restarting and failing")
◊(define-meta published "2011-05-11")
◊(define-meta topics "windows")

Over the past week and a half, my Win 7 laptop has been trying to automatically install the same set of updates and failing over and over again. Sometimes the automatic install/restart cycle would happen in the middle of the night when the dumb thing was supposed to be sleeping. It would restart, say “Configuring Windows Updates”, then “Updates Failed, Reverting Changes” (or something like that).

The update history showed they mostly failed with error ◊code{80071A90}. The help file on that error recommended running Windows Update manually after starting Windows in safe mode with networking, but the Windows Update service will not run in safe mode.

I found the solution in ◊link["http://answers.microsoft.com/en-us/windows/forum/windows_7-windows_update/unable-to-update-windows-7-pro-error-80071a90/0304f6a2-0174-e011-8dfc-68b599b31bf5"]{this Microsoft Answers article}:

◊blockquote{
Assuming the updates-in-question include KB2515325, KB2492386, KB2506928, KB2512715 and/or KB982018, and all is well with your computer otherwise:

◊ol{
◊item{Run a manual check for updates per ◊link["http://windows.microsoft.com/en-us/windows7/How-can-I-tell-if-my-computer-is-up-to-date"]{http://windows.microsoft.com/en-us/windows7/How-can-I-tell-if-my-computer-is-up-to-date}}
◊item{Select (check) only ◊code{KB2515325}, ◊code{KB2492386}, ◊code{KB2506928} and/or ◊code{KB2512715}, and install them; follow all prompts.}
◊item{Now run another manual check for updates, if necessary, and install ◊code{KB982018} by itself; again, follow all prompts.}
}
}
