#lang pollen

◊(define-meta title "Splitting Pollen tags with Racket macros")
◊(define-meta published "2016-11-09")
◊(define-meta topics "Pollen,Racket")

This may be one of the nerdiest things I have ever written, but I know there may be three or five people who will find it useful. This post is specifically for people who are using ◊link["http://pollenpub.com"]{Pollen} to generate content in ◊link["https://docs.racket-lang.org/pollen/fourth-tutorial.html"]{multiple output formats}, and who may also be using a separate build system like ◊link["https://www.gnu.org/software/make/manual/html_node/Overview.html#Overview"]{make}.

Normally when targeting multiple output formats in ◊link["http://pollenpub.com"]{Pollen}, you’d write a tag function something like this:

◊blockcode[#:filename "pollen.rkt"]{; …
    
(define (strong . xs)
  (case (current-poly-target)
    [ltx (string-append "\\textbf{" ,@xs "}")]
    [else `(strong ,@xs)]))

; …}

Here, everything for the ◊code{strong} tag is contained in a single tidy function that produces different output depending on the current output format. This is fine for simple projects, but not ideal for more complex ones, for a couple of reasons.

First there’s the issue of tracking dependencies. Let’s say every Pollen file in your project gets rendered as an HTML file ◊emph{and} as part of a PDF file. Then one day you make a small change in your ◊code{pollen.rkt} file. Does this edit affect just the HTML files? Or the PDF files? Or both? Which ones now need to be rebuilt? If you’re doing things as shown above, there’s no straightforward way for Pollen (or ◊code{make}) to determine this; you’ll have to rebuild all the output files every time.

Then there’s the issue of readability. Even with two possible output formats, ◊code{pollen.rkt} gets much more difficult to read. I didn’t even want to think about how hairy it would get at three or four.

I decided to address this by having each output format get its own separate ◊code{.rkt} file, containing its own definitions for each tag function, prefixed by the output format:

◊blockcode[#:filename "html-tags.rkt"]{
(define (html-strong attrs elements)
  `(strong ,attrs ,@elements))
}

◊blockcode[#:filename "pdf-tags.rkt"]{
(define (pdf-strong attrs elements)
  (string-append "\\textbf{" ,@xs "}"))
}

That part is simple enough. But you also need a way for ◊code{pollen.rkt} to branch to one tag or the other depending on the current poly target.

To handle this part, I wrote a macro, ◊code{poly-branch-tag}, which allows you to define a tag that will automatically call a different tag function depending on the current output format. The macro is rather long, but you can view it in the ◊link["https://github.com/otherjoel/thenotepad/blob/master/pollen-local/polytag.rkt"]{◊code{polytag.rkt}} file of this blog's source code at Github.

◊section{Defining tag functions with ◊code{poly-branch-tag}}

To use this macro, first copy the ◊link["https://github.com/otherjoel/thenotepad/blob/master/pollen-local/polytag.rkt"]{◊code{polytag.rkt} file} from this blog’s source code into your project.

You then need to make one edit to the top of this file, to ensure the ◊code{site-poly-targets} list matches the definition of ◊code{poly-targets} in your own ◊code{pollen.rkt} file. It would have been nice to find a way to have them match up automatically, but since the two live in different modules and in different ◊link["http://docs.racket-lang.org/reference/syntax-model.html#%28tech._phase._level%29"]{phase levels}, it looked like a non-trivial amount of work. I decided this was good enough for now:

◊blockcode[#:filename "polytag.rkt"]{
; This needs to match the definition of poly-targets in pollen.rkt
; Note that you can omit 'html if you like, it will still be the default format
(define-for-syntax site-poly-targets '(html pdf))}

You then include ◊code{polytag.rkt} and declare your Pollen tags using the macro. The first argument is the tag name, optionally followed by a single required attribute and/or as any number of optional attributes with default values:

◊blockcode[#:filename "pollen.rkt"]{
(require "polytag.rkt")
(require "html-tags.rkt" "pdf-tags.rkt")

; Simple tag with no required or default attributes
(poly-branch-tag strong)

; Tag with a single required attribute
(poly-branch-tag link url)

; Tag with required attribute + some optional attrs w/defaults
(poly-branch-tag figure src (fullwidth #f) (link-url ""))}

For every tag function declared this way, write the additional functions needed for each output type in your ◊code{site-poly-targets}. E.g., for ◊code{strong} above, we would define ◊code{html-strong} and ◊code{pdf-strong} inside their respective ◊code{.rkt} files.

These tag functions should always accept exactly two arguments: a list of attributes and a list of elements. The macro will ensure that any required attribute is present and any default values are applied. Here's an example:

◊blockcode[#:filename "html-tags.rkt"]{
(define (html-figure attrs elems)     ; Important! Tag name must have html- prefix
  (define src (attr-val 'src attrs))  ; You can grab what you need from attrs
  (if (attr-val 'fullwidth attrs)     ; (I made (attr-val) to accept boolean values in attributes)
      (make-fullwidth)))              ; [dummy example]
}

◊section{The benefits, reiterated}

If you use a dependency system like ◊code{make} in your Pollen project, you now have a clear separation between output files in a particular format and the code that produces output in that format. An edit to ◊code{html-tags.rkt} will only affect HTML files. An edit to ◊code{pdf-tags.rkt} will only affect PDF files. You can see ◊link["https://github.com/otherjoel/thenotepad/blob/master/makefile"]{this blog’s makefile} for a detailed example.

But there’s a delightful extra benefit that comes with this approach: vastly improved code readability. Since ◊code{pollen.rkt} is vacated of all function definitions, it suddenly becomes a very clean, spare list of the project’s tag functions and their expected attributes. This makes it basically a self-updating cheatsheet! See what I mean in ◊link["https://github.com/otherjoel/thenotepad/blob/master/pollen.rkt"]{this blog’s ◊code{pollen.rkt}}. The logic for the tag functions in each format becomes much easier to follow as well.