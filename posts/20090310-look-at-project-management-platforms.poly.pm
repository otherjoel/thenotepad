#lang pollen

◊(define-meta title "A look at project management platforms")
◊(define-meta published "2009-03-10")
◊(define-meta tags "activeCollab,SharePoint,Basecamp,Project management")

I had a question from Stephen, and thought I’d post my response here for public benefit and/or comment. The core of the question:

◊blockquote{
◊emph{I am very interested in what happened in your quest for a good project management system. I started comparing Basecamp and SharePoint today, and I found some of your comments on a Joyent forum at ◊link["http://discuss.joyent.com/viewtopic.php?id=3982"]{http://discuss.joyent.com/viewtopic.php?id=3982} In that forum, you mentioned looking for a SharePoint alternative in Basecamp, then being totally turned off by Basecamp’s lack of functionality (too much eye candy!). Well, I am very interested in learning what happened next in your search.}
}

I think Basecamp or activeCollab could work well depending on your needs. I have experimented with ◊link["http://www.activecollab.com/"]{activeCollab}, which is a canned solution (but no longer open source). You can host it yourself, and might be just what you are looking for. It looks like it has come a long way since its beta testing days.

As far as what actually happened in my quest, we ended up sticking with SharePoint because we were sort of invested in it and there was no other self-hosted solution that worked well for sharing large amounts of files with the permissions control we needed.

It all comes down to, what do you need? A communications and scheduling tool? Or a document management and sharing tool? Basecamp and activeCollab do the former --- Basecamp is cute and works well for small projects, activeCollab looks like it would scale better for larger projects. SharePoint could be both (though it does neither thing ◊emph{well}) if everyone using it is an employee of the same company (because Sharepoint user accounts are linked directly to domain or local user accounts), but administering it for “outside” users is problematic at best for that very reason: you have to make every user of Sharepoint also a user somewhere on your internal corporate network.

◊strong{Where most solutions break down for me} is the perfect storm of requirements that any engineering firm runs into: the need to share ◊emph{large} groups of ◊emph{large} files with a large number of people from different companies, with a fine-grained level of control. That last requirement is a particularly hard one — take it out and a simple FTP site will do. (In fact, a lot of contractors do just that.) One tool that does ◊emph{just} file sharing that I was interested to see was ◊link["https://bigfilebox.com/pages/index"]{BigFileBox}. One of the founders told me it had been designed with A/E firms in mind (see my comments, and the founder’s response, on the forum ◊link["http://discuss.joyent.com/viewtopic.php?id=15712"]{here}). The only thing that precluded me from pursuing it was our requirement for hosting in-house. Also, engineering reproduction firms like ◊link["http://www.ersdigital.com/Services/PlanWellOnlineServices/ManageyourprojectwithPlanWell/tabid/93/Default.aspx"]{ERS Digital/PlanWell} have their own hosted platforms that can be tailored to anything requiring this kind of high-volume file sharing with versioning, fine-grained permissions, access tracking, etc. At the extreme end of this group is AutoDesk’s ◊link["http://usa.autodesk.com/adsk/servlet/index?siteID=123112&id=2407898"]{BuzzSaw}, which (last I checked) is prohibitively expensive for small- to mid-size firms.

Other than that, there is this ◊link["http://en.wikipedia.org/wiki/List_of_project_management_software"]{list of project management software}, but I of course have not experimented with any of those in depth. I don’t get the impression that industrial-quality file management is a big component of any of them, however. Finally, the biggest part of any solution is getting people to use it. If you can discern what your users really want (e.g., mainly want to shuffle files around, or track schedules), then it is probably better to find a tool that scratches just that one itch really well. Whereas more “comprehensive” products often require an overhaul of everyone’s workflow — if you are in a position to “sell” a new approach and get everyone to buy in on it and actually open up their browsers and ◊emph{use} it every day, so much the better.

◊h2[#:id "comments"]{Comments}

◊h3[#:id "jjriv-said"]{◊link["https://www.blogger.com/profile/15903971177129603875"]{jjriv} said:}

Another great alternative to Basecamp that includes more functionality is ◊link["http://www.myintervals.com"]{Intervals}. It includes time tracking, task management, and several other project management features that make it ideal for managing everything in one place.

(Comment posted March 16, 2009)

◊h3[#:id "tiajones-said"]{◊link["https://www.blogger.com/profile/17182939622668582660"]{tiajones} said:}

I wrote an article “Tips for Choosing a SharePoint Alternative” that you might find interesting. Check it out when you have a moment. Let me know what you think!

http://budurl.com/bpzj

Best,
Tia
http://budurl.com/bybt

(Comment posted June 07, 2009)
