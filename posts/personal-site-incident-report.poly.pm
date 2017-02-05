#lang pollen

◊(define-meta title "Site Incident Report")
◊(define-meta published "2017-02-04")
◊(define-meta topics "textpattern,web servers")

Important notice: last Tuesday night all my sites went offline. In the interests of extreme transparency, I present this complete incident report and postmortem.

◊section[#:id "impact"]{Impact}

◊ol{
◊item{All of my websites that still use Textpattern were broken from 11pm Jan 31 until about lunchtime the next day. (◊emph{The Notepad} does not use Textpattern and was mostly unaffected, except for #2 below.)}
◊item{All the traffic logged on all sites during that time was lost. So I have no record of how many people used my websites during the time that my websites were unusable.}
}

◊section[#:id "timeline"]{Timeline}

(All times are my time zone.)

◊ol{
◊item{◊strong{Tuesday Jan 31, late evening:} I logged into my web server and and noticed a message about an updated version of my Ubuntu distribution being available. I was in a good mood and ran the ◊code{do-release-upgrade} command, even knowing it would probably cause problems. Because breaking your personal web server’s legs every once in a while is a good way to learn stuff. If I’d noticed that this “update” proposed to take my server from version 14.04 all the way to 16.04, I’d have said ◊emph{Hell no}.}
◊item{In about half an hour the process was complete and sure enough, all my DB-driven sites were serving up ugly PHP errors.}
}

◊section[#:id "recovery"]{Recovery}

◊ol{
◊item{Soon determined that my Apache config referred to non-existant PHP5 plugin. Installed PHP7 because why the hell not.}
◊item{More errors. The version of Textpattern I was using on all these sites ◊link["http://forum.textpattern.com/viewtopic.php?id=46223"]{doesn’t work with PHP7}. Installed the latest version of Textpattern on one of the sites.}
◊item{Textpattern site still throwing errors because a few of my plugins didn’t like PHP7 either. Logged into the MySQL cli and manually disabled them in the database.}
◊item{Textpattern’s DB upgrade script kept failing because it ◊link["https://github.com/textpattern/textpattern/issues/694"]{doesn’t like something about my databases}. I began the process of hand-editing each of the tables in one of the affected websites.}
◊item{Sometime around midnight my brother texted asking me to drive over and take him in to the emergency room. I judged it best to get over there in a hurry so I closed up my laptop and did that. His situation is a little dicey right now; it was possible that when I got there I’d find him bleeding or dying. That wasn’t it, thankfully. By four in the morning they had him stabilized and I was able to drive home.}
◊item{◊strong{Morning of Feb 1st:} I got out of bed at around eight on the morning of Feb 1st, made myself some coffee and emailed my boss to tell him I wouldn’t be in the office until nine-thirty.}
◊item{After driving in to work, I remembered almost all of my websites were still busted. I started to think about the ramifications. I wondered if anyone had noticed. I opened Twitter for the first time since before the election and closed it again, appalled.}
◊item{At lunchtime I drove to the coffee shop for some more caffeine and a sandwich. I remember it got up to 30º F that day so I almost didn’t need a coat. After I ate my sandwich I pulled out my laptop and resumed poking around the same database and trying to swap in all the mental state from before the hospital trip.}
◊item{Towards the end of my lunch hour I decided that this wasn’t fun anymore. Maybe I could poke this one database until Textpattern would stop whining about it, but there was still the matter of the broken plugins, and then I’d have to go through the same rigmarole for the other three sites.}
◊item{Sometime between noon and 1pm I logged into my DigitalOcean dashboard and clicked a button to restore the automatic backup from 18 hours ago. In two minutes it was done and all the sites were running normally.}
}

◊section[#:id "problems-encountered"]{Problems Encountered}

◊ol{
◊item{In-place OS upgrades across major releases will always break your stack}
◊item{Textpattern 4.5.7 doesn’t support PHP7}
◊item{Textpattern 4.6.0 needs a bunch of hacks to work with newer versions of MySQL}
◊item{Emergency rooms always have so much waiting time in between tests and stuff}
}

◊section[#:id "post-recovery-followup-tasks"]{Post-Recovery Followup Tasks}

◊ol{
◊item{Leave the goddamn server alone}
◊item{Revisit shelved projects that involve getting rid of Textpattern and MySQL.}
}
