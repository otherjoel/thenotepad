#lang punct notepad

---
title: Accessing BBC Coverage from the U.S.
date: 2012-07-29
---

You live in the U.S., you don’t have a cable subscription but you want to watch
the Olympics live? Here’s how to do it.

If you have a Mac, you can just [follow these excellent instructions by Brad
Gessler](http://bearsfightingbears.com/how-to-watch-the-olympics-live-from-the-united-states).

If you’re a Windows user, follow the instructions below, which I’ve adapted from
Brad’s post after a good bit of tinkering. I’m also including some details that
he left out.

1. Brad writes[^1]: “[Signup up for a Linode
   account](http://www.linode.com/?r=01cd5799b9a7520304c0bf19c17eff6b22f4f574).
   After you enter your credit card information and select a Linode server,
   you’ll be asked where you’d like to boot the server. **It’s important that
   you select London, UK** during this step so that you get an IP address from
   inside of London.” Note that the $20 (least-expensive) server option should
   be plenty for your needs.

2. When Linode asks which distribution you’d like to use, leave it at the
   default (Debian). You can also follow all the defaults for the other setup
   settings (disk space, swap, etc.). After configuration and setup are
   complete, follow the steps on the web interface to boot your server up.

3. [Download
   PuTTY](http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html) (just
   download the `putty.exe` file listed first). This is the program you will use
   to connect to your Linode server in London.

4. Configure PuTTY:

   - Main PuTTY screen: Under *Host Name* enter the IP address of your server,
     leave *Connection type* as SSH.
   - In the tree view at left, click *Connection* → *Data*. In the *auto-login
     username* field, enter the text `root`
   - In the tree view at left, click *Connection* → *SSH*. Make sure *enable
     compression* is **checked**.
   - In the tree view at left, click *Connection* → *SSH* → *Tunnels*. Under
     *Source port*, type `8080`. Select the *Dynamic* option and leave the other
     settings as default, then click *Add*.
   - Return to the main PuTTY screen by clicking *Session* in the tree view at
     left. Type a name under *Saved Sessions* and click *Save* (so you won’t
     have to go through this whole rigamarole every time).

5. Set up your proxy.

   - If you use IE or Chrome, configure this by going to Network and Sharing
     Center, and clicking Internet Options. Go to *Connections* tab, click *LAN
     Settings* button. Make sure *Use a proxy server for your LAN* is checked,
     and click the “Advanced” button. Enter `127.0.0.1` next to the “Socks”
     field, and enter `8080` for the port. **Leave the other fields blank** as
     shown (HTTP, Secure, and FTP).

     •figure["/posts/img/20120729proxysettings.png" #:width "160"]

   - If you use Firefox, go to “Connection Settings”, select “Manual proxy
     configuration” and follow the same procedure, entering `127.0.0.1` next to
     the “Socks host” field, and `8080` for the port, and ensure the other
     fields are blank.

Now every thing is set up.

**Whenever you want to watch Olympics on BBC:**

1. Make sure the proxy is turned on as in step 5 above—these settings will be
   saved from last time, all you have to do is turn it on again.
2. Open PuTTY, double-click on your saved session, and enter your password when
   prompted. You can minimize the terminal window once you’re sure you’ve logged
   in.
3. Browse to
   [http://www.bbc.co.uk/iplayer/tv/bbc_one_london/watchlive](http://www.bbc.co.uk/iplayer/tv/bbc_one_london/watchlive)
   to watch the Olympics live, **or** go to
   [http://www.bbc.co.uk/sport/olympics/2012/live-video](http://www.bbc.co.uk/sport/olympics/2012/live-video)
   to pick and watch specific events.

**When you’re done:** Tunneling all your web traffic through a London server
will make the rest of your browsing slower (and waste your Linode account’s
bandwidth) so you should close PuTTY and turn off the proxy server setting from
step 5 above when you’re not watching the Olympics.

*Thanks to [@mja](https://twitter.com/mja) for the original tip about Brad’s
post, and the one about where to go directly to watch specific events.*

## Other approaches

I did attempt to use a VPN service to do essentially the same thing, but it was
far too slow.

•updatebox["July 30 2012"]{
- If you use Chrome or Firefox, installing a “proxy switcher” extension for your
  browser will make between enabling and disabling the proxy setting much
  easier. Use [Proxy
  Switchy](https://chrome.google.com/webstore/detail/caehdcpeofiiigpdhbabniblemipncjj)
  for Chrome, or
  [QuickProxy](https://addons.mozilla.org/en-us/firefox/addon/quickproxy/) for
  Firefox.

- A couple more good articles about this issue have popped up:

  - A post by [Colin
    Nederkoorn](http://iamnotaprogrammer.com/Watch-olympics-streaming-free.html),
    in which he initially advocates the VPN method, but also mentions the
    [Unblock Us](http://unblock-us.com/) service. He’s not sure how it works
    (and neither am I) but he says it works great.
  - Dan Parsons advocates [setting up OpenVPN on your Linode
    server](https://gist.github.com/3195652), but I haven’t seen any reason why
    one should go to the additional step of installing OpenVPN when a simple
    SOCKS proxy seems to work fine.
}

[^1]: **Full disclosure:** I’ve copied the Linode signup link from [Brad’s
    original
    post](http://bearsfightingbears.com/how-to-watch-the-olympics-live-from-the-united-states),
    which means it still includes Brad’s referral code. I thought this was fair
    since he was the one who first posted the basic solution. In his post he
    expresses a wish to find some way to use his referral code to donate to the
    EFF; I’ll keep an eye out, and if he finds a way to do that I’ll update this
    post’s link as well.
