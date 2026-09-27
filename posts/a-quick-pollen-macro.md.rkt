#lang punct notepad

---
title: A Quick Macro for Pollen
date: 2018-07-07
topics: Pollen, Racket
---

One of Pollen’s [somewhat
recent](https://groups.google.com/d/msg/pollenpub/FdWdGgL9jSk/1VWpX_nsAAAJ)
additions is the
[`for/splice`](http://docs.racket-lang.org/pollen/Core.html#%28form._%28%28lib._pollen%2Fcore..rkt%29._for%2Fsplice%29%29)
function, which lets you loop through one or more lists and inject the results
into a surrounding expression.

Here’s an example from the code for the home page on this blog:

```index.html.pp
...
◊for/splice[[(post (in-list (latest-posts 10)))]]{
   <article>
   ◊(hash-ref post 'header_html)
   ◊(hash-ref post 'html)
   </article>
   <hr>
}
...
```

It’s very useful, but I’m sure you’ve noticed something about this code: *many
many parentheses* in the arguments list for `for/splice`. Well, it is the way it
is, because the `for/splice` function is a direct analogue of Racket’s
[`for/list`
function](https://docs.racket-lang.org/reference/for.html?q=for%2Flist#%28form._%28%28lib._racket%2Fprivate%2Fbase..rkt%29._for%2Flist%29%29),
which supports looping through multiple lists at the same time. It’s nice to
have the flexibility. But there’s no denying the readability of the code suffers
in the most common use cases.

If, like me, you usually only need to loop through a single list, you can put a
macro like the one below in your `pollen.rkt`:

```pollen.rkt
(require pollen/core)

...

(provide for/s)
(define-syntax (for/s stx)
  (syntax-case stx ()
    [(_ thing listofthings result-expr ...)
     #'(for/splice ([thing (in-list listofthings)]) result-expr ...)]))
```

This cuts down on the parentheses quite a bit:

```index.html.pp
...
◊for/s[post (latest-posts 10)]{
   <article>
   ◊(hash-ref post 'header_html)
   ◊(hash-ref post 'html)
   </article>
   <hr>
}
...
```
