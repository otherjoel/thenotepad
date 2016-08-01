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
