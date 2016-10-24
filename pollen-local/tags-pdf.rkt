#lang racket

(require "polytag.rkt"
         "publication-vals.rkt"  
         "common-helpers.rkt")
         
(require txexpr
         pollen/decode
         pollen/setup)

(provide (all-defined-out))

(define (pdf-root attrs elements)
  (define first-pass (decode-elements (get-elements (wrap-comment-section (txexpr 'root null (esc elements)) esc))
                                      #:inline-txexpr-proc (compose1 txt-decode pdf-link-decoder)
                                      #:string-proc (compose1 smart-quotes smart-dashes)
                                      #:exclude-tags '(script style figure txt-noescape)))
  (txexpr 'body null (decode-elements first-pass #:inline-txexpr-proc txt-decode)))

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

; Helper function: escape $, %, #, _ and & for LaTeX
; when not already preceeded by a backslash
(define (ltx-escape-str str)
  (regexp-replace* #px"(?<!\\\\)([$#%&_])" str "\\\\\\1"))

; Helper function: escape all strings in a list
(define (esc elems)
  (for/list ([e (in-list elems)])
            (if (string? e) (ltx-escape-str e) e)))

(define (pdf-link-decoder inline-txpr)
  (if (eq? 'zlink (get-tag inline-txpr))
      (let ([elems (get-elements inline-txpr)])
           `(txt "\\href{" ,(ltx-escape-str (first elems)) "}"
                 "{" ,@(esc (rest elems)) "}"))
      inline-txpr))

(define (pdf-p attrs elems)     `(txt ,@(esc elems) "\n\n"))
(define (pdf-i attrs text)      `(txt "{\\itshape " ,@(esc text) "}"))
(define (pdf-emph attrs text)   `(txt "\\emph{" ,@(esc text) "}"))
(define (pdf-b attrs text)      `(txt "{\\bfseries " ,@(esc text) "}"))
(define (pdf-strong attrs text) `(txt "\\textbf{" ,@(esc text) "}"))
(define (pdf-color c attrs text) `(txt "\\textcolor{" ,c "}{" ,@(esc text) "}"))
  
(define (pdf-ol attrs elements)     `(txt "\\begin{enumerate}" ,@elements "\\end{enumerate}"))
(define (pdf-ul attrs elements)     `(txt "\\begin{itemize}" ,@elements "\\end{itemize}"))
(define (pdf-item attrs elements)   `(txt "\\item " ,@(esc elements)))

(define (pdf-sup attrs text)        `(txt "\\textsuperscript{" ,@(esc text) "}"))

; preserve as zlink for possible processing by enclosing tags; see also pdf-root
(define (pdf-link url attrs elems)   `(zlink ,url ,@elems))

(define (pdf-blockquote attrs elems) `(txt "\\begin{quote}" ,@(esc elems) "\\end{quote}"))
(define (pdf-newthought attrs elems) `(txt "\\newthought{" ,@(esc elems) "}"))
(define (pdf-smallcaps attrs elems)  `(txt "\\smallcaps{" ,@(esc elems) "}"))

(define (pdf-inline-math attrs elems) `(txt-noescape "$" ,@elems "$"))

(define (pdf-center attrs words)     `(txt "\\begin{center}" ,@(esc words) "\\end{center}"))
(define (pdf-section attrs title)    `(txt "\\section{" ,@(esc title) "}"))
(define (pdf-subsection attrs title) `(txt "\\subsection{" ,@(esc title) "}"))

(define (pdf-index-entry entry attrs text) `(txt "\\index{" ,entry "}" ,@(esc text)))

(define (pdf-figure src attrs elements)
  (define source (string-append (if (attr-val 'has-print-version attrs) 
                                    image-originals-dir 
                                    image-dir) 
                                src))
  (define figure-env (if (attr-val 'fullwidth attrs) "figure*" "figure"))
  `(txt "\\begin{" ,figure-env "}"
        "\\includegraphics{" ,source "}"
        "\\caption{" ,@(esc (latex-no-hyperlinks-in-margin elements)) "}"
        "\\end{" ,figure-env "}"))

(define (pdf-image src attrs elems)
  (define source (string-append (if (attr-val 'has-print-version attrs) 
                                    image-originals-dir 
                                    image-dir) 
                                src))
  `(txt "\n\n\\frame{\\includegraphics{" ,source "}}"))

; Note that because of the need to escape backslashes in LaTeX, you
; cannot use any other commands inside a ◊code tag
(define (pdf-code attrs text)
  `(txt "\\texttt{"
        ,@(esc (list (string-replace (apply string-append text) "\\" "\\textbackslash ")))
        "}"))

;
(define (pdf-noun attrs text)
 `(txt "\\texttt{" ,@(esc text) "}"))

(define (pdf-blockcode attrs text)
  (define filename (attr-val 'filename attrs))
  (define caption 
          ; Note that using title= instead of caption= prevents listings from showing up in
          ; the "List of Listings" in the table of contents
          (if (string>? filename "") (string-append "[title={\\fileicon{} " filename "}]") ""))
  `(txt-noescape "\\begin{lstlisting}" ,caption "\n" ,@text "\n\\end{lstlisting}"))

(define (pdf-Latex attrs text)
  `(txt "\\LaTeX\\xspace"))      ; \xspace adds a space if the next char is not punctuation

(define (pdf-verse attrs text)
  (let ([title (attr-val 'title attrs)]
        [italic (attr-val 'italic attrs)])
       (define poem-title (if (non-empty-string? title)
                              (apply string-append `("\\poemtitle{" ,title "}"))
                              ""))
       ; Replace double spaces with "\vin " to indent lines
       (define poem-text (ltx-escape-str (string-replace (apply string-append text) "  " "\\vin ")))
       (define longest-line 
         (first (sort (string-split poem-text "\n")
                      (λ(x y) (> (string-length x) (string-length y))))))
       ; Optionally italicize poem text
       (define fmt-text (if italic (format "{\\itshape ~a}" (latex-poem-linebreaks poem-text))
                                   (latex-poem-linebreaks poem-text)))
       `(txt "\n\n" ,poem-title
             "\n\\settowidth{\\versewidth}{"
             ,longest-line
             "}"
             "\n\\begin{verse}[\\versewidth]"
             ,fmt-text
             "\\end{verse}\n\n")))

(define (latex-poem-linebreaks text)
  (regexp-replace* #px"([^[:space:]])\n(?!\n)" ; match newlines that follow non-whitespace
                                               ; and which are not followed by another newline
                   text
                   "\\1 \\\\\\\\\n"))

#|
  This function is called from within the margin/sidenote functions when
  targeting Latex/PDF, to filter out hyperlinks from within those tags.
  (See notes above)
|#
(define (latex-no-hyperlinks-in-margin txpr-elems)
  ; First define a local function that will transform each ◊hyperlink
  (define (cleanlinks inline-tx)
      (if (eq? 'zlink (get-tag inline-tx))
        `(txt ,@(cdr (get-elements inline-tx))
              ; Return the text with the URI in parentheses
              " (\\url{" ,(ltx-escape-str (car (get-elements inline-tx))) "})")
        inline-tx)) ; otherwise pass through unchanged
  ; Run txpr through the decode-elements wringer using the above function to
  ; flatten out any ◊hyperlink tags
  (decode-elements txpr-elems #:inline-txexpr-proc cleanlinks))

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

(define (pdf-margin-note attrs elems)
  `(txt "\\marginnote{" ,@(latex-no-hyperlinks-in-margin elems) "}"))

(define (pdf-numbered-note attrs elems)
  `(txt "\\footnote{" ,@(latex-no-hyperlinks-in-margin elems) "}"))

;
(define (pdf-margin-figure src attrs elems)
  (define source (string-append (if (attr-val 'has-print-version attrs) 
                                    image-originals-dir 
                                    image-dir) 
                                src))
  `(txt "\\begin{marginfigure}"
        "\\includegraphics{" ,source "}"
        "\\caption{" ,@(latex-no-hyperlinks-in-margin elems) "}"
        "\\end{marginfigure}"))

;
(define (pdf-tweet attrs contents)
  (check-required-attributes 'tweet '(id handle realname permlink timestamp) attrs)
  
  ; Helper: replaces any link with just the link's second element
  (define (zap-links t)
     (if (and (txexpr? t) (equal? 'zlink (get-tag t))) (cadr (get-elements t)) t))
       
  `(txt "\\begin{mdframed}[style=tweet]\n"
        "{\\NHLight\\raggedright\\small "
        ,@(esc (map zap-links contents))
        "}\n\\textcolor[RGB]{220,220,220}{\\hrule}\n"
        "{\\sffamily\\small " ,(attr-val 'realname attrs)
        "} • {\\NHLight\\raggedleft\\footnotesize @" ,(attr-val 'handle attrs)
        " \\hfill " ,(attr-val 'timestamp attrs) "\\footnotemark}" 
        "\n\\end{mdframed}\n\\footnotetext{\\url{" ,(attr-val 'permlink attrs) "}}\n"))

;
(define (pdf-retweet attrs contents)
  (check-required-attributes 'retweet '(permlink handle realname timestamp) attrs)
  `(txt "\n\n@" ,(attr-val 'handle attrs) ", " ,(attr-val 'timestamp attrs) ": " ,@(esc contents)))

(define (pdf-updatebox datestr attrs contents)
  `(txt ,@(esc contents)))
  
(define (pdf-comment attrs contents)
  (check-required-attributes 'comment '(author datetime authorlink) attrs)
  (let ([author (attr-val 'author attrs)]
        [comment-date (attr-val 'datetime attrs)])
       `(txt-comment "\\begin{quote}\n" ,@(esc contents)
                     "\n\\attrib{" ,(ltx-escape-str author) ", " ,comment-date "}"
                     "\n\\end{quote}\n\n")))

(define (pdf-td-tag . tx-els) `(txt ,@(esc tx-els)))
(define (pdf-th-tag . tx-els) `(txt ,@(esc tx-els)))
(define (pdf-tr-tag . tx-elems) `(txt ,@(add-between tx-elems " & ") " \\\\\n"))
  
; A lot of code duplicated between this function and the HTML one.
; Decided to do it this way to get complete independence between the
; HTML and PDF paths.
(define (pdf-table attrs elems)
  (define c-aligns (attr-val 'columns attrs))
  (cond [(not (or (equal? #f c-aligns) (column-alignments-string? c-aligns)))
         (raise-argument-error 'table "#:columns must be a string containing 'l', 'r', or 'c'" (assq 'columns attrs))])

  ; Split the arguments into rows (at "\n"), and split any string values into
  ; separate cells (at "|") and remove extra whitespace.
  (define rows-parsed (for/list ([row (in-list (split-by elems "\n"))])
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
      (cons (map pdf-th-tag header-row)
            (for/list ([row (in-list other-rows)])
                      (map pdf-td-tag row)))))
  
  (define col-args (if (not c-aligns) (make-string (length (first table-rows)) #\l) c-aligns))
  
  (match-let ([(cons header-row other-rows) rows-of-cells])
    `(txt "\\begin{table}[h!]\n"
          "  \\centering\n"
          "  \\begin{tabular}{" ,col-args "}\n"
          "    \\toprule\n"
          ,(apply pdf-tr-tag header-row)
          "    \\midrule\n"
          ,@(for/list ([row (in-list other-rows)]) (apply pdf-tr-tag row))
          "    \\bottomrule\n"
          "  \\end{tabular}\n"
          "\\end{table}\n")))
