#lang racket/base

;; Provides a connection to a database of posts.
(require db/sqlite3 db/base racket/list racket/match racket/function racket/string)
(require pollen/setup pollen/core)

(provide QUERY-DEBUG
         init-db
         save-post
         latest-posts
         topic-list)

;; What follows is the cheapest ORM ever made.
;; You give it table names and field names. 
;; When you query it, it gives you rows as hash tables instead of vectors.
;; This is generic SQL stuff. None of it is provided outside the module.

(define DBFILE (build-path (current-project-root) "notepad.sqlite"))
(define QUERY-DEBUG (make-parameter #f))

(define (backtick str) (format "`~a`" str))
(define (list->sql-fields fields) (apply string-append (add-between (map backtick fields) ", ")))
(define (list->sql-parameters fields)
  (apply string-append (add-between (map (λ(x) (format "?~a" (add1 x))) (range (length fields))) ", ")))

(define dbc (sqlite3-connect #:database DBFILE #:mode 'create))

(define (log-query q) (unless (not (QUERY-DEBUG)) (println q)))

(define (table-schema tablename fields #:primary-key-cols [primary-cols '()])
  (define primary-key
    (format "PRIMARY KEY (~a)"
            (list->sql-fields (if (empty? primary-cols) (list (first fields)) primary-cols))))
  (format "CREATE TABLE IF NOT EXISTS `~a` (~a, ~a);"
          tablename
          (list->sql-fields fields)
          primary-key))

(define (make-insert-query tablename fields)
  (format "INSERT OR REPLACE INTO `~a` (`rowid`, ~a) values ((SELECT `rowid` FROM `~a` WHERE `~a`= ?1), ~a)"
          tablename
          (list->sql-fields fields)
          tablename
          (first fields)
          (list->sql-parameters fields)))

(define (row->hash vector-row fields)
  (define (interleave xs ys)
    (match (list xs ys)
      [(list (cons x xs) (cons y ys)) (cons x (cons y (interleave xs ys)))]
      [(list '() ys)                  ys]
      [(list xs '())                  xs]))
  (apply hash (interleave (map string->symbol fields) (vector->list vector-row))))

(define (make-select-query table fields where-clause)
  (format "SELECT ~a FROM `~a` WHERE ~a"
          (list->sql-fields fields)
          table
          where-clause))

(define (query-exec-logging q . args)
  (log-query q)
  (apply query-exec dbc q args))

(define (select-rows-hash query fields)
  (log-query query)
  (define result (query-rows dbc query))
  (cond [(empty? result) result]
        [else (map (curryr row->hash fields) result)]))

;; Now the non-generic stuff.
;; Our database schema:
(define posts-fields       '("pagenode" "published" "updated" "title" "header_html" "html"))
(define posts-insert-query (make-insert-query "posts" posts-fields))
(define topics-fields `("pagenode" "topic"))

;; Now the provided (public) functions.

;; Templates that will write to the DB must call this function to ensure the tables
;; are set up with the most current schema. This is a compromise between A) having to
;; run some manual task when the schema changes, and B) running these queries every
;; single time pollen.rkt is loaded.
(define (init-db)
  (query-exec-logging (table-schema "posts" posts-fields))
  (query-exec-logging (table-schema "posts-topics" topics-fields #:primary-key-cols topics-fields)))

(define (save-post pnode metas header-html body-html)
  (query-exec-logging posts-insert-query
                      (symbol->string pnode)
                      (hash-ref metas 'published)
                      (hash-ref metas 'updated "")
                      (hash-ref metas 'title)
                      header-html
                      body-html)
  
  (define topics (select-from-metas 'topics metas))
  (cond [topics
         (query-exec-logging "DELETE FROM `posts-topics` WHERE `pagenode`=?1" (symbol->string pnode))
         (define rows-to-insert
           (for/list ([tag (in-list (string-split (regexp-replace* #px"\\s*,\\s*" topics ",") ","))])
                     (format "(\"~a\", \"~a\")" (symbol->string pnode) tag)))
         (define rows-str (apply string-append (add-between rows-to-insert ", ")))
         (query-exec-logging (string-append "INSERT INTO `posts-topics` (`pagenode`, `topic`) VALUES " rows-str))]))

(define (select-post pnode)
  (define query (make-select-query "posts" posts-fields "`pagenode`=?1"))
  (log-query query)
  (define result (query-rows dbc  pnode))
  (cond
    [(empty? result) result]
    [else (row->hash (first result) posts-fields)]))

(define (latest-posts limit)
  (define q (format "SELECT ~a FROM `posts` ORDER BY `published` DESC LIMIT ~a"
                    (list->sql-fields posts-fields)
                    limit))
  (select-rows-hash q posts-fields))

(define (topic-list)
  (define query
    (string-append "SELECT `topic`, p.pagenode, p.title "
                   "FROM `posts-topics` t INNER JOIN `posts` p "
                   "ON t.pagenode = p.pagenode "
                   "ORDER BY `topic` ASC"))
  (log-query query)
  (define everything (query-rows dbc query))
  (define hashed-topics  
    (for/fold ([topics (hash)])
              ([topic-in-post (in-list everything)])
      (match-let ([(vector this-topic this-post this-title) topic-in-post])
        (hash-set topics this-topic (append (hash-ref topics this-topic '())
                                            (list (list this-post this-title)))))))
  (sort (hash->list hashed-topics)
        (lambda (x y) (string<? (string-downcase (first x))
                                (string-downcase (first y))))))