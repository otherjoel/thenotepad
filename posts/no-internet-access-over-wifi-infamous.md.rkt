#lang punct notepad

---
title: No internet access over wifi (the infamous “local access only” problem)
date: 2010-02-12
topics: Windows problems,wifi
---

On my Windows laptop, wifi connnects easily to all wireless routers, but every
once in awhile it will not allow connections all the way out to the internet.
This mainly seems to happen when I switch to a new environment, such as bringing
my laptop out of the home and out to a coffee shop. This first [started
happening to me in
Vista](http://notely.blogspot.com/2009/08/ready-for-desktop.html), and the
problem has persisted in Windows 7 Pro.

The problem, which you can verify by opening a command prompt and typing
`ipconfig`, is that sometimes Windows assigns itself a bizzarro IP address
instead of the one given by the DHCP service on the wifi router. This made-up IP
address is usually on some odd subnet and never of course on the same one as the
actual wifi network.

Here’s the (ugly) solution: Open Notepad and cut/paste in the following:

```
ipconfig /release
ipconfig /renew
```

Save it as something like `wifi.bat`. Save it somewhere permanent but out of the
way, and put a shortcut to it somewhere handy (on your Start menu or something).

Now when you have the problem, right-click this file/shortcut and click “Run as
Administrator”.[^1] It might take a little while, but five’ll getcha ten your
problem will be all cleared up afterwards.

[^1]: If you have
    [UAC](http://lifehacker.com/5329964/windows-7-makes-uac-less-annoying-than-vista)
    turned off, you can just run it the normal way.
