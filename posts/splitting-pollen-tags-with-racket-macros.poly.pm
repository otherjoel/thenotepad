#lang pollen

◊(define-meta title "Splitting Pollen tags with Racket macros")
◊(define-meta published "2016-10-09")
◊(define-meta topics "Pollen,Racket")

Normally when targeting multiple output formats in ◊link["http://pollenpub.com"]{Pollen}, you’d write a tag function something like this:

◊blockcode[#:filename "pollen.rkt"]{; …
    
(define (strong . xs)
  (case (current-poly-target)
    [ltx (string-append "\\textbf{" ,@xs "}")]
    [else `(strong ,@xs)]))

; …}

Here, everything for the ◊code{strong} tag is contained in a single tidy function that produces different output depending on the current output format. This is fine for simple projects, but not ideal for more complex ones, for a couple of reasons.

First there’s the issue of tracking dependencies. Let’s say every Pollen file in your project gets rendered as an HTML file and a PDF file. Then one day you make a small change in your ◊code{pollen.rkt} file. Does this edit affect just the HTML files? Or the PDF files? Or both? Which ones now need to be rebuilt? If you’re doing things as shown above, there’s no straightforward way to determine this; you’ll have to rebuild all the output files every time.

Then there’s the issue of readability. Even with two possible output formats, ◊code{pollen.rkt} gets much more difficult to read. I didn’t even want to think about how hairy it would get at three or four.

I decided to address this by having each output format get its own separate ◊code{.rkt} file, containing its own definitions for each tag function, prefixed by the output format:

◊blockcode[#:filename "html-tags.rkt"]{(define (html-strong attrs elements)
  `(strong ,attrs ,@elements))}

◊blockcode[#:filename "latex-tags.rkt"]{(define (ltx-strong attrs elements)
  (string-append "\\textbf{" ,@xs "}"))}

That part is simple enough. But you also need a way for ◊code{pollen.rkt} to branch to one tag or the other depending on the current poly target.

To handle this part, I wrote a macro ◊code{poly-branch-tag}, which allows you to define a tag that will automatically call a different tag function depending on the current output format. The macro is rather long, but you can view it in the ◊link["https://github.com/otherjoel/thenotepad/blob/master/pollen-local/polytag.rkt"]{◊code{polytag.rkt}} file of this blog's source code at Github.

To use it, you first need to ensure the ◊code{site-poly-targets} list in ◊code{polytag.rkt} is set up to match your definition of ◊code{poly-targets}:

◊blockcode[#:filename "polytag.rkt"]{; This needs to match the definition of poly-targets in pollen.rkt
(define-for-syntax site-poly-targets '(html pdf))}

You then declare your Pollen tags as follows:

◊blockcode[#:filename "pollen.rkt"]{(require "polytag.rkt")
(require "html-tags.rkt" "latex-tags.rkt")

(poly-branch-tag strong)

; Tag with a "positional" attribute
(poly-branch-tag link url)

; Tag with required attribute and an optional w/default
(poly-branch-tag figure src (fullwidth #f))}

