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

(define (posts-by-date-desc #:limit [limit #f])
  (define (postdate-desc p1 p2)
    (> (date->seconds (datestring->date (select-from-metas 'published p1)))
       (date->seconds (datestring->date (select-from-metas 'published p2)))))
  (if (not limit) (sort (children 'index.html) postdate-desc)
      (take (sort (children 'index.html) postdate-desc) limit)))

(define (get-post-body pnode)
  (define (is-comment? tx)
    (and (txexpr? tx)
         (eq? (get-tag tx) 'section)
         (attrs-have-key? tx 'class)
         (string=? (attr-ref tx 'class) "comments")))

  (let-values ([(splut matched) (splitf-txexpr (get-doc pnode) is-comment?)]) splut))

(define (post->tablerow pnode)
  (define (paragraph tx) (and (txexpr? tx) (equal? 'p (get-tag tx))))

  (->html `(tr (td [[class "date-col"]] ,(pubdate->english (select-from-metas 'published pnode)))
               (td [[class "post-col"]]
                   (h2 [[style "margin: 0"]] (a [[href ,(symbol->string pnode)]]
                                                ,(select-from-metas 'title pnode)))
                   ,(findf-txexpr (get-doc pnode) paragraph)
                   ;,get-post-body pnode
                   (p (i (a [[href ,(symbol->string pnode)]] " (Read more…)")))))))
