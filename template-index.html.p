◊(local-require "util-date.rkt" "util-template.rkt")
<!DOCTYPE html>
<html lang="en" class="gridded">
    <head>
        <meta charset="utf-8">
        <title>◊(select-from-metas 'title here)</title>
        <link rel="stylesheet" href="/styles.css" media="screen" charset="utf-8">
    </head>
    <body>
        <header class="main">
            <p><a href="/" class="home">The Notepad</a>’s full of ballpoint hypertext</p>
            <nav>
                <ul>
                    <li><a href="/topics.html">Topics</a></li>
                    <li><a href="/books.html">Books</a></li>
                    <li><a href="/about.html">About</a></li>
                </ul>
            </nav>
        </header>

        ◊;(map ->html (select-from-doc 'body here))

        ◊(define latest-post (car (posts-by-date-desc #:limit 1)))
        ◊(define source-file (select-from-metas 'here-path latest-post))
        ◊(define pollen-source-listing
            (regexp-replace #px"(.*)\\/(.+).html" (symbol->string latest-post) "\\2.pollen.html"))
        <section class="main">
            <h1>More Recent Posts</h1>
            <table class="post-list">
                ◊(map post->tablerow (posts-by-date-desc #:limit 10))
            </table>
        </section>
        <footer class="main">
            <p><a href="/feed.xml">RSS</a> &middot; <a href="mailto:comments@thenotepad.org">comments@thenotepad.org</a> &middot; <a href="https://twitter.com/joeld">@joeld</a>
            <br>Produced with <a href="http://pollenpub.com">Pollen</a>. Source code <a href="https://github.com/otherjoel/thenotepad">on Github</a>. Valid HTML5 + CSS. </p>
        </footer>
    </body>
</html>
