# Client-Side Phase — Unresolved

No client-side route could be exercised. Every resolving dynamic host is blocked
at the CDN edge from this network:

- Brand hosts: `403 {"error":"access blocked"}`
- API hosts: `503 {"error":"access blocked"}` (`bb-rsn: bc`)
- Help/feed/WS hosts: CloudFront 403 "Request blocked"

The block occurs before HTML/JS is served, including with a real headless Chrome
session and a normal browser UA. The only reachable responses are S3 XML bucket
listings and static image/JSON assets, which contain no application JavaScript.

The only retrievable JS is `https://start5.sptpub.com/bt-renderer.min.js`
(sha256 `be3fde...d104c`, 3,678 B), a static error-page renderer that writes a
fixed geo-403 message via `innerHTML`. It has no input, no network calls, and no
routes. The identical file is served on all `startN` hosts.

Therefore:
- No application JavaScript bundle, chunk, worker, or source map exists.
- No source/sink flows could be traced.
- No postMessage listeners could be enumerated.
- No runtime XSS/CSTI/open-redirect test was possible.

See `result/server-side/blocked-hosts.md` and `result/unresolved.md`.
