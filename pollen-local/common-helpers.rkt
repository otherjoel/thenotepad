#lang racket

(require rackunit
         txexpr)

#|
  Contains helper functions used by tags in more than one format
|#

(provide (all-defined-out))

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
