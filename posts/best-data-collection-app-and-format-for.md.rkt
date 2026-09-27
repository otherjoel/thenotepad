#lang punct notepad

---
title: The Best Data Collection App (And Format) for iPhone
date: 2011-11-08
topics: quantified self,data collection
---

I’ve long been intrigued by [Nick Felton’s Annual Reports](http://feltron.com).
Felton has become the poster child for a new kind of a
[subculture](http://quantifiedself.com/) growing up around this idea of
“personal metrics.” Measuring and reporting esoteric and insane amounts of data
about your personal habits can be a great way to Meet People And Make Friends.

Creating these reports will involve coming up with your own solutions to an
interesting set of problems: how to capture all that data, how to store it in an
analytics-friendly format, how to actually analyze it, and how to design the
information displays. In this post I’m dealing mainly with the first two parts
of that list: capturing data and storing it, with some hints about analytics
afterwards.

In data collection, your smartphone is your friend. You want to make sure
collecting data is easy and frictionless, so that you get it all. Your phone is
always with you, so you can jot things down and not worry about having to get it
later. And as much as I love pen and paper, if you go that route you’re going to
end up collecting the same info down twice when it comes time to get it into
your computer for analytics.

There are a lot of apps out there for collecting and reporting various kinds of
data—running times/length, weight loss/gain, sex, sleep and eating habits—and
these can be great if you’re only interested in tracking one or two aspects of
your life. But as soon as you begin to raise your sights a little and think
about comprehensive Felton-scale data collection, you realize what a pain it’s
going to be to have a herd of seventeen apps to manage. Another problem with
most of these apps is that they don’t provide any access to the actual data.

## Daytum

For awhile, Felton was working on a project called [Daytum](http://daytum.com)
that would help people create their personal reports similar to his. Daytum has
always had a lot of promise, but there are a few major problems with it that
need to change before it can be really useful:

1. Felton was hired by Facebook recently, and doesn’t seem to be actively
   maintaining the service anymore
2. The web interface is clumsy for entering anything more than simple quantities
3. The [iPhone
   app](http://itunes.apple.com/us/app/daytum/id352646537?mt=8)—which would
   ordinarily be the ideal channel for collecting data—is buggy, infrequently
   updated, and (worst of all) has been known to randomly erase data

## The Format is Text

I found what I was looking for in Ben Lipkowitz’s [lifelog
project](http://fennetic.net/sleep/). He developed a simple text format that
allows you to quickly capture personal events and data as they happen. A
self-explanatory sample is below:

```
date 2011 01 08
0000 0851 sleep
0851 0902 domestics
0902 0904 walking langton-labs
0904 0906 setup kitty
0906 0907 science guinea-pig
0908 0920 food cookie-cereal 2c soy-milk 0.6c peanut-butter-ice-cream 1c
0920 1000 net thermal-clothing, food donut-hole 2pc oatmeal-cookie-dough 3pc
1000 1052 net thermal-clothing
1052 1100 riding kaplans
1100 1145 shoppin, act tour-kaplans
1145 1155 riding langton-labs
1155 1200 chat rachel-?
1200 1210 riding rei
1210 1445 shoppin, domestics test-clothes
1445 1451 stupid rei-membership-form
```

The syntax is pretty self-explanatory. Each interval is given an activity (e.g.,
`net` or `drive`) followed by any number of tags that add detail (e.g.
`drive commute-home`). Multiple activities and their tags are separated by
commas.

The advantages of capturing data in this way are obvious:

- Both the *time length* and *frequency* of activities is captured
- It’s easy to add custom data to different kinds of activities (such as the
  quantities given in the `food` activity above)
- You can easily enter and read the data without any special software
- The data will still be easy to read ten or fifty years from now

**How to actually use the data:** Creating any visual displays of all this data
is going to involve brushing off your script-writing chops. The good news is if
you have any programming ability whatsoever, you should be able to cobble
something together quite easily for whatever you want to do. Check out the
[lifelog project](http://fennetic.net/sleep/) for examples of scripts for
parsing and displaying the data. Ben currently produces graphs showing time
intervals colored by activity, but you could just as easily build a script in
your favourite language to build reports for things like average commute times,
top five conversation topics, or total times you had to look for things and how
many of those times you found them, etc. If you have your script output the
results in a [`CSV`
format](http://en.wikipedia.org/wiki/Comma-separated_values), you can open those
reports directly in Excel and create charts from there.

This format doesn’t work well for capturing broader categories of events that
span over multiple time intervals. For example, there’s no clear way to record
that everything you did this afternoon was part of Brother Mike’s Wedding, for
example. There are a couple of ways to extend this, such as adding `mark`,
`start` or `end` keywords to mark the beginning and ending of these types of
things, or simply recording that info elsewhere.

I don’t recommend trying to record your moment-to-moment moods for any reason
whatsoever. That way lies self-referential madness.

## The App is Nebulous Notes

•figure["/posts/img/photonov082c111447am.png" #:width "134"]

•figure["/posts/img/photonov082c111548am.png" #:width "134"]

[Nebulous
Notes](http://itunes.apple.com/us/app/nebulous-notes-for-dropbox/id375006422?mt=8#)
has a couple of great features that make it great for this kind of data
collection:

- **Shortcut keys:** You can set up shortcut keys to quickly insert date and
  timestamps in right format, as well as skip forward and backwards by word or
  character (see screenshots above)
- **Dropbox support:** Store your text file on your Dropbox account and it will
  be auto-saved to the cloud every time you edit it, and you can easily pull it
  into your laptop for analytics.

I recently switched to the iPhone, so if you have an Android or Blackberry
you’ll need to find your own favorite app for that platform. (Personally I can’t
imagine attempting anything like this on my laggy old Blackberry.) Let me know
in the comments if you find anything!
