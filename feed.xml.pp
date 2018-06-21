#lang racket

(require txexpr
         racket/date
         racket/format)   ; For ~r

(require "util-db.rkt"    ; Feed is built from the SQLite cache now
         "util-date.rkt")

#|
  Customizeable values
|#

(define opt-author-name  "Joel Dueck")         ; The name given for the feed's <author>
(define opt-author-email "joel@jdueck.net")    ; Email for the feed's <author>
(define opt-feed-title   "The Notepad")
(define opt-feed-site    "https://thenotepad.org/") ; This should end with /
(define opt-feed-limit   50)                    ; Max items in feed

#|
  You should customize the timezone/DST settings to match those of the
  computer that will be generating this feed.
|#
(define opt-feed-timezone -6)         ; Enter as an integer offset from GMT
(define adjust-daylight-savings? #t)  ; Determines whether we add 1 to the
                                      ; offset for times that fall within DST

#|
  This is where you’d normally be told not to change anything below this point.
  But you are expected to know how this works and change it if you need to!
|#

(define (as-cdata string)
  (cdata #f #f (format "<![CDATA[~a]]>" string)))

(define (email-encode str)
  (map char->integer (string->list str)))

; Atom feeds require dates to be in RFC 3339 format
(define (date->rfc3339 d)
  (string-append (format "~a-~a-~aT~a:~a:~a~a:00"
                         (date-year d)
                         (~r (date-month d) #:min-width 2 #:pad-string "0")
                         (~r (date-day d) #:min-width 2 #:pad-string "0")
                         (~r (date-hour d) #:min-width 2 #:pad-string "0")
                         (~r (date-minute d) #:min-width 2 #:pad-string "0")
                         (~r (date-second d) #:min-width 2 #:pad-string "0")
                         (if (and (date-dst? d) adjust-daylight-savings?)
                             (~r (+ 1 opt-feed-timezone) #:min-width 2 #:pad-string "0" #:sign '++)
                             (~r opt-feed-timezone #:min-width 2 #:pad-string "0" #:sign '++)))))

(define (rss-items)
  (define posts (latest-posts opt-feed-limit))
    (for/list ([post (in-list posts)])
       (define post-url (string-append opt-feed-site (hash-ref post 'pagenode)))
       (define post-updated
         (let ([updated (hash-ref post 'updated)])
           (if (non-empty-string? updated) `(updated ,(date->rfc3339 (datestring->date updated))) "")))
       `(entry
         (author (name ,opt-author-name))
         (published ,(date->rfc3339 (datestring->date (hash-ref post 'published))))
         ,post-updated
         (title ,(hash-ref post 'title))
         (link [[rel "alternate"] [href ,post-url]])
         (id ,post-url)
         (summary [[type "html"]]
                  ,(as-cdata (hash-ref post 'html))))))
  
(define rss-feed-xexpr
  `(feed [[xml:lang "en-us"] [xmlns "http://www.w3.org/2005/Atom"]]
         (title ,opt-feed-title)
         (link [[rel "self"] [href ,(string-append opt-feed-site "feed.xml")]])
         (generator [[uri "http://pollenpub.com/"]] "Pollen (custom feed)")
         (id ,opt-feed-site)
         (updated ,(date->rfc3339 (current-date)))
         (author
          (name ,opt-author-name)
          (email ,@(email-encode opt-author-email)))
         ,@(rss-items)))

; Generates a string for the whole RSS feed
(define complete-feed-string
  (string-append "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                 (xexpr->string rss-feed-xexpr)))

#|
  Because this file uses "lang racket" instead of "#lang pollen" we have to
  manually take some steps that Pollen would normally take for us: defining
  'doc and 'metas, and displaying the output (which will
  be stored in the target file).
|#
(provide doc metas)
(define doc complete-feed-string)
(define metas (hash))
(module+ main
  (display doc))
