#lang racket

(require pollen/decode
         pollen/core
         pollen/cache
         pollen/setup       ; For current-poly-target
         pollen/file
         txexpr
         pollen/tag
         pollen/template
         pollen/pagetree
         racket/date
         "util-date.rkt"
         "util-template.rkt"
         "pollen-local/polytag.rkt"
         "pollen-local/tags-html.rkt"
         "pollen-local/tags-pdf.rkt")

(provide add-between
         attr-ref
         attrs-have-key?
         make-txexpr
         string-split
         get-markup-source
         string-contains?
         (all-from-out "util-date.rkt" "util-template.rkt")
         (all-from-out "pollen-local/tags-html.rkt")
         (all-from-out "pollen-local/tags-pdf.rkt"))
(provide (all-defined-out))

(module setup racket/base
    (provide (all-defined-out))
    (define poly-targets '(html pdf)))

(define (root . elements)
  (case (current-poly-target)
    [(ltx pdf)
     (define first-pass (decode-elements (get-elements (wrap-comment-section (txexpr 'root null (esc elements))))
                                         #:inline-txexpr-proc (compose1 txt-decode hyperlink-decoder)
                                         #:string-proc (compose1 smart-quotes smart-dashes)
                                         #:exclude-tags '(script style figure txt-noescape)))
     (txexpr 'body null (decode-elements first-pass #:inline-txexpr-proc txt-decode))]

    [else
      (define first-pass (decode-elements elements
                                          #:txexpr-elements-proc decode-paragraphs
                                          #:exclude-tags '(script style figure table)))
      (define second-pass (decode-elements first-pass
                                           #:block-txexpr-proc detect-newthoughts
                                           #:inline-txexpr-proc hyperlink-decoder
                                           #:string-proc (compose1 smart-quotes smart-dashes)
                                           #:exclude-tags '(script style pre code)))
      (wrap-comment-section (txexpr 'body null second-pass))]))

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
(poly-branch-tag blockcode)

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
  `(link ,(format "https://amzn.com/~a/?tag=~a" product-id affiliate-id) ,@contents))
 
(define (hyperlink-decoder inline-tx)
  (define (hyperlinker url . words)
    (define tag-contents (if (empty? words)
                             (list url)
                             words))
    (case (current-poly-target)
      [(ltx pdf) `(txt "\\href{" ,(ltx-escape-str url) "}" "{" ,@(esc tag-contents) "}")]
      [else `(a [[href ,url]] ,@tag-contents)]))

  (if (eq? 'link (get-tag inline-tx))
      (apply hyperlinker (get-elements inline-tx))
      inline-tx))

#|
   If an article has comments, we want to be able to split those out from the
   rest of the article without requiring the writer to add a ◊comment-section
   tag or anything dumb like that. This way we can add a heading before the
   comments or add other markup around them.
|#
(define (wrap-comment-section txpr)
  
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
      [(pdf ltx) `(txt "\n\\section{Responses}\n" ,@(esc contents))]
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
