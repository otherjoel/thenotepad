#lang racket/base

;; Breaking the loading cycle
;; Can no longer do (require (for-syntax pollen/setup)) in anything used by pollen.rkt
;; See https://github.com/mbutterick/pollen/issues/229

(define poly-targets '(html pdf))
(provide poly-targets)
