#lang pollen

◊(define-meta title "Blackberry Messenger Logs — Timestamp Format")
◊(define-meta published "2010-02-12")
◊(define-meta tags "Blackberry Messenger")

(◊emph{Update: I’ve ◊link["20100217-bbm-messenger-log-cleanup-script.html"]{written a VBScript} to convert BBM logs into something cleaner and a bit easier to read.}) The newer versions of Blackberry Messenger (BBM) include an option to save chat history to your device memory or media card. I was glad to find it save chats in ◊link["http://en.wikipedia.org/wiki/Comma-separated_values"]{comma-separated value format} (CSV) — or at least that the files it creates have a .csv extension — since CSV has been around for decades and is easy to read on any platform. There are a few caveats with BBM’s particular log file format, however.

To get the files off my phone, I just emailed them to myself (they’re stored on my media card under ◊code{/Media Card/BlackBerry/im/BlackBerry Messenger/your_pin/history}). You can open up the file in a text editor like Notepad, and you will see the messages are in the following one-per-line format:

◊blockquote{
◊code{[timestamp], "[sender PIN]", "[receiver PIN]", Message...}
}

◊strong{Example:}

◊blockquote{
◊code{201002101265815660914,"8194BE13","31E12A40",Ok, heading out the door!}
}

The format for the timestamp is a mish-mash of things: the left eight characters are the date in text format (◊code{yyyymmdd}) while the rest is actually ◊link["http://www.epochconverter.com/"]{epoch time} with an extra three digits added for the milliseconds. So the date part is really redundant (since epoch time includes the date) but whatever.

The other caveat here, as you can see in the example above, is that the actual message portion is not enclosed in quotes, which is unfortunate. A proper CSV file would enclose in quotes any field that may contain a comma (since commas are used to delimit fields in CSV files). Thus, if the message contains any commas, that particular record will appear “broken” to any CSV parser. I consider this to be a bug in the Blackberry Messenger software.◊numbered-note{The bug is especially weird since the PIN fields, which have no possibility of containing commas, ◊emph{are} enclosed in quotes.} This could be fixed in this case by creating a script that cleans the file up into strict CSV form ◊strong{(◊smallcaps{Update}: I wrote ◊link["20100217-bbm-messenger-log-cleanup-script.html"]{the script}}: insert a quote mark before the 45th character of every line, and another at the very end, and double all quote marks in between (that is, in the original message) — again, see the ◊link["http://en.wikipedia.org/wiki/Comma-separated_values"]{wiki article} for more info on the CSV format.
