#lang racket

(require pollen/decode
         pollen/setup       ; For current-poly-target
         pollen/file        ; get-markup-source
         txexpr
         pollen/tag         ; default-tag-function
         "util-date.rkt"
         "util-template.rkt"
         "pollen-local/polytag.rkt"
         "pollen-local/tags-html.rkt"
         "pollen-local/tags-pdf.rkt")

(provide string-split
         (all-from-out "util-date.rkt" "util-template.rkt")
         (all-from-out "pollen-local/tags-pdf.rkt"))
(provide (all-defined-out))

(module setup racket/base
    (provide (all-defined-out))
    (define poly-targets '(html pdf)))

(poly-branch-tag root)
    
(poly-branch-tag p)
(poly-branch-tag i)
(poly-branch-tag emph)
(poly-branch-tag b)
(poly-branch-tag strong)
(poly-branch-tag color c)
(poly-branch-tag ol)
(poly-branch-tag ul)
(poly-branch-tag item)
(poly-branch-tag sup)
(poly-branch-tag link url)
(poly-branch-tag blockquote)
(poly-branch-tag newthought)
(poly-branch-tag smallcaps)
(poly-branch-tag inline-math)
(poly-branch-tag center)

(poly-branch-tag section)
(poly-branch-tag subsection)

(poly-branch-tag index-entry entry)
(poly-branch-tag figure src (fullwidth #f) (has-print-version #f))
(poly-branch-tag margin-figure src (has-print-version #f))
(poly-branch-tag image src (has-print-version #f))

(poly-branch-tag margin-note)
(poly-branch-tag numbered-note)

; Note that because of the need to escape backslashes in LaTeX, you
; cannot use any other commands inside a ◊code tag
(poly-branch-tag code)
(poly-branch-tag noun)
(poly-branch-tag blockcode (filename ""))

(poly-branch-tag Latex)
(poly-branch-tag verse (title "") (italic #f))

#|
  ◊tweet and ◊retweet handle markup for embedded tweets. I use a Python script
  to generate the tags in my Pollen markup (github.com/otherjoel/blackbirdpy).
|#
(poly-branch-tag tweet)
(poly-branch-tag retweet)

(poly-branch-tag updatebox date-str)
(poly-branch-tag comment (authorlink ""))

; Our ◊table will support an optional argument specifying the text alignment for
; each column in the table: E.g. "llrc" means two left-aligned columns, a right-
; aligned column, and a center-aligned column (4 columns total).
(poly-branch-tag table (columns #f))
      
(define (amazon product-id . contents)
  (define affiliate-id "thloya-20")
  (apply link (format "https://amzn.com/~a/?tag=~a" product-id affiliate-id) contents))
