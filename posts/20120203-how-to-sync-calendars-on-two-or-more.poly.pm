#lang pollen

◊(define-meta title "How to Sync Calendars on Two (or more) iPhones or iPads")
◊(define-meta published "2012-02-03")
◊(define-meta tags "iCloud,iOS,iPhone,calendars")

My wife and I each use an iPhone, but it wasn’t until recently that I got around to syncing our calendars. Now that we actually have a synced calendar system that we can both view and update from our phones, we’ve begun actually using it for planning and apponintments. In this how-to, I’ll show you how to do the same thing for yourself.

◊margin-note{If you happen to be using the same Apple ID/iCloud account on two phones, I would assume you don’t need this article since everything is already syncing across all devices within your single account.} These instructions assume that each iPhone user has their own, separate Apple ID and iCloud.

◊h2[#:id "use-icloud-for-your-calendar-account"]{1. Use iCloud for Your Calendar Account}

I’m not saying you ◊emph{have} to use iCloud. I’m saying it’s by far the simplest and easiest way.

Make sure each user has iCloud set up on his or her device. If you have iOS 5 or newer on your phone or iPad, you likely have signed up for iCloud: to make sure, grab your device and go to ◊code{Settings} → ◊code{iCloud} and check that it shows something next to ◊code{Account}. Also check that ◊code{Calendars} is set to ◊strong{On}.

If iCloud is not set up on your device, read these ◊link["http://www.apple.com/icloud/setup/"]{simple iCloud setup instrctions} from Apple.

◊h3[#:id "other-calendar-accounts"]{Other Calendar Accounts}

◊strong{Gmail accounts} come with a pretty useable calendar system, so a lot of people use those; but I found the instructions and process for syncing GMail calendars between multiple Google accounts/iPhones very clumsy, complicated, and unintuitive, even for a geek like myself. If you have tips on that, let us know in the comments.

◊strong{Exchange accounts} also include calendar functionality. I have one of these at my job, and it syncs to my phone also, but I don’t really need to share it with my wife so I haven’t tried. I expect the only way to do this would be to add my exchange account to her phone with my own password, and turn off the mail part of the account in the iPhone’s settings. Again, let us know in the comments if you’ve experimented with this.

◊h2[#:id "share-your-icloud-calendars"]{2. Share Your iCloud Calendar(s)}

This is an easy process, but not entirely obvious because you have to use a laptop/desktop computer, and not your iOS device, to start the process.

◊ol{
◊li{First of all, pick which iCloud account is going to “own” the shared calendar(s). It really makes no difference because both parties will have full access.}
◊li{Open your web browser on your desktop or laptop computer and go to ◊link["http//icloud.com"]{icloud.com}.}
◊li{Sign in using the account of the “owner” and click on ◊code{Calendar}.}
◊li{Click on the small circle to the right of the calendar you wish to share. Under ◊code{Private Calendar}, enter the email address for the user of the “other” iPhone/iPad. It can be any email address for that person (it doesn’t have to be the one they use to sign in to iCloud) but it should be one that they have set up on their iPhone/iPad.
◊figure["/img/20120203icloudsharing1.jpg"]{iCloud sharing}}
◊li{After entering the email address, click ◊code{Share}.}
}

Now the other user can grab his or her device, open the email, and click the “Join Calendar” button.

Voila, you now have a calendar shared between two devices. Any events or appointments you create or change on the shared calendar on one device will automatically show up on the other device pretty quickly, and without any additional steps.

◊h3[#:id "some-additional-notes"]{Some additional notes:}

◊ul{
◊li{You can of course share multiple calendars with this process, and you can even share them with different multiple people. My wife and I share three calendars, because this allows us to easily colour-code different kinds of events simply by putting them on different calendars. (There are some calendar apps that let you colour-cde different events within the same calendar, but not the one we happen to use.)}
◊li{When creating/changing an event that you want shared, you do have to make sure it is in fact created on one of the shared calendars. That should seem obvious, but it can be an easy step to miss. You can make it easier for yourself by setting your ◊emph{default} calendar on your iOS device to the shared calendar you use most often: click ◊code{Settings}, then ◊code{Mail, Contacts, Calendars}, and then ◊emph{scroll down} to the Calendars section and click on the ◊code{Default Calendars} setting to change it. Otherwise (if you’d rather not default to sharing all your events) just be aware that your iOS device does have multiple calendars and remember to pick the right one when setting up an appointment.

◊ul{
◊li{If you use Calvetica Classic as your calendar app, you can have it ask you which calendar to use every time you set up an event, which is nice.}
}}
}

◊h2[#:id "get-a-better-calendar-app"]{3. Get a Better Calendar App}

The calendar app that comes with iOS is plain, and has many shortcomings: the interface for creating new appointments is clumsy, the colour-coding is not visible in month view, and there’s no week view at all, to name a few. For notes and recommendations on iOS calendar apps, read my post on ◊link["20120203-recommended-calendar-apps-for-iphone.html"]{iOS Calendar App Recommendations}.

◊h2[#:id "comments"]{Comments}

◊h3[#:id "brent-said"]{◊link["https://www.blogger.com/profile/15089526498016743276"]{Brent} said:}

I wonder if you have tried Cozi. It seems to be the best ”family” calendering service I have found. It has clients for iOS, Android etc, and is fairly simple to sty up and use.

(Comment posted February 03, 2012)

◊h3[#:id "fitzage-said"]{◊link["https://www.blogger.com/profile/13811974447327211236"]{fitzage} said:}

My wife and I have a shared iCloud account because this is the best way to share Photo Stream and Contacts. Then we each have separate accounts as well.

We share a joint calendar on the shared account, and then we have individual calendars that we share with each other on our individual accounts. We then have the option to set these shared ones to not give us notifications for the other person’s calendar, which has really been a big benefit. We wouldn’t really need the joint iCloud account to do the joint calendar, but I figured I may as well do it that way since we were using the joint account anyway.

My thoughts about the whole thing ◊link["http://fitzage.com/article/thoughts-on-a-multi-user-icloud-setup"]{are here}. There are pros and cons to this setup, and I’m still not 100% sure it’s the best, but it’s working for us now.

(Comment posted February 03, 2012)

◊h3[#:id "joel-a.-said"]{◊link["https://www.blogger.com/profile/13646393468637062885"]{Joel A.} said:}

Brent, Cozi looks interesting. I wonder, does its iOS app integrate with the iOS calendar system, or does it maintain its own completely separate calendar? I can think of pros and cons to either approach.

(Comment posted February 03, 2012)

◊h3[#:id "joel-a.-said-1"]{◊link["https://www.blogger.com/profile/13646393468637062885"]{Joel A.} said:}

Fitzage, I didn’t even realize you could have multiple iCloud accounts. I assume the additional shared account is set up by going through Settings - Mail/Contacts/Calendars, clicking Add Account and creating a new Apple ID? (Frankly the relationship between Apple IDs and iCloud accounts is still rather fuzzy to me)

(Comment posted February 03, 2012)

◊h3[#:id "brent-said-1"]{◊link["https://www.blogger.com/profile/15089526498016743276"]{Brent} said:}

Joel, it’s a separate calendar, but you can export a read only ical that can be imported into the iOS calendar. I haven’t actually tried to set this up yet.

(Comment posted February 03, 2012)

◊h3[#:id "todd-beard-said"]{◊link["https://www.blogger.com/profile/07262557618352583388"]{Todd Beard} said:}

What a great help this was. We’d not realized an old email address was in the icloud id and then presto, sharing our dates.
Thank you for being there for us.

(Comment posted September 06, 2014)
