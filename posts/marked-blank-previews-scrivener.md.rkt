#lang punct notepad

---
title: Marked 2 Previews of Scrivener Files Coming Up Blank
date: 2015-03-03
topics: Scrivener,Marked
---

You’re *supposed* to be able to drag and drop a
[Scrivener](http://www.literatureandlatte.com/scrivener.php) file onto the
[Marked](http://marked2app.com) app icon in the dock and have Marked open a
preview for you.

However, when I did this on *one particular Scrivener file*, the Marked preview
came up blank–even though I had plenty of Markdown-formatted content project.

I finally found the solution, after checking other things[^1]. When you create a
new “blank” Scrivener project, it gives you a couple of default folders; one of
those is named *Drafts* and contains a blank text document. That Drafts folder,
it seems, is actually supposed to be the root folder of all your project’s
content.

What I had done was create a folder outside the Drafts folder and create all of
my content there. Marked will not preview content located outside the Drafts
folder.

The solution is to rename the original *Drafts* to something else like
*Content*, and create a separate Drafts folder under it. Then make sure
everything you might want to preview in Marked is located under that Content
folder.

I’m using the latest version of Marked 2 (2.4.10) and Scrivener (2.6)

[^1]: Including whether “Include in compile” was turned on for each document
    within each document in the Scrivener project—if it’s unchecked, Marked
    *does* exclude it from the preview, even though no “compile” is actually
    taking place from Scrivener’s perspective.
