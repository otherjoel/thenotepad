#lang pollen

◊(define-meta title "How to convert mp3 files for use as on-hold music")
◊(define-meta published "2014-12-05")
◊(define-meta tags "phones,voip,mp3,ffmpeg")

If you administer your company’s VoIP system, you probably want to change the default on-hold music. Our company just started using a new system this year and the hold music was awful; it sounded like a 2nd grade piano recital. And whatever you do, you don’t want to make your callers suffer through any more of ◊link["https://www.youtube.com/watch?v=6g4dkBF5anU"]{this}.

Most phone systems don’t let you use plain-old MP3 files, but you can convert any song to the necessary format.

First, get yourself suitable music. Something instrumental, without any exotic highs and lows. Try ◊link["http://www.amazon.com/gp/product/B004Y430YQ/ref=as_li_tl?ie=UTF8&camp=1789&creative=390957&creativeASIN=B004Y430YQ&linkCode=as2&tag=thloya-20&linkId=AYWBOT32QQYWLHPS"]{this instrumental version of ◊emph{Save the Last Dance For Me}}, for example.

Next, ◊link["https://www.ffmpeg.org/download.html"]{get ffmpeg}, the classic command-line utility for converting audio files to other formats.

For simplicity’s sake, put your MP3 file of choice in the same folder as your extracted ffmpeg executable file, and make sure the filename doesn’t contain any spaces. Then, open a command line/terminal and run this command:

◊blockcode{ffmpeg -i YOURFILE.mp3 -ar 8000 -ac 1 -ab 64 YOURFILE.wav -ar 8000 -ac 1 -ab 64 -f mulaw YOURFILE.pcm -map 0:0 -map 0:0}

This will create two files, a ◊code{.wav} file and a ◊code{.pcm} file. Try using the ◊code{.wav} file first, if not, the other one should do the job.

Final note: all music sounds like ass over a phone line.
