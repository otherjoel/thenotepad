#lang racket/base

;; Feed entries carry the whole post, with root-relative links made absolute.

(require camp
         racket/match
         racket/string
         "render.rkt")

(provide feed-content)

(define site-root "https://thenotepad.org")

(define (absolutize x)
  (match x
    [(list (? symbol? tag) (list (list (? symbol? ks) vs) ...) elems ...)
     `(,tag ,(for/list ([k (in-list ks)] [v (in-list vs)])
               (list k (if (and (memq k '(href src)) (string? v) (string-prefix? v "/"))
                           (string-append site-root v)
                           v)))
            ,@(map absolutize elems))]
    [(list (? symbol? tag) elems ...) `(,tag ,@(map absolutize elems))]
    [_ x]))

(define (feed-content doc ctxt)
  `(article ,@(map absolutize (camp-doc->html-xexpr doc notepad-html))))
