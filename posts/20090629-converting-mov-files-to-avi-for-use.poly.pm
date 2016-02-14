#lang pollen

◊(define-meta title "Converting MOV files to AVI for use with video editing software")
◊(define-meta published "2009-06-29")
◊(define-meta topics "Windows,video")

If your camera records in MOV format, you may find it difficult to use with Windows Movie Maker or other Windows-platform movie editors. Fortunately there is a way to convert these files to AVI format.

First, download and install ◊link["http://www.cocoonsoftware.com/index.php?option=com_frontpage&Itemid=1"]{Quick Media Converter}. There are a lot of free/shareware programs for this purpose out there, but this one was ◊link["http://lifehacker.com/5110552/most-popular-free-windows-downloads-of-2008"]{recommended} by the venerable Lifehacker, works well, and is free. The instructions in this post were written for the 3.6.5 version of the software but should work with later versions.

Here is a pic of Quick Media Converter’s main screen, with some annotation:

◊figure["/img/image2.jpg"]{Quick Media Converter}

◊ol{
◊item{Click the DivX button (1) and select the “Win Media Player Compatible” option.}
◊item{Drag and drop your MOV movie clip file into the file list area (2)}
◊item{Click the (i) button (3) to display information about the clip in the pane at right (5)}
◊item{Click the folder button (4) and select a place to save the converted file (e.g., My Documents)}
◊item{In the file information area (5) scroll down until you see Width and Height information, as shown. Ideally this should be 640x480 but if not it’s not a dealbreaker :)}
◊item{If necessary, change the output width and height numbers (6) to match the numbers in the info area (5)}
◊item{Click the convert button (7).}
}

The program will then convert and drop an AVI file into your selected folder, for use in the editing software of your choice!

Note that you now have two (likely rather large) copies of the same video clip. Later when you are done publishing your finished video to YouTube or Vimeo, if you feel you want to keep a copy of the original clip for archiving purposes, I recommend you keep only the original one (the MOV or “QuickTime” file) and delete the other. It is easy to convert from MOV to AVI, but hard to go the other direction.
