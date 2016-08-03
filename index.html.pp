#lang pollen
◊(current-pagetree (dynamic-require "index.ptree" 'doc))
◊(require racket/list pollen/pagetree pollen/template)
<!DOCTYPE html>
<html lang="en" class="gridded">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>The Notepad</title>
        <link rel="stylesheet" href="/styles.css" media="screen" charset="utf-8">
    </head>
    <body>
        <header class="main">
            <p><a href="/" class="home">The Notepad</a>’s full of ballpoint hypertext</p>
            <nav>
                <ul>
                    <li class="current-section"><a href="/topics.html">Topics</a></li>
                    <li><a href="/books.html">Books to Read</a></li>
                    <li><a href="/about.html">About</a></li>
                </ul>
            </nav>
        </header>
        
        ◊(let* ([top-ten (take (posts-by-date-desc) 10)]
                [top-ten-formed (map post-format top-ten)])
               (apply string-append 
                      (map ->html (add-between top-ten-formed '("\n\n" (hr)  "\n\n")))))

        <footer class="main">
            <ul>
                <li class="rss"><a href="/feed.xml">RSS</a></li>
                <li><a href="mailto:comments@thenotepad.org">comments@thenotepad.org</a></li>
                <li><a href="https://twitter.com/joeld">@joeld</a></li>
                <li>Produced with <a href="http://pollenpub.com">Pollen</a></li>
                <li>Source code <a href="https://github.com/otherjoel/thenotepad">on Github</a></li>
                <li>Valid HTML5 + CSS</li>
            </ul>
        </footer>
    </body>
</html>
