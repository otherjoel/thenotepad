#lang racket/base

(provide (all-defined-out))

;; Should be the path following the domain name where the site is hosted.
;; Change if you host the site in a subfolder of your html root!
;; Must start with "/"
(define site-root "/")

(define image-dir (build-path "img"))
(define image-originals-dir (build-path "img" "originals"))