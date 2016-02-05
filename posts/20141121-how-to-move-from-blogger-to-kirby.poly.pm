#lang pollen

◊(define-meta title "")
◊(define-meta published "")


◊h2[#:id "title-how-to-move-from-blogger-to-another-cms"]{Title: How to move from Blogger to another CMS}

◊h2[#:id "tags-blogger-kirby"]{Tags: blogger, kirby}

◊h2[#:id "date-2014-11-20"]{Date: 2014-11-20}

Text: When I started this blog it was at ◊link["http://blogger.com"]{Blogger}. I eventually decided I wanted to move the blog into a system I owned and controlled. I chose ◊link["http://getkirby.com/"]{Kirby} on a lark. It&#39;s very simple; no database, just a collection of text files.

There are a lot of guides for moving from Blogger to Wordpress, but nothing about moving to any other type of blog. Nearly all of those guides are incomplete, but by adapting and adding to them I was able to achieve all my goals for the move:

◊ul{
◊li{Automatically migrate posts with their metadata into Kirby&#39;s text format}
◊li{Make copies of all images in blog posts so they are included in the move}
◊li{Retain each blog post&#39;s comments}
◊li{Automatically redirect posts at the old blog to the new one without loosing Google juice}
}

◊h2[#:id "migrating-posts-comments-and-images"]{1. Migrating Posts, Comments and Images}

First of all, download a copy of your Blogger blog: once logged in to Blogger, go to the dashboard for your blog, then click ◊code{Settings} → ◊code{Other}. There will be a link at the top to export your blog -- this will allow you to download a ◊code{.xml} file containing your entire blog, including your template, all configuration settings, posts and comments.

The bulk of my work in this projects was in writing a script to get the data I wanted out of that big hairy file.

The ◊link["https://github.com/otherjoel/blogger2kirby"]{◊code{blogger2kirby} script is on Github}. To use it you will need Python3 and a number of libraries installed -- there are simple instructions for this in the Readme file at Github.

Place the ◊code{.xml} file exported from Blogger in the same folder as the script, then open Terminal and run the script with the command ◊code{python3 blogger2kirby.py}.

The script will create a folder called ◊code{out} containing subfolders for each post. These subfolders are named using a straightforward pattern:

◊blockcode{Old Blogger URL: myblog.blogspot.com/2010/03/my-trip-to-philly.html
blogger2kirby output folder: 20100317-my-trip-to-philly
Resulting New Kirby URL: mysite.com/blog/my-trip-to-philly}

Upload all these folders to the relevant content folder on your Kirby site and they will be available immediately.

The folders include copies of any images referenced in the post, and all image links in each post are converted to Kirby&#39;s own format.

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

Now that your new blog is ready to receive incoming hits, we&#39;ll start redirecting your old blog.

You will need to revert to &quot;Classic templates&quot; on your old blogspot site.

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
◊li{It sets a ◊code{link rel="canonical"} tag for each page on your blog listing the new URL for that page on your new site. Several search engines (◊link["https://support.google.com/webmasters/answer/139066?hl=en"]{including Google}) use this tag to update their search results with the new URL instead of the old one. ◊strong{This ensures you continue to get traffic from search engines at the new blog instead of the old one.}}
◊li{It uses javascript to instantly redirect visitors to a page at your new blog.}
}

Once you&#39;ve saved this template, any hit to any page on your old blog should magically land you at the new one.

I&#39;d advise leaving the old blog in place for as long as possible (at least a year).
