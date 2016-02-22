#lang pollen

◊(define-meta title "WriteMonkey: Tips and Tricks for Writers")
◊(define-meta published "2012-03-08")
◊(define-meta topics "Markdown,WriteMonkey,text editing")

I use WriteMonkey for almost all my writing. It’s the best Windows-based text editor I have found for writing prose (as opposed to programming code).

WriteMonkey is extremely ◊link["http://daringfireball.net/projects/markdown/"]{Markdown}-friendly — useful if, for example, like me you ◊link["20110818-how-to-use-markdown-in-blogspot-posts.html"]{write all your blog posts in Markdown format}.

Not all of WriteMonkey’s features are well-explained or documented, so I’m writing them up here.

◊section{Configure Markdown features}

◊ul{
◊item{Markdown highlighting will not work unless you have Markdown set as your “Markup Standard” — set this in the ◊code{Print & Export} section of your Preferences screen.}
◊item{Set the font size/weight/style used on headers: in the Preferences screen’s ◊code{Colors & Fonts} tab, click the button labeled ◊code{...} in the upper right section (why they didn’t label it more clearly is beyond my understanding).}
◊item{Make your exports look great. ◊link["https://docs.google.com/open?id=0B9SDJ22NRBkrTTVhYkcwMVVSTGVMQkc0QWtCcXdsUQ"]{Download the template in this zip file} and place it in WriteMonkey’s ◊code{templates} folder. It’s a version of ◊link["http://kevinburke.bitbucket.org/markdowncss"]{this Markdown stylesheet} with the following changes:

◊ul{
◊item{Removed ◊code{padding: 0; margin: 0} rule for the ◊code{ul} and ◊code{ol} elements - this preserves indentation in multi-level lists.}
◊item{The ◊code{max-width} was widened to look better on bigger screens.}
}}
}

◊section{Some undocumented features I found by accident}

◊ul{
◊item{You can toggle whether WM will use normal quotes or “smart quotes” with ◊code{CTRL+SHIFT+'} (apostrophe).}
◊item{Out of the box: type ◊code{/now} to insert the timestamp. You can format this timestamp in the Preferences screen.}
}

◊section{Use WriteMonkey to write your book}

WriteMonkey has a number of great features for writers:

◊ul{
◊item{It lets you set and monitor progress goals for your writing based on either word count or time or both.}
◊item{Hit ◊code{F5} to toggle between your main text and the “repository,” which works as kind of a scratch pad for the current file.}
◊item{You can use the Jump screen to set navigate around your text’s headings, bookmarks, and todo items.}
}

The upcoming version (2.3.5.0 as of this writing), however, will have some great project management functionality. (See ◊link["http://writemonkey.com/new.php"]{here} for more info)

◊ul{
◊item{Folders will be treated as projects, and all the files within it will be part of the project. You’ll be able to switch quickly between text files in the same folder using a new Files view in the Jumps window.}
◊item{You’ll be able to quickly merge all of a project’s files into a single text file.}
◊item{You’ll be able to mark a file with “tags” using a comment line (starting with ◊code{\\}) at the top of the file, and filter the project file list by tags.}
◊item{Special tags affect how the file is treated in the project window

◊ul{
◊item{Tagging a file with a color name will cause that file to show up with a colored star in the jump screen. Multple colors mean multiples stars, e.g. ◊code{// red red red} will add three red stars.}
◊item{Adding the “draft” tag will move the file to the “repository section” — the file will be presented with lighter color and excluded from total word count.}
◊item{Tag with a percentage, e.g. ◊code{// 50%} to add a grey progress bar}
◊item{Tag with a date in order to add a deadline; the border of the file will turn red when it becomes past-due}
}}
}

Let us know of any additional tips in the comments!

◊comment[#:author "Kabi Park"
         #:datetime "April 02, 2013"
         #:authorlink "https://www.blogger.com/profile/06871116148520330540"]{I like writing using ◊link["https://draftin.com/"]{Draft} which is online editor and supporting markdown & version control instead of WriteMonkey.}

◊comment[#:author "apps4all"
         #:datetime "November 11, 2014"
         #:authorlink "https://www.blogger.com/profile/02574603827688030109"]{You should have a look at SmartDown : ◊link["http://www.aflava.com/"]{More infos} which provides a zen UI and advanced features like focus mode or is able to “fold” markdown}
