#lang racket

(require racket/string txexpr pollen/core)

(provide (all-defined-out))
#|
Index functionality: allows creation of a book-style keyword index.

* An index ENTRY refers to the heading that will appear in the index.
* An index LINK is a txexpr that has class="index-entry" and
  title="ENTRY-WORD".

|#

; Given a file, returns a list of links to that file, one for each topic
; listed in the metas
(define (get-index-links pnode)
  (define pnode-tags (select-from-metas 'topics pnode))
  (define (make-index-link itag)
    `(a [[href ,(symbol->string pnode)]
         [title ,itag]]
        ,(select-from-metas 'title pnode)))
  (if pnode-tags
    (map make-index-link (string-split pnode-tags ","))
    '()))

; Returns a list of index links (not entries!) for all files in file-list.
(define (collect-index-links file-list)
  (apply append (map get-index-links file-list)))

; Given a list of index links, returns a list of headings (keywords). This list
; has duplicates removed and is sorted in ascending alphabetical order.
; Note that the list is case-sensitive by design; "thing" and "Thing" are
; treated as separate keywords.
(define (index-headings entrylink-list)
  (sort (remove-duplicates (map (λ(tx) (attr-ref tx 'title))
                                entrylink-list))
        string-ci<?))

; Given a heading and a list of index links, returns only the links that match
; the heading.
(define (match-index-links keyword entrylink-list)
  (filter (λ(link)(string=? (attr-ref link 'title) keyword))
          entrylink-list))
