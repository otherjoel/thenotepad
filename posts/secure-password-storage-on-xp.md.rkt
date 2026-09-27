#lang punct notepad

---
title: Secure Password Storage on XP
date: 2005-07-09
topics: password storage
---

- You have a lot of online accounts, and

- You don’t want to use the same password for each, because that is
  insecure—however

- It’s hard to remember all those passwords, so

- *You need to store the passwords off-brain somewhere.*

  - Also, you don’t want to store them in a text file, that is very insecure,
    almost worse than writing them down on paper, because a malicious program
    could grab that file without your knowing.
  - Therefore, you need to encrypt the data.

- You could use
  [PGP](http://web.archive.org/web/20061105133527/http://www.pgp.com/), because
  that is undoubtedly the best-designed and strongest encryption software
  available; but

- You don’t want to pay $50 just to store passwords. You could use
  [GnuPG](http://web.archive.org/web/20061105133527/http://www.gnupg.org/),
  which is free and just as strong, but

- You don’t want to have to use the command line every time you unlock your
  files, use them, and lock them again.

- You also don’t want to store your passwords in the browser because

- Anyone using your browser could get access to your sites.

  - Even when the browser allows you to use a master password to protect your
    stored passwords, reason tells you that storing sensitive information
    directly within the browser brings them that much closer to the reach of
    security exploits and malware.

So in many cases, for reasons of security/cost/convenience, you can rule out:
writing them down, plain text files, PGP, GPG, and browser-saved passwords. For
these reasons, I’ve found that the best program for password storage on XP is
[KeePass](http://web.archive.org/web/20061105133527/http://keepass.sourceforge.net/).

- It’s free
- It is open source, and therefore open to scrutiny for backdoors or weaknesses
- It has a well-designed interface, specifically tuned to the task of securing
  and using passwords
- It is small in size (440k), and fast
- It doesn’t require installation; just unzip and run
- It doesn’t need .NET runtimes or other support files
- It uses strong encryption
- It is configurable to be as secure *or* as convenient as you want

Go to the [KeePass
website](http://web.archive.org/web/20061105133527/http://keepass.sourceforge.net/)
to download it, view screenshots, and read more information. More later on an
end-to-end process for securing your software and customizing your KeePass
installation.
