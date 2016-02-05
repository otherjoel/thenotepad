#lang pollen

◊(define-meta title "Opening the Temporary Internet Files folder for Outlook attachments (OLK5A, for example)")
◊(define-meta published "2010-02-18")
◊(define-meta tags "email,attachments,windows,registry,outlook")

One of our employees opened up a PowerPoint attachment (ugh, I know) from an email in Outlook. He then edited it extensively and saved it using the ◊code{File → Save As} menu command. Unfortunately he did not bother changing the folder he was saving it to, with the result that it was saved in whatever temporary folder Outlook uses for holding email file attachments. The problem is that this folder is hidden and very hard to find. Even typing in the path directly in Windows Explorer does not work. So when he closed out of PowerPoint he realized he was in danger of losing all the work he had done unless he could find and open that folder.

I found the solution ◊link["http://www.groovypost.com/howto/microsoft/outlook/find-the-microsoft-outlook-temporary-olk-folder/"]{here} after some searching, but even that page only explains how to learn where this temporary folder is located; it does not make it clear how to actually open the file. I found how to do it though.

Open Registry Editor (Click Start → Run, type ◊code{regedit} and hit Enter). Browse to the following location in the registry structure, depending on the version of Outlook you use:









Outlook 97





HKEY_CURRENT_USER.0









Outlook 98





HKEY_CURRENT_USER.5









Outlook 2000





HKEY_CURRENT_USER.0









Outlook 2002/XP





HKEY_CURRENT_USER0.0









Outlook 2003





HKEY_CURRENT_USER1.0









Outlook 2007





HKEY_CURRENT_USER2.0









Double click the ◊code{OutlookSecureTempFolder} value, and copy that value to the clipboard (i.e., select all the text, right-click and hit Copy on the popup menu).

Then go to Start → Run and paste the value in, and hit enter. An Explorer window will open showing the folder, containing probably every attachment you’ve ever opened.

◊h2[#:id "comments"]{Comments}

◊h3[#:id "alexis-said"]{◊link["https://www.blogger.com/profile/07547255185381643744"]{Alexis} said:}

I know a lot of tools which work with other types of files. But couple days ago I was in the Internet and downloaded several tools. Something happened with my outlook passwords and I didn’t know what to do then. To my good fortune suddenly my friend called me up and advised - ◊link["http://www.recoverytoolbox.com/pst_password_cracker.html"]{outlook pst file password cracker}. He was right,and I was lucky)) The utility helped me free of charge and without payment as I bore in mind.

(Comment posted May 01, 2010)
