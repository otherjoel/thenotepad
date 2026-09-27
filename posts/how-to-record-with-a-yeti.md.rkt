#lang punct notepad

---
title: How to Record With a Yeti and Audacity (and eliminate background noise)
date: 2014-11-28
topics: podcasting,audio
---

Maybe you saw renowned podcaster Marco Arment’s tweet this morning:

•tweet[#:name "Marco Arment" #:handle "marcoarment" #:url "https://twitter.com/marcoarment/status/538351950866415617" #:date "Nov 28 2014 9:21 AM"]{
But the Yeti is fine for most podcasters too. Just keep in mind that it picks up
a lot of background noise no matter what pattern you set.
}

I use/used a [Yeti](https://www.amazon.com/dp/B002VA464S/?tag=thloya-20) on [my
podcast](http://howellcreekradio.com) for a few years now. Many others do too
(including [Jason Snell](https://twitter.com/jsnell/status/538351510296358912)
for what that’s worth)—it’s long been known as the sweet spot of
bang-for-the-buck for intermediate-level podcasting. Marco’s probably right that
it’s not ideal in some ways, but let me tell you how I eliminate background
noise.

In my experience, you can get a very clean signal with very little background
noise from just about any mic if you use the Right Technique. That technique is:

1. Use a pop filter
2. Turn gain on the mic *way* down
3. Speak super close to the mic

•figure["/posts/img/mymicsetup.jpg" #:width "512"]{My super inexpensive,
terrible mic setup.}

Yes, the pop filter (the $10 [Nady
MPF-6](https://www.amazon.com/dp/B0002CZW0Y/?tag=thloya-20)) is simply held in
place with a heavy object. I own no booms or shock-mounts. Not to say I wouldn’t
love to have them, but I’m just not about to buy them for now (see further notes
below).

Using the above placement, I set the gain knob on my Yeti at 40-45%, and set the
pattern to Cardioid (heart-shaped). Then I set Audacity’s input level for the
mic to 50%. I speak at a normal volume **with my mouth almost touching the pop
filter**.

Additionally, I run Chris’s Dynamic Compressor plugin on voice tracks after all
other editing has been done:

•figure["/posts/img/audacity-compress.png" #:width "476"]{My settings for
Chris’s Dynamic Compressor}

- Compress Ratio: `0.7`
- Compression Hardness: `0.7`
- Floor: `-14.0`
- Noise gate falloff: `6.0`
- Maximum amplitude: `0.95`

I may normalize the track to -2db before or after running the compressor, or
both.

You can hear the results on any of the later episodes of [my
podcast](http://howellcreekradio.com) (which I’ve currently not been keeping up
with). Which brings me to standard disclaimers: my podcasting is of a different
style than most podcasts. My episodes are relatively short (5-15 min), and
almost everything I say is pre-written and edited, and I’m the only voice. All
of which makes my primitive Yeti/pop filter setup that much more bearable. If I
were co-hosting with anyone or doing longer episodes I can see where it would
get kind of unworkable, but for what I do I don’t mind it at all.
