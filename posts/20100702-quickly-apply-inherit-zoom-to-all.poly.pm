#lang pollen

◊(define-meta title "Quickly apply “Inherit Zoom” to all bookmarks in a PDF file")
◊(define-meta published "2010-07-02")
◊(define-meta tags "acrobat,regular-expressions,bookmarks,adobe,pdf")

I often compile PDF reports totaling 1,000 to 2,000 pages, and am always creating hierarchical bookmarks for these files. One of my beefs is that often, clicking a bookmark will change the magnification setting to “fit width” from whatever you had it set at. Ideally, clicking a bookmark should default to just leaving the zoom level at whatever the reader is currently set to use (“Inherit zoom”). I’ve found no way in Acrobat to set the default behaviour for newly-created bookmarks, and changing these links one at a time in Acrobat is extremely tedious.

Thankfully, there is ◊link["http://maba.wordpress.com/2004/06/20/pdf-bookmark-hacks/"]{a solution} provided by Martin Backschat:

◊blockquote{
To modify this annoyance you can directly modify the PDF document in your Text editor.

With UltraEdit, for example, I load the PDF document and open the “Search and Replace” box, enable “Regular Expressions” and replace all occurrences of ◊code{R/XYZ*]} with ◊code{R/XYZ]}, and then also all occurrences of ◊code{R/Fit*]} with ◊code{R/XYZ]}. Now save the document.

With the Perl scripting language, this hack is applied with

◊code{perl -pe 's#R/(XYZ.*?|Fit.*?)\]#R/XYZ\]#g#' in.pdf >out.pdf}

The next time you open the modified document with Acrobat you will get a message that the document is being repaired. Just safe it again with Acrobat and everything is fine.
}

I don’t have UltraEdit but I was able to make this work using ◊link["http://sourceforge.net/projects/notepad-plus/"]{Notepad++}. The exact search/replace text was slightly different for my PDF files (note the added space) but the principle is the same:

◊ol{
◊item{In Notead++, click the ◊code{TextFX} menu, then ◊code{TextFX Quick} → ◊code{Find/Replace} (the standard find/replace tool will not help you here). Make sure you check the “Regular Expr” check box on the right.}
◊item{Use ◊code{R/XYZ(.*)]} as your search string and ◊code{R/XYZ]} as your replace string and replace all instances.}
◊item{Do it again using ◊code{R/Fit(.*)]} as your search string and the same replace string as above.}
}

◊section{Comments}

◊comment[#:author "Rob"
         #:datetime "May 27, 2011"
         #:authorlink "https://www.blogger.com/profile/10021798230734615659"]{Hey I tried this using Notepad++ on a pdf that has a bunch of bookmarks with different zoom levels. The find/replace didn’t find any matches to the strings.}

◊comment[#:author "Rob"
         #:datetime "May 27, 2011"
         #:authorlink "https://www.blogger.com/profile/10021798230734615659"]{This was using the TextFX find/replace. Any suggestions to get it to work? It would be great if I could get it to work}

◊comment[#:author "Shane"
         #:datetime "June 24, 2011"
         #:authorlink "https://www.blogger.com/profile/02454026051373796378"]{Thanks for the tip. For the folks running into trouble with Notepad++, just remove the space between the “R” and “/” in “R /XYZ(.*)]”, it should be “R/XYZ(.*)]” same thing applies to the repalcement text.}

◊comment[#:author "Joshua"
         #:datetime "March 01, 2012"
         #:authorlink "https://www.blogger.com/profile/08903612467158866477"]{I couldn’t get it to work using Notepad++, but came up with another solution using JPDFBookmarks…

◊link["http://codebyjoshua.blogspot.com/2012/02/easily-change-pdf-zoom-level-and-name.html"]}

◊comment[#:author "Daniel Kraus"
         #:datetime "January 11, 2014"
         #:authorlink "https://www.blogger.com/profile/02046983092294373360"]{I wrote a small java application which is based on the PDF Clown library. It allows you to easily apply various bookmark configurations, such as ‘Inherit zoom’, to multiple PDF files within a desired directory.

This is my first public project and due to the fact that I’m taking my exams in the next couple of weeks, I’m running out of time. But afterwards, which should be in mid-February, I’ll keep on developing.

In the meantime, feel free to use the application and give some feedback.

◊link["https://bitbucket.org/beatngu13/pdfbookmarkwizard/downloads"]}

◊comment[#:author "Werner Heckel"
         #:datetime "March 21, 2014"
         #:authorlink "https://www.blogger.com/profile/00817185928224919763"]{Thanks Daniel. Your tool was a great help.}

◊comment[#:author "N. Jones"
         #:datetime "May 27, 2014"
         #:authorlink "https://www.blogger.com/profile/08891272085176919152"]{Daniel,

Thanks for the java app. It works like a charm! Great time-saver too.}

◊comment[#:author "SergioUrra"
         #:datetime "August 03, 2014"
         #:authorlink "https://www.blogger.com/profile/13821816373936026294"]{@Joshua, thanks a lot. I did use JPDFBookmarks. Really nice app.}

◊comment[#:author "Jonnie Tyler"
         #:datetime "August 19, 2015"
         #:authorlink "https://www.blogger.com/profile/03832919638641651711"]{Thank you Daniel!}
