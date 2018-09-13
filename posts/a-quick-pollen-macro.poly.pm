#lang pollen

◊(define-meta title "A Quick Macro for Pollen")
◊(define-meta published "2018-07-07")
◊(define-meta topics "Pollen, Racket")

One of Pollen’s
◊link["https://groups.google.com/d/msg/pollenpub/FdWdGgL9jSk/1VWpX_nsAAAJ"]{somewhat recent}
additions is the ◊link["http://docs.racket-lang.org/pollen/Core.html#%28form._%28%28lib._pollen%2Fcore..rkt%29._for%2Fsplice%29%29"]{◊code{for/splice}} function,
which lets you loop through one or more lists
and inject the results into a surrounding expression.

Here’s an example from the code for the home page on this blog:

◊blockcode[#:filename "index.html.pp"]{...
◊"◊"for/splice[[(post (in-list (latest-posts 10)))]]{
   <article>
   ◊"◊"(hash-ref post 'header_html)
   ◊"◊"(hash-ref post 'html)
   </article>
   <hr>
}
...}

It’s very useful,
but I’m sure you’ve noticed something about this code:
◊emph{many many parentheses} 
in the arguments list for ◊code{for/splice}.
Well, it is the way it is,
because the ◊code{for/splice} function 
is a direct analogue
of Racket’s ◊link["https://docs.racket-lang.org/reference/for.html?q=for%2Flist#%28form._%28%28lib._racket%2Fprivate%2Fbase..rkt%29._for%2Flist%29%29"]{◊code{for/list} function},
which supports looping through multiple lists at the same time.
It’s nice to have the flexibility.
But there’s no denying the readability of the code suffers
in the most common use cases.

If, like me, you usually only need to loop through a single list,
you can put a macro like the one below 
in your ◊code{pollen.rkt}:

◊blockcode[#:filename "pollen.rkt"]{
(require pollen/core)

...

(provide for/s)
(define-syntax (for/s stx)
  (syntax-case stx ()
    [(_ thing listofthings result-expr ...)
     #'(for/splice ([thing (in-list listofthings)]) result-expr ...)]))
}

This cuts down on the parentheses quite a bit:

◊blockcode[#:filename "index.html.pp"]{...
◊"◊"for/s[post (latest-posts 10)]{
   <article>
   ◊"◊"(hash-ref post 'header_html)
   ◊"◊"(hash-ref post 'html)
   </article>
   <hr>
}
...}
