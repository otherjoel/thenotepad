#lang pollen

◊(define-meta title "Inserting graphics into a PDF")
◊(define-meta published "2005-09-09")
◊(define-meta topics "Acrobat,graphics,PDF")

If you have Adobe Acrobat (the real deal, not just the reader) you can insert graphics into PDF docs, but it is not intuitive --- mainly because Acrobat can only cut and paste graphics ◊emph{within itself}, not to/from other programs.

◊ol{
◊item{Click ◊noun{Document} menu → ◊noun{Insert Page}}
◊item{In the ◊noun{Browse}window, change the file type to your graphics format (GIF, JPG, etc) and select your graphics file.}
◊item{The image will be inserted on its own page.}
◊item{Click the TouchUp Object tool on the toolbar. Right-click the image and select ◊noun{Cut}.}
◊item{Go to the page where you want the document and ◊noun{Paste} in the image. Drag and drop the image to its correct location.}
◊item{Click ◊noun{Document} menu → ◊noun{Delete page} and delete the (now-empty) page you just inserted.}
}

Resizing the graphics: I haven’t yet figured that out. I am using 5.0 (an old version) so things may be different in the newer versions of Acrobat.
