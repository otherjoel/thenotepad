#lang racket/base

(require camp
         camp/page
         punct/doc
         punct/fetch
         racket/file
         racket/list
         racket/match
         racket/string
         net/uri-codec)

(provide render-post
         render-page
         notepad-html
         post-date
         post-topics
         topic-url
         post-index
         (all-from-out camp))

(define source-url "https://github.com/otherjoel/thenotepad")
(define camp-url "https://joeldueck.com/what-about/camp/")

;; ---------------------------------------------------------------- small helpers

(define (post-date pl) (hash-ref (page-link-metas pl) 'date))

(define (split-topics v)
  (cond [(list? v) v]
        [(string? v) (filter non-empty-string? (map string-trim (string-split v ",")))]
        [else '()]))

(define (post-topics pl) (split-topics (hash-ref (page-link-metas pl) 'topics '())))

(define (topic-url t) (string-append "/topics.html#" (uri-encode t)))

(define (sep) '(span [[class "sep"]] middot))

(define (attr-list? a)
  (and (list? a) (andmap (λ (p) (and (list? p) (= 2 (length p)) (symbol? (car p)))) a)))

(define (xexpr-text x)
  (cond [(string? x) x]
        [(and (pair? x) (symbol? (car x)))
         (define kids (if (and (pair? (cdr x)) (attr-list? (cadr x))) (cddr x) (cdr x)))
         (apply string-append (map xexpr-text kids))]
        [else ""]))

(define (slugify str)
  (string-trim (regexp-replace* #px"[^a-z0-9]+" (string-downcase str) "-") "-"))

;; ---------------------------------------------------------------- custom elements → HTML

(define (attr attrs key [default #f])
  (match (assq key attrs) [(list _ v) v] [_ default]))

(define (notepad-html tag attrs elems)
  (match tag
    ['figure
     (define caption (string-trim (apply string-append (map xexpr-text elems))))
     (define width (attr attrs 'width))
     `(figure (img [[src ,(attr attrs 'src)]
                    [alt ,caption]
                    ,@(if width `((width ,width)) '())
                    [loading "lazy"]])
              ,@(if (string=? caption "") '() `((figcaption ,@elems))))]
    ['updatebox
     `(aside [[class "update"]]
             (p [[class "update-label meta"]] "Update " ,(attr attrs 'date))
             ,@elems)]
    ['comment
     (define author (attr attrs 'author))
     (define link (attr attrs 'link ""))
     `(div [[class "comment"]]
           (p [[class "comment-meta meta"]]
              ,(if (string=? link "") author `(a [[href ,link]] ,author))
              ,(sep)
              ,(attr attrs 'date))
           ,@elems)]
    ['tweet
     (define handle (attr attrs 'handle))
     `(blockquote [[class "tweet"]]
                  ,@elems
                  (p [[class "tweet-meta meta"]]
                     ,(attr attrs 'name) " "
                     (a [[href ,(string-append "https://twitter.com/" handle)]] "@" ,handle)
                     ,(sep)
                     (a [[href ,(attr attrs 'url)]] ,(attr attrs 'date))))]
    ['color `(span [[style ,(string-append "color: " (attr attrs 'value))]] ,@elems)]
    [_ #f]))

;; Fenced code blocks: Punct gives (pre (code [[info "language-X"]] …)). On this site the info string
;; is the listing's filename, if any. Headings get ids so sections can be linked.
(define (tidy-body xs)
  (define (walk x)
    (match x
      [`(pre (code ((info ,info)) ,content ...))
       (define filename (regexp-replace #rx"^language-" info ""))
       `(figure [[class "listing"]]
                (figcaption ,filename)
                (pre (code ,@content)))]
      [(list (and tag (or 'h2 'h3)) kids ...)
       #:when (not (and (pair? kids) (attr-list? (car kids))))
       `(,tag [[id ,(slugify (xexpr-text x))]] ,@(map walk kids))]
      [(list (? symbol? tag) (? attr-list? attrs) kids ...)
       `(,tag ,attrs ,@(map walk kids))]
      [(list (? symbol? tag) kids ...) `(,tag ,@(map walk kids))]
      [_ x]))
  (map walk xs))

;; ---------------------------------------------------------------- layout

(define nav-items
  '(("index" "/" "Index")
    ("topics" "/topics.html" "Topics")
    ("books" "/books.html" "Books")
    ("about" "/about.html" "About")
    ("feed" "/feed.atom" "Feed")))

(define (layout #:title title
                #:current [current #f]
                #:head [head-extra '()]
                . body)
  `(html [[lang "en"]]
    (head
     (meta [[charset "utf-8"]])
     (meta [[name "viewport"] [content "width=device-width, initial-scale=1"]])
     (title ,(if (equal? title "The Notepad") title (string-append title " · The Notepad")))
     (link [[rel "stylesheet"] [href "/styles.css"]])
     (link [[rel "alternate"] [type "application/atom+xml"] [title "The Notepad"] [href "/feed.atom"]])
     (link [[rel "icon"] [type "image/png"] [sizes "32x32"] [href "/favicon-32x32.png"]])
     (link [[rel "icon"] [type "image/png"] [sizes "16x16"] [href "/favicon-16x16.png"]])
     (link [[rel "apple-touch-icon"] [href "/apple-touch-icon.png"]])
     ,@head-extra)
    (body
     (header [[class "masthead"]]
             (a [[class "wordmark"] [href "/"]] "The Notepad")
             (nav [[aria-label "Site"]]
                  ,@(for/list ([item (in-list nav-items)])
                      (match-define (list slug href label) item)
                      (if (equal? slug current)
                          `(a [[href ,href] [aria-current "page"]] ,label)
                          `(a [[href ,href]] ,label)))))
     (div [[class "site"]]
          (main ,@body)
          (footer [[class "sitefoot meta"]]
                  (span "© Joel Dueck")
                  (a [[href ,source-url]] "Source")
                  (span "Built with " (a [[href ,camp-url]] "Camp")))))))

;; ---------------------------------------------------------------- posts

;; Publish the Punct source next to the page as <slug>.md, minus the #lang line.
(define (write-markdown-copy! doc ctxt)
  (define src (meta-ref doc 'here-path))
  (when (and src (current-output-dir) (file-exists? src))
    (define text (regexp-replace #px"^#lang[^\n]*\n\\s*" (file->string src) ""))
    (define dest (build-path (current-output-dir) "posts" (string-append (context-slug ctxt) ".md")))
    (make-parent-directory* dest)
    (unless (and (file-exists? dest) (equal? (file->string dest) text))
      (call-with-output-file dest #:exists 'truncate/replace
        (λ (o) (write-string text o))))))

(define (comment-block? x)
  (match x [`(div ((class "comment")) ,_ ...) #t] [_ #f]))

(define (footnotes-block? x)
  (match x [`(section ((class "footnotes")) ,_ ...) #t] [_ #f]))

(define (post-nav-link label pl)
  (if pl
      `(span ,label ": " (a [[href ,(page-link-url pl)]] ,(page-link-title pl)))
      ""))

(define (render-post doc ctxt)
  (write-markdown-copy! doc ctxt)
  (define title (meta-ref doc 'title))
  (define date (meta-ref doc 'date))
  (define updated (meta-ref doc 'updated))
  (define topics (hash-ref (context-taxonomies ctxt) "topics" '()))
  (define md-name (string-append (context-slug ctxt) ".md"))
  (define body (tidy-body (camp-doc->html-xexpr doc notepad-html)))
  (define comments (filter comment-block? body))
  (define footnotes (filter footnotes-block? body))
  (define main-body (filter (λ (x) (not (or (comment-block? x) (footnotes-block? x)))) body))
  (layout
   #:title title
   #:head `((link [[rel "alternate"] [type "text/markdown"] [href ,md-name]]))
   `(article
     (header
      (h1 ,title)
      (div [[class "meta"]]
           (span (time [[datetime ,(~d "yyyy-MM-dd" date)]] ,(~d "yyyy-MM-dd" date))
                 ,@(if updated
                       `(,(sep) "updated " (time [[datetime ,(~d "yyyy-MM-dd" updated)]] ,(~d "yyyy-MM-dd" updated)))
                       '())
                 ,@(if (null? topics)
                       '()
                       `(,(sep) ,@(add-between (for/list ([t (in-list topics)]) `(a [[href ,(topic-url t)]] ,t))
                                               ", "))))
           (a [[href ,md-name] [type "text/markdown"]] ,md-name)))
     (div [[class "body"]] ,@main-body ,@footnotes)
     ,@(if (null? comments)
           '()
           `((section [[class "comments"]]
                      (h2 [[id "comments"]] "Comments")
                      ,@comments)))
     (footer [[class "meta"]]
             ,(post-nav-link "Older" (next ctxt))
             ,(post-nav-link "Newer" (prev ctxt))))))

;; ---------------------------------------------------------------- pages

(define (render-page doc ctxt)
  (define title (meta-ref doc 'title))
  (define slug (context-slug ctxt))
  (define body (tidy-body (camp-doc->html-xexpr doc notepad-html)))
  (cond
    [(camp-page-doc? doc)
     (apply layout #:title title #:current slug body)]
    [else
     (layout #:title title #:current slug
             `(article
               (header (h1 ,title)
                       ,@(match (meta-ref doc 'updated)
                           [#f '()]
                           [u `((div [[class "meta"]] "Updated " (time [[datetime ,u]] ,u)))]))
               (div [[class "body"]] ,@body)))]))

;; ---------------------------------------------------------------- listings

;; The dated index of every post: year shown once per group, then month-day and title.
(define (post-index posts)
  `(div [[class "index"]]
        ,@(for/fold ([out '()] #:result (reverse out))
                    ([pl (in-list posts)]
                     [prev-pl (in-list (cons #f posts))])
            (define d (post-date pl))
            (define y (~d "yyyy" d))
            (define new-year? (not (and prev-pl (equal? y (~d "yyyy" (post-date prev-pl))))))
            (define topics (post-topics pl))
            (define row
              `(div [[class "row"]]
                    (span [[class "y"]] ,(if new-year? y ""))
                    (span [[class "md"]] (time [[datetime ,(~d "yyyy-MM-dd" d)]] ,(~d "MM-dd" d)))
                    (span [[class "t"]]
                          (a [[href ,(page-link-url pl)]] ,(page-link-title pl))
                          ,@(if (null? topics) '()
                                `((span [[class "tp"]] ,(string-join topics ", ")))))))
            ;; A year's rule is its own grid row, so baseline alignment of the text can't shift it
            (if (and new-year? prev-pl)
                (list* row '(div [[class "yearrule"] [aria-hidden "true"]] (span) (span) (span)) out)
                (cons row out)))))
