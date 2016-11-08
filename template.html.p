◊(define path-prefix (if (string-contains (symbol->string here) "/") "../" ""))
◊(define source-file (select-from-metas 'here-path metas))
◊(define pollen-source-listing
    (regexp-replace #px"(\\.html$)" (symbol->string here) ".pollen.html"))
<!DOCTYPE html>
<html lang="en" class="gridded">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>◊(select-from-metas 'title here)</title>
        <link rel="stylesheet" href="/styles.css" media="screen">
    </head>
    <body>
        <header class="main">
            <p><a href="/index.html" class="home">The Notepad</a> <span class="tagline">is old&nbsp;and&nbsp;grody</span></p>
            <nav>
                <ul>
                    <li><a href="/topics.html">Topics</a></li>
                    <li><a href="/books.html">Books to Read</a></li>
                    <li><a href="/about.html">About</a></li>
                    <li><a href="/feed.xml" class="rss">Use&nbsp;RSS?</a></li>
                </ul>
            </nav>
        </header>

        <article>
            <header>
                <h1>◊(select-from-metas 'title here)</h1>
                <p>◊when/splice[(select-from-metas 'published here)]{Scribbled <a href="/◊(symbol->string here)" class="permlink"><time datetime="◊(select-from-metas 'published here)">◊(pubdate->english (select-from-metas 'published here))</time></a>}
                ◊when/splice[(select-from-metas 'updated here)]{&middot; <em>Updated <time datetime="◊(select-from-metas 'updated here)">◊(pubdate->english (select-from-metas 'updated here))</time></em>}
                ◊when/splice[(pdfable? source-file)]{&middot;&nbsp;<a class="pdf" href="◊pdfname[source-file]">PDF</a>&nbsp;}
                &middot;&nbsp;<a href="/◊|pollen-source-listing|" class="source-link">&loz;&nbsp;Pollen&nbsp;Source</a></p>
                ◊when/splice[(select-from-metas 'topics here)]{<ul>
                    ◊(map (λ(t-str)(->html `(li (a [[href ,(string-append "/topics.html#" t-str)]] "#" ,t-str))))
                          (string-split (select-from-metas 'topics here) ","))</ul>}
            </header>

◊(map ->html (select-from-doc 'body here))
        </article>
        <footer class="main">
            <ul>
                <li><a class="rss" href="/feed.xml">RSS</a></li>
                <li><a href="mailto:comments@thenotepad.org">comments@thenotepad.org</a></li>
                <li>Source code <a href="https://github.com/otherjoel/thenotepad">on Github</a></li>
                <li>Valid <a href="https://validator.w3.org/nu/?doc=https%3A%2F%2Fthenotepad.org%2F">HTML5</a> + CSS</li>
            </ul>
        </footer>
    </body>
</html>
