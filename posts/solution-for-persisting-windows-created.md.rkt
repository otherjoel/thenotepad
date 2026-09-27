#lang punct notepad

---
title: Solution for persisting ‘Windows created a temporary paging file on your computer’ error
date: 2011-08-18
topics: Windows problems,virtual memory
---

Solution for persisting “Windows created a temporary paging file on your
computer” error

My Windows 7 laptop began displaying a notification/error every time I logged
in:

> `Windows created a temporary paging file on your computer because of a problem that  occured with your paging file configuration when you started your computer. The total paging  file size for all disk drives may be somewhat larger than the size you specified`

After clicking OK, it would open the virtual memory settings without any
explanation of what you were supposed to check or do there.

This evidently happens because `pagefile.sys`, the file that Windows uses for
virtual memory, has become corrupted in some way.

[This Microsoft Answers
article](http://answers.microsoft.com/en-us/windows/forum/windows_7-performance/windows-7-virtual-memory-keeps-resetting-on/e7ba857a-ba74-4978-9ea7-0c929f75a19d)
recommends running a system file check. Here’s [how to run an
SFC](http://support.microsoft.com/kb/936212/en-us). This did not solve the
problem for me, but it is something you should try first.

Here’s how I cleared it up:

1. Log in under a local Administrator account. (Do this after each restart in
   these instructions as well.)

2. If it’s not already open, open the virtual memory settings by rich-clicking
   on Computer, → `Properties` → `Advanced System Settings` → click the
   `Advanced` tab → Under Performance, click `Settings`, go to `Advanced` tab,
   finally under Virtual Memory section click the `Change` button.

3. Uncheck the `Autmatically manage paging file size for all drives` checkbox.

4. Set a “Custom size” for the paging file on the C drive: 0MB initial, 0MB
   maximum.

5. Click OK, close all dialog boxes, and restart your computer.

6. After logging in again, delete the file `C:\pagefile.sys`

   1. To do this, you may need to change your folder settings so you can see it
      first. Open a window of your C: drive and click `Organize` at the top,
      then `Folder and Search Options`
   2. Click the `View` tab, and make sure
      `Show hidden files, folders and drives` is turned on, and that
      `Hide protected system files` is **not** checked.
   3. Click OK and go back to your C: drive, find `pagefile.sys` and delete it.

7. Now go back to the virtual memory settings (see step 2 above) and set the
   paging file for the C: drive to `System managed size`, and then make sure the
   `Automatically manage paging file size for all drives` checkbox is
   **checked**.

8. Click OK, close all dialog boxes, and restart your computer.

**A summary of what this does:** By temporarily turning off virtual memory, you
allow yourself to delete the (now-corrupt) paging file. Then when you re-enable
virtual memory, Windows automatically builds a new paging file from scratch, and
*voilà*, problem solved.

I was helped by [this thread at
geekstogo.com](http://www.geekstogo.com/forum/topic/41071-paging-file-is-gone%3B-correspondng-error-at-startup/)
although I did not find it necessary to do any editing of the Registry or any of
that jazz. Try the simplest solution first, I always say.

•comment[#:author "Dave" #:date "January 10, 2012" #:link "https://www.blogger.com/profile/17498737960581332989"]{
Thank you, That worked for me, thx for taking the time to make a webpage for
this, awesome!
}

•comment[#:author "sam" #:date "May 23, 2012" #:link "https://www.blogger.com/profile/05266122372721852797"]{
cant find pagefile.sys
}

•comment[#:author "Aygo Blogs" #:date "July 17, 2012" #:link "https://www.blogger.com/profile/14933439453417472703"]{
It dosen’t work. When I delete pagefile.sys it said This action can’t be
completed because the file was open in another program
}

•comment[#:author "Eddie" #:date "August 07, 2012" #:link "https://www.blogger.com/profile/04802276480486889180"]{
YES! Big thanks to you as this was driving me Nucking Futs!! Followed each step
as described, and it killed the “Windows has created…” crapola, and restored
what’s left of any remaining sanity… sincere appreciation.
}

•comment[#:author "Raul Junior" #:date "October 11, 2012" #:link "https://www.blogger.com/profile/15061192096353164554"]{
Aygo,

I had the same problem, and I was able to delete the file by restarting on Safe
Mode. Hope it helps!
}

•comment[#:author "schilbach" #:date "April 09, 2013" #:link "http://schilbach.wordpress.com/"]{
Thanks for this…more help than MS documentation…

Came across this whilst trying to free more space which people may find
helpful - turning off hibernation:

[http://www.howtogeek.com/howto/15140/what-is-hiberfil.sys-and-how-do-i-delete-it/](http://www.howtogeek.com/howto/15140/what-is-hiberfil.sys-and-how-do-i-delete-it/)
}

•comment[#:author "Prof. Sancho Panza" #:date "May 22, 2013" #:link "https://www.blogger.com/profile/11688178243832561724"]{
Thank you for this! I’d tried several other solutions, including both the SFC
and the “sc config afs start= disabled” command, and none of them worked. This
one did - and better still, I actually understood what I was doing!
}

•comment[#:author "naveenvarshan" #:date "June 25, 2013" #:link "http://naveenvarshan.wordpress.com/"]{
Even if I start in safe mode, I am not able to delete it. Please help
}

•comment[#:author "Gabriel Gunawan" #:date "October 17, 2013" #:link "https://www.blogger.com/profile/14020288305534476060"]{
Look carefully that you unchecked “Hide protected operating system files”.
Couldn’t find it the first time, but then I realized I’ve overlooked this
option.
}

•comment[#:author "SiKuple" #:date "October 27, 2013" #:link "https://www.blogger.com/profile/11851475628690360716"]{
so do i, Even if I start in safe mode, I am not able to delete it. Please help
}

•comment[#:author "Joel A." #:date "October 28, 2013" #:link "https://www.blogger.com/profile/13646393468637062885"]{
If you can’t delete pagefile.sys (gives “in use by another program” error), make
sure you’re running Explorer with Admin priviledges: close your Explorer window,
then open Start menu, type “explorer” in search, SHIFT-right-click on the
Windows Explorer in the results, and click “Run as Administrator”.
}

•comment[#:author "SiKuple" #:date "October 31, 2013" #:link "https://www.blogger.com/profile/11851475628690360716"]{
still not work, i’ve closed the explorer first, and then i open windows and
typed “explorer” then i press shift with right klicked at \&quot;quot; Windows
Explorer\&quot;quot; and “RUN AS ADMIN” then find the pagefile.sys delete and
then… ZONK, STILL use by program
}

•comment[#:author "SiKuple" #:date "October 31, 2013" #:link "https://www.blogger.com/profile/11851475628690360716"]{
even i choose windows explorer and RUN it as ADMIN i still cant delete
pagefile.sys
}

•comment[#:author "J.Balboa" #:date "March 30, 2014" #:link "https://www.blogger.com/profile/03316507853791461184"]{
I cannot delete the pagifile.sys either. I am always the admin on my computer,
moreover, I still went ahead and SHIFT+right-clicked the explorer and I don’t
get that “Run as admin…” option. This file is indestructible.

What else do you recommend? Is there a program running in the background (a
“process” in the “Task Manager”) that I should kill first?
}

•comment[#:author "mizzuhh" #:date "August 27, 2014" #:link "https://www.blogger.com/profile/04561100263697843549"]{
maraming salamat, that worked

–mza.
}

•comment[#:author "Tammy" #:date "September 13, 2014" #:link "https://www.blogger.com/profile/09487479834848996888"]{
I am getting this problem too. I’ve followed ALL of the instructions here, but
when I go back and click the automatically manage box and reboot, the system
doesn’t create a paging file, it just shows everything grayed out and it says no
paging file. Ugh and Grrrrr
}

•comment[#:author "Johan Kotze" #:date "October 27, 2015" #:link "https://www.blogger.com/profile/14621006434624043591"]{
Good day just to add to this…

If you running an HyperV Gen1 VM and getting this message please check that the
VHD is not mounted as an ISCSI drive or else the problem will also persist. it
needs to be mounted as an Traditional hard drive for the OS to write the
Pagefile.
}

•comment[#:author "adrian no" #:date "January 07, 2016" #:link "https://www.blogger.com/profile/17277708789116383763"]{
Yep. works fine.. Thanks
}
