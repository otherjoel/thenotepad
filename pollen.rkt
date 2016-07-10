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
         "util-template.rkt")

(provide add-between
         attr-ref
         attrs-have-key?
         make-txexpr
         string-split
         get-markup-source
         string-contains?
         (all-from-out "util-date.rkt" "util-template.rkt"))
(provide (all-defined-out))

(define image-dir "img/")
(define image-originals-dir "img/originals/")

(module setup racket/base
    (provide (all-defined-out))
    (define poly-targets '(html pdf)))

(define (split-by lst x)
  (foldr (lambda (element next)
           (if (eqv? element x)
               (cons empty next)
               (cons (cons element (first next)) (rest next))))
         (list empty) lst))

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

#|
   If an article has comments, we want to be able to split those out from the
   rest of the article without requiring the writer to add a ◊comment-section
   tag or anything dumb like that. This way we can add a heading before the
   comments or add other markup around them.
|#
(define (wrap-comment-section txpr)
  ; Helper function identifies comments for us. Returns true for any txexpr
  ; whose tag is 'txt-comment, or which is a 'div with class "comment-box".
  (define (is-comment? tx)
    (and (txexpr? tx)
         (or (equal? 'txt-comment (get-tag tx))
             (and (equal? 'div (get-tag tx))
                  (attrs-have-key? tx 'class)
                  (string=? "comment-box" (attr-ref tx 'class))))))
  ; Split the comments out from the rest of the doc
  (let-values ([(splut comments) (splitf-txexpr txpr is-comment?)])
    (if (not (empty? comments))
        ; Reconstitute the doc with the freshly marked-up comment section
        ; at the end
        (txexpr 'body null (apply append (list (get-elements splut)
                                               `(,(apply comment-section comments)))))

        ; Or if no comments exist, return the original txexpr
        txpr)))

; Escape $,%,# and & for LaTeX
(define (ltx-escape-str str)
  ; matches special characters not already preceeded by a slash
  ; # $ % & ~ _ ^ \ { }
  ;(define str-2nd (regexp-replace* #px"\\\\" str "\\textbackslash"))
  (regexp-replace* #px"(?<!\\\\)([$#%&_])" str "\\\\\\1"))

(define (esc elems)
  (and (not (member (current-poly-target) '(ltx pdf))) (error "WRONG"))
  (for/list ([e (in-list elems)])
            (if (string? e) (ltx-escape-str e) e)))

#|
`txt-decode` is called by root when targeting LaTeX/PDF. It simply returns all
all elements contained inside ◊txt tag or a ◊txt-noescape tag. ◊txt is not
intended to be used in normal markup; its sole purpose is to allow other tag
functions to return LaTeX code as a valid tagged X-expression rather than as a
naked string.
|#
(define (txt-decode xs)
    (if (member (get-tag xs) '(txt txt-noescape txt-comment))
        (get-elements xs)
        xs))

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
◊numbered-note, ◊margin-figure, ◊margin-note:
  These three tag functions produce markup for "sidenotes" in HTML and LaTeX.
  In our LaTeX template, any hyperlinks also get auto-converted to numbered
  sidenotes, which is kinda neat. Unfortunately, this also means that when
  targeting LaTeX, you can't have a hyperlink inside a sidenote since that would
  equate to a sidenote within a sidenote, which causes Problems.

  We handle this by not using a normal tag function for hyperlinks. Instead,
  within these three tag functions we call latex-no-hyperlinks-in-margin to
  filter out any hyperlinks inside these tags (for LaTeX/PDF only). Then the
  root function uses a separate decoder to properly handle any hyperlinks that
  sit outside any of these three tags.
|#

(define (numbered-note . text)
    (define refid (symbol->string (gensym 'footnote)))
    (case (current-poly-target)
      [(ltx pdf)
       `(txt "\\footnote{" ,@(latex-no-hyperlinks-in-margin text) "}")]
      [else
        `(@ (label [[for ,refid] [class "margin-toggle sidenote-number"]])
            (input [[type "checkbox"] [id ,refid] [class "margin-toggle"]])
            (span [(class "sidenote")] ,@text))]))

(define (margin-figure src #:has-print-version [print-ver #f] . caption)
    (define refid (symbol->string (gensym 'marginfigure)))
    (case (current-poly-target)
      [(ltx pdf)
       (define source (string-append (if print-ver image-originals-dir image-dir) src))
       `(txt "\\begin{marginfigure}"
             "\\includegraphics{" ,source "}"
             "\\caption{" ,@(latex-no-hyperlinks-in-margin caption) "}"
             "\\end{marginfigure}")]
      [else
        (define source (string-append image-dir src))
        `(@ (label [[for ,refid] [class "margin-toggle"]] 8853)
            (input [[type "checkbox"] [id ,refid] [class "margin-toggle"]])
            (span [[class "marginnote"]] (img [[src ,source]]) ,@caption))]))

(define (margin-note . text)
    (define refid (symbol->string (gensym 'marginnote)))
    (case (current-poly-target)
      [(ltx pdf)
       `(txt "\\marginnote{" ,@(latex-no-hyperlinks-in-margin text) "}")]
      [else
        `(@ (label [[for ,refid] [class "margin-toggle"]] 8853)
            (input [[type "checkbox"] [id ,refid] [class "margin-toggle"]])
            (span [[class "marginnote"]] ,@text))]))
#|
  This function is called from within the margin/sidenote functions when
  targeting Latex/PDF, to filter out hyperlinks from within those tags.
  (See notes above)
|#
(define (latex-no-hyperlinks-in-margin txpr)
  ; First define a local function that will transform each ◊hyperlink
  (define (cleanlinks inline-tx)
      (if (eq? 'link (get-tag inline-tx))
        `(txt ,@(cdr (get-elements inline-tx))
              ; Return the text with the URI in parentheses
              " (\\url{" ,(ltx-escape-str (car (get-elements inline-tx))) "})")
        inline-tx)) ; otherwise pass through unchanged
  ; Run txpr through the decode-elements wringer using the above function to
  ; flatten out any ◊hyperlink tags
  (decode-elements txpr #:inline-txexpr-proc cleanlinks))

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

(define (amazon product-id . contents)
  (define affiliate-id "thloya-20")
  `(link ,(format "https://amzn.com/~a/?tag=~a" product-id affiliate-id) ,@contents))

#|
  ◊tweet and ◊retweet handle markup for embedded tweets. I use a Python script
  to generate the tags in my Pollen markup (github.com/otherjoel/blackbirdpy).
|#
(define (tweet #:id tweet-id #:handle tweeter #:realname tweeter-IRL
               #:permlink tweet-link #:timestamp tweet-time . contents)
  (case (current-poly-target)
    [(ltx pdf)
     ; Replaces any link with just the link's second element
     (define (zap-links t)
       (if (and (txexpr? t) (equal? 'link (get-tag t))) (cadr (get-elements t)) t))

     `(txt "\\begin{mdframed}[style=tweet]\n"
           "{\\NHLight\\raggedright\\small "
           ,@(esc (map zap-links contents))
           "}\n\\textcolor[RGB]{220,220,220}{\\hrule}\n"
           "{\\sffamily\\small " ,tweeter-IRL
           "} • {\\NHLight\\raggedleft\\footnotesize @" ,tweeter
           " \\hfill " ,tweet-time "\\footnotemark}" 
           "\n\\end{mdframed}\n\\footnotetext{\\url{" ,tweet-link "}}\n")]
    [else
      `(blockquote [[id ,(string-append "t" tweet-id)] [class "tweet"]]
        (div [[class "twContent"]] ,@contents)
        (footer [[class "twMeta"]]
          (span [[class "twDecoration"]] "— ")
          (span [[class "twRealName"]] ,tweeter-IRL)
          (span [[class "twDecoration"]] " (")
          (span [[class "twScreenName"]]
                (a [[href ,(format "https://twitter.com/~a" tweeter)]] ,(format "@~a" tweeter)))
          (span [[class "twDecoration"]] ") ")
          (span [[class "twTimeStamp"]]
                (a [[href ,tweet-link]] ,tweet-time))))]))

(define (retweet #:id tweet-id #:handle tweeter #:realname tweeter-IRL
               #:permlink tweet-link #:timestamp tweet-time . contents)
  (case (current-poly-target)
    [(ltx pdf) `(txt "\n\n(@" ,tweeter ", " ,tweet-time ": " ,@(esc contents))]
    [else
      `(blockquote [[class "retweet"]]
        (p [[class "twRetweetMeta"]] (b ,tweeter-IRL)
           (span [[class "twScreenName"]] ,(format " (@~a) " tweeter))
           (span [[class "twTimeStamp"]] (a [[href ,tweet-link]] ,tweet-time)))
        ,@contents)]))

(define (updatebox d . contents)
  (case (current-poly-target)
    [(ltx pdf) `(txt ,@(esc contents))]
    [else
      `(div [[class "updateBox"]]
            (p (b (span [[class "smallcaps"]] "Update, " ,d)))
            ,@contents)]))


(define (comment-section . contents)
  (case (current-poly-target)
    [(ltx pdf) `(txt ,(section "Responses") ,@(esc contents))]
    [else `(section [[class "comments"]] ,(section "Responses") ,@contents)]))

(define (comment #:author author #:datetime comment-date #:authorlink author-url . comment-text)
  (case (current-poly-target)
    [(ltx pdf) `(txt-comment "\\begin{quote}\n" ,@(esc comment-text)
                             "\n\\attrib{" ,(ltx-escape-str author) ", " ,comment-date "}"
                             "\n\\end{quote}\n\n")]
    [else `(div [[class "comment-box"]]
                (p [[class "comment-meta"]]
                   (span [[class "comment-name"]]
                         (a [[href ,author-url]] ,author))
                   (span [[class "comment-time"]] ,comment-date))
                ,@comment-text)]))

#|
  ◊table : allows the creation of basic tables from a simplified notation.
  Modified from ◊quick-table in MB’s Typography for Lawyers source
  (http://docs.racket-lang.org/pollen-tfl/_pollen_rkt_.html#%28elem._%28chunk._~3cquick-table~3e~3a1%29%29)

  I’ve updated this tag so that A. it can produce both LaTeX and HTML tables,
  B. it allows you to specify the text-alignment for columns in both those
  formats, and C. it allows you to include tags inside table cells (not just strings)

  This necessarily made things a bit more complex.
|#

; Our ◊table will support an optional argument specifying the text alignment for
; each column in the table: E.g. "llrc" means two left-aligned columns, a right-
; aligned column, and a center-aligned column (4 columns total).

; This function is for use in a contract, allowing me to spike the ball if
; a writer uses characters other than l, r, or c in the columns argument of my
; ◊quick-table tag.
(define (column-alignments-string? s)
  (subset? (string->list s) '(#\l #\r #\c)))

; Since LaTeX is involved, we once again must manually define our tag functions.
; These are not called by authors; rather they are for use within the ◊quick-table
; tag function.
;    A normal cell and a header cell appear in HTML as different tags (<td> and
; <th> but in LaTeX both are just strings; the headers are differentiated from
; normal cells only by surrounding visual cues that will have to be added by the
; surrounding “row” function one level up.
(define (td-tag . tx-els)
  (case (current-poly-target)
    [(ltx pdf) `(txt ,@(esc tx-els))]
    [else `(td ,@tx-els)]))

(define (th-tag . tx-els)
  (case (current-poly-target)
    [(ltx pdf) `(txt ,@(esc tx-els))]
    [else `(th ,@tx-els)]))

; tr-tag takes a column-alignment string (e.g. "llrc") and a list of cells.
; In LaTeX it returns a 'txt expression with the cells separated by " & " and
; ending with ‘\\’.
; In HTML it returns a <tr> tag containing <td> tags, using the column-alignment
; string to set the CSS text-alignment property on each cell that is not left-aligned.
(define (tr-tag #:columns [columns #f] . tx-elems)
  (define column-alignments #hash(("l" . "left") ("r" . "right") ("c" . "center")))
  (case (current-poly-target)
    [(ltx pdf) `(txt ,@(add-between tx-elems " & ") " \\\\\n")]
    [else (if columns
              (cons 'tr (for/list ([cell (in-list tx-elems)]
                                   [c-a columns])
                                  (if (not (equal? c-a #\l))
                                      (attr-set cell
                                                'style
                                                (string-append "text-align: "
                                                               (hash-ref column-alignments (string c-a))
                                                               ";"))
                                      cell)))
              `(tr ,@tx-elems))]))
;
; Ladies and gentlemen may I direct your attention to the center ring:
;
(define/contract (table #:columns [c-aligns #f] . tx-elements)
  (() (#:columns column-alignments-string?) #:rest (listof txexpr-element?) . ->* . txexpr?)

  ; Helper function which takes a list and effectively removes any sub-list
  ; which is not a txexpr. This way a row contains only a flat list of values
  ; and/or txexprs.
  (define (clean-cells-in-row lst)
    (foldr (lambda (x rest-of-list)
             (if (and (list? x) (not (txexpr? x)))
                 (append x rest-of-list)
                 (cons x rest-of-list)))
           empty
           lst))

  ; Split the arguments into rows (at "\n"), and split any string values into
  ; separate cells (at "|") and remove extra whitespace.
  (define rows-parsed (for/list ([row (in-list (split-by tx-elements "\n"))])
                                (for/list ([cell (in-list row)])
                                          (if (string? cell)
                                              (map string-trim (filter-not whitespace? (string-split cell "|")))
                                              cell))))

  ; Clean things up using the helper function above
  (define rows-of-cells (map clean-cells-in-row rows-parsed))

  ; Create lists of individual cells using the tag functions defined previously.
  ; These will be formatted according to the current target format.
  ;   LaTeX: '((txt "Cell 1") " & " (txt "Cell 2") "\\\n")
  ;   HTML:  '((td "Cell 1") (td "Cell 2"))
  (define table-rows
    (match-let ([(cons header-row other-rows) rows-of-cells])
      (cons (map th-tag header-row)
            (for/list ([row (in-list other-rows)])
                      (map td-tag row)))))

  ; With the rows prepared, it only remains for us to format the cells inside
  ; rows and the rows inside the table structure.
  (case (current-poly-target)
    [(ltx pdf)
     ; LaTeX requires a column alignment string in the table. So if none was
     ; specified, generate one, using one ‘l’ character for each cell in the
     ; first row (thus defaulting to left-alignment).
     (define col-args (if (not c-aligns) (make-string (length (first table-rows)) #\l) c-aligns))
     (match-let ([(cons header-row other-rows) rows-of-cells])
       `(txt "\\begin{table}[h!]\n"
             "  \\centering\n"
             "  \\begin{tabular}{" ,col-args "}\n"
             "    \\toprule\n"
             ,(apply tr-tag #:columns col-args header-row)
             "    \\midrule\n"
             ,@(for/list ([row (in-list other-rows)]) (apply tr-tag #:columns col-args row))
             "    \\bottomrule\n"
             "  \\end{tabular}\n"
             "\\end{table}\n"))]
    [else (cons 'table (for/list ([table-row (in-list table-rows)])
                         (apply tr-tag #:columns c-aligns table-row)))]))

(define (p . words)
  (case (current-poly-target)
    [(ltx pdf) `(txt ,@(esc words) "\n\n")]
    [else `(p ,@words)]))

(define (blockquote . words)
  (case (current-poly-target)
    [(ltx pdf) `(txt "\\begin{quote}" ,@(esc words) "\\end{quote}")]
    [else `(blockquote ,@words)]))

(define (newthought . words)
  (case (current-poly-target)
    [(ltx pdf) `(txt "\\newthought{" ,@(esc words) "}")]
    [else `(span [[class "newthought"]] ,@words)]))

(define (smallcaps . words)
  (case (current-poly-target)
    [(ltx pdf) `(txt "\\smallcaps{" ,@(esc words) "}")]
    [else `(span [[class "smallcaps"]] ,@words)]))

(define (∆ . elems)
  (case (current-poly-target)
    [(ltx pdf) `(txt-noescape "$" ,@elems "$")]
    [else `(span "\\(" ,@elems "\\)")]))

(define (center . words)
  (case (current-poly-target)
    [(ltx pdf) `(txt "\\begin{center}" ,@(esc words) "\\end{center}")]
    [else `(div [[style "text-align: center"]] ,@words)]))

(define (section title)
  (case (current-poly-target)
    [(ltx pdf) `(txt "\\section{" ,@(esc (list title)) "}")]
                 ;"\\label{sec:" ,title ,(symbol->string (gensym)) "}")]
    [else `(h2 ,title)]))

(define (subsection title)
  (case (current-poly-target)
    [(ltx pdf) `(txt "\\subsection{" ,@(esc (list title)) "}")]
    [else `(h3 ,title)]))

(define (index-entry entry . text)
  (case (current-poly-target)
    [(ltx pdf) `(txt "\\index{" ,entry "}" ,@(esc text))]
    [else
      (case (apply string-append text)
        [("") `(a [[id ,entry] [class "index-entry"]])]
        [else `(a [[id ,entry] [class "index-entry"]] ,@text)])]))

(define (figure src #:fullwidth [fullwidth #f] #:has-print-version [print-ver #f] . caption)
  (case (current-poly-target)
    [(ltx pdf)
     (define source (string-append (if print-ver image-originals-dir image-dir) src))
     (define figure-env (if fullwidth "figure*" "figure"))
     `(txt "\\begin{" ,figure-env "}"
           "\\includegraphics{" ,source "}"
           "\\caption{" ,@(esc (latex-no-hyperlinks-in-margin caption)) "}"
           "\\end{" ,figure-env "}")]
    [else
      (define source (string-append image-dir src))
      (if fullwidth
          ; Note the syntax for calling another tag function, margin-note,
          ; from inside this one. Because caption is a list, we need to use
          ; (apply) to pass the values in that list as individual arguments.
          `(figure [[class "fullwidth"]] ,(apply margin-note caption) (img [[src ,source]]))
          `(figure ,(apply margin-note caption) (img [[src ,source]])))]))

(define (image src #:has-print-version [print-ver #f])
  (case (current-poly-target)
    [(ltx pdf) 
     (define source (string-append (if print-ver image-originals-dir image-dir) src))
     `(txt "\n\n\\frame{\\includegraphics{" ,source "}}")]
    [else 
      (define source (string-append image-dir src))
      `(img [[src ,source]])]))

; Note that because of the need to escape backslashes in LaTeX, you
; cannot use any other commands inside a ◊code tag
(define (code . text)
  (case (current-poly-target)
    [(ltx pdf)
     `(txt "\\texttt{"
           ,@(esc (list (string-replace (apply string-append text) "\\" "\\textbackslash ")))
           "}")]
    [else `(code ,@text)]))

(define (noun . text)
  (case (current-poly-target)
    [(ltx pdf) `(txt "\\texttt{" ,@(esc text) "}")]
    [else `(span [[class "noun"]] ,@text)]))

(define (blockcode . text)
  (case (current-poly-target)
    [(ltx pdf) `(txt-noescape "\\begin{lstlisting}\n" ,@text "\n\\end{lstlisting}")]
    [else `(pre [[class "code"]] ,@text)]))

(define (ol . elements)
  (case (current-poly-target)
    [(ltx pdf) `(txt "\\begin{enumerate}" ,@elements "\\end{enumerate}")]
    [else `(ol ,@elements)]))

(define (ul . elements)
  (case (current-poly-target)
    [(ltx pdf) `(txt "\\begin{itemize}" ,@elements "\\end{itemize}")]
    [else `(ul ,@elements)]))

(define (item . elements)
  (case (current-poly-target)
    [(ltx pdf) `(txt "\\item " ,@(esc elements))]
    [else `(li ,@elements)]))

(define (sup . text)
  (case (current-poly-target)
    [(ltx pdf) `(txt "\\textsuperscript{" ,@(esc text) "}")]
    [else `(sup ,@text)]))

#|
  Just because we can, here's a tag function for typesetting the LaTeX logo
  in both HTML and (obv.) LaTeX.
|#
(define (Latex)
  (case (current-poly-target)
    [(ltx pdf)
     `(txt "\\LaTeX\\xspace")]      ; \xspace adds a space if the next char is not punctuation
    [else `(span [[class "latex"]]
             "L"
             (span [[class "latex-sup"]] "a")
             "T"
             (span [[class "latex-sub"]] "e")
             "X")]))

; In HTML these two tags won't look much different. But when outputting to
; LaTeX, ◊i will italicize multiple blocks of text, where ◊emph should be
; used for words or phrases that are intended to be emphasized. In LaTeX,
; if the surrounding text is already italic then the emphasized words will be
; non-italicized.
;   A similar approach is offered for boldface text.
;
(define (i . text)
  (case (current-poly-target)
    [(ltx pdf) `(txt "{\\itshape " ,@(esc text) "}")]
    [else `(i ,@text)]))

(define (emph . text)
  (case (current-poly-target)
    [(ltx pdf) `(txt "\\emph{" ,@(esc text) "}")]
    [else `(em ,@text)]))

(define (b . text)
  (case (current-poly-target)
    [(ltf pdf) `(txt "{\\bfseries " ,@(esc text) "}")]
    [else `(b ,@text)]))

(define (strong . text)
  (case (current-poly-target)
    [(ltx pdf) `(txt "\\textbf{" ,@(esc text) "}")]
    [else `(strong ,@text)]))


#|
Typesetting poetry in LaTeX or HTML. HTML uses a straightforward <pre> with
appropriate CSS. In LaTeX we explicitly specify the longest line for centering
purposes, and replace double-spaces with \vin to indent lines.
|#
(define verse
    (lambda (#:title [title ""] #:italic [italic #f] . text)
     (case (current-poly-target)
      [(ltx pdf)
       (define poem-title (if (non-empty-string? title)
                              (apply string-append `("\\poemtitle{" ,title "}"))
                              ""))

       ; Replace double spaces with "\vin " to indent lines
       (define poem-text (ltx-escape-str (string-replace (apply string-append text) "  " "\\vin ")))

       ; Optionally italicize poem text
       (define fmt-text (if italic (format "{\\itshape ~a}" (latex-poem-linebreaks poem-text))
                                   (latex-poem-linebreaks poem-text)))

       `(txt "\n\n" ,poem-title
             "\n\\settowidth{\\versewidth}{"
             ,(longest-line poem-text)
             "}"
             "\n\\begin{verse}[\\versewidth]"
             ,fmt-text
             "\\end{verse}\n\n")]
      [else
        (define pre-attrs (if italic '([class "verse"] [style "font-style: italic"])
                                     '([class "verse"])))
        (define poem-xpr (if (non-empty-string? title)
                             `(pre ,pre-attrs
                                   (p [[class "poem-heading"]] ,title)
                                   ,@text)
                             `(pre ,pre-attrs
                                   ,@text)))
        `(div [[class "poem"]] ,poem-xpr)])))
#|
Helper function for typesetting poetry in LaTeX. Poetry should be centered
on the longest line. Browsers will do this automatically with proper CSS but
in LaTeX we need to tell it what the longest line is.
|#
(define (longest-line str)
  (first (sort (string-split str "\n")
               (λ(x y) (> (string-length x) (string-length y))))))

(define (latex-poem-linebreaks text)
  (regexp-replace* #px"([^[:space:]])\n(?!\n)" ; match newlines that follow non-whitespace
                                               ; and which are not followed by another newline
                   text
                   "\\1 \\\\\\\\\n"))

(define (color c . text)
  (case (current-poly-target)
    [(ltx pdf) `(txt "\\textcolor{" ,c "}{" ,@(esc text) "}")]
    [else `(span [[style ,(string-append "color: " c)]] ,@text)]))
