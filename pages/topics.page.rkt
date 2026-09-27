#lang camp/page

(require notepad/render racket/list)

#:title "Topics"
#:slug "topics"

(define by-topic (get-taxonomy-pages "posts" "topics"))
(define topics (sort (hash-keys by-topic) string-ci<?))

`((h1 [[class "page-title"]] "Topics")
  (div [[class "topics"]]
       ,@(for/list ([t (in-list topics)])
           (define pages (hash-ref by-topic t))
           `(section [[class "topic"] [id ,t]]
                     (h2 ,t (span [[class "n"]] ,(number->string (length pages))))
                     (ul ,@(for/list ([pl (in-list pages)])
                             `(li (a [[href ,(page-link-url pl)]] ,(page-link-title pl)))))))))
