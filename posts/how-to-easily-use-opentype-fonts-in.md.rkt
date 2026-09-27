#lang punct notepad

---
title: How to Easily Use OpenType Fonts in LaTeX
date: 2012-04-23
topics: LaTeX,typography,pandoc,PDF
---

I became interested in LaTeX out of a desire to be able to produce high-quality
PDFs for self-published books. Someday I hope to be able to produce books of
comparable quality to [these humanities books](http://www.tsengbooks.com/)
typeset in TeX. This idea became even more feasible when I discovered the text
content could be written in Markdown and converted to LaTeX with
[`pandoc`](http://johnmacfarlane.net/pandoc/index.html) (More information in
[this article](http://www.charlietanksley.net/philtex/primarily-pandoc/)).

Typographically, the example books I linked to above are more the exception than
the rule: the vast majority of LaTeX documents use the same boring default font,
[Computer Modern](http://en.wikipedia.org/wiki/Computer_modern_font), that was
originally packaged with the software in the 1980s. Using Computer Modern in a
self-published book would be almost as bad as using Times New Roman or Arial.

If you try to figure out whether and how you might be able to use your
computer’s normal fonts with LaTeX, you will soon come across a lot of
[extremely complicated and incomplete
documentation](http://www.ece.ucdavis.edu/~jowens/code/otfinst/) about how to
convert TrueType or OpenType fonts into a format LaTeX can use.

The happy truth is that these instructions are now obsolete: **you now have easy
access to OpenType fonts on Windows *and* Mac platforms**, thanks to a new
version of LaTeX called [XeTeX](http://tug.org/xetex/). XeTeX includes a package
called `fontspec` that gives full access to all system fonts, as well as
advanced features for OpenType fonts, such as ligatures and small caps. XeTeX is
available for Mac, but what most people don’t say is that this font-accessing
goodness can also be used on Windows since XeTeX is included with Windows
distributions such as [TeX Live](http://www.tug.org/texlive/) and
[MikTeX](http://miktex.org/).

That being understood, here’s how to use your system fonts in your TeX documents
([source](http://tex.stackexchange.com/questions/46/how-do-i-use-an-opentype-font-with-my-latex-document)):

> 1. Use the `xelatex` command in place of `pdflatex`
> 2. Add `\usepackage{xltxtra}` at the beginning of your preamble (enables some
>    XeTeX goodies, in particular it also loads fontspec, which is needed for font
>    selection).
> 3. Add `\setmainfont{Name of OTF font}` in the preamble.
> 4. No step 4.

**Note:** If you are using the aforementioned pandoc to generate your TeX
documents, you do not need to do step 2—pandoc already includes the fontspec
package in its default template. Also, you can set the main font by adding the
option `--variable=mainfont:"font name"` when calling the `pandoc` command.

•comment[#:author "soramimi" #:date "May 15, 2012" #:link "http://soramimi.wordpress.com/"]{
Wow, awesome! Just tried this out and it worked quite very well. Thanks!
}

•comment[#:author "James Plant" #:date "January 30, 2013" #:link "https://www.blogger.com/profile/12119364791147441592"]{
Worked! Thanks!
}
