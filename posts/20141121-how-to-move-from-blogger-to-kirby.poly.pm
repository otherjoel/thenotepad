#lang pollen

◊(define-meta title "How to move from Blogger to another CMS")
◊(define-meta published "2014-11-20")
◊(define-meta tags "Blogger,Kirby,Python")

When I started this blog it was at ◊link["http://blogger.com"]{Blogger}. I eventually decided I wanted to move the blog into a system I owned and controlled. I chose ◊link["http://getkirby.com/"]{Kirby} on a lark. It’s very simple; no database, just a collection of text files.

There are a lot of guides for moving from Blogger to Wordpress, but nothing about moving to any other type of blog. Nearly all of those guides are incomplete, but by adapting and adding to them I was able to achieve all my goals for the move:

◊ul{
◊item{Automatically migrate posts with their metadata into Kirby’s text format}
◊item{Make copies of all images in blog posts so they are included in the move}
◊item{Retain each blog post’s comments}
◊item{Automatically redirect posts at the old blog to the new one without loosing Google juice}
}

◊h2[#:id "migrating-posts-comments-and-images"]{1. Migrating Posts, Comments and Images}

First of all, download a copy of your Blogger blog: once logged in to Blogger, go to the dashboard for your blog, then click ◊noun{Settings} → ◊noun{Other}. There will be a link at the top to export your blog -- this will allow you to download a ◊code{.xml} file containing your entire blog, including your template, all configuration settings, posts and comments.

The bulk of my work in this projects was in writing a script to get the data I wanted out of that big hairy file.

The ◊link["https://github.com/otherjoel/blogger2kirby"]{◊code{blogger2kirby} script is on Github}. To use it you will need Python3 and a number of libraries installed -- there are simple instructions for this in the Readme file at Github.

Place the ◊code{.xml} file exported from Blogger in the same folder as the script, then open Terminal and run the script with the command ◊code{python3 blogger2kirby.py}.

The script will create a folder called ◊code{out} containing subfolders for each post. These subfolders are named using a straightforward pattern:

◊ul{
    ◊item{Old Blogger URL: ◊code{myblog.blogspot.com/2010/03/my-trip-to-philly.html}}
    ◊item{blogger2kirby output folder: ◊code{20100317-my-trip-to-philly}}
    ◊item{Resulting New Kirby URL: ◊code{mysite.com/blog/my-trip-to-philly}}}

Upload all these folders to the relevant content folder on your Kirby site and they will be available immediately.

The folders include copies of any images referenced in the post, and all image links in each post are converted to Kirby’s own format.

◊h2[#:id "redirecting-from-the-old-blog"]{2. Redirecting From the Old Blog}

Create a folder ◊code{blogger} on the server for your ◊emph{new} website, accessible at the URL ◊code{mysite.com/blogger}. Make a file in that folder called ◊code{index.php} and paste in this code:

◊blockcode{<?php
/* Make sure to replace mysite.com/blog below
   with your own blog address. /*

    $old_url = $_GET['q'];
    if ($old_url != "") {
        $tld_fix = preg_replace("/blogspot.[a-zA-Z0-9]+/", "blogspot.com", $old_url);
        $permalink = explode("blogspot.com", $tld_fix);

        $new_url = preg_replace('/.+?([^\/]+)\.html/', '$1', $permalink[1]);
        header ("HTTP/1.1 301 Moved Permanently");
        header("Location: http://mysite.com/blog/$new_url");
    } else {
        echo "<!DOCTYPE html><html><head><title>BOO</title></head><body><h1>BOO!</h1></body></html>";
    }
?>}

This creates a handler on your new blog that will take incoming requests from your old blog and point them to the correct location on the new blog:

◊blockcode{Incoming request: mysite.com/blogger/?q=http://myblog.blogspot.com/2010/03/my-trip-to-philly.html
Redirected to: mysite.com/blog/my-trip-to-philly}

Now that your new blog is ready to receive incoming hits, we’ll start redirecting your old blog.

You will need to revert to “Classic templates” on your old blogspot site.

Edit the template and past in the following code just before the ◊code{</head>} tag:

◊blockcode{<script>
<MainOrArchivePage>
    window.location.href='http://mysite.org/'
 </MainOrArchivePage>
<Blogger><ItemPage>
    window.location.href='http://mysite.com/blogger/?q=<$BlogItemPermalinkURL$>'
</ItemPage></Blogger>
</script>
<MainPage>
    <link rel="canonical" href="http://mysite.com/" />
</MainPage>
<Blogger><ItemPage>
    <link rel="canonical" href="http://mysite.com/blogger/?q=<$BlogItemPermalinkURL$>" />
</ItemPage></Blogger>}

This does two things.

◊ol{
◊item{It sets a ◊code{link rel="canonical"} tag for each page on your blog listing the new URL for that page on your new site. Several search engines (◊link["https://support.google.com/webmasters/answer/139066?hl=en"]{including Google}) use this tag to update their search results with the new URL instead of the old one. ◊strong{This ensures you continue to get traffic from search engines at the new blog instead of the old one.}}
◊item{It uses javascript to instantly redirect visitors to a page at your new blog.}
}

Once you’ve saved this template, any hit to any page on your old blog should magically land you at the new one.

I’d advise leaving the old blog in place for as long as possible (at least a year).

◊updatebox["4 Feb 2016"]{◊ul{◊item{I didn’t stick with Kirby, but this code still came in handy.}
◊item{Even with that redirect in place, my search traffic (and my ad clicks) ◊emph{totally tanked}.}}}
