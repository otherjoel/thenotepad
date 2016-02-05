#lang pollen

◊(define-meta title "")
◊(define-meta published "")


◊h2[#:id "title-marked-2-previews-of-scrivener-files-coming-up-blank"]{Title: Marked 2 Previews of Scrivener Files Coming Up Blank}

◊h2[#:id "tags-scrivener-marked-markdown"]{Tags: scrivener, marked, markdown}

◊h2[#:id "date-2015-03-03"]{Date: 2015-03-03}

Text: You&#39;re ◊emph{supposed} to be able to drag and drop a ◊link["http://www.literatureandlatte.com/scrivener.php"]{Scrivener} file onto the ◊link["http://marked2app.com"]{Marked} app icon in the dock and have Marked open a preview for you.

However, when I did this on ◊emph{one particular Scrivener file}, the Marked preview came up blank -- even though I had plenty of Markdown-formatted content project.

I finally found the solution, after checking other things◊numbered-note{Including whether &quot;Include in compile&quot; was turned on for each document within each document in the Scrivener project -- if it&#39;s unchecked, Marked ◊emph{does} exclude it from the preview, even though no &quot;compile&quot; is actually taking place from Scrivener&#39;s perspective.}. When you create a new &quot;blank&quot; Scrivener project, it gives you a couple of default folders; one of those is named ◊code{Drafts} and contains a blank text document. That Drafts folder, it seems, is actually supposed to be the root folder of all your project&#39;s content.

What I had done was create a folder outside the Drafts folder and create all of my content there. Marked will not preview content located outside the Drafts folder.

The solution is to rename the original ◊code{Drafts} to something else like ◊code{Content}, and create a separate Drafts folder under it. Then make sure everything you might want to preview in Marked is located under that Content folder.

I&#39;m using the latest version of Marked 2 (2.4.10) and Scrivener (2.6)
