#lang pollen

◊(define-meta title "Testing network switches")
◊(define-meta published "2016-08-22")
◊(define-meta topics "networking,switches")

A couple of weeks ago, one of the two Netgear GS748T network switches in our main office failed. The lights were still blinking, but nothing connected to it was able to talk to anything else. We were able to plug almost everyone in to the other switch, the rest we put on a temporary 8-port switch until we could get a replacement.

We ordered two more of these switches off eBay (a replacement plus a spare), and those arrived today. After testing both of them, I was able to swap out the bad one and figure out exactly what had happened to it.

◊section[#:id "how-i-test-a-switch"]{How I test a switch}

This is pretty basic and generic, but maybe someone will find it useful.

◊ol{
◊item{Grab the reference manual and hard-reset the switch to factory defaults.}
◊item{Connect directly to the switch with an ethernet cable. Does the port light up?}
◊item{Manually set your computer’s IP address to correspond to the switch’s defaults. In this case, the Netgear’s default IP is ◊code{192.168.0.239} with a subnet mask of ◊code{255.255.255.0}, so I set my computer to ◊code{192.168.0.20} and the same subnet.}
◊item{Try to ping the switch at its default address. Does it respond? If not, plug in another computer and set its IP address manually as well. Can you ping it? Try it across several ports.}
◊item{From your browser, try to log in to the switch’s web interface. In this case I browsed to ◊code{http://192.168.0.239} and was greeted with the login screen.}
◊item{Try transferring data between two computers connected through the switch. In my case I was testing with two Windows machines, so I used ◊link["http://www.netchain.com/netcps"]{NetCPS} to benchmark these transfers. Again, use several different ports. If the ports are visibly divided between “banks” of 4 or 8 ports, test each bank. (Testing each individual port is overkill in most cases.)}
◊item{Managed switches◊margin-note{The GS748T doesn't have a separate console port or a CLI, so this point wasn't applicable in this particular case. On another occasion though, when I had an HP ProCurve switch that was acting up, connecting via the console port revealed a barrage of error messages and an endless cycle of rebooting. Having a saved copy of this output was very helpful when I was on the phone with the manufacturer demanding a warranty replacement.}  usually have their own OS with a command-line interface that you can open by connecting through a separate “console” port (either RJ-45 or serial DB-9). Try to log in through this interface and poke around. Refer to the switch’s manual for details.}
}

◊section[#:id "so-what-happened-here"]{So what happened here?}

In the case of our failing Netgear GS748T, after I pulled it out I found it was still “working”: I could connect to its web interface, and even send data between a couple of computers connected via the switch, but several things indicated something was wrong.

First of all, pinging the switch itself while plugged into it directly was yielding response times of 7–14ms. This may seem pretty fast, but an acceptable response time is more like 1ms, ◊emph{max}.

Second, by looking at the error counters in the switch’s web interface, I noticed Rx errors piling up after only a few minutes:

◊figure["rx-errors.png"]{Rx errors piling up after only a few minutes of traffic}

An acceptable number of errors is ◊emph{zero}, assuming there is no problem with the cables themselves.

All of this points towards some degradation that destroys performance when traffic increases past a certain point.

Finally, just for the heck of it, we opened up the switch’s casing and took a look at its innards.

◊figure["switch-caps.jpg"]{The inside of the Netgear GS748T}

The capacitors with flat tops (such as the group of four on the left) are in good shape, but the ones with bulging, rounded tops (there are three in this pic) have definitely gone bad. Hardware companies often try to save money by getting cheap, low-quality capacitors, and when they fail, they start to bulge like this.

The failed capacitors definitely seem to explain our problem. Personally, I would not have bothered unscrewing the casing on the failed switch◊margin-note{Nor would I have ordered the same make/model as a replacement. The “new” switches are a later revision than the originals, though (GS748Tv3H1 vs GS748Tv1H3) so hopefully that represents some improvement.}, but it was a good way to confirm that we were in fact dealing with a hardware failure. You might also want to do this if you ever order used network gear; if any of the capacitors are bulging like this you know to return the item immediately.
