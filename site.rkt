#lang camp/site

title = "The Notepad"
url = "https://thenotepad.org"
founded = 2006-01-01
authors = ["Joel Dueck (joel@jdueck.net)"]
default-render = "(notepad/render render-page)"
deploy-script = "deploy.sh"

[[collections]]
name = "posts"
source = "posts/*"
output-paths = "posts/*"
render-with = "(notepad/render render-post)"
taxonomies = ["topics"]

[[collections]]
name = "pages"
source = "pages/*"
output-paths = "*"
render-with = "(notepad/render render-page)"
sort-key = "title"
order = "ascending"

[[feeds]]
filename = "feed.atom"
collections = ["posts"]
render-with = "(notepad/feed feed-content)"
