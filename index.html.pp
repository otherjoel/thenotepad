#lang pollen
◊(current-pagetree (dynamic-require "index.ptree" 'doc))
◊(require racket/list pollen/pagetree pollen/template pollen/private/version)
<!DOCTYPE html>
<html lang="en" class="gridded">
    <head>
        <meta charset="utf-8">
        <meta name="generator" content="Racket ◊(version) + Pollen ◊|pollen:version|">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>The Notepad</title>
        <link rel="stylesheet" href="/styles.css" media="screen">
        ◊|meta-favicons|
    </head>
    <body>
        <header class="main">
            <p><a href="/" class="home">The Notepad</a> <span class="tagline">’s full&nbsp;of&nbsp;ballpoint&nbsp;hypertext</span></p>
            <nav>
                <ul>
                    <li class="current-section"><a href="/topics.html">Topics</a></li>
                    <li><a href="/books.html">Books to Read</a></li>
                    <li><a href="/about.html">About</a></li>
                    <li><a href="/feed.xml" class="rss" title="Subscribe to feed">Use RSS?</a></li>
                </ul>
            </nav>
        </header>
        
        ◊(let* ([top-ten (take (posts-by-date-desc) 10)]
                [top-ten-formed (map post-format top-ten)])
               (apply string-append 
                      (map ->html (add-between top-ten-formed '("\n\n" (hr)  "\n\n")))))

        <footer class="main">
            <ul>
                <li><a href="/feed.xml" class="rss" title="Subscribe to feed">RSS</a></li>
                <li><a href="mailto:comments@thenotepad.org">comments@thenotepad.org</a></li>
                <li>Source code <a href="https://github.com/otherjoel/thenotepad">on Github</a></li>
                <li>Valid <a href="https://validator.w3.org/nu/?doc=https%3A%2F%2Fthenotepad.org%2F">HTML5</a> + CSS</li>
            </ul>
        </footer>
    </body>
</html>
