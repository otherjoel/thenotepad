#lang pollen

◊(define-meta title "Delicious Linkrolls Not Working")
◊(define-meta published "2010-09-02")
◊(define-meta tags "linkrolls,delicious,javascript,bookmarks")

I wanted to create a linkroll on my website, an embedded list of my ◊link["http://delicious.com"]{delicious.com} links. Problem was, the ◊link["http://www.delicious.com/help/linkrolls"]{linkroll code they generated} resulted in…nothing. No links appeared on my website using their code.

I tried manually opening the ◊span[#:class "caps"]{URL} in the script tag, which refers to a ◊code{feeds.www.delicious.com} address, and the browser told me it couldn’t find the site!

On a whim I tried removing the “www” from the address, and voila. The script worked. So when you add the code to your site, change ◊code{feeds.www.delicious.com} to ◊code{feeds.delicious.com}.

I have sent a support request to Delicious about this and will update the post when I hear back from them.

◊strong{Update, June 2011:} I don’t know if they’ve fixed it yet, but after ◊link["http://techcrunch.com/2010/12/16/is-yahoo-shutting-down-del-icio-us/"]{recent developments} threw the future of delicious into doubt, many of us have switched to ◊link["http://pinboard.in"]{Pinboard}. Their linkroll code also happens to work perfectly, you can find the javascrip widget on their ◊link["http://pinboard.in/resources/"]{resources page}.
