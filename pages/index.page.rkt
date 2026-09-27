#lang camp/page

(require notepad/render)

#:title "The Notepad"
#:slug "index"

(define posts (get-collection "posts"))
(define first-year (~d "yyyy" (post-date (car (reverse posts)))))
(define last-year (~d "yyyy" (post-date (car posts))))

`((p [[class "lede"]]
     "Tech notes by Joel Dueck, " ,first-year "–" ,last-year ". Fixes for Windows and Office problems, "
     "ebook and podcast workflows, and later a lot of Pollen and Racket. Each post is also published "
     "as plain Markdown for language models and other readers.")
  (p [[class "meta lede-meta"]]
     ,(format "~a posts" (length posts))
     (span [[class "sep"]] middot)
     (a [[href "/feed.atom"]] "feed.atom"))
  ,(post-index posts))
