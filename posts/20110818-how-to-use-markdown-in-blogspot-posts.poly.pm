#lang pollen

◊(define-meta title "How to use Markdown in Blogspot posts")
◊(define-meta published "2011-08-18")
◊(define-meta tags "future-proofing,Markdown,Blogger")

If your blog is hosted on running Blogspot and you want to use ◊link["http://daringfireball.net/projects/markdown/basics"]{Markdown} for your posts, here’s how to do it and future-proof your writing in the process.

◊ol{
◊li{Write your posts in a text editing program ◊emph{on your computer} and save them ◊emph{on your computer}. (I use a ◊code{yyyy-mm-dd post title.txt} format)}
◊li{Then copy and paste the text into the ◊link["http://daringfireball.net/projects/markdown/dingus"]{online Markdown processor} and click ◊code{Convert} to generate HTML. (Set “Filter” to “both” for extra typographic goodness.)}
◊li{Finally, copy and paste the HTML into a new post in Blogspot.}
}

This has two advantages. First, it future-proofs your blog. No matter what happens, if Blogger ever gets shut down or becomes undesirable to use for any reason, in ten years you’ll still have a very useable copy of all your writing. Second, a text-editing program is much less likely to crash than your browser. This approach eliminates the risk of a browser crash causing you to lose large amounts of work.

◊h3[#:id "getting-blogspot-to-play-nice-with-your-markdown-generated-html"]{Getting Blogspot to play nice with your Markdown-generated HTML}

This is the area people seem to have trouble with, but it’s really quite simple.

◊ol{
    ◊li{In Blogspot, go to ◊code{Settings} tab, then the ◊code{Formatting} section. Set “Convert Line Breaks” to ◊code{No}.}
    ◊li{In your New Posts,
        ◊ul{
            ◊li{Make sure you are using the “Edit HTML” tab}
            ◊li{Under “Post Options” (at the bottom) make sure
                ◊ul{
                    ◊li{“Edit HTML Line Breaks” is set to ◊code{Use <br /> tags}}
                    ◊li{“Compose Settings” is set to ◊code{Interpret typed HTML}}
            }}
    }}
}

It’s that simple really. Now you can paste in your Markdown-generated HTML without getting extra linebreaks or other wierdnesses.
