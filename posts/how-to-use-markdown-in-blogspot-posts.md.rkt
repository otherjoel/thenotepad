#lang punct notepad

---
title: How to use Markdown in Blogspot posts
date: 2011-08-18
topics: future-proofing,Markdown,Blogger
---

If your blog is hosted on running Blogspot and you want to use
[Markdown](http://daringfireball.net/projects/markdown/basics) for your posts,
here’s how to do it and future-proof your writing in the process.

1. Write your posts in a text editing program *on your computer* and save them
   *on your computer*. (I use a `yyyy-mm-dd post title.txt` format)
2. Then copy and paste the text into the [online Markdown
   processor](http://daringfireball.net/projects/markdown/dingus) and click
   `Convert` to generate HTML. (Set “Filter” to “both” for extra typographic
   goodness.)
3. Finally, copy and paste the HTML into a new post in Blogspot.

This has two advantages. First, it future-proofs your blog. No matter what
happens, if Blogger ever gets shut down or becomes undesirable to use for any
reason, in ten years you’ll still have a very useable copy of all your writing.
Second, a text-editing program is much less likely to crash than your browser.
This approach eliminates the risk of a browser crash causing you to lose large
amounts of work.

### Getting Blogspot to play nice with your Markdown-generated HTML

This is the area people seem to have trouble with, but it’s really quite simple.

1. In Blogspot, go to `Settings` tab, then the `Formatting` section. Set
   “Convert Line Breaks” to `No`.

2. In your New Posts,

   - Make sure you are using the “Edit HTML” tab

   - Under “Post Options” (at the bottom) make sure

     - “Edit HTML Line Breaks” is set to `Use <br /> tags`
     - “Compose Settings” is set to `Interpret typed HTML`

It’s that simple really. Now you can paste in your Markdown-generated HTML
without getting extra linebreaks or other wierdnesses.
