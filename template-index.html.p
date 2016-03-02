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
        <article>
        <header>
            <h1>◊(select-from-metas 'title latest-post)</h1>
            <p>Scribbled <a href="/" class="permlink"><time datetime="◊(select-from-metas 'published latest-post)" pubdate>◊(pubdate->english (select-from-metas 'published latest-post))</time></a>
            ◊when/splice[(select-from-metas 'updated latest-post)]{&middot; <em>Updated <time datetime="◊(select-from-metas 'updated latest-post)">◊(pubdate->english (select-from-metas 'updated latest-post))</time></em>}
            ◊when/splice[(pdfable? source-file)]{&middot;&nbsp;<a class="pdf" href="◊pdfname[source-file]">PDF</a>&nbsp;}
            &middot;&nbsp;<a href="◊|pollen-source-listing|" class="source-link">&loz;&nbsp;Pollen&nbsp;Source</a></p>
            ◊when/splice[(select-from-metas 'topics latest-post)]{<ul>
                ◊(map (λ(t-str)(->html `(li (a [[href ,(string-append "/topics.html#" t-str)]] "#" ,t-str))))
                      (string-split (select-from-metas 'topics latest-post) ","))</ul>}
        </header>

        ◊(map ->html (cdr (get-post-body latest-post)))
        </article>

        <section class="main">
            <h1>More Recent Posts</h2>
            <table class="post-list">
                ◊(map post->tablerow (cdr (posts-by-date-desc #:limit 10)))
            </table>
        </section>
        <footer class="main">
            <p>RSS &middot; <a href="mailto:joel@jdueck.net">joel@jdueck.net</a> &middot; <a href="https://twitter.com/joeld">@joeld</a>
            <br>Produced with <a href="http://pollenpub.com">Pollen</a>. Source code on Github. Valid HTML5 + CSS. </p>
        </footer>
    </body>
</html>
