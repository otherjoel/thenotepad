#lang punct notepad

---
title: Outlook 2003: Warn if Subject Line Empty
date: 2005-07-01
topics: Outlook
---

Outlook does not have a built-in option to warn you if the subject line is
empty. (Outlook *Express* does, but for some reason Outlook doesn’t.) Here’s how
to put one in.

1. Go to the menu *Tools → Macro → Visual Basic Editor*.

2. Now in the Visual Basic Editor, you should see Project1 in the tree menu on
   the left. Drill down the tree to *Project1 → Microsoft Office Outlook →
   ThisOutlookSession*.

3. In the code area (the big text area on the right) paste in the following
   code:

   ```
   Private Sub Application_ItemSend(ByVal Item As Object, Cancel As Boolean)
   If TypeName(Item) &quot;MailItem&quot; Then Exit Sub

   'CHECK FOR BLANK SUBJECT LINE
   If Item.Subject = "" Then
   Cancel = MsgBox("This message does not have a subject." & vbNewLine & _
                        "Do you wish to continue sending anyway?", _
                        vbYesNo + vbExclamation, "No Subject") = vbNo
   End If
   End Sub
   ```

4. Save and exit the VBA Editor.

You can test this by creating a message with a blank subject and clicking Send.
You will be warned that the subject line is empty and asked if you want to send
the message anyway. This macro is a simplified version of [this code at
outlookcode.com](http://www.outlookcode.com/codedetail.aspx?id=553). I tested it
on Outlook 2003 and it runs with no problems with macro security set to High.
(To check your macro security level, click the menu *Tools → Macro → Security*.)

•comment[#:author "chriswue" #:date "September 10, 2012" #:link "https://www.blogger.com/profile/14585314387028370212"]{
Also works for Outlook 2007, thanks :)
}

•comment[#:author "yourcodeisshowing" #:date "April 11, 2014" #:link "http://yourcodeisshowing.wordpress.com/"]{
I found this very useful. The messagebox sometimes appears beneath the message,
however, and since it’s modal, I can’t move the message window to click “OK”.
Sort of the ultimate warning, I have to kill the process and start over… Still a
good macro though.
}
