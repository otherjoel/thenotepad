#lang racket

(require "polytag.rkt"
         "publication-vals.rkt"
         "common-helpers.rkt")
         
(require txexpr
         pollen/decode
         pollen/setup)

(provide (all-defined-out))

(define html-image-dir (string-append "/posts/" image-dir))

(define/contract (html-p attrs elems)
  ((listof attribute?) txexpr-elements? . -> . txexpr?)
  `(p ,@elems))

(define/contract (html-i attrs text)
  ((listof attribute?) txexpr-elements? . -> . txexpr?)
  `(i ,@text))

(define/contract (html-emph attrs text)
  ((listof attribute?) txexpr-elements? . -> . txexpr?)
  `(em ,@text))

(define/contract (html-b attrs text)
  ((listof attribute?) txexpr-elements? . -> . txexpr?)
  `(b ,@text))

(define/contract (html-strong attrs text)
  ((listof attribute?) txexpr-elements? . -> . txexpr?)
  `(strong ,@text))

(define/contract (html-color c attrs text)
  (string? (listof attribute?) txexpr-elements? . -> . txexpr?)
  `(span [[style ,(string-append "color: " c)]] ,@text))

(define/contract (html-ol attrs elements)
  ((listof attribute?) txexpr-elements? . -> . txexpr?)
  `(ol ,@elements))

(define/contract (html-ul attrs elements)
  ((listof attribute?) txexpr-elements? . -> . txexpr?)
  `(ul ,@elements))

(define/contract (html-item attrs elements)
  ((listof attribute?) txexpr-elements? . -> . txexpr?)
  `(li ,@elements))

(define/contract (html-sup attrs text)
  ((listof attribute?) txexpr-elements? . -> . txexpr?)
  `(sup ,@text))

(define/contract (html-blockquote attrs elems)
  ((listof attribute?) txexpr-elements? . -> . txexpr?)
  `(blockquote ,@elems))

(define/contract (html-newthought attrs elems)
  ((listof attribute?) txexpr-elements? . -> . txexpr?)
  `(span [[class "newthought"]] ,@elems))

(define/contract (html-smallcaps attrs elems)
  ((listof attribute?) txexpr-elements? . -> . txexpr?)
  `(span [[class "smallcaps"]] ,@elems))

(define/contract (html-inline-math attrs elems)
  ((listof attribute?) txexpr-elements? . -> . txexpr?)
  `(span "\\(" ,@elems "\\)"))

(define/contract (html-center attrs words)
  ((listof attribute?) txexpr-elements? . -> . txexpr?)
  `(div [[style "text-align: center"]] ,@words))

(define/contract (html-section attrs title)
  ((listof attribute?) txexpr-elements? . -> . txexpr?)
  `(h2 ,@title))

(define/contract (html-subsection attrs title)
  ((listof attribute?) txexpr-elements? . -> . txexpr?)
  `(h3 ,@title))

(define/contract (html-index-entry entry attrs text)
  (string? (listof attribute?) txexpr-elements? . -> . txexpr?)
  (case (apply string-append text)
    [("") `(a [[id ,entry] [class "index-entry"]])]
    [else `(a [[id ,entry] [class "index-entry"]] ,@text)]))
    
(define/contract (html-figure src attrs elements)
  (string? (listof attribute?) txexpr-elements? . -> . txexpr?)
  (define source (string-append html-image-dir src))
  (if (attr-val 'fullwidth attrs)
      `(figure [[class "fullwidth"]] ,(html-margin-note '() elements) (img [[src ,source]]))
      `(figure ,(html-margin-note '() elements) (img [[src ,source]]))))

(define/contract (html-image src attrs elems)
  (string? (listof attribute?) txexpr-elements? . -> . txexpr?)
  (define source (string-append html-image-dir src))
  `(img [[src ,source]]))

(define/contract (html-code attrs text)
  ((listof attribute?) txexpr-elements? . -> . txexpr?)
  `(code ,@text))
  
(define/contract (html-noun attrs text)
  ((listof attribute?) txexpr-elements? . -> . txexpr?)
  `(span [[class "noun"]] ,@text))

(define/contract (html-blockcode attrs text)
  ((listof attribute?) txexpr-elements? . -> . txexpr?)
  `(pre [[class "code"]] ,@text))

(define (html-Latex attrs text)
  `(span [[class "latex"]]
         "L" (span [[class "latex-sup"]] "a")
          "T" (span [[class "latex-sub"]] "e") "X"))

(define (html-verse attrs text)
  (let ([title  (attr-val 'title attrs)]
        [italic (attr-val 'italic attrs)])
       (define pre-attrs (if italic '([class "verse"] [style "font-style: italic"])
                                    '([class "verse"])))
       (define poem-xpr (if (non-empty-string? title)
                            `(pre ,pre-attrs (p [[class "poem-heading"]] ,title)
                                  ,@text)
                            `(pre ,pre-attrs
                                   ,@text)))
       `(div [[class "poem"]] ,poem-xpr)))

(define/contract (html-margin-note attrs elems)
  ((listof attribute?) txexpr-elements? . -> . txexpr?)
  (define refid (symbol->string (gensym 'marginnote)))
  `(@ (label [[for ,refid] [class "margin-toggle"]] 8853)
      (input [[type "checkbox"] [id ,refid] [class "margin-toggle"]])
      (span [[class "marginnote"]] ,@elems)))

(define/contract (html-numbered-note attrs elems)
  ((listof attribute?) txexpr-elements? . -> . txexpr?)
  (define refid (symbol->string (gensym 'footnote)))
  `(@ (label [[for ,refid] [class "margin-toggle sidenote-number"]])
      (input [[type "checkbox"] [id ,refid] [class "margin-toggle"]])
      (span [(class "sidenote")] ,@elems)))

(define/contract (html-margin-figure src attrs elems)
  (string? (listof attribute?) txexpr-elements? . -> . txexpr?)
  (define refid (symbol->string (gensym 'marginfigure)))
  (define source (string-append html-image-dir src))
  `(@ (label [[for ,refid] [class "margin-toggle"]] 8853)
      (input [[type "checkbox"] [id ,refid] [class "margin-toggle"]])
      (span [[class "marginnote"]] (img [[src ,source]]) ,@elems)))

(define/contract (html-tweet attrs contents)
  ((listof attribute?) txexpr-elements? . -> . txexpr?)
  (check-required-attributes 'tweet '(id handle realname permlink timestamp) attrs)
  `(blockquote [[id ,(string-append "t" (attr-val 'id attrs))] [class "tweet"]]
     (div [[class "twContent"]] ,@contents)
     (footer [[class "twMeta"]]
       (span [[class "twDecoration"]] "— ")
       (span [[class "twRealName"]] ,(attr-val 'realname attrs))
       (span [[class "twDecoration"]] " (")
       (span [[class "twScreenName"]]
         (a [[href ,(format "https://twitter.com/~a" (attr-val 'handle attrs))]] 
            ,(format "@~a" (attr-val 'handle attrs))))
       (span [[class "twDecoration"]] ") ")
       (span [[class "twTimeStamp"]]
         (a [[href ,(attr-val 'permlink attrs)]] ,(attr-val 'timestamp attrs))))))

(define (html-retweet attrs contents)
  (check-required-attributes 'retweet '(permlink handle realname timestamp) attrs)
  `(blockquote [[class "retweet"]]
    (p [[class "twRetweetMeta"]] (b ,(attr-val 'realname attrs))
       (span [[class "twScreenName"]] ,(format " (@~a) " (attr-val 'handle attrs)))
       (span [[class "twTimeStamp"]] (a [[href ,(attr-val 'permlink attrs)]]))
       ,@contents)))

(define/contract (html-updatebox datestr attr contents)
  (string? (listof attribute?) txexpr-elements? . -> . txexpr?)
  `(div [[class "updateBox"]]
        (p (b (span [[class "smallcaps"]] "Update, " ,datestr)))
        ,@contents))
  
(define/contract (html-comment attrs contents)
  ((listof attribute?) txexpr-elements? . -> . txexpr?)
  (check-required-attributes 'comment '(author datetime authorlink) attrs)
  (let ([author (attr-val 'author attrs)]
        [comment-date (attr-val 'datetime attrs)]
        [authorlink (attr-val 'authorlink attrs)])
       `(div [[class "comment-box"]]
             (p [[class "comment-meta"]]
                (span [[class "comment-name"]]
                      (a [[href ,authorlink]] ,author))
                (span [[class "comment-time"]] ,comment-date))
             ,@contents)))
#|
detect-newthoughts: called by root above when targeting HTML.
The ◊newthought tag (defined further below) makes use of the \newthought
command in Tufte-LaTeX and the .newthought CSS style in Tufte-CSS to start a
new section with some words in small caps. In LaTeX, this command additionally
adds some vertical spacing in front of the enclosing paragraph. There is no way
to do this in HTML/CSS without adding in some Javascript: i.e., there is no
CSS selector for “p tags that contain a span of class ‘newthought’”. So we can
handle it at the Pollen processing level.
|#
(define (detect-newthoughts block-xpr)
  (define is-newthought? (λ(x) (and (txexpr? x)
                                    (eq? 'span (get-tag x))
                                    (attrs-have-key? x 'class)
                                    (string=? "newthought" (attr-ref x 'class)))))
  (if (and(eq? (get-tag block-xpr) 'p)             ; Is it a <p> tag?
          (findf-txexpr block-xpr is-newthought?)) ; Does it contain a <span class="newthought">?
      (attr-set block-xpr 'class "pause-before")   ; Add the ‘pause-before’ class
      block-xpr))                                  ; Otherwise return it unmodified

#|
  ◊table : allows the creation of basic tables from a simplified notation.
  Modified from ◊quick-table in MB’s Typography for Lawyers source
  (http://docs.racket-lang.org/pollen-tfl/_pollen_rkt_.html#%28elem._%28chunk._~3cquick-table~3e~3a1%29%29)

  I’ve updated this tag so that A. it can produce both LaTeX and HTML tables,
  B. it allows you to specify the text-alignment for columns in both those
  formats, and C. it allows you to include tags inside table cells (not just strings)
|#
(define (html-td-tag . tx-els) `(td ,@tx-els))
(define (html-th-tag . tx-els) `(th ,@tx-els))
(define (html-tr-tag columns . tx-elems)
  (define column-alignments #hash(("l" . "left") ("r" . "right") ("c" . "center")))
  
  (cons 'tr (for/list ([cell (in-list tx-elems)]
                       [c-a columns])
                      (if (not (equal? c-a #\l))
                          (attr-set cell 'style
                                    (string-append "text-align: "
                                                   (hash-ref column-alignments (string c-a))
                                                   ";"))
                          cell))))

(define/contract (html-table attrs elems)
  ((listof attribute?) txexpr-elements? . -> . txexpr?)
  (define c-aligns (attr-val 'columns attrs))
  (cond [(not (or (equal? #f c-aligns) (column-alignments-string? c-aligns)))
         (raise-argument-error 'table "#:columns must be a string containing 'l', 'r', or 'c'" (assq 'columns attrs))])
  
  
  ;
  ; Split the arguments into rows (at "\n"), and split any string values into
  ; separate cells (at "|") and remove extra whitespace.
  (define rows-parsed (for/list ([row (in-list (split-by elems "\n"))])
                                (for/list ([cell (in-list row)])
                                          (if (string? cell)
                                              (map string-trim (filter-not whitespace? (string-split cell "|")))
                                              cell))))
  
  ; Clean things up (remove unnecessary levels of sublisting)
  (define rows-of-cells (map clean-cells-in-row rows-parsed))
  
  ; Create lists of individual cells using the tag functions defined previously.
  ; These will be formatted according to the current target format.
  ;   LaTeX: '((txt "Cell 1") " & " (txt "Cell 2") "\\\n")
  ;   HTML:  '((td "Cell 1") (td "Cell 2"))
  (define table-rows
    (match-let ([(cons header-row other-rows) rows-of-cells])
      (cons (map html-th-tag header-row)
            (for/list ([row (in-list other-rows)])
                      (map html-td-tag row)))))
  
  (define col-args (if (not c-aligns) (make-string (length (first table-rows)) #\l) c-aligns))
  (cons 'table (for/list ([table-row (in-list table-rows)])
                         (apply html-tr-tag col-args table-row))))
