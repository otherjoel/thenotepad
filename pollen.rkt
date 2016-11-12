#lang racket

(require pollen/decode
         pollen/setup       ; For current-poly-target
         pollen/file        ; get-markup-source
         txexpr
         pollen/tag         ; default-tag-function
         "util-date.rkt"
         "util-template.rkt")

(provide string-split
         (all-from-out "util-date.rkt" "util-template.rkt"))
(provide (all-defined-out))

(module setup racket/base
  (provide (all-defined-out))
  (define poly-targets '(html pdf)))

(require (for-syntax racket/syntax syntax/stx))
(define-syntax (define-poly-tag-from-file stx)
  (syntax-case stx ()
    [(_ ID [TARGET SOURCE] ...)
     (with-syntax* ([(TARGET: ...) (stx-map
                                    (λ(stx) (format-id stx "~a:" stx))
                                    #'(TARGET ...))]
                    [(TARGET:ID ...) (stx-map
                                             (λ(stx) (format-id stx "~a~a" stx #'ID))
                                             #'(TARGET: ...))])
       #'(begin
           (require (prefix-in TARGET: SOURCE)) ...
           (provide ID)
           (define-tag-function (ID attrs elems)
             (case (current-poly-target)
               [(TARGET) (TARGET:ID attrs elems)] ...))))]))

;; basic form
(define-poly-tag-from-file root
  [html "pollen-local/tags-html.rkt"]
  [pdf "pollen-local/tags-pdf.rkt"])

;; shorthand for other tags
(define-syntax-rule (my-poly-tags ID ...)
  (begin
    (define-poly-tag-from-file ID
      [html "pollen-local/tags-html.rkt"]
      [pdf "pollen-local/tags-pdf.rkt"]) ...))

(my-poly-tags p i emph b strong code)