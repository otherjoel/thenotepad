#lang pollen

◊(define-meta title "Accessing BBC Coverage from the U.S.")
◊(define-meta published "2012-07-29")
◊(define-meta tags "ssh,putty,linode")

You live in the U.S., you don’t have a cable subscription but you want to watch the Olympics live? Here’s how to do it.

If you have a Mac, you can just ◊link["http://bearsfightingbears.com/how-to-watch-the-olympics-live-from-the-united-states"]{follow these excellent instructions by Brad Gessler}.

If you’re a Windows user, follow the instructions below, which I’ve adapted from Brad’s post after a good bit of tinkering. I’m also including some details that he left out.

◊ol{
◊item{Brad writes◊numbered-note{◊strong{Full disclosure:} I’ve copied the Linode signup link from ◊link["http://bearsfightingbears.com/how-to-watch-the-olympics-live-from-the-united-states"]{Brad’s original post}, which means it still includes Brad’s referral code. I thought this was fair since he was the one who first posted the basic solution. In his post he expresses a wish to find some way to use his referral code to donate to the EFF; I’ll keep an eye out, and if he finds a way to do that I’ll update this post’s link as well.}: “◊link["http://www.linode.com/?r=01cd5799b9a7520304c0bf19c17eff6b22f4f574"]{Signup up for a Linode account}. After you enter your credit card information and select a Linode server, you’ll be asked where you’d like to boot the server. ◊strong{It’s important that you select London, UK} during this step so that you get an IP address from inside of London.” Note that the $20 (least-expensive) server option should be plenty for your needs.}
◊item{When Linode asks which distribution you’d like to use, leave it at the default (Debian). You can also follow all the defaults for the other setup settings (disk space, swap, etc.). After configuration and setup are complete, follow the steps on the web interface to boot your server up.}
◊item{◊link["http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html"]{Download PuTTY} (just download the ◊code{putty.exe} file listed first). This is the program you will use to connect to your Linode server in London.}
◊item{Configure PuTTY:

◊ul{
◊item{Main PuTTY screen: Under ◊noun{Host Name} enter the IP address of your server, leave ◊noun{Connection type} as SSH.}
◊item{In the tree view at left, click ◊noun{Connection} → ◊noun{Data}. In the ◊noun{auto-login username} field, enter the text ◊code{root}}
◊item{In the tree view at left, click ◊noun{Connection} → ◊noun{SSH}. Make sure ◊noun{enable compression} is ◊strong{checked}.}
◊item{In the tree view at left, click ◊noun{Connection} → ◊noun{SSH} → ◊noun{Tunnels}. Under ◊noun{Source port}, type ◊code{8080}. Select the ◊noun{Dynamic} option and leave the other settings as default, then click ◊noun{Add}.}
◊item{Return to the main PuTTY screen by clicking ◊noun{Session} in the tree view at left. Type a name under ◊noun{Saved Sessions} and click ◊noun{Save} (so you won’t have to go through this whole rigamarole every time).}
}}
◊item{Set up your proxy.

◊ul{
◊item{If you use IE or Chrome, configure this by going to Network and Sharing Center, and clicking Internet Options. Go to ◊noun{Connections} tab, click ◊noun{LAN Settings} button. Make sure ◊noun{Use a proxy server for your LAN} is checked, and click the “Advanced” button. Enter ◊code{127.0.0.1} next to the “Socks” field, and enter ◊code{8080} for the port. ◊strong{Leave the other fields blank} as shown (HTTP, Secure, and FTP).
◊figure["/img/20120729proxysettings.png"]{ }}
◊item{If you use Firefox, go to “Connection Settings”, select “Manual proxy configuration” and follow the same procedure, entering ◊code{127.0.0.1} next to the “Socks host” field, and ◊code{8080} for the port, and ensure the other fields are blank.}
}}
}

Now every thing is set up.

◊strong{Whenever you want to watch Olympics on BBC:}

◊ol{
◊item{Make sure the proxy is turned on as in step 5 above — these settings will be saved from last time, all you have to do is turn it on again.}
◊item{Open PuTTY, double-click on your saved session, and enter your password when prompted. You can minimize the terminal window once you’re sure you’ve logged in.}
◊item{Browse to ◊link["http://www.bbc.co.uk/iplayer/tv/bbc_one_london/watchlive"]{http://www.bbc.co.uk/iplayer/tv/bbc_one_london/watchlive} to watch the Olympics live, ◊strong{or} go to ◊link["http://www.bbc.co.uk/sport/olympics/2012/live-video"]{http://www.bbc.co.uk/sport/olympics/2012/live-video} to pick and watch specific events.}
}

◊strong{When you’re done:} Tunneling all your web traffic through a London server will make the rest of your browsing slower (and waste your Linode account’s bandwidth) so you should close PuTTY and turn off the proxy server setting from step 5 above when you’re not watching the Olympics.

◊emph{Thanks to ◊link["https://twitter.com/mja"]{@mja} for the original tip about Brad’s post, and the one about where to go directly to watch specific events.}

◊section{Other approaches}

I did attempt to use a VPN service to do essentially the same thing, but it was far too slow.

◊strong{Update, July 30 2012:}

◊ul{
◊item{If you use Chrome or Firefox, installing a “proxy switcher” extension for your browser will make between enabling and disabling the proxy setting much easier. Use ◊link["https://chrome.google.com/webstore/detail/caehdcpeofiiigpdhbabniblemipncjj"]{Proxy Switchy} for Chrome, or ◊link["https://addons.mozilla.org/en-us/firefox/addon/quickproxy/"]{QuickProxy} for Firefox.}
◊item{A couple more good articles about this issue have popped up:

◊ul{
◊item{A post by ◊link["http://iamnotaprogrammer.com/Watch-olympics-streaming-free.html"]{Colin Nederkoorn}, in which he initially advocates the VPN method, but also mentions the ◊link["http://unblock-us.com/"]{Unblock Us} service. He’s not sure how it works (and neither am I) but he says it works great.}
◊item{Dan Parsons advocates ◊link["https://gist.github.com/3195652"]{setting up OpenVPN on your Linode server}, but I haven’t seen any reason why one should go to the additional step of installing OpenVPN when a simple SOCKS proxy seems to work fine.}
}}
}
