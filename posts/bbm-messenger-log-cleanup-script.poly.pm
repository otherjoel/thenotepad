#lang pollen

◊(define-meta title "BBM Messenger Log Cleanup Script")
◊(define-meta published "2010-02-17")
◊(define-meta topics "Blackberry Messenger,VBscript")

As ◊link["blackberry-messenger-logs-timestamp.html"]{mentioned previously}, the CSV files produced by Blackberry Messenger 5.0+ need some cleaning up before they can be properly used. I finally wrote a short script for doing just that.

You can download the VBScript here: ◊link["https://docs.google.com/leaf?id=0B9SDJ22NRBkrNzdjYTIzYWMtNjcwNi00ZjlhLWE1ZDEtNWU0NTQ1ZmEwYjc5&hl=en"]{◊code{bbmcleaner-1.1.zip}}. This code is released to the public domain.

Once you have the BBM log file on your computer (email it there from your phone, again, see the ◊link["blackberry-messenger-logs-timestamp.html"]{last post} on this subject), just drag and drop it onto this ◊code{.vbs} file, and a “clean” version will be produced as a separate file in the same directory. The new file will have human-readable dates and the message will be properly escaped – in short, it will be something you can just open and use in Excel (e.g.).

◊section{Change Log}

Version 1.1 (◊emph{Feb 20, 2010})

◊ul{
◊item{Added ◊code{GMTOffset} constant to allow timestamps to be properly adjusted for time zones.}
}

◊comment[#:author "Denise"
         #:datetime "May 29, 2010"
         #:authorlink "https://www.blogger.com/profile/01695068080007560560"]{I get an error when I tried this.

◊link["http://docs.google.com/Doc?docid=0Abg5wFZeGIUcZGQ3NGMyd3JfMmZnZjlkNWho&amp;hl=en"]

I’m not sure if that link will work. I’m new to googledocs. My apologies.

Can you please help me?}

◊comment[#:author "Joel (author)"
         #:datetime "June 17, 2011"
         #:authorlink "https://www.blogger.com/profile/13646393468637062885"]{I tried opening that link but it says I do not have access to that file.

Can you explain what you did, and exactly what the error message said?}

◊comment[#:author "Gretchen Nobles"
         #:datetime "November 02, 2011"
         #:authorlink "https://www.blogger.com/profile/14130558180346013746"]{Hey --- Great script! I have a couple of questions. How do I adjust to make the time display in 12 hour format? Also --- is there a way to set my time zone? Central Standard}

◊comment[#:author "Joel (author)"
         #:datetime "November 02, 2011"
         #:authorlink "https://www.blogger.com/profile/13646393468637062885"]{If you open the .vbs script file in Notepad, you’ll see there is a place to edit the timezone.

The format of the time display actually ◊emph{is} in 12hr format in the output csv file, but by default Excel converts it to 24hr format when displaying the time value. You can display it however you want by changing the cell formatting in Excel.}
