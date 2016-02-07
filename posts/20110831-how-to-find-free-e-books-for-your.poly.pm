#lang pollen

◊(define-meta title "How to find free e-books for your Kindle using Google")
◊(define-meta published "2011-08-31")
◊(define-meta tags "Kindle,eBooks")

Google already indexes the locations of many ebooks, you just need to know how to find them.

Just enter your search using the form ◊code{intitle:index.of Moby Dick epub mobi} — replace ◊emph{Moby Dick} with your desired title or keyword. This search will turn up file listings with direct downloads for (hopefully) ebooks. You may, in fact, get many more books than just the one you were searching for.

If clicking on a search result gives you some kind of “access denied” message, just go back to the Google search result and click where it says ◊noun{Cached} to access the copy Google cached before the file listing was made private. Usually the download links from these cached listings still work.

Kindles don’t support the ePub format, so if that’s all you can find, you’ll need to convert it to ◊code{.mobi} format using ◊link["http://calibre-ebook.com/"]{Calibre}.
