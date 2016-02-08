#lang pollen

◊(define-meta title "How to Easily Use OpenType Fonts in LaTeX")
◊(define-meta published "2012-04-23")
◊(define-meta tags "latex,typography,opentype,pandoc,pdf")

I became interested in ◊Latex[] out of a desire to be able to produce high-quality PDFs for self-published books. Someday I hope to be able to produce books of comparable quality to ◊link["http://www.tsengbooks.com/"]{these humanities books} typeset in TeX. This idea became even more feasible when I discovered the text content could be written in Markdown and converted to ◊Latex[] with ◊link["http://johnmacfarlane.net/pandoc/index.html"]{◊code{pandoc}} (More information in ◊link["http://www.charlietanksley.net/philtex/primarily-pandoc/"]{this article}).

Typographically, the example books I linked to above are more the exception than the rule: the vast majority of ◊Latex[] documents use the same boring default font, ◊link["http://en.wikipedia.org/wiki/Computer_modern_font"]{Computer Modern}, that was originally packaged with the software in the 1980s. Using Computer Modern in a self-published book would be almost as bad as using Times New Roman or Arial.

If you try to figure out whether and how you might be able to use your computer’s normal fonts with ◊Latex[], you will soon come across a lot of ◊link["http://www.ece.ucdavis.edu/~jowens/code/otfinst/"]{extremely complicated and incomplete documentation} about how to convert TrueType or OpenType fonts into a format ◊Latex[] can use.

The happy truth is that these instructions are now obsolete: ◊strong{you now have easy access to OpenType fonts on Windows ◊emph{and} Mac platforms}, thanks to a new version of ◊Latex[] called ◊link["http://tug.org/xetex/"]{XeTeX}. XeTeX includes a package called ◊code{fontspec} that gives full access to all system fonts, as well as advanced features for OpenType fonts, such as ligatures and small caps. XeTeX is available for Mac, but what most people don’t say is that this font-accessing goodness can also be used on Windows since XeTeX is included with Windows distributions such as ◊link["http://www.tug.org/texlive/"]{TeX Live} and ◊link["http://miktex.org/"]{MikTeX}.

That being understood, here’s how to use your system fonts in your TeX documents (◊link["http://tex.stackexchange.com/questions/46/how-do-i-use-an-opentype-font-with-my-latex-document"]{source}):

◊blockquote{
◊ol{
◊li{Use the ◊code{xelatex} command in place of ◊code{pdflatex}}
◊li{Add ◊code{\usepackage{xltxtra}} at the beginning of your preamble (enables some XeTeX goodies, in particular it also loads fontspec, which is needed for font selection).}
◊li{Add ◊code{\setmainfont{Name of OTF font}} in the preamble.}
◊li{No step 4.}
}
}

◊strong{Note:} If you are using the aforementioned pandoc to generate your TeX documents, you do not need to do step 2 — pandoc already includes the fontspec package in its default template. Also, you can set the main font by adding the option ◊code{--variable=mainfont:"font name"} when calling the ◊code{pandoc} command.

◊h2[#:id "comments"]{Comments}

◊h3[#:id "soramimi-said"]{◊link["http://soramimi.wordpress.com/"]{soramimi} said:}

Wow, awesome! Just tried this out and it worked quite very well. Thanks!

(Comment posted May 15, 2012)

◊h3[#:id "james-plant-said"]{◊link["https://www.blogger.com/profile/12119364791147441592"]{James Plant} said:}

Worked! Thanks!

(Comment posted January 30, 2013)
