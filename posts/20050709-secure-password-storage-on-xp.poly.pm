#lang pollen

◊(define-meta title "Secure Password Storage on XP")
◊(define-meta published "2005-07-09")
◊(define-meta topics "security,Windows,passwords,GPG,KeePass,PGP")

◊ul{
◊item{You have a lot of online accounts, and}
◊item{You don’t want to use the same password for each, because that is insecure — however}
◊item{It’s hard to remember all those passwords, so}
◊item{◊emph{You need to store the passwords off-brain somewhere.}

◊ul{
◊item{Also, you don’t want to store them in a text file, that is very insecure, almost worse than writing them down on paper, because a malicious program could grab that file without your knowing.}
◊item{Therefore, you need to encrypt the data.}
}}
◊item{You could use ◊link["http://web.archive.org/web/20061105133527/http://www.pgp.com/"]{PGP}, because that is undoubtedly the best-designed and strongest encryption software available; but}
◊item{You don’t want to pay $50 just to store passwords. You could use ◊link["http://web.archive.org/web/20061105133527/http://www.gnupg.org/"]{GnuPG}, which is free and just as strong, but}
◊item{You don’t want to have to use the command line every time you unlock your files, use them, and lock them again.}
◊item{You also don’t want to store your passwords in the browser because}
◊item{Anyone using your browser could get access to your sites.

◊ul{
◊item{Even when the browser allows you to use a master password to protect your stored passwords, reason tells you that storing sensitive information directly within the browser brings them that much closer to the reach of security exploits and malware.}
}}
}

So in many cases, for reasons of security/cost/convenience, you can rule out: writing them down, plain text files, PGP, GPG, and browser-saved passwords. For these reasons, I’ve found that the best program for password storage on XP is ◊link["http://web.archive.org/web/20061105133527/http://keepass.sourceforge.net/"]{KeePass}.

◊ul{
◊item{It’s free}
◊item{It is open source, and therefore open to scrutiny for backdoors or weaknesses}
◊item{It has a well-designed interface, specifically tuned to the task of securing and using passwords}
◊item{It is small in size (440k), and fast}
◊item{It doesn’t require installation; just unzip and run}
◊item{It doesn’t need .NET runtimes or other support files}
◊item{It uses strong encryption}
◊item{It is configurable to be as secure ◊emph{or} as convenient as you want}
}

Go to the ◊link["http://web.archive.org/web/20061105133527/http://keepass.sourceforge.net/"]{KeePass website} to download it, view screenshots, and read more information. More later on an end-to-end process for securing your software and customizing your KeePass installation.
