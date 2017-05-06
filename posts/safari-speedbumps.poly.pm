#lang pollen

◊(define-meta title "Safari Speedbumps")
◊(define-meta published "2017-05-03")

For a long time now, I've had a problem with Safari taking a long time to load a website when I first navigate to it: there will be a long pause (5–10 sec) with no visible progress or network traffic. Then there will be a burst of traffic, the site will load fully inside of a second, and every page I visit within that site afterwards will be lightning fast.

The same thing happens whether I'm at work, at home, or on public wifi (using a VPN of course). I've tried disabling all extensions and I've also tried using Chrome. So this was mystifying to me.

But I think I might have finally found the source of the problem. I was in Safari's preferences window and noticed this little warning on the Security tab:

◊figure["safari-fraud.png"]{Safari preferences pane showing a problem with the 'Safe Browsing Service'}

I unchecked that box, and the problem seems to have disappeared.

Now, I haven't yet been able to find any official information on exactly how Safe Browsing Service works, but it's not hard to make an educated guess. If it's turned on, the first time you browse to a website, the name of that website would first get sent, in a separate request, to Apple's servers, which would return a thumbs up/thumbs down type of response. A problem on Apple's end would cause these requests to time out, making any website's first load terribly slow. And as the screenshot shows, clearly there ◊emph{is} a problem on Apple's end, because the Safe Browsing Service is said to be "unavailable". (It says it's only been unavailable for 1 day but I have reason to believe that number just resets every day.)

The fact that disabling the setting on Safari fixed the problem in Chrome too leads me to believe that this is in fact an OS-level setting, enforced on all outgoing HTTP requests, not just a Safari preference.

Anyway, if you are having this problem, see if disabling Safe Browsing Service solves it for you.