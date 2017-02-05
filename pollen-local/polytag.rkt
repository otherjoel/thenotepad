#lang racket

(require pollen/tag pollen/setup)
(require (for-syntax racket/syntax
                     syntax/parse
                     pollen/setup))

(provide (all-defined-out))
(provide poly-branch-tag)

; For use in contracts, this is somewhat looser than txexpr-attribute? in that it allows
; for any value, not just strings.
(define/contract (attribute? x)
  (any/c . -> . boolean?)
  (and (pair? x) (symbol? (first x))))

; Gives tag functions a quick way to look up values in standalone attribute lists 
(define/contract (attr-val key attributes)
  (symbol? (listof attribute?) . -> . any/c)
  (let ([result (assq key attributes)])
       (if result (second result) #f)))

(define/contract (check-required-attributes tagname required-attrs attrs)
  (symbol? (listof symbol?) (listof attribute?) . -> . void)
  (define (missing? a) (if (not (attr-val a attrs)) #t #f))
  (define required-list (apply string-append "attributes must include " (add-between (map symbol->string required-attrs) ", ")))
  (define missed-list (filter missing? required-attrs))
  (cond
      [(not (empty? missed-list))
       (raise-argument-error tagname required-list attrs)]))

(define/contract (apply-default-attributes attrs defaults)
  ((listof attribute?) (listof attribute?) . -> . (listof attribute?))
  (define (not-in-attrs a) (if (not (member (first a) (map first attrs))) #t #f))
  (append attrs (filter not-in-attrs defaults)))

#|
   Defines a function that automatically calls PREFIX-tag, where PREFIX is the
   current poly target. You must define those functions separately.
   
   Simple tag: 
      (poly-branch-tag strong)
   Tag with default attributes:
      (poly-branch-tag emph (underline #f) (color "black"))
   Tag with single positional argument:
      (poly-branch-tag link url)
   Tag with positional argument and default attributes:
      (poly-branch-tag newlink url (external #t))
|#
(define-syntax (poly-branch-tag stx)
  (define-syntax-class keyval
    #:description "key-value pair"
    (pattern (KEY:id VAL:expr)))

  (syntax-parse stx
    ; tag function with no special arguments or defaults
    [(_ TAG:id)
     (with-syntax ([((POLY-TARGET POLY-FUNC) ...) 
                    (for/list ([target (in-list (setup:poly-targets))])
                              (list target (format-id stx "~a-~a" target #'TAG)))]
                   [DEFAULT-TARGET (format-id stx "html-~a" #'TAG)])
       #'(define-tag-function (TAG attributes elems)
           (case (current-poly-target)
             [(POLY-TARGET) (POLY-FUNC attributes elems)] ... 
             [else (DEFAULT-TARGET attributes elems)])))]

    ; tag function with no positional arguments but with specified defaults
    [(_ TAG:id ATTRS:keyval ...+)
     (with-syntax ([((POLY-TARGET POLY-FUNC) ...) 
                    (for/list ([target (in-list (setup:poly-targets))])
                              (list target (format-id stx "~a-~a" target #'TAG)))]
                   [DEFAULT-TARGET (format-id stx "html-~a" #'TAG)])
      #'(define-tag-function (TAG attributes elems)
          (define attrs-with-defaults (apply-default-attributes attributes '(ATTRS ...)))
          (case (current-poly-target)
            [(POLY-TARGET) (POLY-FUNC attrs-with-defaults elems)] ...
            [else (DEFAULT-TARGET attrs-with-defaults elems)])))]
    
    ; tag function with one positional argument and no defaults
    [(_ TAG:id ARG:id)
     (with-syntax ([((POLY-TARGET POLY-FUNC) ...) 
                    (for/list ([target (in-list (setup:poly-targets))])
                              (list target (format-id stx "~a-~a" target #'TAG)))]
                   [DEFAULT-TARGET (format-id stx "html-~a" #'TAG)])
       #'(define-tag-function (TAG attributes elems)
           (cond [(empty? elems) (raise-argument-error 'TAG "at least one tag element" elems)])
           (case (current-poly-target)
             [(POLY-TARGET) (POLY-FUNC (first elems) attributes (rest elems))] ...
             [else (DEFAULT-TARGET (first elems) attributes (rest elems))])))]
    
    ; tag function with one positional argument and specified defaults
    [(_ TAG:id ARG:id ATTRS:keyval ...+)
     (with-syntax ([((POLY-TARGET POLY-FUNC) ...)
                    (for/list ([target (in-list (setup:poly-targets))])
                              (list target (format-id stx "~a-~a" target #'TAG)))]
                   [DEFAULT-TARGET (format-id stx "html-~a" #'TAG)])
       #'(define-tag-function (TAG attributes elems)
           (cond [(empty? elems) (raise-argument-error 'TAG "at least one tag element" elems)])
           (define attrs-with-defaults (apply-default-attributes attributes '(ATTRS ...)))
           (case (current-poly-target)
             [(POLY-TARGET) (POLY-FUNC (first elems) attrs-with-defaults (rest elems))] ...
             [else (DEFAULT-TARGET (first elems) attrs-with-defaults (rest elems))])))]))
