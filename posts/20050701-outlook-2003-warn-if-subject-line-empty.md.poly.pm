#lang pollen

◊(define-meta title "Outlook 2003: Warn if Subject Line Empty")
◊(define-meta published "2005-07-01")
◊(define-meta tags "email,VBA,Outlook")

Outlook does not have a built-in option to warn you if the subject line is empty. (Outlook ◊emph{Express} does, but for some reason Outlook doesn’t.) Here’s how to put one in.

◊ol{
◊li{Go to the menu ◊noun{Tools → Macro → Visual Basic Editor}.}
◊li{Now in the Visual Basic Editor, you should see Project1 in the tree menu on the left. Drill down the tree to ◊noun{Project1 → Microsoft Office Outlook → ThisOutlookSession}.}
◊li{In the code area (the big text area on the right) paste in the following code:
◊blockcode{Private Sub Application_ItemSend(ByVal Item As Object, Cancel As Boolean)
If TypeName(Item) &quot;MailItem&quot; Then Exit Sub

'CHECK FOR BLANK SUBJECT LINE
If Item.Subject = "" Then
Cancel = MsgBox("This message does not have a subject." & vbNewLine & _
                     "Do you wish to continue sending anyway?", _
                     vbYesNo + vbExclamation, "No Subject") = vbNo
End If
End Sub}}
◊li{Save and exit the VBA Editor.}
}

You can test this by creating a message with a blank subject and clicking Send. You will be warned that the subject line is empty and asked if you want to send the message anyway. This macro is a simplified version of ◊link["http://www.outlookcode.com/codedetail.aspx?id=553"]{this code at outlookcode.com}. I tested it on Outlook 2003 and it runs with no problems with macro security set to High. (To check your macro security level, click the menu ◊noun{Tools → Macro → Security}.)

◊h2[#:id "comments"]{Comments}

◊h3[#:id "alex-said"]{◊link["https://www.blogger.com/profile/02892788277177092618"]{Alex} said:}

This comment has been removed by a blog administrator.

(Comment posted February 27, 2010)

◊h3[#:id "chriswue-said"]{◊link["https://www.blogger.com/profile/14585314387028370212"]{chriswue} said:}

Also works for Outlook 2007, thanks :)

(Comment posted September 10, 2012)

◊h3[#:id "yourcodeisshowing-said"]{◊link["http://yourcodeisshowing.wordpress.com/"]{yourcodeisshowing} said:}

I found this very useful. The messagebox sometimes appears beneath the message, however, and since it’s modal, I can’t move the message window to click “OK”. Sort of the ultimate warning, I have to kill the process and start over… Still a good macro though.

(Comment posted April 11, 2014)
