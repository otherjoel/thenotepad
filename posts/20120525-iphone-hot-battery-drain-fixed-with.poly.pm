#lang pollen

◊(define-meta title "The iPhone Hot Battery Drain, Fixed with a Lightweight Email Setup")
◊(define-meta published "2012-05-25")
◊(define-meta tags "email,battery,contacts,google,iphone")

Recently my iPhone 4S suddenly began exhibiting symptoms of the famous ◊link["http://www.loopinsight.com/2011/11/02/apple-confirms-battery-life-issues-in-ios-5/"]{“hot battery drain” problem}, where the phone would become much warmer to the touch then normal, the battery would drain more quickly, and the phone would charge much more slowly than normal.

It’s been known for some time now that this is often an iOS 5 bug caused by a contact sync process that gets out of hand◊numbered-note{No one seems to be sure why, however. The ◊link["http://www.macworld.com/article/1163200/troubleshoot_iphone4s_battery.html"]{most extensive troubleshooting that has been made public} seems to leave a lot of unanswered questions.}. In the process of fixing this problem for myself, I discovered an alternative to ◊link["http://lifehacker.com/5859854/how-to-set-up-gmail-google-calendar-and-google-contacts-on-ios"]{the commonly-used practice of using an extra Exchange account for syncing Gmail contacts}. This new setup has dramatically increased my battery life even beyond what it was before I started having the battery drain issue.

◊strong{Note:} I use Gmail, and I like all my contacts to be available from there. These instructions are thus somewhat Gmail-centric, but you should be able to improve your battery life by following the general principles shown. If you have tips for other email/contact setups, please let us all know in the comments.

First, solve the battery drain issue. The following steps solved the problem for me◊numbered-note{I based this off of ◊link["https://discussions.apple.com/thread/2481216?start=0&tstart=0"]{this thread at Apple support} — they seem to work even though they were posted as a solution to a similar problem that was before iOS 5}:

◊ol{
◊li{Remove all the messaging accounts on your phone, including iCloud. Remove all Calendars, Contacts, Notes and Bookmarks from the phone (so you don’t have duplicates when you re-add the accounts later).}
◊li{Power down your phone (the normal way, by holding down the power button and sliding to power off).}
◊li{Let it cool off, and start it up again.}
}

You now have a blank slate: no email, calendars, or contacts. A blank slate means a chance to clean up and streamline.

◊ol{
◊li{Re-add your iCloud account. Wait long enough for contacts and calendars to sync, check to make sure.}
◊li{Re-add your Gmail account ◊emph{as a Gmail account}. This means it will only pull in mail (and calendar), not contacts.}
◊li{Clean up your Gmail contacts by opening your contacts in Gmail (i.e., open the website on your computer), clicking the ◊noun{More} button at the top, and clicking ◊noun{Find and merge duplicates...}}
◊li{Purchase the ◊link["http://itunes.apple.com/us/app/contacts-sync-for-google-gmail/id451691288?mt=12"]{Contacts Sync For Google GMail} app. Yes it’s $4.99. It’s worth it.}
◊li{Run the app, making sure to read the User Guide to make sure it will be syncing contacts the way you want it to. (I used 2-way, so all my contacts live in both my iCloud and my Gmail accounts.)}
◊li{Finally, go to the Settings app, and go to the ◊noun{Mail, Contacts, Calendars} section. Click on ◊noun{Fetch New Data}. Make sure ◊noun{Push} is turned ◊strong{off}, and select the ◊noun{Hourly} fetch schedule.}
}

Now you have all your contacts synced by an app that knows how to do its job better than iOS does (seriously, check out the reviews), and you have an email connection that is lightweight and uses minimal battery life.

For what it’s worth, I also have an Exchange account for work that syncs mail, contacts, calendars and reminders — also on the hourly fetch schedule.

◊strong{Wait, won’t there be a big delay for receiving emails this way?} No, not really. The fact is that whenever you open an email inbox in the Mail app, your iPhone instantly re-checks the account for new mail anyway. The Fetch setting only limits the background checking that the phone does when you’re not looking, so setting it to hourly just means the red “new email” number on the Mail icon won’t update itself more than once an hour◊numbered-note{Seriously, how often do you really need to check your email? More than once an hour and I’d say you have serious productivity issues.}. You can always get an up-to-the-minute check by just opening the Mail app.

◊h2[#:id "comments"]{Comments}

◊h3[#:id "susan-said"]{◊link["https://www.blogger.com/profile/01163256334849940206"]{Susan} said:}

This was incredibly helpful and easy to follow (although I had to look up solutions separately on how to delete all my contacts from my iphone easily). I’m going to test it out over the next few days to see if power drain has been helped.

One follow up question: In the Info tab on Itunes for your iphone, what have you selected with regards to Syncing your contacts? Nothing? Is it just syncing with icloud?

(Comment posted September 05, 2012)

◊h3[#:id "matt-said"]{◊link["https://www.blogger.com/profile/14454517341881101636"]{Matt} said:}

Yes! THANK YOU! This was perfect and fixed my problem, along with getting all my contacts synced up and on my phone. Thanks for sharing!

(Comment posted September 13, 2012)

◊h3[#:id "joseph-dcruz-said"]{◊link["https://www.blogger.com/profile/10707415689731186668"]{Joseph D’Cruz} said:}

Google have just added the CardDAV protocol to their Google Contacts service, which means you can directly sync iOS devices with your Google contacts. There are instructions on the Google support site here:

◊link["http://support.google.com/mail/bin/answer.py?hl=en&amp;answer=2753077"]

(Comment posted September 27, 2012)

◊h3[#:id "malbino-said"]{◊link["https://www.blogger.com/profile/10784730407744980843"]{Malbino} said:}

Apple have replaced 2 iphones with this issue blaming it on bugs in apps.
I tried what u suggested and it worked.
brilliant.

(Comment posted November 14, 2012)

◊h3[#:id "yogesh-dandawate-said"]{◊link["https://www.blogger.com/profile/10517578576588077213"]{Yogesh Dandawate} said:}

Thanks for this ! Seems to work for mw

~Yogesh D. India

(Comment posted November 24, 2012)

◊h3[#:id "yogesh-nogia-said"]{◊link["https://www.blogger.com/profile/16888284555835013628"]{Yogesh Nogia} said:}

Hmmmm Im gonna try this on my iPhone4s. Cuz im having the same prblm. Thank

(Comment posted March 09, 2013)
