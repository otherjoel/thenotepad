#lang pollen

◊(define-meta title "Fixing AutoCAD error: ARX_ERROR:eNotThatKindOfClass")
◊(define-meta published "2009-07-28")
◊(define-meta topics "AutoCAD")

Some of our users have the old AutoCAD 2005 version, while a lucky few have the newer 2009 version (licenses are danged expensive, you know). We had a case where a drawing was being opened in AutoCAD 2009 and “saved-as” back to the 2004 format so the other users could open it. When attempting to perform commands on the drawing in in the old 2005 version, however, the following error messages would come up:

◊blockquote{
◊code{ARX_ERROR:eNotThatKindOfClass Command not allowed because drawing contains objects from a newer version of Architectural Desktop}
}

The solution, pointed to by various forum threads (such as ◊link["http://www.cadtutor.net/forum/showthread.php?s=d2bad05f1e697902b2a7024c33bf1285&t=16383"]{this one}), is to download and install the ◊link["http://usa.autodesk.com/adsk/servlet/ps/item?siteID=123112&id=9378493&linkID=9240617"]{Object Enabler hotfix} from the AutoDesk support site. Doing this immediately resolved the issue in our case.

Another possible approach, in case that does not work for you, is to use the ◊code{exporttoautocad} command instead of Save As - see ◊link["http://discussion.autodesk.com/forums/message.jspa?messageID=5556678"]{this thread} on the AutoDesk forums.
