#lang pollen

◊(local-require "util-topics.rkt" pollen/template pollen/pagetree pollen/private/version)
◊(define main-pagetree (dynamic-require "index.ptree" 'doc))

<!DOCTYPE html>
<html lang="en" class="gridded">
    <head>
        <meta charset="utf-8">
        <meta name="generator" content="Racket ◊(version) + Pollen ◊|pollen:version|">
        <title>Topics (The Notepad)</title>
        <link rel="stylesheet" href="/styles.css" media="screen">
    </head>
    <body>
        <header class="main">
            <p><a href="/" class="home">The Notepad</a>’s full of ballpoint hypertext</p>
            <nav>
                <ul>
                    <li><a href="/topics.html">Topics</a></li>
                    <li><a href="/books.html">Books to Read</a></li>
                    <li><a href="/about.html">About</a></li>
                    <li><a href="/feed.xml" class="rss" title="Subscribe to feed">Use RSS?</a></li>
                </ul>
            </nav>
        </header>
        <section class="main">
            ◊; Get two lists: one of all index links in the current pagetree,
            ◊; another of all the unique headings used in the first list.
            ◊(define tlinks (collect-index-links (children 'index.html main-pagetree)))
            ◊(define topics (index-headings tlinks))
            <dl class="topic-list">
                ◊(define (ddlink lnk) `(dd ,lnk))
                ◊(->html (apply append (for/list([topic topics])
                                         `((dt (a [[href ,(string-append "#" topic)]
                                                   [name ,topic]] ,topic))
                                           ,@(map ddlink (match-index-links topic tlinks))))))
            </dl>
        </section>
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
