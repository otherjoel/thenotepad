#lang punct notepad

---
title: Formatting and Typesetting your Book in MS Word
date: 2012-03-12
topics: typography,Word
---

You can actually get some good-quality typesetting from Microsoft Word if you
just change a few options.

It starts with your page size. If you are self-publishing with a service like
Lulu or CreateSpace, you select the size of your book, and this will give you a
set of constraints (margins, etc.) to start with. Your page size and maximum
margins will generally determine roughly how wide your text block can be.

Next, you want to find a matching set of values for your final font size, line
height, and line width. The method I’m going to give you here is based on one
possible set of proportions between font size, line height, and line width. See
[this article about golden ratio
typography](http://www.pearsonified.com/2011/12/golden-ratio-typography.php) for
more information.

1. Take the width of your text block in inches and multiply by 72. This tells
   you how many “points” there are in one line of text.
2. Take the square root of this number and divide by 1.618 (the golden ratio).
   This gives you an optimal font size, in points, for your main text.
3. After rounding this font size to within half a point, multiply it by 1.618
   again. This will give you your optimal line height in points.

You may need to reiterate a few times until you get a matching set of numbers
that fit well on your page and do not need too much rounding.

## Configure Word’s typesetting

A couple of points about paragraph formatting:

- Make sure your main text is set to “justified”, and not “flush left.” While it
  is currently better to [set text flush-left on the
  web](http://www.webtypography.net/Rhythm_and_Proportion/Horizontal_Motion/2.1.3/),
  books look better justified and are nearly always set that way.
- Don’t have spaces between paragraphs in your main body text.
- Paragraphs should have a first-line indent of the width of about 2 or 3
  characters, but only where two or more paragraphs are joined together: the
  first paragraph of any group of paragraphs should have no first-line indent.
  (This could be a pain to manage; I tend to handle it by making all paragraphs
  indented by default, then going back and manually removing the indent from
  first paragraphs at some later stage in the editing.)

Make sure the following settings are enabled under the “Compatibility” options.
To get to these options, click on the circular “Office Button” in the upper left
corner, and then click *Word Options* at the very bottom of the menu. Then click
*Advanced*, scroll down to the bottom of that section, and click the *+* next to
*Layout Options*. On older versions, click the *Tools* menu, then *Options* (or
*Edit* → *Preferences* on a Mac) then click the *Compatibility* tab.

- Put a check next to “Do full justification like WordPerfect 6.x for Windows.”
  This allows justified text to contract as well as expand, making the automatic
  adjustments look a lot better.
- “Don’t add extra space for raised/lowered characters.”
- “Don’t expand character spaces on the line ending SHIFT+RETURN.” This ensures
  that lines you end with a soft return will still be properly justified.
- “Suppress ‘Space Before’ after a hard page or column break.”

Configure Word’s hyphenation settings. On the toolbar, click the *Page Layout*
tab, then *Hyphenation* drop-down button → *Hyphenation Options*. (On older
versions, click *Tools* menu → *Language* → *Hyphenation*.)

- Put a check next to “Automatically hyphenate document.”
- Set “Hyphenation zone” to about half an inch.
- Set “Limit consecutive hyphens” to 3.

Finally, enable ligatures. If your font is of good quality and has alternates
for character combinations like fi and ffi, this will tell Word to use them
automatically. This can only be done in MS Word 2010 or later.

- Open the *Font* settings window. You can do this by selecting some text,
  right-clicking and selecting *Font* from the menu, but I recommend setting
  this up in whatever “style” you use for your body text (e.g., “Normal”):
  *Home* tab, right click the style, select *Modifiy*, then *Format* button →
  *Font*.
- Click the *Advanced* tab, then next to the *Ligatures* option, select
  *Standard Only*.

### Sources

These tips are compiled from many sources, and in many cases updated for clarity
or accuracy with newer versions of Word.

- [How to Enable OpenType ligatures in Word
  2010](http://www.orzeszek.org/blog/2009/05/17/how-to-enable-opentype-ligatures-in-word-2010/)
- [Typesetting in Microsoft
  Word](http://www.selfpublishing.com/design/downloads/articles/typesetting.pdf)
  by Jack Lyon
- [Golden Ratio
  typography](http://www.pearsonified.com/2011/12/golden-ratio-typography.php)
  by Chris Pearson

•comment[#:author "Rundy" #:date "March 12, 2012" #:link "https://www.blogger.com/profile/01047159380596730164"]{
I am not familiar with Word since I use OpenOffice/LibreOffice but here is an
additional tip from my experience:

Set the first paragraph in each chapter (or whatever body of text the first
paragraph will not be indented in) to a different style (with no indent) than
the rest of the body text. I call the style something like “first paragraph.”
Instead of going back and deleting the indent from the first paragraph of each
section, I change the style for the paragraph to the no indent “first paragraph”
style.

At the time this is no more or less work than simply deleting the indent, but
should you ever want to add some stylized feature to the first paragraph (like
dropped caps) you can do this to all beginning paragraphs with one simple edit
of the “first paragraph” style.
}
