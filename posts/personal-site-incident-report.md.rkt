#lang punct notepad

---
title: Site Incident Report
date: 2017-02-04
topics: Textpattern,web servers
---

Important notice: last Tuesday night all my sites went offline. In the interests
of extreme transparency, I present this complete incident report and postmortem.

## Impact

1. All of my websites that still use Textpattern were broken from 11pm Jan 31
   until about lunchtime the next day. (*The Notepad* does not use Textpattern
   and was mostly unaffected, except for #2 below.)
2. All the traffic logged on all sites during that time was lost. So I have no
   record of how many people used my websites during the time that my websites
   were unusable.

## Timeline

(All times are my time zone.)

1. **Tuesday Jan 31, late evening:** I logged into my web server and and noticed
   a message about an updated version of my Ubuntu distribution being available.
   I was in a good mood and ran the `do-release-upgrade` command, even knowing
   it would probably cause problems. Because breaking your personal web server’s
   legs every once in a while is a good way to learn stuff. If I’d noticed that
   this “update” proposed to take my server from version 14.04 all the way to
   16.04, I’d have said *Hell no*.
2. In about half an hour the process was complete and sure enough, all my
   DB-driven sites were serving up ugly PHP errors.

## Recovery

1. Soon determined that my Apache config referred to non-existant PHP5 plugin.
   Installed PHP7 because why the hell not.
2. More errors. The version of Textpattern I was using on all these sites
   [doesn’t work with
   PHP7](http://forum.textpattern.com/viewtopic.php?id=46223). Installed the
   latest version of Textpattern on one of the sites.
3. Textpattern site still throwing errors because a few of my plugins didn’t
   like PHP7 either. Logged into the MySQL cli and manually disabled them in the
   database.
4. Textpattern’s DB upgrade script kept failing because it [doesn’t like
   something about my
   databases](https://github.com/textpattern/textpattern/issues/694). I began
   the process of hand-editing each of the tables in one of the affected
   websites.
5. Sometime around midnight my brother texted asking me to drive over and take
   him in to the emergency room. I judged it best to get over there in a hurry
   so I closed up my laptop and did that. His situation is a little dicey right
   now; it was possible that when I got there I’d find him bleeding or dying.
   That wasn’t it, thankfully. By four in the morning they had him stabilized
   and I was able to drive home.
6. **Morning of Feb 1st:** I got out of bed at around eight on the morning of
   Feb 1st, made myself some coffee and emailed my boss to tell him I wouldn’t
   be in the office until nine-thirty.
7. After driving in to work, I remembered almost all of my websites were still
   busted. I started to think about the ramifications. I wondered if anyone had
   noticed. I opened Twitter for the first time since before the election and
   closed it again, appalled.
8. At lunchtime I drove to the coffee shop for some more caffeine and a
   sandwich. I remember it got up to 30º F that day so I almost didn’t need a
   coat. After I ate my sandwich I pulled out my laptop and resumed poking
   around the same database and trying to swap in all the mental state from
   before the hospital trip.
9. Towards the end of my lunch hour I decided that this wasn’t fun anymore.
   Maybe I could poke this one database until Textpattern would stop whining
   about it, but there was still the matter of the broken plugins, and then I’d
   have to go through the same rigmarole for the other three sites.
10. Sometime between noon and 1pm I logged into my DigitalOcean dashboard and
    clicked a button to restore the automatic backup from 18 hours ago. In two
    minutes it was done and all the sites were running normally.

## Problems Encountered

1. In-place OS upgrades across major releases will always break your stack
2. Textpattern 4.5.7 doesn’t support PHP7
3. Textpattern 4.6.0 needs a bunch of hacks to work with newer versions of MySQL
4. Emergency rooms always have so much waiting time in between tests and stuff

## Post-Recovery Followup Tasks

1. Leave the goddamn server alone
2. Revisit shelved projects that involve getting rid of Textpattern and MySQL.
