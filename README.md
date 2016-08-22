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
* Pollen tags for perma-embedding Tweets (no JavaScript)
* Example dynamically generated `index.ptree` — no need to edit every time you add a new post

## Setting up your own copy

* You'll need `xelatex` installed and in your `PATH` to generate PDFs. On Mac, installing [MacTeX](https://tug.org/mactex/) is easy and will do the job.
* You'll need to install [Racket](http://racket-lang.org), and the [Pollen package](https://docs.racket-lang.org/pollen/Installation.html)
* Ideally you'll be on a system that can run Bash scripts and the GNU `make` utility

Then just plop all the files from this repository in a folder.

## Tinkering

Blog posts should be named `your-post-name.poly.pm` and placed  in the `posts/` subfolder. Make sure the first line is `#lang pollen` and use `◊define-meta` to specify the title, publish date, and, optionally, “topics” (basically tags). Check out the existing `.poly.pm` files in that folder for more examples of how things are done.

If you really want to customize anything, you will need to [learn all about Pollen](https://docs.racket-lang.org/pollen/index.html)!

As in any Pollen project, you can test-run the site locally by running `raco pollen start` from the project folder. Then browse to `http://localhost:8080` in your browser.

From the project folder, run `make all` to generate all the static files for the site. This is an incremental rebuild: if you’ve built the site once and since done nothing but add a new post, `make all` will build the HTML and PDF files for that post, rebuild the Index and Topics HTML pages, and rebuild the RSS feed. If you change any of the Racket code (`.rkt` files) or any of the template files, it will rebuild the HTML files for every single post, or the PDF files for every post, or both, depending on what you changed.

Use `make zap` to clean out all the generated pages, which will force a complete rebuild next time you do `make all`.

Finally, you can use `make publish` to push all necessary static files to your web server. See `makefile` for more details; you'll need to configure a couple of environment variables and you also need to be able to ssh into your server passwordlessly.