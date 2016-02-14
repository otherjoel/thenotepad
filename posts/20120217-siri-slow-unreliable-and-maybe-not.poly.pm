#lang pollen

◊(define-meta title "Siri: Slow, unreliable, and maybe not a priority at Apple")
◊(define-meta published "2012-02-17")
◊(define-meta topics "Siri,Apple,iPhone")

◊link["http://www.apple.com/iphone/features/siri.html"]{Siri} had a lot of promise when it was released as a feature of the new iPhone 4S. It wowed everyone at the ◊link["http://www.apple.com/apple-events/october-2011/"]{WWDC keynote in October 2011}.

I’ve had an iPhone 4S since November 2011, and I would describe Siri as gimmicky, flaky, and useful only within a narrow subset of the things it was promised for.

The biggest killers of my enthusiasm for using Siri are ◊emph{laggy interaction} and ◊emph{flaky availability}. Interaction misses plus plain old network lag combine to make Siri slow, slow, slow.

◊strong{There are five ◊emph{possible} outcomes to each Siri interaction:}

◊ol{
◊item{Siri misunderstands what you said due to you speaking incorrectly, or}
◊item{Siri misunderstands what you said because of a voice recognition error, or}
◊item{Siri understands what you said but misunderstands what you ◊emph{meant}, or}
◊item{Siri is unable to connect to its servers, or}
◊item{Siri connects and responds correctly}
}

Four out of these five outcomes result in a failed interaction. While you can get better at speaking correctly, there are few to no workarounds for the other three error conditions.

Since Siri goes out over the internet in order to analyze each spoken interaction, it can often take a good 5--10 seconds to offer a response to what you’ve just said◊numbered-note{Connection failures are especially common when you are on the outer edge of a known wifi network, such as when in the driveway or parking lot, or walking to/from your house. The iPhone seems to think it is connected via wifi for some time after you have left range, causing Siri to attempt using a nearly non-existent connection.}. In addition, at least every other day Siri’s servers seem to go dark for a period of time, resulting in “really sorry, but I can’t take any requests right now, please try again in a little while.”

Add this delay, and a random but sizeable chance of connection failure, in between each incorrect response, and you soon get used to doing most things the old way rather than gamble on an unreliable Siri.

Someone’s bound to respond that Siri is still officially beta software. I am aware of that, and don’t expect it to be perfect◊numbered-note{Although I do expect beta software to be at least feature-complete, which I don’t believe Siri is.}.

But it’s also worth noting that Apple, like most software companies, has introduced many apps and features that they then failed to improve upon or even abandoned◊numbered-note{See the Calendar, Weather, Music and Stock apps, iTunes Genius, Ping, and of course Mobile Me.}. My gut feeling is that Siri is in danger of ending up as the next Mobile Me, especially given that it has received almost no improvement or attention since its release so far.
