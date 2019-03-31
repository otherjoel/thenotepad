#lang racket/base

(require racket/function
         racket/list
         racket/class
         racket/match
         racket/string)

(require "polytag.rkt"
         "publication-vals.rkt"
         "common-helpers.rkt")
         
(require txexpr
         file/md5
         pollen/decode
         pollen/core
         pollen/setup)

(provide (all-defined-out))

; Customized paragraph decoder replaces newlines within paragraphs
; with single spaces instead of <br> tags
(define (decode-paras-nolinebreaks xs)
  (define (no-linebreaks xs)
    (decode-linebreaks xs " "))
  (decode-paragraphs xs #:linebreak-proc no-linebreaks))

(define (html-root attrs elements)
  (define first-pass (decode-elements elements
                                      #:txexpr-elements-proc decode-paras-nolinebreaks
                                      #:exclude-tags '(script style figure table pre)))
  (define second-pass (decode-elements first-pass
                                       ; see towards end of file for detect-newthoughts
                                       #:block-txexpr-proc detect-newthoughts
                                       #:string-proc (compose1 smart-quotes smart-dashes)
                                       #:exclude-tags '(script style pre code)))
  (wrap-comment-section (txexpr 'body null second-pass) identity))   

(define (html-p attrs elems)
  `(p ,@elems))

(define (html-i attrs text)
  `(i ,@text))

(define (html-emph attrs text)
  `(em ,@text))

(define (html-b attrs text)
  `(b ,@text))

(define (html-strong attrs text)
  `(strong ,@text))

(define (html-strike attrs text)
  `(s ,@text))

(define (html-color c attrs text)
  `(span [[style ,(string-append "color: " c)]] ,@text))

(define (html-ol attrs elements)
  `(ol ,@elements))

(define (html-ul attrs elements)
  `(ul ,@elements))

(define (html-item attrs elements)
  `(li ,@elements))

(define (html-sup attrs text)
  `(sup ,@text))

(define (html-link url attrs elements)
  `(a [[href ,url]] ,@elements))

(define (html-blockquote attrs elems)
  `(blockquote ,@elems))

(define (html-newthought attrs elems)
  `(span [[class "newthought"]] ,@elems))

(define (html-smallcaps attrs elems)
  `(span [[class "smallcaps"]] ,@elems))

(define (html-inline-math attrs elems)
  `(span "\\(" ,@elems "\\)"))

(define (html-center attrs words)
  `(div [[style "text-align: center"]] ,@words))

(define (html-section attrs title)
  `(h2 ,@title))

(define (html-subsection attrs title)
  `(h3 ,@title))

(define (html-index-entry entry attrs text)
  (case (apply string-append text)
    [("") `(a [[id ,entry] [class "index-entry"]])]
    [else `(a [[id ,entry] [class "index-entry"]] ,@text)]))

;; Builds a path to an image in the [image-dir] subfolder of the current document's folder,
;; relative to the current document’s folder
(define (image-source basename)
  (cond [(current-metas)
         (define-values (_ here-rel-path-parts)
           (drop-common-prefix (explode-path (current-project-root))
                               (explode-path (string->path (select-from-metas 'here-path (current-metas))))))
         (let* ([folder-parts (drop-right here-rel-path-parts 1)]
                [img-path-parts (append folder-parts (list image-dir basename))]
                [img-path (apply build-path/convention-type 'unix img-path-parts)])
           (path->string img-path))]
        [else basename]))

(require racket/draw)
(define (get-image-size filename)
  (define bmp (make-object bitmap% filename))
  (list (send bmp get-width) (send bmp get-height)))

(define (html-figure src attrs elements)
  (define alt-text (apply string-append (filter string? (flatten elements))))
  (define source (image-source src))
  (cond
    [(attr-val 'fullwidth attrs)
      `(figure [[class "fullwidth"]] (img [[src ,(string-append site-root source)] [alt ,alt-text]]) (figcaption ,@elements))]
    [else
      (match-define (list img-width img-height) (get-image-size (build-path (current-project-root) source)))
      (define style-str (format "width: ~apx;" (/ img-width 2.0)))
      `(figure (img [[src ,(string-append site-root source)] [alt ,alt-text] [style ,style-str]]) (figcaption ,@elements))]))

(define (html-image src attrs elems)
  (define alt-text (apply string-append (filter string? (flatten elems))))
  `(img [[src ,(string-append site-root (image-source src))] [alt ,alt-text]]))

(define (html-code attrs text)
  `(code ,@text))
  
(define (html-noun attrs text)
  `(span [[class "noun"]] ,@text))

(define (html-blockcode attrs text)
  (define filename (attr-val 'filename attrs))
  (define codeblock `(pre [[class "code"]] ,@text))
  (cond
    [(string>? filename "") `(@ (div [[class "listing-filename"]] 128196 " " ,filename) ,codeblock)]
    [else codeblock]))

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

(define (fingerprint elems)
  (let* ([els (map (λ (ss) (if (symbol? ss) (symbol->string ss) ss)) (flatten elems))]
         [els (apply string-append els)]
         [els (take-right (bytes->list (md5 els)) 6)])
        (bytes->string/utf-8 (list->bytes els))))

(define (html-margin-note attrs elems)
  (define refid (fingerprint elems))
  `(@ (label [[for ,refid] [class "margin-toggle"]] 8853)
      (input [[type "checkbox"] [id ,refid] [class "margin-toggle"]])
      (span [[class "marginnote"]] ,@elems)))

(define (html-numbered-note attrs elems)
  (define refid (fingerprint elems))
  `(@ (label [[for ,refid] [class "margin-toggle sidenote-number"]])
      (input [[type "checkbox"] [id ,refid] [class "margin-toggle"]])
      (span [(class "sidenote")] ,@elems)))

(define (html-margin-figure src attrs elems)
  (define refid (fingerprint elems))
  (define alt-text (apply string-append (filter string? (flatten elems))))
  `(@ (label [[for ,refid] [class "margin-toggle"]] 8853)
      (input [[type "checkbox"] [id ,refid] [class "margin-toggle"]])
      (span [[class "marginnote"]] (img [[src ,(string-append site-root (image-source src))] [alt ,alt-text]]) ,@elems)))

(define (html-tweet attrs contents)
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

(define (html-updatebox datestr attr contents)
  `(div [[class "updateBox"]]
        (p (b (span [[class "smallcaps"]] "Update, " ,datestr)))
        ,@contents))
  
(define (html-comment attrs contents)
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

(define (html-table attrs elems)
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
