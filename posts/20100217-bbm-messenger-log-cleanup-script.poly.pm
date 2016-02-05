#lang pollen

◊(define-meta title "BBM Messenger Log Cleanup Script")
◊(define-meta published "2010-02-17")
◊(define-meta tags "csv,blackberry,vbscript,bbm")

As ◊link["20100212-blackberry-messenger-logs-timestamp.html"]{mentioned previously}, the CSV files produced by Blackberry Messenger 5.0+ need some cleaning up before they can be properly used. I finally wrote a short script for doing just that.

You can download the VBScript here: ◊link["https://docs.google.com/leaf?id=0B9SDJ22NRBkrNzdjYTIzYWMtNjcwNi00ZjlhLWE1ZDEtNWU0NTQ1ZmEwYjc5&hl=en"]{◊code{bbmcleaner-1.1.zip}}. This code is released to the public domain.

Once you have the BBM log file on your computer (email it there from your phone, again, see the ◊link["20100212-blackberry-messenger-logs-timestamp.html"]{last post} on this subject), just drag and drop it onto this ◊code{.vbs} file, and a “clean” version will be produced as a separate file in the same directory. The new file will have human-readable dates and the message will be properly escaped – in short, it will be something you can just open and use in Excel (e.g.).

◊h2[#:id "change-log"]{Change Log}

Version 1.1 (◊emph{Feb 20, 2010})

◊ul{
◊li{Added ◊code{GMTOffset} constant to allow timestamps to be properly adjusted for time zones.}
}

◊h2[#:id "comments"]{Comments}

◊h3[#:id "denise-said"]{◊link["https://www.blogger.com/profile/01695068080007560560"]{Denise} said:}

I get an error when I tried this.

http://docs.google.com/Doc?docid=0Abg5wFZeGIUcZGQ3NGMyd3JfMmZnZjlkNWho&amp;hl=en

I’m not sure if that link will work. I’m new to googledocs. My apologies.

Can you please help me?

(Comment posted May 29, 2010)

◊h3[#:id "joel-said"]{◊link["https://www.blogger.com/profile/13646393468637062885"]{Joel} said:}

I tried opening that link but it says I do not have access to that file.

Can you explain what you did, and exactly what the error message said?

(Comment posted June 17, 2011)

◊h3[#:id "gretchen-nobles-said"]{◊link["https://www.blogger.com/profile/14130558180346013746"]{Gretchen Nobles} said:}

Hey - Great script! I have a couple of questions. How do I adjust to make the time display in 12 hour format? Also - is there a way to set my time zone? Central Standard

(Comment posted November 02, 2011)

◊h3[#:id "joel-a.-said"]{◊link["https://www.blogger.com/profile/13646393468637062885"]{Joel A.} said:}

If you open the .vbs script file in Notepad, you’ll see there is a place to edit the timezone.

The format of the time display actually ◊emph{is} in 12hr format in the output csv file, but by default Excel converts it to 24hr format when displaying the time value. You can display it however you want by changing the cell formatting in Excel.

(Comment posted November 02, 2011)