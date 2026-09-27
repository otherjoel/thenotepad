#!/usr/bin/env zsh
# Deploy publish/ as the static assets of the thenotepad-site Worker (wrangler.jsonc). Each deploy is
# a full snapshot of publish/; only changed files are uploaded.
set -euo pipefail
cd "${0:A:h}"

print .DS_Store > publish/.assetsignore   # Finder files must not go public
wrangler deploy
