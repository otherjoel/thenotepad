SHELL = /bin/bash

### Type 'make' at the prompt to see a list of available tasks.

# --- Variables used by rules ---

core-files := pollen.rkt \
              index.ptree \
			  util-date.rkt \
			  pollen-local/polytag.rkt \
			  pollen-local/common-helpers.rkt \
			  pollen-local/publication-vals.rkt

posts-sourcefiles := $(wildcard posts/*.poly.pm)

posts-html := $(patsubst %.poly.pm,%.html,$(posts-sourcefiles))
posts-pdf := $(patsubst %.poly.pm,%.pdf,$(posts-sourcefiles))

# I want to show off my Pollen source files, so I name them .pollen.html
posts-sourcelistings := $(patsubst %.poly.pm,%.pollen.html,$(posts-sourcefiles))

other-sourcefiles := books.html.pm about.html.pm
other-html := $(patsubst %.html.pm,%.html,$(other-sourcefiles))
other-sourcelistings := $(patsubst %.html.pm,%.pollen.html,$(other-sourcefiles))

# --- Rules ---

all: last_html.rebuild $(posts-html) $(posts-sourcelistings) $(other-html) $(other-sourcelistings) index.html feed.xml topics.html
all: ## Update all web content (not PDFs)

# Certain files affect all HTML output files. If these change, I want to do a complete rebuild
# of all posts. Rendering the whole ptree is somewhat faster than rendering each post separately.
#
# To ensure Pollen doesn't rely on its cache for these rebuilds, we need to touch pollen.rkt.
# But we save its timestamp first and restore it afterwards; otherwise we'd have the side effect
# of triggering the rule for last_pdf.rebuild also, even if pollen.rkt hadn't actualy been changed.
last_html.rebuild: $(core-files) template.html.p util-template.rkt pollen-local/tags-html.rkt
	touch -r pollen.rkt _save_timestamp
	touch pollen.rkt
	raco pollen render index.ptree
	tidy -quiet -modify -indent --wrap 0 --tidy-mark no --drop-empty-elements no posts/*.html || true
	touch -r _save_timestamp pollen.rkt; rm _save_timestamp
	touch last_html.rebuild

# If the above rule was triggered, all the posts-html files will already have been re-rendered.
# (That rule comes before this one in the list of dependencies for "all")
# But if not, any individual files that have been edited will get re-rendered.
$(posts-html): %.html: %.poly.pm
	raco pollen render -t html $<
	tidy -quiet -modify -indent --wrap 0 --tidy-mark no --drop-empty-elements no $@ || true

$(posts-sourcelistings): util/make-html-source.sh
$(posts-sourcelistings): %.pollen.html: %.poly.pm
	util/make-html-source.sh $< > $@
	tidy -quiet -modify -indent --wrap 0 --tidy-mark no --drop-empty-elements no $@ || true

pdfs: ## Update PDF files
pdfs: last_pdf.rebuild $(posts-pdf)

# Similar to HTML, first re-render all the PDFs if necessary...
last_pdf.rebuild: $(core-files) template.pdf.p util-template.rkt pollen-local/tags-pdf.rkt
	touch -r pollen.rkt _save_timestamp
	touch pollen.rkt
	raco pollen render pdf.ptree
	touch -r _save_timestamp pollen.rkt; rm _save_timestamp
	touch last_pdf.rebuild

# ...then, if a complete re-render wasn't necessary, render any individual PDFs that need it.
$(posts-pdf): %.pdf: %.poly.pm
	raco pollen render -t pdf $<

feed.xml: $(core-files) $(posts-sourcefiles) feed.xml.pp util-template.rkt pollen-local/tags-html.rkt
	touch feed.xml.pp
	raco pollen render feed.xml.pp

index.html: $(core-files) $(posts-sourcefiles) 
index.html: index.html.pp util-template.rkt pollen-local/tags-html.rkt
	touch index.html.pp
	raco pollen render index.html
	tidy -quiet -modify -indent --wrap 0 --tidy-mark no --drop-empty-elements no index.html || true

$(other-html): %.html: %.html.pm
	raco pollen render $@
	tidy -quiet -modify -indent --wrap 0 --tidy-mark no --drop-empty-elements no $@ || true

$(other-sourcelistings): util/make-html-source.sh
$(other-sourcelistings): %.pollen.html: %.html.pm
	util/make-html-source.sh $< > $@

topics.html: topics.html.pp $(core-fils) $(posts-sourcefiles) pollen-local/tags-html.rkt
	touch topics.html.pp
	raco pollen render topics.html.pp
	tidy -quiet -modify -indent --wrap 0 --tidy-mark no --drop-empty-elements no topics.html || true


# --- Additional project tasks ---

.PHONY: all pdfs publish spritz zap help

# Doing ‘make publish’ automatically upload everything except the Pollen source
# files to the public web server. The NOTEPAD_SRV is defined as an environment
# variable for security reasons (never put credentials in a script!)
# Make sure yours is of the form ‘username@serverdomain.com:public_html/’
# See also the docs for ‘raco pollen publish’:
#  http://pkg-build.racket-lang.org/doc/pollen/raco-pollen.html

publish: ## Rsync the website to the public web server (does not rebuild site first)
	rm -rf posts/pollen-latex-work flatland/pollen-latex-work
	raco pollen publish
	rsync -av ~/Desktop/publish/ -e 'ssh -p $(WEB_SRV_PORT)' $(NOTEPAD_SRV) \
		--delete \
	    --exclude=projects \
		--exclude=.git \
		--exclude=drafts \
	    --exclude=pollen-local \
		--exclude='*.rebuild' \
		--exclude=.DS_Store \
		--exclude=.gitignore \
	    --exclude='template*.*' \
		--exclude=makefile \
		--exclude=util \
		--exclude='posts/img/originals'
	rm -rf ~/Desktop/publish

# ‘make spritz’ just cleans up the pollen-latex-work files and clears the Pollen cache; 
# ‘make zap’ deletes all output files as well.
spritz: ## Just cleans up LaTeX working folders and Pollen cache
	rm -rf posts/pollen-latex-work pollen-latex-work
	raco pollen reset

zap: spritz ## Does a spritz and also deletes all HTML and PDF output
	rm posts/*.html posts/*.pdf
	rm feed.xml
	rm *.html *.pdf
	rm -f notepad.sqlite
	raco pollen reset

post: ## Quickly start a new post from template
	racket util/newpost.rkt

# Self-documenting makefile (http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html)
help: ## Displays this help screen
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help
