#lang punct notepad

---
title: Delicious Linkrolls Not Working
date: 2010-09-02
topics: Delicious
---

I wanted to create a linkroll on my website, an embedded list of my
[delicious.com](http://delicious.com) links. Problem was, the [linkroll code
they generated](http://www.delicious.com/help/linkrolls) resulted in…nothing. No
links appeared on my website using their code.

I tried manually opening the URL in the script tag, which refers to a
`feeds.www.delicious.com` address, and the browser told me it couldn’t find the
site!

On a whim I tried removing the “www” from the address, and voila. The script
worked. So when you add the code to your site, change `feeds.www.delicious.com`
to `feeds.delicious.com`.

I have sent a support request to Delicious about this and will update the post
when I hear back from them.

•updatebox["June 2011"]{
I don’t know if they’ve fixed it yet, but after [recent
developments](http://techcrunch.com/2010/12/16/is-yahoo-shutting-down-del-icio-us/)
threw the future of delicious into doubt, many of us have switched to
[Pinboard](http://pinboard.in). Their linkroll code also happens to work
perfectly, you can find the javascript widget on their [resources
page](http://pinboard.in/resources/).
}
