#lang pollen

◊(define-meta title "Cleaner titles for podcast posts in Tumblr")
◊(define-meta published "2011-09-13")
◊(define-meta topics "FeedBurner,iTunes,podcasting,Tumblr")

After reading my post ◊link["http://notely.blogspot.com/2011/07/tips-for-better-podcast-publishing.html"]{◊emph{How to publish a better podcast using Textpattern, Tumblr, or anything else}}, Lars Jannsen of ◊link["http://gamesandmacs.de/"]{gamesandmacs.de}, a new German website/podcast, wrote me a question:

◊blockquote{When I use an audio post to publish my latest podcast episode as .mp3 (since I want my listeners to get the Flash audio player on Tumblr) and put the link to the .mp3 file in the description of that audio post it also shows up in the iTunes description of the episode when I use FeedBurner to get my podcast on iTunes. In order to get ‘cleaner’ show notes, I’d like to exclude the link from the iTunes info field. Looks a bit weird if there’s stuff like ◊code{(‘Download MP3 file’)} in the show notes.}

I noticed the same thing on my tumblr-based podcast. This titling originates with how Tumblr serves up its feeds to FeedBurner. Tumblr has no descreet “Title” field for audio posts; instead Tumblr takes, from the ◊emph{description} field, the first however-many complete words there are before the 63-character mark (or thereabouts, including spaces and punctuation), slaps an ellipses (…) on the end, and uses that as the title. This title is the one that gets passed to Feedburner and the one that your listeners eventually see in iTunes. This is what causes ugly things like seeing “Download Mp3 file” as the episode’s title in iTunes.

Fortunately there’s a simple workaround. The MP3 download link doesn’t need to be at the very beginning of your description, it just needs to be the first ◊emph{link} in the description. So, just make sure it occurs after the first several words (or after the 63-character mark, to be precise).

In my posts, I’ve been using variations on the following template in my description:

◊blockquote{
◊strong{Episode 1234: Blue-Collar Reading Habits}, recorded on Aug 23, 2011, is now available for download etc etc

You can ◊code{download the mp3 audio [mp3 link]} (1:26:46, 59.8 MB) or ◊code{subscribe to the podcast [feedburner link]}.
}

This ensures that the episode’s actual title is the first thing in the title that ends up in iTunes. The “overflow,” if there is any, contains relevant info like the record date, etc.

In the above example, the title would show up in iTunes as “Episode 1234: Blue-Collar Reading Habits, recorded on Aug 23…”.

◊emph{Update}, Lars responded:

◊blockquote{
By the time I got your e-mail I also figured that iTunes takes the first 63 character to create the episode’s title and the rest flows into the description field. However, I’m still wondering if there’s a way to have a shorter title (without having to put lots of spaces in there…) and the body of the audio post (without the actual MP3 link as description in iTunes). I might be a bit perfectionist in this case, but I’d really like to find a solution to that without having to manually edit the XML feed every time I update my Tumblr blog with a new episode. Maybe there’s a way to “tweak” FeedBurner to take the “Title” field you can specify for an MP3 file you link on Tumblr.
}

I currently don’t know of any tweaks that are possible; neither Tumblr nor Feedburner seem to expose the kind of functionality that would allow for this tweaking. Any suggestions are welcome!

◊comment[#:author "שניצל"
         #:datetime "December 29, 2012"
         #:authorlink "https://www.blogger.com/profile/12107533202914200359"]{Hi. I read your guide on how to publish podcasts using tumblr, but it doesn’t work - for some reason it uses the flash player as the episode file. the .mp3 link is the first link after the 63 characters, but it still doesn’t work.

Can you please help me?

thanks,
Dan}
