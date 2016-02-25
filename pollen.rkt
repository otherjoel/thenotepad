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
         racket/date)

(provide add-between
         attr-ref
         attrs-have-key?
         make-txexpr
         string-split
         get-markup-source
         string-contains?)
(provide (all-defined-out))

(module setup racket/base
    (provide (all-defined-out))
    (define poly-targets '(html ltx pdf)))

(define (root . elements)
  (case (current-poly-target)
    [(ltx pdf)
     (define first-pass (decode-elements elements
                                         #:inline-txexpr-proc (compose1 txt-decode hyperlink-decoder)
                                         #:string-proc (compose1 ltx-escape-str smart-quotes smart-dashes)
                                         #:exclude-tags '(script style figure txt-noescape)))
     (txexpr 'body null (decode-elements first-pass #:inline-txexpr-proc txt-decode))]

    [else
      (define first-pass (decode-elements elements
                                          #:txexpr-elements-proc detect-paragraphs
                                          #:exclude-tags '(script style figure table)))
      (define second-pass (decode-elements first-pass
                                           #:block-txexpr-proc detect-newthoughts
                                           #:inline-txexpr-proc hyperlink-decoder
                                           #:string-proc (compose1 smart-quotes smart-dashes)
                                           #:exclude-tags '(script style pre code)))
      (wrap-comment-section (txexpr 'body null second-pass))]))

(define (wrap-comment-section txpr)
  (define (is-comment? tx)
    (and (txexpr? tx)
         (equal? 'div (get-tag tx))
         (attrs-have-key? tx 'class)
         (string=? "comment-box" (attr-ref tx 'class))))
  (let-values ([(splut comments) (splitf-txexpr txpr is-comment?)])
    (if (not (empty? comments))
        (txexpr 'body null (apply append (list (get-elements splut) `(,(apply comment-section comments)))))
        txpr)))

; Escape $,%,# and & for LaTeX
(define (ltx-escape-str str)
  (regexp-replace* #px"([$#%&])" str "\\\\\\1"))

#|
`txt` is called by root when targeting LaTeX/PDF. It converts all elements inside
a ◊txt tag into a single concatenated string. ◊txt is not intended to be used in
normal markup; its sole purpose is to allow other tag functions to return LaTeX
code as a valid X-expression rather than as a string.
|#
(define (txt-decode xs)
    (if (member (get-tag xs) '(txt txt-noescape))
        (apply string-append (get-elements xs))
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

(define (margin-figure source . caption)
    (define refid (symbol->string (gensym 'marginfigure)))
    (case (current-poly-target)
      [(ltx pdf)
       `(txt "\\begin{marginfigure}"
             "\\includegraphics{" ,source "}"
             "\\caption{" ,@(latex-no-hyperlinks-in-margin caption) "}"
             "\\end{marginfigure}")]
      [else
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
      [(ltx pdf) `(txt "\\href{" ,url "}" "{" ,@tag-contents "}")]
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
     (define (zap-links t)
       (if (and (txexpr? t) (equal? 'link (get-tag t))) (get-elements t) t))

     `(txt "\\begin{quote}"
                     ,@(map zap-links contents)
                     "\n\\attrib{" ,tweeter-IRL " (@" ,tweeter
                     "), \\href{" ,tweet-link "}{" ,tweet-time "}}"

                     "\\end{quote}")]
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
    [(ltx pdf) `(txt "\n\n(@" ,tweeter ", " ,tweet-time ": " ,@contents)]
    [else
      `(blockquote [[class "retweet"]]
        (p [[class "twRetweetMeta"]] (b ,tweeter-IRL)
           (span [[class "twScreenName"]] ,(format " (@~a) " tweeter))
           (span [[class "twTimeStamp"]] (a [[href ,tweet-link]] ,tweet-time)))
        ,@contents)]))

(define (updatebox d . contents)
  (case (current-poly-target)
    [(ltx pdf) `(txt ,@contents)]
    [else
      `(div [[class "updateBox"]]
            (p (b (span [[class "smallcaps"]] "Update, " ,d)))
            ,@contents)]))


(define (comment-section . contents)
  (case (current-poly-target)
    [(ltx pdf) `(txt ,(section "Comments") ,@contents)]
    [else `(section [[class "comments"]] ,@contents)]))

(define (comment #:author author #:datetime comment-date #:authorlink author-url . comment-text)
  (case (current-poly-target)
    [(ltx pdf) `(txt "\\begin {quote}" ,@comment-text
                     "\n\\attrib{" ,author ", " ,comment-date "}"
                     "\\end{quote}")]
    [else `(div [[class "comment-box"]]
                (p [[class "comment-meta"]]
                   (span [[class "comment-name"]]
                         (a [[href ,author-url]] ,author))
                   (span [[class "comment-time"]] ,comment-date))
                ,@comment-text)]))

(define (p . words)
  (case (current-poly-target)
    [(ltx pdf) `(txt ,@words)]
    [else `(p ,@words)]))

(define (blockquote . words)
  (case (current-poly-target)
    [(ltx pdf) `(txt "\\begin{quote}" ,@words "\\end{quote}")]
    [else `(blockquote ,@words)]))

(define (newthought . words)
  (case (current-poly-target)
    [(ltx pdf) `(txt "\\newthought{" ,@words "}")]
    [else `(span [[class "newthought"]] ,@words)]))

(define (smallcaps . words)
  (case (current-poly-target)
    [(ltx pdf) `(txt "\\smallcaps{" ,@words "}")]
    [else `(span [[class "smallcaps"]] ,@words)]))

(define (∆ . elems)
  (case (current-poly-target)
    [(ltx pdf) `(txt-noescape "$" ,@elems "$")]
    [else `(span "\\(" ,@elems "\\)")]))

(define (center . words)
  (case (current-poly-target)
    [(ltx pdf) `(txt "\\begin{center}" ,@words "\\end{center}")]
    [else `(div [[style "text-align: center"]] ,@words)]))

(define (section title)
  (case (current-poly-target)
    [(ltx pdf) `(txt "\\section{" ,title "}")]
                 ;"\\label{sec:" ,title ,(symbol->string (gensym)) "}")]
    [else `(h2 ,title)]))

(define (subsection title)
  (case (current-poly-target)
    [(ltx pdf) `(txt "\\subsection{" ,title "}")]
    [else `(h3 ,title)]))

(define (index-entry entry . text)
  (case (current-poly-target)
    [(ltx pdf) `(txt "\\index{" ,entry "}" ,@text)]
    [else
      (case (apply string-append text)
        [("") `(a [[id ,entry] [class "index-entry"]])]
        [else `(a [[id ,entry] [class "index-entry"]] ,@text)])]))

(define (figure source #:fullwidth [fullwidth #f] . caption)
  (case (current-poly-target)
    [(ltx pdf)
     (define figure-env (if fullwidth "figure*" "figure"))
     `(txt "\\begin{" ,figure-env "}"
           "\\includegraphics{" ,source "}"
           "\\caption{" ,@(latex-no-hyperlinks-in-margin caption) "}"
           "\\end{" ,figure-env "}")]
    [else (if fullwidth
              ; Note the syntax for calling another tag function, margin-note,
              ; from inside this one. Because caption is a list, we need to use
              ; (apply) to pass the values in that list as individual arguments.
              `(figure [[class "fullwidth"]] ,(apply margin-note caption) (img [[src ,source]]))
              `(figure ,(apply margin-note caption) (img [[src ,source]])))]))

(define (image src)
  (case (current-poly-target)
    [(ltx pdf) `(txt "\\includegraphics{" ,src "}")]
    [else `(img [[src ,src]])]))

(define (code . text)
  (case (current-poly-target)
    [(ltx pdf) `(txt "\\texttt{" ,@text "}")]
    [else `(code ,@text)]))

(define (noun . text)
  (case (current-poly-target)
    [(ltx pdf) `(txt "\\texttt{" ,@text "}")]
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
    [(ltx pdf) `(txt "\\item " ,@elements)]
    [else `(li ,@elements)]))

(define (sup . text)
  (case (current-poly-target)
    [(ltx pdf) `(txt "\\textsuperscript{" ,@text "}")]
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
    [(ltx pdf) `(txt "{\\itshape " ,@text "}")]
    [else `(i ,@text)]))

(define (emph . text)
  (case (current-poly-target)
    [(ltx pdf) `(txt "\\emph{" ,@text "}")]
    [else `(em ,@text)]))

(define (b . text)
  (case (current-poly-target)
    [(ltf pdf) `(txt "{\\bfseries " ,@text "}")]
    [else `(b ,@text)]))

(define (strong . text)
  (case (current-poly-target)
    [(ltx pdf) `(txt "\\textbf{" ,@text "}")]
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
       (define poem-text (string-replace (apply string-append text) "  " "\\vin "))

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
    [(ltx pdf) `(txt "\\textcolor{" ,c "}{" ,@text "}")]
    [else `(span [[style ,(string-append "color: " c)]] ,@text)]))
