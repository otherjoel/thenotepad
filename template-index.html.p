◊(local-require "util-template.rkt")

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
        <section class="main">
        ◊(map ->html (select-from-doc 'body here))

        <table class="post-list">
            ◊(map post->tablerow (posts-by-date-desc #:limit 10))
        </table>
        </section>
        <footer class="main">
            <p>RSS &middot; <a href="mailto:joel@jdueck.net">joel@jdueck.net</a> &middot; <a href="https://twitter.com/joeld">@joeld</a>
            <br>Produced with <a href="http://pollenpub.com">Pollen</a>. Source code on Github. Valid HTML5 + CSS. </p>
        </footer>
    </body>
</html>
