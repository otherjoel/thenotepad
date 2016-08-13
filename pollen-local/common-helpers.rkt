#lang racket

(require rackunit
         txexpr
         pollen/setup)

#|
  Contains helper functions used by tags in more than one format
|#

(provide (all-defined-out))

#|
   If an article has comments, we want to be able to split those out from the
   rest of the article without requiring the writer to add a ◊comment-section
   tag or anything dumb like that. This way we can add a heading before the
   comments or add other markup around them.
|#
(define/contract (wrap-comment-section txpr escaper)
  (txexpr? (list? . -> . list?) . -> . txexpr?)
  ; Helper - Returns true for any txexpr whose tag is 'txt-comment, 
  ; or which is a 'div with class "comment-box".
  (define (is-comment? tx)
    (and (txexpr? tx)
         (or (equal? 'txt-comment (get-tag tx))
             (and (equal? 'div (get-tag tx))
                  (attrs-have-key? tx 'class)
                  (string=? "comment-box" (attr-ref tx 'class))))))
  (define (comment-section . contents)
    (case (current-poly-target)
      [(pdf ltx) `(txt "\n\\section{Responses}\n" ,@(escaper contents))]
      [else      `(section [[class "comments"]] (h2 "Responses") ,@contents)]))
      
  ; Split the comments out from the rest of the doc
  (let-values ([(splut comments) (splitf-txexpr txpr is-comment?)])
    (if (not (empty? comments))
        ; Reconstitute the doc with the freshly marked-up
        ; comment section at the end
        (txexpr 'body null (apply append (list (get-elements splut)
                                               `(,(apply comment-section comments)))))

        ; Or if no comments exist, return the original txexpr
        txpr)))


; This function is for use in a contract, allowing me to spike the ball if
; a writer uses characters other than l, r, or c in the columns argument of my
; ◊table tag.
(define (column-alignments-string? s)
  (subset? (string->list s) '(#\l #\r #\c)))

; Split a list into multiple lists at every occurence of x
(define/contract (split-by lst x)
  (list? any/c . -> . (listof list?))
  (foldr (lambda (element next)
           (if (eqv? element x)
               (cons empty next)
               (cons (cons element (first next)) (rest next))))
         (list empty) lst))

(check-equal? (split-by '(a b 1 d e 1 f g h) 1) '((a b) (d e) (f g h)))

; Helper function which takes a list and effectively removes any sub-list
; which is not a txexpr. This way a row contains only a flat list of values
; and/or txexprs.
(define/contract (clean-cells-in-row lst)
  (list? . -> . list?)
  (foldr (lambda (x rest-of-list)
           (if (and (list? x) (not (txexpr? x)))
               (append x rest-of-list)
               (cons x rest-of-list)))
         empty
         lst))
