#lang pollen

◊(define-meta title "Pollen Footnotes: An Approach")
◊(define-meta published "2018-01-21")
◊(define-meta updated "2018-01-25")

◊margin-note{This article assumes you are familiar with ◊link["http://pollenpub.com"]{Pollen} and the concept of tagged X-expressions.} One of the things you get for free with Markdown that you have to cook from scratch with Pollen (or HTML for that matter) is footnotes. But this is fine, since it gives you more control over the results. Here is what I cooked up for use on the upcoming redesign of ◊i{The Local Yarn} weblog/book project.

◊updatebox["2018-01-25"]{The Pollen discussion group has ◊link["https://groups.google.com/forum/#!topic/pollenpub/laWL4SWx0Zc"]{a thread on this post} that is well worth reading. Matthew Butterick showed you can get mostly the same results with clearer and more concise code using normal tag functions as opposed to doing everything top-down starting with ◊code{root}.}

An aside: on the web, footnotes are something of an oddity. HTML doesn’t have any semantic notion of a footnote, so we typically make them up using superscripted links to an ordered list at the end of the article. I’m sympathetic to arguments that this makes for a poor reading experience, and am convinced that they are probably overused. Nonetheless, I’m converting a lot of old content that uses footnotes, and I know I’ll be resorting to them in the future. Some ◊link["https://edwardtufte.github.io/tufte-css/#sidenotes"]{newer treatments} of web footnotes use clever CSS to sprinkle them in the margins, which is nice, but comes with downsides: it isn’t accessible, it’s not intuitive to use and read on a phone, it renders the footnotes inline with the text in CSS-less environments (Lynx, e.g.) and the markup is screwy◊numbered-note{These reasons are listed in decreasing order of importance for the particular application I have in mind.}. So I’m sticking with the old ordered-list-at-the-end approach (for this project, and for now, at least).

So I get to design my own footnote markup. Here’s what’s on my wishlist:

◊ol{
◊item{I want each footnote’s ◊emph{contents} to be defined in a separate place from the footnote ◊emph{references}. This will keep the prose from getting too cluttered.}
◊item{I want to be able to define the footnote contents anywhere in the document, in any order, and have them properly collected and ordered at the end.}
◊item{I want to be able to use any mix of strings, symbols or numbers to reference footnotes, and have these all be converted to ordinal reference numbers.}
◊item{I want to be able to refer to the same footnote more than once.◊numbered-note{It was this requirement in particular that steered me away from using the otherwise-excellent ◊link["https://github.com/malcolmstill/pollen-count"]{pollen-count} package.} (Rare, but useful in some cases).}
◊item{If I should happen to refer to a footnote that is never defined, I want a blank footnote to appear in the list in its place. (On the other hand if I define a footnote that isn’t referenced anywhere, I’m content to let it disappear from the output.)}
◊item{I want the footnote links not to interfere with each other when more than one footnote-using article is displayed on the same page. In other words, the URL for footnote #3 on article (A) should never be the same as the URL for footnote #3 on article (B).}
}

In other words, I want to be able to do this:

◊blockcode{Here is some text◊"◊"fn[1]. Later on the paragraph continues.

In another paragraph, I may◊"◊"fn[2] refer to another footnote.

◊"◊"fndef[1]{Here’s the contents of the first footnote.}
◊"◊"fndef[2]{And here are the contents of the second one.}}

But I also want to be able to do this:

◊blockcode{◊"◊"fndef["doodle"]{And here are the contents of the second one.}

Here is some text◊"◊"fn["wipers"]. Later on the paragraph continues.
◊"◊"fndef["wipers"]{Here’s the contents of the first footnote.}

In another paragraph, I may◊"◊"fn["doodle"] refer to another footnote.}

And both of these should render identically to:

◊blockcode{<p>Here is some text<sup><a href="#550b35-1" id="550b35-1_1">1</a></sup>. Later on the paragraph continues.</p>

<p>In another paragraph, I may <sup><a href="#550b35-2" id="550b35_1">2</a></sup> refer to another footnote.</p>

<section class="footnotes"><hr />
<ol>
  <li id="550b35-1">Here’s the contents of the first footnote. <a href="#550b35-1_1">↩</a></li>
  <li id="550b35-2">And here are the contents of the second one. <a href="#550b35-2_1">↩</a></li>
</ol>
</section>}

◊margin-note{You may be wondering, where did the ◊code{550b35} come from? Well, it’s an automatically generated identifier that’s (mostly, usually) unique to the current article. By using it as a prefix on our footnote links and backlinks, we prevent collisions with other footnote-using articles that may be visible on the same page. I’ll explain where it comes from at the end of this article.}

This style of markup is a little more work to code in ◊code{pollen.rkt}, but it lets me be flexible and even a bit careless when writing the prose.

◊strike{The output for footnotes (given my requirements) can’t very well be handled within individual tag functions; it demands a top-down approach.} [Again, this turns out not to be true! see ◊link["https://groups.google.com/forum/#!topic/pollenpub/laWL4SWx0Zc"]{the Pollen group discussion}.]  So I will be leaving my ◊code{◊"◊"fn} and ◊code{◊"◊"fndef} tag functions undefined, and instead create a single function ◊code{do-footnotes} (and several helper functions nested inside it) that will transform everything at once. I’ll call it from my ◊code{root} tag like so:

◊blockcode[#:filename "pollen.rkt"]{
(require txexpr
         sugar/coerce
         openssl/md5
         pollen/decode
         pollen/template) ; That’s everything we need for this project

(define (root . elements)
  (define footnoted 
    (do-footnotes `(root ,@elements) 
                  (fingerprint (first elements)))))
}

The ◊code{do-footnotes} function takes a tagged X-expression (the body of the article) and a prefix to use in all the relative links and backlinks. ◊margin-note{You may have surmised that the ◊code{fingerprint} function call above is where the ◊code{550b35} prefix came from. Again, more on that later.} Here are the general stages we’ll go through inside this function:

◊ol{
◊item{Go through the footnote ◊emph{references}. Transform them into ◊emph{reference links}, giving each an incrementally higher ◊emph{reference number} (or, if the footnote has been referenced before, using the existing number). For later use, keep a list of all references and in the order in which they’re found.}
◊item{Split out all the footnote ◊emph{definitions} from the rest of the article. Get rid of the ones that aren’t referenced anywhere. Add empty ones to stand in for footnotes that are referenced but not defined.}
◊item{Sort the footnote definitions according to the order that they are first referenced in the article.}
◊item{Transform the footnote definitions into an ordered list with backlinks, and append them back on to the end of the article.}
}

Here is the code for ◊code{do-footnotes} that implements the first stage:

◊blockcode[#:filename "pollen.rkt"]{
(define (do-footnotes tx prefix)
  (define fnrefs '())
  
  (define (fn-reference tx)
    (cond
      [(and (eq? 'fn (get-tag tx))
            (not (empty? (get-elements tx))))
       (define ref (->string (first (get-elements tx))))
       (set! fnrefs (append fnrefs (list ref)))
       (let* ([ref-uri (string-append "#" prefix "-" ref)]
              [ref-sequence (number->string (count (curry string=? ref) fnrefs))]
              [ref-backlink-id (string-append prefix "-" ref "_" ref-sequence)]
              [ref-ordinal (number->string (+ 1 (index-of fnrefs ref)))]
              [ref-str (string-append "(" ref-ordinal ")")])
         `(sup (a [[href ,ref-uri] [id ,ref-backlink-id]] ,ref-str)))]
      [else tx]))

  (define tx-with-fnrefs (decode tx #:txexpr-proc fn-reference))
  …)}

Looking at the last line in this example will help you understand the flow of control here: we can call ◊link["http://docs.racket-lang.org/pollen/Decode.html"]{◊code{decode}} and, using the ◊code{#:txexpr-proc} keyword argument, pass it a function to apply to every X-expression tag in the article. In this case, it’s a helper function we’ve just defined, ◊code{fn-reference}. The upshot: the body of ◊code{fn-reference} is going to be executed once for each ◊code{◊"◊"fn} tag in the article.

By defining ◊code{fn-reference} ◊emph{inside} the ◊code{do-foonotes} function, it has access to identifiers outside its scope, such as the ◊code{prefix} string but most importantly the ◊code{fnrefs} list. This means that every call to ◊code{fn-reference} will be able to check up on the results of all the other times it’s been called so far. And other helper functions we’ll be creating inside ◊code{do-footnotes} later on will also have easy access to the results of those calls.

So let’s examine the steps taken by ◊code{fn-definition} in more detail.

◊ol{
◊item{First, using ◊code{cond} it checks to see if the current X-expression ◊code{tx} is a ◊code{fn} tag and has at least one element (the reference ID). This is necessary because ◊code{decode} is going to call ◊code{fn-reference} for ◊emph{every X-expression in the article}, and we only want to operate on the ◊code{◊"◊"fn} tags.}

◊item{Every time ◊code{fn-reference} finds a footnote reference, it has the side-effect of appending its reference ID (in string form) to the ◊code{fnrefs} list (the ◊code{set!} function call). Again, that list is the crucial piece that allows all the function calls happening inside ◊code{do-footnotes} to coordinate with each other.}

◊item{The function uses ◊code{let*} to set up a bunch of values for use in outputting the footnote reference link:
    ◊ol{
    ◊item{◊code{ref-uri}, the relative link to the footnote at the end of the article.}
    ◊item{◊code{ref-sequence}, will be ◊code{"1"} if this is the first reference to this footnote, ◊code{"2"} if the second reference, etc. We get this by simply counting how many times ◊code{ref} appears in the ◊code{fnrefs} list so far.}
    ◊item{◊code{ref-backlink-id} uses ◊code{ref-sequence} to make an id that will be the target of a ↩ back-link in the footnote definition.}
    ◊item{◊code{ref-ordinal} is the footnote number as it will appear to the reader. To find it, we remove all duplicates from the ◊code{fnrefs} list, find the index of the current ◊code{ref} in that list, and add one (since we want footnote numbers to start with 1, not 0).}
    ◊item{◊code{ref-str} is the text of the footnoote reference that the reader sees. It’s only used because I wanted to put parentheses around the footnote number.}
    }
}

◊item{Then, in the body of the ◊code{let*} expression, the function outputs the new footnote reference link as an X-expression that will transform neatly to HTML when the document is rendered.}
}

So after the call to ◊code{decode}, we have an X-expression, ◊code{tx-with-fnrefs}, that has all the footnote references (◊code{◊"◊"fn} tags) properly transformed, and a list ◊code{fnrefs} containing all the footnote reference IDs in the order in which they are found in the text.

Let’s take a closer look at that list. In our first simple example above, it would end up looking like this: ◊code{'("1" "2")}. In the second example, it would end up as ◊code{'("wipers" "doodle")}. In a very complicated and sloppy document, it could end up looking like ◊code{'("foo" "1" "7" "foo" "cite1" "1")}. So when processing ◊code{◊"◊"fndef["foo"]}, for example, we can see by looking at that list that this should be the first footnote in the list, and that there are two references to it in the article.

All that said, we’re ready to move on to phase two through four.

◊blockcode[#:filename "pollen.rkt"]{
(define (do-footnotes tx)
  ; … stage 1 above …

  (define (is-fndef? x) (and (txexpr? x) (equal? 'fndef (get-tag x))))
  
  ; Collect ◊"◊"fndef tags, filter out any that aren’t actually referenced
  (define-values (body fn-defs) (splitf-txexpr tx-with-fnrefs is-fndef?))
  (define fn-defs-filtered 
    (filter (λ(f) 
              (cond 
                [(member (->string (first (get-elements f))) fnrefs) #t]
                [else #f]))
            fn-defs))
            
  ; Get a list of all the IDs of the footnote *definitions*
  (define fn-def-ids
    (for/list ([f (in-list fn-defs-filtered)]) (->string (first (get-elements f)))))
  
  ; Pad the footnote definitions to include empty ones for any that weren’t defined
  (define fn-defs-padded 
    (cond [(set=? fnrefs fn-def-ids) fn-defs-filtered]
          [else (append fn-defs-filtered 
                        (map (λ (x) `(fndef ,x (i "Missing footnote definition")))
                             (set-subtract fnrefs fn-def-ids)))]))
  ; … stage 3 and 4 …
)
}

We define a helper function ◊code{is-fndef?} and use it with ◊code{splitf-txexpr} to extract all the ◊code{◊"◊"fndef} tags out of the article and put them in a separate list. Then we use ◊code{filter}, passing it an anonymous function that returns ◊code{#f} for any ◊code{fndef} whose ID doesn’t appear in ◊code{fndefs}.

Now we need to deal with the case where the ◊code{◊"◊"fn} tags in a document reference a footnote that is never defined with an ◊code{◊"◊"fndef} tag. To test for this, we just need a list of the reference IDs used by the footnote definitions. The definition of ◊code{fn-def-ids} provides this for us, using ◊code{for/list} to loop through all the footnote definitions and grab out a stringified copy of the first element of each. We can then check if ◊code{(set=? fnrefs fn-def-ids)} — that is, do these two lists contain all the same elements (regardless of duplicates)? If not, we use ◊code{set-subtract} to get a list of which IDs are missing from ◊code{fn-def-ids} and for each one, append another ◊code{fndef} to the filtered list of footnote definitions.

◊blockcode[#:filename "pollen.rkt"]{
(define (do-footnotes tx)
  ; … stages 1 and 2 above …

  (define (footnote<? a b)
    (< (index-of (remove-duplicates fnrefs) (->string (first (get-elements a))))
       (index-of (remove-duplicates fnrefs) (->string (first (get-elements b))))))
  
  (define fn-defs-sorted (sort fn-defs-padded footnote<?))

  ; … stage 4 …
}

The helper function ◊code{footnote<?} compares two footnote definitions to see which one should come first in the footnote list: it compares them to see which one has the ID that appears first in ◊code{fndefs}. We pass that function to ◊code{sort}, which uses it to sort the whole list of footnote definitions.

We are almost done. We just have to transform the now-ordered list of footnote definitions and append it back onto the end of the article:

◊blockcode[#:filename "pollen.rkt"]{
(define (do-footnotes tx)
  ; … stages 1 to 3 above …

  (define (fn-definition tx)
    (let* ([ref (->string (first (get-elements tx)))]
           [fn-id (string-append "#" prefix "-" ref)]
           [fn-elems (rest (get-elements tx))]
           [fn-backlinks 
             (for/list ([r-seq (in-range (count (curry string=? ref) fnrefs))])
               `(a [[href ,(string-append "#" prefix "-" ref "_"
                                          (number->string (+ 1 r-seq)))]] "↩"))])
      `(li [[id ,fn-id]] ,@fn-elems ,@fn-backlinks)))
      
  (define footnotes-section 
    `(section [[class "footnotes"]] (hr) (ol ,@(map fn-definition fn-defs-sorted))))
    
  (txexpr (get-tag body)
          (get-attrs body) 
          (append (get-elements body) 
                  (list footnotes-section)))
  ; Finis!
)
}

We need one more helper function, ◊code{fn-definition}, to transform an individual ◊code{◊"◊"fndef} tag into a list item with the footnote’s contents and backlinks to its references. This helper uses ◊code{let*} in a way similar to ◊code{fn-reference} above, constructing each part of the list item and then pulling them all together at the end. Of these parts, ◊code{fn-backlinks} is worth examining. The expression ◊code{(curry string=? ref)} returns a function that compares any string to whater ◊code{ref} currently is.◊margin-note{◊code{curry} is basically a clever way of temporarily “pre-filling” some of a function’s arguments.} That function gets passed to ◊code{count} to count how many times the current footnote is found in ◊code{fnrefs}. The list comprehension ◊code{for/list} can then use that range to make a ◊code{↩} backlink for each of them.

In defining the ◊code{footnotes-section} we ◊code{map} the helper function ◊code{fn-definition} onto each ◊code{◊"◊"fndef} tag in our sorted list, and drop them inside an X-expression matching the HTML markup we want for the footnotes section. The last statement adds this section to the end of ◊code{body} (which was the other value given to us by ◊code{splitf-txexpr} way up in stage 2), and we’re done.

All that remains now is to show you where I got that ◊code{550b35} prefix from.

◊section{Ensuring unique footnote IDs}

As mentioned before, I wanted to be able to give all the footnotes in an article some unique marker for use in their ◊code{id} attribute, to make sure the links for footnotes in different articles never collide with each other.

When the topic of “ensuring uniqueness” comes up it’s not long before we start talking about hashes.

I could generate a random hash once for each article, but then the footnote’s URI would change every time I rebuild the article, which would break any deep links people may have made to those footnotes. How often will people be deep-linking into my footnotes? Possibly never. But I would say, if you’re going to put a link to some text on the web, don’t make it fundamentally unstable.

So we need something unique (and stable) from each article that I can use to deterministically create a unique hash for that article. An obvious candidate would be the article’s title, but many of the articles on the site I’m making will not have titles.

Instead I decided to use an MD5 hash of the text of the article’s first element (in practice, this will usually mean its first paragraph):

◊blockcode[#:filename "pollen.rkt"]{
; Concatentate all the elements of a tagged x-expression into a single string
; (ignores attributes)
(define (txexpr->elements-string tx)
  (cond [(string? tx) tx]
        [(stringish? tx) (->string tx)]
        [(txexpr? tx)
         (apply string-append (map txexpr->elements-string (get-elements tx)))]))

(define (fingerprint tx)
  (let ([hash-str (md5 (open-input-string (txexpr->elements-string tx)))])
    (substring hash-str (- (string-length hash-str) 6))))
}

The helper function ◊code{txexpr->elements-string} will recursively drill through all the nested expressions in an X-expression, pulling out all the strings found in the ◊emph{elements} of each and appending them into a single string. The ◊code{fingerprint} function then takes the MD5 hash of this string and returns just the last six characters, which are unique enough for our purposes.

If you paste the above into DrRacket (along with the ◊code{require}s at the beginnning of this post) and then run it as below, you’ll see 

◊blockcode{
> (fingerprint (txexpr->elements-string '(p "Here is some text" (fn 1) ". Later on the paragraph continues.")))
"550b35"
}

This now explains where we were getting the ◊code{prefix} argument in ◊code{do-footnotes}:

◊blockcode[#:filename "pollen.rkt"]{
(define (root . elements)
  (define footnoted 
    (do-footnotes `(root ,@elements) 
                  (fingerprint (first elements)))))
}

Under this scheme, things could still break if I have two articles with exactly the same text in the first element. Also, if I ever edit the text in the first element in an article, the prefix will change (breaking any deep links that may have been made by other people). But I figure that’s the place where I’m least likely to make any edits. This approach brings the risk of footnote link collision and breakage down to a very low level, wasn’t difficult to implement and won’t be any work to maintain.

◊section{Summary and parting thoughts}

When designing the markup you’ll be using, Pollen gives you unlimited flexibility. You can decide to adhere pretty closely to HTML structures in your markup (allowing your underlying code to remain simple), or you can write clever code to enable your markup do more work for you later on.

One area where I could have gotten more clever would have been error checking. For instance, I could throw an error if a footnote is defined but never referenced. I could also do more work to validate the contents of my ◊code{◊"◊"fn} and ◊code{◊"◊"fndef} tags. If I were especially error-prone and forgetful, this could save me a bit of time when adding new content to my site. For now, on this project, I’ve opted instead for marginally faster code…and more cryptic error messages.

I will probably use a similar approach to allow URLs in hyperlinks to be specified separately from the links themselves. Something like this:

◊blockcode[#:filename "chapter.html.pm"]{
#lang pollen

For more information, see ◊"◊"a[1]{About the Author}. You can also
see ◊"◊"a[2]{his current favorite TV show}.

◊"◊"hrefs{
[1]: http://joeldueck.com
[2]: http://www.imdb.com/title/tt5834198/
}
}

