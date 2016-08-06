#lang racket

(require
    racket/date
    pollen/template
    pollen/core
    pollen/pagetree
    "util-date.rkt"
    txexpr)

(provide (all-defined-out))

(define (pdfable? file-path)
  (string-contains? file-path ".poly"))

(define (pdfname page) (string-replace (path->string (file-name-from-path page))
                                       "poly.pm" "pdf"))
                                       
(define (source-listing p)
    (regexp-replace #px"(\\.html$)" (symbol->string p) ".pollen.html"))

(define (posts-by-date-desc)
  (define (postdate-desc p1 p2)
    (> (date->seconds (datestring->date (select-from-metas 'published p1)))
       (date->seconds (datestring->date (select-from-metas 'published p2)))))
  (sort (children 'index.html) postdate-desc))

(define (get-post-body pnode)
  (define (is-comment? tx)
    (and (txexpr? tx)
         (eq? (get-tag tx) 'section)
         (attrs-have-key? tx 'class)
         (string=? (attr-ref tx 'class) "comments")))

  (let-values ([(splut matched) (splitf-txexpr (get-doc pnode) is-comment?)]) splut))

(define (post-format post)
  `(article (header "\n" 
                    (h1 (a [[href ,(symbol->string post)]] ,(select-from-metas 'title post))) "\n" 
                    (p "Scribbled " 
                       (a [[class "permlink"] [href ,(symbol->string post)]]
                          (time [[datetime ,(select-from-metas 'published post)]]
                                ,(pubdate->english (select-from-metas 'published post))))
                       nbsp middot nbsp
                       (a [[class "pdf"] 
                           [href ,(string-append "posts/" (pdfname (select-from-metas 'here-path post)))]] 
                          "PDF")
                       nbsp middot nbsp
                       (a [[class "source-link"] [href ,(source-listing post)]]
                          loz nbsp "Pollen" nbsp "source")))
            "\n\n" 
            ,@(cdr (get-post-body post))))
