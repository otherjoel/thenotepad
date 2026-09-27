#lang punct notepad

---
title: Blackberry Messenger Logs — Timestamp Format
date: 2010-02-12
topics: Blackberry Messenger
---

(*Update: I’ve [written a VBScript](bbm-messenger-log-cleanup-script.html) to
convert BBM logs into something cleaner and a bit easier to read.*) The newer
versions of Blackberry Messenger (BBM) include an option to save chat history to
your device memory or media card. I was glad to find it save chats in
[comma-separated value
format](http://en.wikipedia.org/wiki/Comma-separated_values) (CSV)—or at least
that the files it creates have a .csv extension—since CSV has been around for
decades and is easy to read on any platform. There are a few caveats with BBM’s
particular log file format, however.

To get the files off my phone, I just emailed them to myself (they’re stored on
my media card under
`/Media Card/BlackBerry/im/BlackBerry Messenger/your_pin/history`). You can open
up the file in a text editor like Notepad, and you will see the messages are in
the following one-per-line format:

```
[timestamp], "[sender PIN]", "[receiver PIN]", Message...
```

**Example:**

```
201002101265815660914,"8194BE13","31E12A40",Ok, heading out the door!
```

The format for the timestamp is a mish-mash of things: the left eight characters
are the date in text format (`yyyymmdd`) while the rest is actually [epoch
time](http://www.epochconverter.com/) with an extra three digits added for the
milliseconds. So the date part is really redundant (since epoch time includes
the date) but whatever.

The other caveat here, as you can see in the example above, is that the actual
message portion is not enclosed in quotes, which is unfortunate. A proper CSV
file would enclose in quotes any field that may contain a comma (since commas
are used to delimit fields in CSV files). Thus, if the message contains any
commas, that particular record will appear “broken” to any CSV parser. I
consider this to be a bug in the Blackberry Messenger software.[^1] This could
be fixed in this case by creating a script that cleans the file up into strict
CSV form **(Update: I wrote [the
script](bbm-messenger-log-cleanup-script.html))**: insert a quote mark before
the 45th character of every line, and another at the very end, and double all
quote marks in between (that is, in the original message)—again, see the [wiki
article](http://en.wikipedia.org/wiki/Comma-separated_values) for more info on
the CSV format.

[^1]: The bug is especially weird since the PIN fields, which have no
    possibility of containing commas, *are* enclosed in quotes.
