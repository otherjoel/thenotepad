#lang punct notepad

---
title: WriteMonkey: Tips and Tricks for Writers
date: 2012-03-08
topics: Markdown,WriteMonkey,text editing
---

I use WriteMonkey for almost all my writing. It’s the best Windows-based text
editor I have found for writing prose (as opposed to programming code).

WriteMonkey is extremely
[Markdown](http://daringfireball.net/projects/markdown/)-friendly—useful if, for
example, like me you [write all your blog posts in Markdown
format](how-to-use-markdown-in-blogspot-posts.html).

Not all of WriteMonkey’s features are well-explained or documented, so I’m
writing them up here.

## Configure Markdown features

- Markdown highlighting will not work unless you have Markdown set as your
  “Markup Standard”—set this in the `Print & Export` section of your Preferences
  screen.

- Set the font size/weight/style used on headers: in the Preferences screen’s
  `Colors & Fonts` tab, click the button labeled `...` in the upper right
  section (why they didn’t label it more clearly is beyond my understanding).

- Make your exports look great. [Download the template in this zip
  file](https://docs.google.com/open?id=0B9SDJ22NRBkrTTVhYkcwMVVSTGVMQkc0QWtCcXdsUQ)
  and place it in WriteMonkey’s `templates` folder. It’s a version of [this
  Markdown stylesheet](http://kevinburke.bitbucket.org/markdowncss) with the
  following changes:

  - Removed `padding: 0; margin: 0` rule for the `ul` and `ol` elements - this
    preserves indentation in multi-level lists.
  - The `max-width` was widened to look better on bigger screens.

## Some undocumented features I found by accident

- You can toggle whether WM will use normal quotes or “smart quotes” with
  `CTRL+SHIFT+'` (apostrophe).
- Out of the box: type `/now` to insert the timestamp. You can format this
  timestamp in the Preferences screen.

## Use WriteMonkey to write your book

WriteMonkey has a number of great features for writers:

- It lets you set and monitor progress goals for your writing based on either
  word count or time or both.
- Hit `F5` to toggle between your main text and the “repository,” which works as
  kind of a scratch pad for the current file.
- You can use the Jump screen to set navigate around your text’s headings,
  bookmarks, and todo items.

The upcoming version (2.3.5.0 as of this writing), however, will have some great
project management functionality. (See [here](http://writemonkey.com/new.php)
for more info)

- Folders will be treated as projects, and all the files within it will be part
  of the project. You’ll be able to switch quickly between text files in the
  same folder using a new Files view in the Jumps window.

- You’ll be able to quickly merge all of a project’s files into a single text
  file.

- You’ll be able to mark a file with “tags” using a comment line (starting with
  `\\`) at the top of the file, and filter the project file list by tags.

- Special tags affect how the file is treated in the project window

  - Tagging a file with a color name will cause that file to show up with a
    colored star in the jump screen. Multple colors mean multiples stars, e.g.
    `// red red red` will add three red stars.
  - Adding the “draft” tag will move the file to the “repository section”—the
    file will be presented with lighter color and excluded from total word
    count.
  - Tag with a percentage, e.g. `// 50%` to add a grey progress bar
  - Tag with a date in order to add a deadline; the border of the file will turn
    red when it becomes past-due

Let us know of any additional tips in the comments!

•comment[#:author "Kabi Park" #:date "April 02, 2013" #:link "https://www.blogger.com/profile/06871116148520330540"]{
I like writing using [Draft](https://draftin.com/) which is online editor and
supporting markdown & version control instead of WriteMonkey.
}

•comment[#:author "apps4all" #:date "November 11, 2014" #:link "https://www.blogger.com/profile/02574603827688030109"]{
You should have a look at SmartDown : [More infos](http://www.aflava.com/) which
provides a zen UI and advanced features like focus mode or is able to “fold”
markdown
}
