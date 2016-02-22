#lang racket

(require racket/date racket/string)

(provide (all-defined-out))

; Modified from https://github.com/malcolmstill/mstill.io/blob/master/blog/pollen.rkt
; Converts a string "2015-12-19" or "2015-12-19 16:02" to a Racket date value
(define (datestring->date datetime)
  (match (string-split datetime)
    [(list date time) (match (map string->number (append (string-split date "-") (string-split time ":")))
                        [(list year month day hour minutes) (seconds->date (find-seconds 0
                                                                                         minutes
                                                                                         hour
                                                                                         day
                                                                                         month
                                                                                         year))])]
    [(list date) (match (map string->number (string-split date "-"))
                   [(list year month day) (seconds->date (find-seconds 0
                                                                       0
                                                                       0
                                                                       day
                                                                       month
                                                                       year))])]))
#|
  Converts a string "2015-12-19" or "2015-12-19 16:02" to a string
  "Saturday, December 19th, 2015" by way of the datestring->date function above
|#
(define (pubdate->english datetime)
  (date->string (datestring->date datetime)))
