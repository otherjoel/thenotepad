#lang pollen

◊(define-meta title "No internet access over wifi (the infamous “local access only” problem)")
◊(define-meta published "2010-02-12")

On my Windows laptop, wifi connnects easily to all wireless routers, but every once in awhile it will not allow connections all the way out to the internet. This mainly seems to happen when I switch to a new environment, such as bringing my laptop out of the home and out to a coffee shop. This first ◊link["http://notely.blogspot.com/2009/08/ready-for-desktop.html"]{started happening to me in Vista}, and the problem has persisted in Windows 7 Pro.

The problem, which you can verify by opening a command prompt and typing ◊code{ipconfig}, is that sometimes Windows assigns itself a bizzarro IP address instead of the one given by the ◊span[#:class "caps"]{DHCP} service on the wifi router. This made-up IP address is usually on some odd subnet and never of course on the same one as the actual wifi network.

Here’s the (ugly) solution: Open Notepad and cut/paste in the following:

◊blockcode{ipconfig /release
    ipconfig /renew}

Save it as something like ◊code{wifi.bat}. Save it somewhere permanent but out of the way, and put a shortcut to it somewhere handy (on your Start menu or something).

Now when you have the problem, right-click this file/shortcut and click “Run as Administrator”.◊margin-note{If you have ◊link["http://lifehacker.com/5329964/windows-7-makes-uac-less-annoying-than-vista"]{◊span[#:class "caps"]{UAC}} turned off, you can just run it the normal way.} It might take a little while, but five’ll getcha ten your problem will be all cleared up afterwards.
