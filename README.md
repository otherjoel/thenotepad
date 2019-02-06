# The Notepad

A blog created with [Pollen](https://docs.racket-lang.org/pollen/index.html). The live site is at <https://thenotepad.org>. See `LICENSE` for copyright/licensing information.

## Background

Pollen is really optimized for *books*, where the sections are finite and can be prearranged according to the logic of the subject matter. It takes some extra work to put it to use as a *blog*, which by analogy is a loose sheaf of papers that need constant reshuffling before any use can be made of them.

Nonetheless, it works pretty well as a static blog generator. Pollen comes with no opinions about your site so there's no cruft to clean out or hack around. Pollen also gives me capabilities I can no longer live without — first among which is, it allows you to design your own markup and control how it works, forever. More thoroughly tedious rationale for my design choices will eventually go on the site’s [About page](https://thenotepad.org/about.html).

## Features

* An RSS Feed
* Generates PDF versions of every post
* Includes “Topics”, a tagging system
* Makefile for incremental builds
* Pollen tags for perma-embedding Tweets in web and PDF output (no JavaScript)
* Example dynamically generated `index.ptree` — no need to edit every time you add a new post
* [Semantic line wrapping](https://github.com/otherjoel/thenotepad/commit/d35f0d40d2d1ce9e1f41086c69fe9fa6183af803)

### Support

If you find this project helpful, please consider chipping a few bucks towards the author!

<a href='https://ko-fi.com/B0B1MJ3B' target='_blank'><img height='36' style='border:0px;height:36px;' src='https://az743702.vo.msecnd.net/cdn/kofi1.png?v=0' border='0' alt='Buy Me a Coffee at ko-fi.com' /></a>

## Setting up your own copy

* You'll need `xelatex` installed and in your `PATH` to generate PDFs. On Mac, installing [MacTeX](https://tug.org/mactex/) is easy and will do the job.
* You'll need to install [Racket](http://racket-lang.org), and the [Pollen package](https://docs.racket-lang.org/pollen/Installation.html)
* Ideally you'll be on a system that can run Bash scripts and the GNU `make` utility
* If you do use the included makefile to build the site, you will want to install [HTML5 Tidy](http://www.html-tidy.org) — or remove references to the `tidy` command in the makefile. (**Note:** Many operating systems come with a version of `tidy` pre-installed, but it is usually very out of date and will throw errors when used with this repo.)

Next, just plop all the files from this repository in a folder. Run `make all` from the command line in this folder to build all the static HTML files. Run `make pdfs` to build the PDF versions of each post. (This is done separately because it is so much slower than building the HTML.)

To start writing your own content, move the included `posts` directory out of the way. You may wish to keep it around under a different name in order to refer to it for examples:

    mv posts posts.example; make zap;

The `make zap` cleans out the top-level pages and the SQLite cache used to build them.

Finally, edit `feed.xml.pp`, filling in your own RSS metadata.

## Tinkering

Blog posts should be named `your-post-name.poly.pm` and placed  in the `posts/` subfolder. Make sure the first line is `#lang pollen` and use `◊define-meta` to specify the title, publish date, and, optionally, “topics” (basically tags). Check out the existing `.poly.pm` files in that folder for more examples of how things are done.

If you really want to customize anything, you will need to [learn all about Pollen](https://docs.racket-lang.org/pollen/index.html)!

As in any Pollen project, you can test-run the site locally by running `raco pollen start` from the project folder. Then browse to `http://localhost:8080` in your browser.

From the project folder, run `make all` to generate all the static HTML files for the site. This is an incremental rebuild: if you’ve built the site once and since done nothing but add a new post, `make all` will build the HTML files for that post, rebuild the Index and Topics HTML pages, and rebuild the RSS feed. If you change any of the Racket code (`.rkt` files) or any of the template files, it will rebuild the HTML files for every single post, depending on what you changed.

Use `make zap` to clean out all the generated pages, which will force a complete rebuild next time you do `make all`.

In order to speed up rendering of `index.html` and other top-level pages, I have implemented an additional caching system in an SQLite database. See the post [Using SQLite to Speed Up Pollen Renders](https://thenotepad.org/posts/pollen-and-sqlite.html) to understand how it works.

Finally, you can use `make publish` to push all necessary static files to your web server. See `makefile` for more details; you'll need to configure a couple of environment variables and you also need to be able to ssh into your server passwordlessly.

## Contributing

See [Contributions](CONTRIBUTIONS.md) for guidance on submitting issues and pull requests to this repo.

## Forking

Please feel free to fork this repo! If you do so, be sure to edit `CONTRIBUTIONS.md` to reflect your preferred guidance for potential contributors. Also note you must abide by the [license terms](LICENSE.md), so please review those carefully.

If you want your improvements and customizations to be more generally known, feel free to let me know; I’ll be happy to add a link to it in the section below. (Alternatively, add a link to it in this file yourself and submit a pull request.)

### Existing forks

None yet!


