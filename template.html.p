◊(define source-file (select-from-metas 'here-path metas))
◊(define pollen-source-listing
    (regexp-replace #px"(.*)\\/(.+).html" (symbol->string here) "\\2.pollen.html"))
<!DOCTYPE html>
<html lang="en" class="gridded">
    <head>
        <meta charset="utf-8">
        <title>◊(select-from-metas 'title here)</title>
        <link rel="stylesheet" href="/styles.css" media="screen" charset="utf-8">
    </head>
    <body>
        <header class="main">
            <p><a href="/" class="home">The Notepad</a> is old and grody</p>
            <nav>
                <ul>
                    <li><a href="/topics.html">Topics</a></li>
                    <li><a href="/books.html">Books</a></li>
                    <li><a href="/about.html">About</a></li>
                </ul>
            </nav>
        </header>

        <article>
            <header>
                <h1>◊(select-from-metas 'title here)</h1>
                <p>Scribbled <a href="/" class="permlink"><time datetime="◊(select-from-metas 'published here)" pubdate>◊(pubdate->english (select-from-metas 'published here))</time></a>
                ◊when/splice[(select-from-metas 'updated here)]{&middot; <em>Updated <time datetime="◊(select-from-metas 'updated here)">◊(pubdate->english (select-from-metas 'updated here))</time></em>}
                ◊when/splice[(pdfable? source-file)]{&middot;&nbsp;<a class="◊|source-link|" href="pdf">PDF</a>&nbsp;}
                &middot;&nbsp;<a href="◊|pollen-source-listing|" class="source-link">&loz;&nbsp;Pollen&nbsp;Source</a></p>
                ◊when/splice[(select-from-metas 'tags here)]{<ul>
                    ◊(map (λ(t-str)(->html `(li (a [[href "#"]] "#" ,t-str))))
                          (string-split (select-from-metas 'tags here) ","))</ul>}
            </header>

            ◊(map ->html (select-from-doc 'body here))
        </article>
        <footer class="main">
            <p>RSS &middot; <a href="mailto:joel@jdueck.net">joel@jdueck.net</a> &middot; <a href="https://twitter.com/joeld">@joeld</a>
            <br>Valid HTML5 + CSS. Produced with <a href="http://pollenpub.com">Pollen</a>. Source code on Github.</p>
        </footer>
    </body>
</html>
