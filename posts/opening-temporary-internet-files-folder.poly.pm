#lang pollen

◊(define-meta title "Opening the Temporary Internet Files folder for Outlook attachments (OLK5A, for example)")
◊(define-meta published "2010-02-18")
◊(define-meta topics "Outlook")

One of our employees opened up a PowerPoint attachment from an email in Outlook. He then edited it extensively and saved it using the ◊noun{File → Save As} menu command. Unfortunately he did not bother changing the folder he was saving it to, with the result that it was saved in whatever temporary folder Outlook uses for holding email file attachments. The problem is that this folder is hidden and very hard to find. Even typing in the path directly in Windows Explorer does not work. So when he closed out of PowerPoint he realized he was in danger of losing all the work he had done unless he could find and open that folder.

I found the solution ◊link["http://www.groovypost.com/howto/microsoft/outlook/find-the-microsoft-outlook-temporary-olk-folder/"]{here} after some searching, but even that page only explains how to learn where this temporary folder is located; it does not make it clear how to actually open the file. I found how to do it though.

Open Registry Editor (Click ◊noun{Start → Run}, type ◊code{regedit} and hit ◊code{Enter}). Browse to the following location in the registry structure, depending on the version of Outlook you use:

◊table{
    Version         | Registry Key
    Outlook 97      | ◊code{HKEY_CURRENT_USER\Software\Microsoft\Office\8.0\Outlook\Security}
    Outlook 98      | ◊code{HKEY_CURRENT_USER\Software\Microsoft\Office\8.5\Outlook\Security}
    Outlook 2000    | ◊code{HKEY_CURRENT_USER\Software\Microsoft\Office\9.0\Outlook\Security}
    Outlook 2002/XP | ◊code{HKEY_CURRENT_USER\Software\Microsoft\Office\10.0\Outlook\Security}
    Outlook 2003    | ◊code{HKEY_CURRENT_USER\Software\Microsoft\Office\11.0\Outlook\Security}
    Outlook 2007    | ◊code{HKEY_CURRENT_USER\Software\Microsoft\Office\12.0\Outlook\Security}
}

Double click the ◊code{OutlookSecureTempFolder} value, and copy that value to the clipboard (i.e., select all the text, right-click and hit Copy on the popup menu).

Then go to ◊noun{Start → Run} and paste the value in, and hit enter. An Explorer window will open showing the folder, containing probably every attachment you’ve ever opened.
