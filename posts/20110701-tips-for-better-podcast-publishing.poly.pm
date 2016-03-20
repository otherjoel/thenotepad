#lang pollen

◊(define-meta title "How to publish a better podcast using Tumblr, Textpattern, or anything else")
◊(define-meta published "2011-07-01")
◊(define-meta topics "Feedburner,iTunes,Textpattern,podcasting,Tumblr")

This isn’t about ◊link["http://hivelogic.com/articles/podcasting-equipment-software-guide-2011/"]{equipment} or ◊link["http://ftrain.com/LearningToSpeak.html"]{recording technique}, but just the cranky details of ◊emph{publishing} a podcast that I have found by trial and error. This article assumes you have some basic computer/web/HTML know-how.

I publish a couple of podcasts: ◊link["http://jdueck.net/radio"]{Howell Creek Radio} uses Textpattern, and ◊link["http://anythingandeverythinggood.tumblr.com"]{Anything Good} uses Tumblr. So in some of the steps I have given some examples that are specific to those CMSs, in order to help you along; but the important thing is that these steps can be easily adapted to any CMS such as Blogger, WordPress, etc.

◊section{Create a separate tag or category for your podcast posts on your blog.}

This is optional; I recommend it because it allows the website for your podcast to be more flexible. For example, if you use Tumblr, you can create a ◊code{podcast} tag, and then continue posting a mix of videos, photos, quotes, etc. alongside your podcast episodes. This way your podcast subscribers will get a clean feed containing only audio downloads, while your website readers will be able to see all your other posts as well.

Even if your website is pretty much exclusively a vehicle for your podcast, you may want to publish other kinds of things posts now and then for administrative purposes, and this will give you the freedom to keep those posts separate.

◊section{Make sure you have cover art where you need it}

You need to create and use cover art in ◊strong{two places}: first you create cover art for your podcast as a whole, and then you also embed cover art in every individual podcast recording. ◊strong{If you use nothing else from this article, please:} add cover art to your mp3 files. Without it, your episodes show up with blank covers in iPods and most mp3 players! Your podcast episodes will look dorky without it! It’s not enough to add cover art to your itunes feed, you need to embed the cover art in every finished mp3 file. This is easy to do, yet many beginners forget to do it.

◊strong{Set up your podcast feed with cover art:} Create a 600×600px cover art image for your podcast and upload it to your site, or somewhere publicly accessible. (In some places Apple says 300px is OK but their ◊link["http://www.apple.com/itunes/whatson/podcasts/specs.html"]{technical spec} says 600.) I recommend using JPEG&lt;, not PNG — the latter is allowed but will look blocky when viewed at reduced sizes in iTunes.

◊ol{
◊item{Get a ◊link["http://feedburner.com"]{FeedBurner} account and set up your podcast feed:

◊ol{
◊item{Tumblr: Set the “original feed” on FeedBurner to the RSS feed for the specific tag you created for your podcast. To get this feed, add ◊code{tagged/YOURTAG/rss} to your tumblr’s address. (Example: ◊code{http://mytumblr.tumblr.comn/tagged/podcast/rss})}
◊item{Textpattern: Set the “original feed” on FeedBurner to Textpattern’s atom feed for that category (e.g., ◊code{http://foopaux.com/atom/?category=podcast}).}
◊item{Blogger: Set the “original feed” on FeedBurner to ◊code{http://www.YOURBLOG.blogspot.com/feeds/posts/default/-/PODCASTTAG} (per ◊link["http://www.google.com/support/blogger/bin/answer.py?hl=en&answer=97933"]{these instructions from Google}).}
}}
◊item{Under FeedBurner’s ◊code{Optimize} tab, add the ◊code{SmartCast} service to make your feed podcast-friendly. Set the cover art to the URL of your covert art image and add as much description, keywords and categories as you can muster.}
}

◊strong{Embed cover art for individual episodes:} You’ll find that iTunes does ◊emph{not} automatically use your cover art for downloaded episodes when they are playing in your iPod. The cover art you created in the steps above is only used in the iTunes ◊emph{store listing} for your podcast (if you get one). In order for your cover art to actually display in people’s iPods when your episodes are playing, you need to embed the cover art into each episode’s MP3 file. Luckily, this is easy to do using only the iTunes (the simplest way I know how):

◊ol{
◊item{Prior to uploading, open add the episode’s MP3 to your iTunes library.}
◊item{Right-click the episode in iTunes, click Get Info.}
◊item{Go to the Artwork tab, manually add your cover art to the file, and click OK. (Tip: in Windows you can actually copy/paste the artwork JPG file from Explorer directly into this tab.)}
◊item{The cover art is now embedded, you can now upload your MP3 file.}
}

◊section{Create a “subscribe” link on your website.}

Lots of folks use iTunes, so it’s nice to provide an iTunes instant-subscribe link for them and a standard RSS link for everyone else. To create an iTunes link, just prefix the URL of your FeedBurner feed with ◊code{itpc://} instead of ◊code{http://}. So, for example, you could place this prominently on your website:

◊blockquote{
◊code{Subscribe in <a href="itpc://feeds.feedburner.com/MyPodcast">iTunes</a> or <a href="http://feeds.feedburner.com/MyPodcast">RSS</a>}
}

◊section{Record and upload your podcast episodes}

I use ◊link["http://audacity.sourceforge.net/"]{Audacity} to record, then upload the MP3 to my website using FTP. If you don’t have any hosted space, you can use a free ◊link["http://dropbox.com"]{Dropbox} account and host your files in a public folder. The bonus with this approach is that uploading is automatic.

◊section{Format your podcast posts properly}

A properly-formatted post ensures that your subscribers will get their episodes automatically with no hiccups.

◊ol{
◊item{Don’t forget to set the post’s category (or tag) to the podcast category you created earlier.}
◊item{Each podcast post should contain a manual, direct download link to the MP3 file for that episode. This is non-optional, and it should be the first link in the post. This will allow FeedBurner to correctly detect and include your audio in the podcast feed. For the text of the link, I recommend something like “Download MP3 audio (14.76 mb, 19:32)”
(◊strong{Update, Sep 13, 2011:} this link doesn’t have to be at the very front of your post, it just has to be the first ◊emph{link} in the post. Also, when using Tumblr, to ensure cleaner descriptions see ◊link["http://notely.blogspot.com/2011/09/cleaner-titles-for-podcast-posts-in.html"]{this follow-up post}.)}
◊item{One nice thing to do if you will be syndicating onto another service, such as Facebook notes etc., is to create a special CSS class called ◊code{for-syndicate} and set it to ◊code{display: none}. Then add a little “helper” boilerplate on the bottom of each post, in a paragraph set to that class:

◊blockquote{
◊code{<p class="for-syndicate">This is a podcast post: <a href="http://site.com/episode.mp3">click here</a> to download the MP3 audio, or visit <a href="http://site.com/podcast">site.com</a> to listen online and subscribe in iTunes.</p>}
}

The ◊code{for-syndicate} class will render the paragraph invisible on your website, but it will be visible when imported into Facebook or when the feed is viewed in a newsreader, since these other sites do not import your CSS styles. (If you like, this quasi-hidden paragraph can also serve as the required MP3 link.)}
}

◊section{Letting people listen from your website}

People will listen to your podcast in one of two ways: by subscribing in iTunes or some similar program (which we’ve already covered) or by going to your web page and listening on their computer. Although they can click to listen to the MP3 file using the link you provided, it’s nice to embed some kind of player that will stream the audio and let them listen right there.

There are lots of ways to do this:

◊ol{
◊item{In Textpattern, install the ◊link["http://textpattern.org/plugins/603/jnm_audio"]{jnm:audio} textpattern plugin and include a ◊code{<txp:jnm_audio>} tag in each podcast post.}
◊item{In Tumblr, create your podcast post as an “audio post” and Tumblr will automatically embed an audio player. (Don’t forget to also include the download link in the text portion of the post though.)}
◊item{Other platforms (WordPress, etc): Let me know how you do it in the comments!}
}

These methods use Flash programs for the audio players, which don’t run on iPhone or iPad browsers. I’ve been tinkering with ways to use HTML5 audio players when the browser supports them, but HTML5 audio support is still flaky for the time being. Check back again in a year or so and maybe I’ll have something for you.

◊section{Get listed in the iTunes Store}

After you’ve gotten your production groove down and can demonstrate that your episodes come out at least somewhat regularly, it’s worth trying to get your podcast added into the iTunes store. Read Apple’s ◊link["http://www.apple.com/itunes/whatson/podcasts/creatorfaq.html"]{FAQ for Podcast Makers}.

◊comment[#:author "Steve Vorass"
         #:datetime "February 11, 2013"
         #:authorlink "https://www.blogger.com/profile/11355795396029699047"]{Very good info. I have a question though - how do you get tags to show up in a Tumblr Feed - such as This here, etc…? thanks!}
