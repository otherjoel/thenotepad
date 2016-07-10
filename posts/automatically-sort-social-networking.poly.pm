#lang pollen

◊(define-meta title "Automatically sort social networking notifications in your Gmail")
◊(define-meta published "2009-03-11")
◊(define-meta topics "email,Gmail")

◊figure["image202.jpg"]{My inbox, full of ◊link["http://www.npr.org/templates/story/story.php?storyId=14032271"]{bacn}}

If you’re like a lot of people nowadays, notification emails from Twitter and Facebook and their ilk have rapidly overtaken your “real” personal correspondence in terms of sheer bulk. It’s not spam, but if you want to still get these emails then you could probably use a way to deal with it more efficiently. What I do in GMail is use a filter. Any email from social networking sites is given the “social” label and archived, but left unread. This means the email never lands in my inbox with the rest of my mail, but I can still quickly see if there are any new messages and read them separately if I like. In GMail, go to Settings, then Filters, then click Create a new filter at the bottom. Use the following text in the “Has Words” field:

◊blockcode{from:{ facebookmail.com twitter.com vimeo.com facebookappmail.com linkedin.com flickr.com }}

Set it to ◊noun{Skip inbox} and ◊noun{Apply label: social} (or whatever label you choose to create for the purpose). Make sure you add in any domains of social networking sites you use that aren’t already incuded above! I’m not the first one to figure this out and ◊link["http://lifehacker.com/291688/how-do-you-handle-bacn"]{everyone has their own method}, but I thought I’d leave it here for anyone who might find it handy.
