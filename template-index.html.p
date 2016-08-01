◊(local-require racket/list)
◊(define (source-listing p)
    (regexp-replace #px"(\\.html$)" (symbol->string p) ".pollen.html"))
<!DOCTYPE html>
<html lang="en" class="gridded">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>◊(select-from-metas 'title here)</title>
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
    
        ◊(define top-ten
            (for/list ([post (in-list (take (posts-by-date-desc) 10))])
              `(article (header "\n" (h1 (a [[href ,(symbol->string post)]] ,(select-from-metas 'title post))) "\n"
                                (p "Scribbled " 
                                   (a [[class "permlink"] [href ,(symbol->string post)]]
                                      (time [[datetime ,(select-from-metas 'published post)]
                                             [pubdate "pubdate"]]
                                            ,(pubdate->english (select-from-metas 'published post))))
                                   nbsp middot nbsp
                                   (a [[class "pdf"] 
                                      [href ,(string-append "posts/" (pdfname (select-from-metas 'here-path post)))]] "PDF")
                                   nbsp middot nbsp
                                   (a [[class "source-link"] [href ,(source-listing post)]]
                                      loz nbsp "Pollen" nbsp "source")))
                        "\n\n" ,@(cdr (get-post-body post)))))
        ◊(map ->html (add-between top-ten '("\n\n" (hr)  "\n\n")))

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
