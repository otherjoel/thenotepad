#lang racket/base

(require racket/string
         racket/path
         pollen/core
         net/uri-codec
         "util-date.rkt"
         txexpr)

(provide (all-defined-out))

(define (pdfable? file-path)
  (string-contains? file-path ".poly"))

(define (pdfname page) (string-replace (path->string (file-name-from-path page))
                                       "poly.pm" "pdf"))
                                       
(define (source-listing p)
  (regexp-replace #px"(\\.html$)" (symbol->string p) ".pollen.html"))

(define (post-header post metas)
  (define updated (select-from-metas 'updated metas))
  (define updated-xexpr
    (cond [updated `((em "Updated " (time [[datetime ,updated]] ,(pubdate->english updated))) nbsp middot nbsp)]
          [else '("")]))

  (define topics (select-from-metas 'topics metas))
  (define topics-xexpr
    (cond [topics
           (define topic-listitems
             (map (λ(t) `(li (a [[href ,(string-append "/topics.html#" (uri-encode t))]] ,t)))
                  (string-split (regexp-replace* #px"\\s*,\\s*" topics ",") ",")))
           `(ul ,@topic-listitems)]
          [else ""]))
  (define timestamp-raw (select-from-metas 'published metas))
  (define timestamp
    (cond [timestamp-raw
           `("Scribbled " 
             (time [[datetime ,timestamp-raw]]
                   ,(pubdate->english timestamp-raw))
             nbsp middot nbsp)]
          [else '("")]))
  (define pdflink
    (cond [(string-prefix? (symbol->string post) "posts")
           `((a [[class "pdf"]
                 [href ,(string-append "/posts/" (pdfname (select-from-metas 'here-path metas)))]]
                "PDF") nbsp middot nbsp)]
          [else '("")]))
  `(header
    (h1 (a [[href ,(string-append "/" (symbol->string post))]] ,(select-from-metas 'title metas)))
    (p ,@timestamp
       ,@updated-xexpr
       ,@pdflink
       (a [[class "source-link"] [href ,(string-append "/" (source-listing post))]]
          loz "Pollen" nbsp "source"))
    ,topics-xexpr))

(define (split-body-comments post-doc)
  (define (is-comment? tx)
    (and (txexpr? tx)
         (eq? (get-tag tx) 'section)
         (attrs-have-key? tx 'class)
         (string=? (attr-ref tx 'class) "comments")))

  (splitf-txexpr post-doc is-comment?))

(define meta-favicons
  "<link rel=\"apple-touch-icon-precomposed\" sizes=\"57x57\" href=\"/css/favicon/apple-touch-icon-57x57.png\" />
    <link rel=\"apple-touch-icon-precomposed\" sizes=\"114x114\" href=\"/css/favicon/apple-touch-icon-114x114.png\" />
    <link rel=\"apple-touch-icon-precomposed\" sizes=\"72x72\" href=\"/css/favicon/apple-touch-icon-72x72.png\" />
    <link rel=\"apple-touch-icon-precomposed\" sizes=\"144x144\" href=\"/css/favicon/apple-touch-icon-144x144.png\" />
    <link rel=\"apple-touch-icon-precomposed\" sizes=\"60x60\" href=\"/css/favicon/apple-touch-icon-60x60.png\" />
    <link rel=\"apple-touch-icon-precomposed\" sizes=\"120x120\" href=\"/css/favicon/apple-touch-icon-120x120.png\" />
    <link rel=\"apple-touch-icon-precomposed\" sizes=\"76x76\" href=\"/css/favicon/apple-touch-icon-76x76.png\" />
    <link rel=\"apple-touch-icon-precomposed\" sizes=\"152x152\" href=\"/css/favicon/apple-touch-icon-152x152.png\" />
    <link rel=\"icon\" type=\"image/png\" href=\"/css/favicon/favicon-196x196.png\" sizes=\"196x196\" />
    <link rel=\"icon\" type=\"image/png\" href=\"/css/favicon/favicon-96x96.png\" sizes=\"96x96\" />
    <link rel=\"icon\" type=\"image/png\" href=\"/css/favicon/favicon-32x32.png\" sizes=\"32x32\" />
    <link rel=\"icon\" type=\"image/png\" href=\"/css/favicon/favicon-16x16.png\" sizes=\"16x16\" />
    <link rel=\"icon\" type=\"image/png\" href=\"/css/favicon/favicon-128.png\" sizes=\"128x128\" />
    <meta name=\"application-name\" content=\"&nbsp;\"/>
    <meta name=\"msapplication-TileColor\" content=\"#FFFFFF\" />
    <meta name=\"msapplication-TileImage\" content=\"/css/favicon/mstile-144x144.png\" />
    <meta name=\"msapplication-square70x70logo\" content=\"/css/favicon/mstile-70x70.png\" />
    <meta name=\"msapplication-square150x150logo\" content=\"/css/favicon/mstile-150x150.png\" />
    <meta name=\"msapplication-wide310x150logo\" content=\"/css/favicon/mstile-310x150.png\" />
    <meta name=\"msapplication-square310x310logo\" content=\"/css/favicon/mstile-310x310.png\" />")
