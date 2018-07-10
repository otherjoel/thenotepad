#lang racket/base

(require racket/date
         racket/string
         racket/file
         racket/system)

(define (normalize str)
  (define alphanum-only
    (regexp-replace* #rx"[^A-Za-z0-9 ]" str ""))
  (string-normalize-spaces (string-downcase alphanum-only) #px"\\s+" "-"))

(define (make-filename basename)
  (build-path (current-directory) "posts" (string-append basename ".poly.pm")))

(define date-string
  (parameterize [(date-display-format 'iso-8601)]
    (date->string (current-date))))

(define (make-template-contents title)
  (list "#lang pollen"
        ""
        (format "◊(define-meta title \"~a\")" title)
        (format "◊(define-meta published \"~a\")" date-string)
        "◊(define-meta topics \"a,b\")"
        ""
        "Hello"))


(display "Enter title: ")
(define title (read-line))
(cond [(non-empty-string? title)
       (define post-file (make-filename (normalize title)))
       (define post-contents (make-template-contents title))
       (display-lines-to-file post-contents post-file)
       (displayln (format "Saved to ~a" post-file))

       ; the + argument tells vim to place the cursor at the last line of the file.
       (system (format "mvim + ~a" post-file))])