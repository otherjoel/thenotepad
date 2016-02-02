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
            <h1>Examples</h1>
            <ul>
            ◊(map (λ(node)(->html `(li (a [[href ,(symbol->string node)]] ,(select-from-metas 'title node)))))
              (children 'index.html))
            </ul>
            <pre class="code">◊(format "~a" (current-pagetree))</pre>
            ◊(map ->html (select-from-doc 'body here))
        </section>
        <footer class="main">
            <p>RSS &middot; <a href="mailto:joel@jdueck.net">joel@jdueck.net</a> &middot; <a href="https://twitter.com/joeld">@joeld</a>
            <br>Produced with <a href="http://pollenpub.com">Pollen</a>. Source code on Github. Valid HTML5 + CSS. </p>
        </footer>
    </body>
</html>
