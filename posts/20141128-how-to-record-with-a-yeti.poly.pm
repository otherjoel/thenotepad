#lang pollen

◊(define-meta title "")
◊(define-meta published "")


◊h2[#:id "title-how-to-record-with-a-yeti-and-audacity-and-eliminate-background-noise"]{Title: How to Record With a Yeti and Audacity (and eliminate background noise)}

◊h2[#:id "date-2014-11-28"]{Date: 2014-11-28}

◊h2[#:id "tags-yeti-podcasting-recording-audacity"]{Tags: yeti, podcasting, recording, audacity}

Text: Maybe you saw renowned podcaster Marco Arment’s tweet this morning:

◊div[]{




But the Yeti is fine for most podcasters too. Just keep in mind that it picks up a lot of background noise no matter what pattern you set.



— Marco Arment (<span class="cite" data-citation-ids="marcoarment">@marcoarment</span>) November 28, 2014



}

I use/used a ◊link["http://www.amazon.com/gp/product/B002VA464S/ref=as_li_tl?ie=UTF8&camp=1789&creative=390957&creativeASIN=B002VA464S&linkCode=as2&tag=thloya-20&linkId=EZCXBTW4VO3X4YE2"]{Yeti} on ◊link["http://howellcreekradio.com"]{my podcast} for a few years now. Many others do too (including ◊link["https://twitter.com/jsnell/status/538351510296358912"]{Jason Snell} for what that’s worth) — it’s long been known as the sweet spot of bang for the buck for intermediate-level podcasting. Marco&#39;s probably right that it&#39;s not ideal in some ways, but let me tell you how I eliminate background noise.

In my experience, you can get a very clean signal with very little background noise from just about any mic if you use the Right Technique. That technique is:

◊ol{
◊li{Use a pop filter}
◊li{Turn gain on the mic ◊emph{way} down}
◊li{Speak super close to the mic}
}

(image: mymicsetup.jpg width: 512 height: 420 caption: My super inexpensive, terrible mic setup.)

Yes, the pop filter (the $10 ◊link["http://www.amazon.com/gp/product/B0002CZW0Y/ref=as_li_tl?ie=UTF8&camp=1789&creative=390957&creativeASIN=B0002CZW0Y&linkCode=as2&tag=thloya-20&linkId=UFU254MECJWY6UTV"]{Nady MPF-6}) is simply held in place with a heavy object. I own no booms or shock-mounts. Not to say I wouldn&#39;t love to have them, but I&#39;m just not about to buy them for now (see further notes below).

Using the above placement, I set the gain knob on my Yeti at 40-45%, and set the pattern to Cardioid (heart-shaped). Then I set Audacity&#39;s input level for the mic to 50%. I speak at a normal volume ◊strong{with my mouth almost touching the pop filter}.

Additionally, I run Chris&#39;s Dynamic Compressor plugin on voice tracks after all other editing has been done:

(image: audacity-compress.png width: 238 height: 110)

◊ul{
◊li{Compress Ratio: ◊code{0.7}}
◊li{Compression Hardness: ◊code{0.7}}
◊li{Floor: ◊code{-14.0}}
◊li{Noise gate falloff: ◊code{6.0}}
◊li{Maximum amplitude: ◊code{0.95}}
}

I may normalize the track to -2db before or after running the compressor, or both.

You can hear the results on any of the later episodes of ◊link["http://howellcreekradio.com"]{my podcast} (which I&#39;ve currently not been keeping up with). Which brings me to standard disclaimers: my podcasting is of a different style than most podcasts. My episodes are relatively short (5-15 min), and almost everything I say is pre-written and edited, and I&#39;m the only voice. All of which makes my primitive Yeti/pop filter setup that much more bearable. If I were co-hosting with anyone or doing longer episodes I can see where it would get kind of unworkable, but for what I do I don’t mind it at all.
