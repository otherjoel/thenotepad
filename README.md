# The Notepad

Source for <https://thenotepad.org>, built with [Punct](https://joeldueck.com/what-about/punct/) and
[Camp](https://joeldueck.com/what-about/camp/). See `LICENSE.md` for copyright and licensing.

(Before 2026 the site was built with Pollen; that version is in the git history.)

## Layout

- `posts/` — one `#lang punct notepad` file per post (Markdown with `•` escapes to Racket).
  Metas: `title`, `date`, optional `updated` and `topics` (comma-separated).
- `pages/` — About, Books, the index (`index.page.rkt`), Topics and the 404 page.
- `main.rkt` — the custom elements available in sources: `•figure`, `•updatebox`, `•comment`,
  `•tweet`, `•color`, `•del`, `•sup`.
- `render.rkt` — page layout and HTML for the custom elements. Each post’s source is also copied
  to `publish/posts/<slug>.md`, minus the `#lang` line.
- `feed.rkt` — Atom feed entries (full post content).
- `static/` — stylesheet, images, favicons and `_headers`.
- `worker/`, `wrangler.jsonc`, `deploy.sh` — Cloudflare Worker hosting.

A fenced code block’s info string is shown as the listing’s filename:

    ```pollen.rkt
    (provide for/s)
    ```

## Building

    raco pkg install --auto --link --name notepad /path/to/this/folder   # once
    raco camp build        # output in publish/
    raco camp serve        # preview at http://localhost:8000
    raco camp deploy       # runs deploy.sh (wrangler deploy)
