// thenotepad-site: thenotepad.org on Cloudflare. Static files come from publish/ (wrangler.jsonc).
// This script runs only when no file matches the path exactly (html_handling is "none", so
// /posts/x.html stays /posts/x.html). It handles:
//   directory indexes (/ → /index.html; /dir → /dir/)
//   URLs from the Pollen site that no longer exist:
//     /posts/<slug>.pollen.html  (source listings)  → /posts/<slug>.md
//     /posts/<slug>.pdf          (PDF editions)     → /posts/<slug>.html
//     /feed.xml                                     → /feed.atom
//     /cgi-bin/rs2019/*  (the repo's old CGI address)  → /repos/rs2019/*
//   /repos/*: fossil repositories on poder (Joel's home server), proxied through the tunnel hostname
//     ORIGIN; run_worker_first in wrangler.jsonc sends these here before any file lookup
//   the 404 page (pages/404.md.rkt)

export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    const path = url.pathname;

    if (path === "/repos") return Response.redirect(`${url.origin}/repos/${url.search}`, 301);
    if (path.startsWith("/repos/")) return proxy(request, url, env);

    let m;
    if ((m = path.match(/^\/cgi-bin\/rs2019(\/.*)?$/))) {
      return Response.redirect(`${url.origin}/repos/rs2019${m[1] || "/"}${url.search}`, 301);
    }
    if ((m = path.match(/^\/(posts\/[^/]+|about|books)\.pollen\.html$/))) {
      return Response.redirect(`${url.origin}/${m[1]}${m[1].startsWith("posts/") ? ".md" : ".html"}`, 301);
    }
    if ((m = path.match(/^\/posts\/([^/]+)\.pdf$/))) {
      return Response.redirect(`${url.origin}/posts/${m[1]}.html`, 301);
    }
    if (path === "/feed.xml") return Response.redirect(`${url.origin}/feed.atom`, 301);

    if (path.endsWith("/")) {
      const index = await env.ASSETS.fetch(new Request(new URL(path + "index.html", url), request));
      if (index.status !== 404) return index;
    } else {
      // A directory without its slash (e.g. /projects/aoc2016): add it, as Apache did
      const index = await env.ASSETS.fetch(new Request(new URL(path + "/index.html", url), request));
      if (index.ok) return Response.redirect(`${url.origin}${path}/${url.search}`, 301);
    }
    return notFound(url, env);
  },
};

// Path and query unchanged; fossil builds thenotepad.org URLs itself (--baseurl). On this hop
// CF-Connecting-IP names the Worker, so the visitor's address travels in X-Jdcom-Client-IP, which
// nginx on poder logs.
async function proxy(request, url, env) {
  const target = new URL(url.pathname + url.search, env.ORIGIN);
  const headers = new Headers(request.headers);
  headers.set("X-Forwarded-Host", url.host);
  headers.set("X-Jdcom-Client-IP", request.headers.get("CF-Connecting-IP") || "");
  return fetch(target, { method: request.method, headers, body: request.body, redirect: "manual" });
}

async function notFound(url, env) {
  const page = await env.ASSETS.fetch(new URL("/404.html", url));
  if (page.ok) return new Response(page.body, { status: 404, headers: page.headers });
  return new Response("Not found", { status: 404, headers: { "Content-Type": "text/plain; charset=utf-8" } });
}
