#lang pollen

◊(define-meta title "Formatting and Typesetting your Book in MS Word")
◊(define-meta published "2012-03-12")
◊(define-meta tags "typography,word,books,writing")

◊h3[#:id "format-your-page-and-text-block"]{Format your page and text block}

It starts with your page size. If you are self-publishing with a service like Lulu or CreateSpace, you select the size of your book, and this will give you a set of constraints (margins, etc.) to start with. Your page size and maximum margins will generally determine roughly how wide your text block can be.

Next, you want to find a matching set of values for your final font size, line height, and line width. The method I’m going to give you here is based on the fact that there is a set of ideal proportions between font size, line height, and line width, that give maximum readability and aesthetic appeal. See ◊link["http://www.pearsonified.com/2011/12/golden-ratio-typography.php"]{this article about golden ratio typography} for more information.

◊ol{
◊li{Take the width of your text block in inches and multiply by 72. This tells you how many “points” there are in one line of text.}
◊li{Take the square root of this number and divide by 1.618 (the golden ratio). This gives you an optimal font size, in points, for your main text.}
◊li{After rounding this font size to within half a point, multiply it by 1.618 again. This will give you your optimal line height in points.}
}

You may need to reiterate a few times until you get a matching set of numbers that fit well on your page and do not need too much rounding.

◊h3[#:id "configure-words-typesetting"]{Configure Word’s typesetting}

You can actually get book-quality typesetting from Word if you just change a few options.

A couple of points about paragraph formatting:

◊ul{
◊li{Make sure your main text is set to “justified”, and not “flush left.” While it is currently better to ◊link["http://www.webtypography.net/Rhythm_and_Proportion/Horizontal_Motion/2.1.3/"]{set text flush-left on the web}, books look better justified and are nearly always set that way.}
◊li{Don’t have spaces between paragraphs in your main body text.}
◊li{Paragraphs should have a first-line indent of the width of about 2 or 3 characters, but only where two or more paragraphs are joined together: the first paragraph of any group of paragraphs should have no first-line indent. (This could be a pain to manage; I tend to handle it by making all paragraphs indented by default, then going back and manually removing the indent from first paragraphs at some later stage in the editing.)}
}

Make sure the following settings are enabled under the “Compatibility” options. To get to these options, click on the circular “Office Button” in the upper left corner, and then click ◊code{Word Options} at the very bottom of the menu. Then click ◊code{Advanced}, scroll down to the bottom of that section, and click the ◊code{+} next to ◊code{Layout Options}. On older versions, click the ◊code{Tools} menu, then ◊code{Options} (or ◊code{Edit} → ◊code{Preferences} on a Mac) then click the ◊code{Compatibility} tab.

◊ul{
◊li{Put a check next to “Do full justification like WordPerfect 6.x for Windows.” This allows justified text to contract as well as expand, making the automatic adjustments look a lot better.}
◊li{“Don’t add extra space for raised/lowered characters.”}
◊li{“Don’t expand character spaces on the line ending SHIFT+RETURN.” This ensures that lines you end with a soft return will still be properly justified.}
◊li{“Suppress ‘Space Before’ after a hard page or column break.”}
}

Configure Word’s hyphenation settings. On the toolbar, click the ◊code{Page Layout} tab, then ◊code{Hyphenation} drop-down button → ◊code{Hyphenation Options}. (On older versions, click ◊code{Tools} menu → ◊code{Language} → ◊code{Hyphenation}.)

◊ul{
◊li{Put a check next to “Automatically hyphenate document.”}
◊li{Set “Hyphenation zone” to about half an inch.}
◊li{Set “Limit consecutive hyphens” to 3.}
}

Finally, enable ligatures. If your font is of good quality and has alternates for character combinations like fi and ffi, this will tell Word to use them automatically. This can only be done in MS Word 2010 or later.

◊ul{
◊li{Open the ◊code{Font} settings window. You can do this by selecting some text, right-clicking and selecting ◊code{Font} from the menu, but I recommend setting this up in whatever “style” you use for your body text (e.g., “Normal”): ◊code{Home} tab, right click the style, select ◊code{Modifiy}, then ◊code{Format} button → ◊code{Font}.}
◊li{Click the ◊code{Advanced} tab, then next to the ◊code{Ligatures} option, select ◊code{Standard Only}.}
}

◊h3[#:id "sources"]{Sources}

These tips are compiled from many sources, and in many cases updated for clarity or accuracy with newer versions of Word.

◊ul{
◊li{◊link["http://www.orzeszek.org/blog/2009/05/17/how-to-enable-opentype-ligatures-in-word-2010/"]{How to Enable OpenType ligatures in Word 2010}}
◊li{◊link["http://www.selfpublishing.com/design/downloads/articles/typesetting.pdf"]{Typesetting in Microsoft Word} by Jack Lyon}
◊li{◊link["http://www.pearsonified.com/2011/12/golden-ratio-typography.php"]{Golden Ratio typography} by Chris Pearson}
}

◊h2[#:id "comments"]{Comments}

◊h3[#:id "rundy-said"]{◊link["https://www.blogger.com/profile/01047159380596730164"]{Rundy} said:}

I am not familiar with Word since I use OpenOffice/LibreOffice but here is an additional tip from my experience:

Set the first paragraph in each chapter (or whatever body of text the first paragraph will not be indented in) to a different style (with no indent) than the rest of the body text. I call the style something like “first paragraph.” Instead of going back and deleting the indent from the first paragraph of each section, I change the style for the paragraph to the no indent “first paragraph” style.

At the time this is no more or less work than simply deleting the indent, but should you ever want to add some stylized feature to the first paragraph (like dropped caps) you can do this to all beginning paragraphs with one simple edit of the “first paragraph” style.

(Comment posted March 12, 2012)
