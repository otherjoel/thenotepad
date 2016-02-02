#lang pollen

◊(define-meta title "CRM Outlook client won’t go back online; IE CRM client closes abruptly")
◊(define-meta published "2006-10-27")
◊(define-meta tags "Outlook")

When using the outlook client for MS CRM 3.0, and trying to click the Go Online button, you may get an error message saying:

◊blockquote{
“Microsoft CRM cannot go online. The Microsoft CRM server was not found.”
}

Often when this is the case, you are also unable to access CRM directly through Internet Explorer. You can confirm this is the problem by opening a new Internet Explorer window, typing the name of your CRM server in the address bar (usually just “crm”), and clicking “Go.” IE will resize for a split-second and then just abruptly disappear.

First of all, make sure of the following:

◊ol{
◊li{That you are connected to the LAN and logged in to the Windows domain}
◊li{That the url of your CRM server is in your “Trusted Sites” list in Internet Explorer, and that the security level for “Trusted Sites” is set to “Low”.}
}

What’s happening is that IE has cached a username/password combo for the CRM server that is incorrect. It fails in the background, and gives up without ever letting you know what happened or giving you a chance to enter it correctly.

To fix it:

◊ol{
◊li{Go to Control Panel → User Accounts. Click the ◊code{Advanced} tab, and click “Manage Passwords”.}
◊li{If we’re on the right track, you will see an entry for the CRM server among the list of stored passwords. Go ahead and delete it.}
}
