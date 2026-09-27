#lang racket/base

;; Bindings available in #lang punct notepad sources.

(require camp
         camp/xref
         punct/element)

(provide (all-from-out camp/xref)
         figure
         updatebox
         comment
         tweet
         color
         del
         sup)

;; •figure["/posts/img/file.png" #:width "300"]{Caption}
(define (figure src #:width [width #f] . caption)
  `(figure [[block "single"] [src ,src] ,@(if width `((width ,width)) '())] ,@caption))

;; •updatebox["July 30 2012"]{…}
(define (updatebox date . elems)
  `(updatebox [[block "root"] [date ,date]] ,@elems))

;; Reader comments carried over from the Blogger era
(define (comment #:author author #:date date #:link [link ""] . elems)
  `(comment [[block "root"] [author ,author] [date ,date] [link ,link]] ,@elems))

;; A quoted tweet
(define (tweet #:name name #:handle handle #:url url #:date date . elems)
  `(tweet [[block "root"] [name ,name] [handle ,handle] [url ,url] [date ,date]] ,@elems))

(define (color c . elems)
  `(color [[value ,c]] ,@elems))

(define-element del)
(define-element sup)
