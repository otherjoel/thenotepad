#lang pollen

◊(define-meta title "How to embed and subset your own webfonts")
◊(define-meta published "2015-02-06")
◊(define-meta tags "fonts,CSS,web fonts")

These days many of us use ◊link["http://typekit.com"]{Typekit} for serving web fonts; and should you need to create and serve them yourself, most of the advice out there will point you to use FontSquirrel’s well-known ◊link["http://www.fontsquirrel.com/tools/webfont-generator"]{Webfont Generator}. However, I’m a big fan of not relying on third-party sites and services if you can avoid it. What happens in five years when those sites are no longer available? It’s best to know how to do get the same result yourself using basic tools, and the result will often get you better performance.

Webfonts have gotten much easier to implement. Because ◊link["http://caniuse.com/#search=woff"]{nearly all browsers support WOFF}, you no longer need to supply four different file formats for each font in order to be sure it will be supported on all browsers. You can simply convert any binary font file into ◊link["http://en.wikipedia.org/wiki/Base64"]{Base64 encoding} and embed the resulting text/data right into your CSS file. However, there are additional steps you should take in order to optimize the size and downloading of your webfonts.

◊h2[#:id "base64-encoding"]{Base64 Encoding}

This part is easy. The command ◊code{base64 filename} will take any file and encode it. This works on Linux and Mac OS X.

With this info, we can create a quick shell script that will take any font file and convert it into a webfont embedded right in a snippet of CSS:

◊blockcode{#!/bin/bash

fontName=$1
fontFace=$2

WOFF=`base64 $fontName`

echo @font-face {
echo font-family: \'$fontFace\'\;
echo font-weight: normal\;
echo font-style: normal\;
echo font-stretch: normal\;
echo src: url\(\'data:application/font-woff\;charset=utf-8\;base64,$WOFF\'\) format\(\'woff\'\)\;
echo }}

Save this to a file called ◊code{webfont-encode} and make it executable:

◊blockcode{chmod u+x ./webfont-encode}

You can then use it to create the webfont from any font file and append it to your CSS file, like so:

◊blockcode{./webfont-encode AlegreyaSans-Reg.otf alegreyasans-1 >> fonts.css}

On OS X, you can also copy the result to the clipboard if you wish:

◊blockcode{./webfont-encode AlegreyaSans-Reg.otf alegreyasans-1 | pbcopy}

Most times you’ll need to do this four times for each typeface: once each for the regular, italic, bold, and bold italic versions of the font. For each one, edit the ◊code{font-weight} and ◊code{font-style} CSS attributes to reflect the actual attributes of that font.

Once you’ve done all that, you can include the above stylesheet in your HTML (make sure it comes before any other stylesheets) and reference the font in your other CSS styles.

◊strong{Note:} The original font file needs to have its &quot;embeddable&quot; flag set to ◊code{0x0000} or the font loading will fail in Internet Explorer (at least in versions 9 through 11). Other browsers do not seem to check for this value. If your font license allows embedding, you can find some more Python code for modifying the flag here: ◊link["http://www.typophile.com/node/102671"]{http://www.typophile.com/node/102671}.

◊h2[#:id "subsetting-your-fonts"]{Subsetting your fonts}

If you create your own webfonts using only the above steps, your files will be huge -- likely around 1 MB per typeface once you include bold and italic versions. This is because most typefaces (the good ones, at least) include characters for Russian, Greek, Hebrew, Arabic, and many other character sets. You can speed up your site a lot by whittling each font down to only the characters you’re likely to need.

For this part I’m assuming you’re on OS X. You’re going to need ◊link["http://brew.sh"]{Homebrew} and Python installed.

First, install the fontforge python extensions with ◊code{brew install fontforge}. Then:

◊blockcode{export PYTHONPATH=/usr/local/lib/python2.7/site-packages:$PYTHONPATH}

(You’ll need to do this every time you open a new terminal unless you permanently add Homebrew’s package folder to your Python path.)

Next, get yourself a copy of ◊link["https://github.com/pettarin/glyphIgo"]{glyphIgo}. This lovely Python script can convert between TTF and OTF font formats, and subset fonts based on any character set. Alberto Pettarin has ◊link["http://www.albertopettarin.it/blog/2014/09/16/subsetting-fonts-with-glyphigo.html"]{a great blog post} explaining more about its use.

If you have ◊code{git} installed (◊code{brew install git}), the following command will download a copy into a ◊code{glyphIgo} folder:

◊blockcode{git clone https://github.com/pettarin/glyphIgo.git}

Now we need to create the character set: a file containing each of the characters you want to include in your font. I wrote a quick Python script to assist with this, and have included codes several extra typographic symbols that I use often:

◊blockcode{from __future__ import print_function

charsets = [
    [0x0020,0x007F],    # BASIC LATIN
    [0x00A1,0x00FF],    # PUNCTUATION, LATIN-1 SUPPLEMENT, COMMON SYMBOLS
    [0xFB00,0xFB04],    # STANDARD ENGLISH LIGATURES fi, fl, ffi, ffl
    [0x0100,0x017F],    # LATIN EXTENDED-A
    [0x0180,0x024F],    # LATIN EXTENDE0D-B
    [0x2010,0x2015],    # HYPHENS AND DASHES
    [0x2018,0x2019],    # LEFT/RIGHT SINGLE QUOTATION MARKS
    [0x201C,0x201D],    # LEFT/RIGHT DOUBLE QUOTATION MARKS
    [0x2026,0x2026],    # ELLIPSES
    [0x221E,0x221E],    # INFINITY SYMBOL
    [0x2190,0x2193],    # ARROWS
    [0x21A9,0x21A9],    # LEFTWARDS ARROW WITH HOOK
    [0x2761,0x2761],    # CURVED STEM PARAGRAPH SIGN ORNAMENT
    [0x2766,0x2767]     # FLORAL HEART, ROTATED FLORAL HEART
]

for charset in charsets:
    for x in range(charset[0],charset[1]+1):
        print(unichr(x).encode('utf-8'),end='')}

Some notes on customizing this script: If you want to include any additional character blocks in your font, simply add the hex ranges to the ◊code{charsets} list (see the complete ◊link["http://www.fileformat.info/info/unicode/block/index.htm"]{list of Unicode blocks}). Single characters can be added by making the first and second numbers of the &quot;range&quot; identical.

Including the ligatures (if the font supports them) makes for a better result on some platforms. On Mac, for example, Safari will make use of the ligatures but Chrome doesn’t use them at all.

Save the above script as ◊code{makeset.py} and create your character set file like so:

◊blockcode{python makeset.py > latin.set}

Armed with our character set, you can now subset your font like so:

◊blockcode{python glyphIgo.py subset -f AlegreyaSans-Regular.otf -p latin.set -o AS-R.otf}

Now encode the new “minimized” font using the script we created above:

◊blockcode{./webfont-encode AS-R.otf alegreyasans-1 >> fonts.css}

◊h2[#:id "results"]{Results}

To get an idea of the size reduction, I used these methods to produce a single CSS file containing regular, italic, bold, and bold italic versions of two typefaces (a total of eight ◊code{@font-face}s).

Without subsetting the fonts, the resulting CSS file was 2.1 MB in size. When I subset the fonts before encoding them, the result was 611 KB in size, a 70% reduction.

For comparison, Typekit reports a size of 339K for a kit containing the same two typefaces, using the “Default” character set and without including OpenType features. However, I strongly suspect that this the ◊emph{compressed} size of their kit. You can achieve the same result by enabling gzip compression on your web server. On my own server, according to ◊link["http://checkgzipcompression.com"]{checkgzipcompression.com}, the 611 KB CSS file gets packed down to a 345 KB download --- almost identical to the Typekit version.

I could probably save even more space by omitting the Latin Extended-A and Extended-B blocks in my character set.

◊h2[#:id "speeding-it-up-even-more"]{Speeding it up even more}

Once you have your fonts set the way you like them, you should do yourself a further favour and check out Adam Beres-Deak’s post ◊link["http://bdadam.com/blog/loading-webfonts-with-high-performance.html"]{Loading webfonts with high performance on responsive websites}. Using the simple Javascript in his post, you can make your fonts load and perform ◊emph{much} faster than they would if you were using Typekit or Google Fonts.
