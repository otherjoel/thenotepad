#lang pollen

◊(define-meta title "Secure Password Storage on XP")
◊(define-meta published "2005-07-09")
◊(define-meta tags "security,windows,passwords,gpg,keepass,pgp")

◊ul{
◊li{You have a lot of online accounts, and}
◊li{You don’t want to use the same password for each, because that is insecure — however}
◊li{It’s hard to remember all those passwords, so}
◊li{◊emph{You need to store the passwords off-brain somewhere.}

◊ul{
◊li{Also, you don’t want to store them in a text file, that is very insecure, almost worse than writing them down on paper, because a malicious program could grab that file without your knowing.}
◊li{Therefore, you need to encrypt the data.}
}}
◊li{You could use ◊link["http://web.archive.org/web/20061105133527/http://www.pgp.com/"]{PGP}, because that is undoubtedly the best-designed and strongest encryption software available; but}
◊li{You don’t want to pay $50 just to store passwords. You could use ◊link["http://web.archive.org/web/20061105133527/http://www.gnupg.org/"]{GnuPG}, which is free and just as strong, but}
◊li{You don’t want to have to use the command line every time you unlock your files, use them, and lock them again.}
◊li{You also don’t want to store your passwords in the browser because}
◊li{Anyone using your browser could get access to your sites.

◊ul{
◊li{Even when the browser allows you to use a master password to protect your stored passwords, reason tells you that storing sensitive information directly within the browser brings them that much closer to the reach of security exploits and malware.}
}}
}

So in many cases, for reasons of security/cost/convenience, you can rule out: writing them down, plain text files, PGP, GPG, and browser-saved passwords. For these reasons, I’ve found that the best program for password storage on XP is ◊link["http://web.archive.org/web/20061105133527/http://keepass.sourceforge.net/"]{KeePass}.

◊ul{
◊li{It’s free}
◊li{It is open source, and therefore open to scrutiny for backdoors or weaknesses}
◊li{It has a well-designed interface, specifically tuned to the task of securing and using passwords}
◊li{It is small in size (440k), and fast}
◊li{It doesn’t require installation; just unzip and run}
◊li{It doesn’t need .NET runtimes or other support files}
◊li{It uses strong encryption}
◊li{It is configurable to be as secure ◊emph{or} as convenient as you want}
}

Go to the ◊link["http://web.archive.org/web/20061105133527/http://keepass.sourceforge.net/"]{KeePass website} to download it, view screenshots, and read more information. More later on an end-to-end process for securing your software and customizing your KeePass installation.
