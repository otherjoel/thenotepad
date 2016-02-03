#lang pollen

◊(define-meta title "Word 2003 crashing when trying to format lists")
◊(define-meta published "2009-03-13")
◊(define-meta tags "Word,Windows Registry")

One of our users was having Word crash on her every time she accessed the ◊code{Bullets and Numbering…} function in Word. The problem seemed intermittent at first but eventually became 100% consistent. We checked Office Update but the site reported that we were all up to date on that front, so there was no possibility of downloading an update that might fix the problem. An internet search uncovered a ◊link["http://www.tech-archive.net/Archive/Word/microsoft.public.word.application.errors/2008-08/msg00490.html"]{solution to the problem}, the problem being a corrupt “List Gallery”. When you access the ◊code{Bullets and Numbering…} function, Word shows you a gallery of list styles so you can preview them all and pick the one you want. Over time, Word tries to adapt this gallery so that the defaults match the styles you most frequently use. However, this adaptive behaviour is kind of flaky and poorly implemented, so if you are working on a lot of documents from a bunch of different people and spend a lot of time fixing broken and mis-formatted lists (as this user often does), the gallery itself eventually fills up with the broken and mis-formatted list styles you happen to be working on. In this case it got so bad that Word itself couldn’t even handle the garbage and it crashed every time it had to display the list gallery. To fix the problem (◊link["http://www.tech-archive.net/Archive/Word/microsoft.public.word.application.errors/2008-08/msg00490.html"]{source}):

◊ol{
◊li{Open Registry Editor (go to Start, click Run, and type ◊code{regedit})}
◊li{Navigate down to the ◊code{HKEY_CURRENT_USER\Software\Microsoft\Office\11.0\Word\List Gallery Presets} key (What look like folders in the Registry are actually called keys)}
◊li{Right click on the ◊code{List Gallery Presets} key and Delete it}
}

When you next start word, click the Format menu and choose Bullets and Numbering — the List Gallery will now display with all the simple, clean defaults it had when you first installed Word.
