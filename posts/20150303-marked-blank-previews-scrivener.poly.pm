#lang pollen

◊(define-meta title "Marked 2 Previews of Scrivener Files Coming Up Blank")
◊(define-meta published "2015-03-03")
◊(define-meta topics "Scrivener,Marked")

You’re ◊emph{supposed} to be able to drag and drop a ◊link["http://www.literatureandlatte.com/scrivener.php"]{Scrivener} file onto the ◊link["http://marked2app.com"]{Marked} app icon in the dock and have Marked open a preview for you.

However, when I did this on ◊emph{one particular Scrivener file}, the Marked preview came up blank -- even though I had plenty of Markdown-formatted content project.

I finally found the solution, after checking other things◊numbered-note{Including whether “Include in compile” was turned on for each document within each document in the Scrivener project --- if it’s unchecked, Marked ◊emph{does} exclude it from the preview, even though no “compile” is actually taking place from Scrivener’s perspective.}. When you create a new “blank” Scrivener project, it gives you a couple of default folders; one of those is named ◊noun{Drafts} and contains a blank text document. That Drafts folder, it seems, is actually supposed to be the root folder of all your project’s content.

What I had done was create a folder outside the Drafts folder and create all of my content there. Marked will not preview content located outside the Drafts folder.

The solution is to rename the original ◊noun{Drafts} to something else like ◊noun{Content}, and create a separate Drafts folder under it. Then make sure everything you might want to preview in Marked is located under that Content folder.

I’m using the latest version of Marked 2 (2.4.10) and Scrivener (2.6)
