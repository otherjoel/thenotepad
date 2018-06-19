◊(define path-prefix (if (string-contains (symbol->string here) "/") "../" ""))
◊(define source-file (select-from-metas 'here-path metas))
◊(define pollen-source-listing
    (regexp-replace #px"(\\.html$)" (symbol->string here) ".pollen.html"))
◊(local-require pollen/private/version)
◊(init-db)
◊(define doc-body (->html (select-from-doc 'body here)))
◊(define doc-header (->html (post-header here metas)))
◊(save-post here metas doc-header doc-body)
<!DOCTYPE html>
<html lang="en" class="gridded">
    <head>
        <meta charset="utf-8">
        <meta name="generator" content="Racket ◊(version) + Pollen ◊|pollen:version|">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>◊(select-from-metas 'title here)</title>
        <link rel="stylesheet" href="/styles.css" media="screen">
        ◊|meta-favicons|
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
            ◊doc-header
            ◊doc-body
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
