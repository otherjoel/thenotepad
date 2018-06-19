#lang pollen

◊(local-require "util-topics.rkt" pollen/template pollen/pagetree pollen/private/version pollen/cache)
◊(define main-pagetree (cached-doc (string->path "index.ptree")))

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
            <table>
              ◊for/splice[([topic (in-list (topic-list))])]{
              <tr>
                <td><a name="#◊(car topic)">◊(car topic)</a></td>
                <td><ul>                   
                 ◊for/splice[([post (in-list (cdr topic))])]{
                  <li><a href="/◊(list-ref post 0)">◊(list-ref post 1)</a></li>
                 }</ul></td>
               </tr> 
                }
            </table>
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
