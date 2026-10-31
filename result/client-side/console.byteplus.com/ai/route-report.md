# Client-Side Route Report — /ai

- Exact route: `https://console.byteplus.com/ai/overview`
- Sub-routes covered: overview and app list (single discovered top-level
  sub-route).
- Auth: test account A.
- JavaScript: first-party Vision AI bundles (`ai/v1`–`v16`) under
  `lab-cv/tob_console_i18`, scanned with the exact skill regexes.

## Match counts (route-related chunks)

| Chunk | source1 | source2 | sink_redirect | sink_locassign | sink_elem | sink_html | sink_react | postMessage | msglistener |
|---|---|---|---|---|---|---|---|---|---|
| `lib-polyfill` (v1) | 3 | 0 | 0 | 0 | 0 | 0 | 0 | 5 | 1 |
| `main.3ad6d4c8` (v3) | 0 | 0 | 0 | 0 | 3 | 0 | 0 | 0 | 0 |
| `vmok-remote-entry` (v4) | 0 | 0 | 0 | 0 | 3 | 0 | 0 | 0 | 0 |
| `lib-arco` (v5) | 8 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 |
| `lib-axios` (v6) | 6 | 0 | 0 | 0 | 0 | 0 | 0 | 4 | 2 |
| `417` (v7) | 315 | 0 | 8 | 3 | 27 | 4 | 0 | 33 | 10 |
| `712` (v12) | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 1 | 0 |
| `438` (v13) | 4 | 1 | 3 | 0 | 0 | 0 | 0 | 0 | 0 |

## Matched sources and sinks

- `v7` (`417.*`): large vendor SDK (applog/Tea/Argus) — `message` listeners are
  devtool collectors with origin checks; `postMessage` sends metrics.
- `v12` (`712`): React DOM internals (`innerHTML` in the SVG shim,
  `MessageChannel.postMessage` for scheduling).
- `v13` (`438`): React Router internals — redirects are only performed when the
  parsed URL is cross-origin and outside the basename; source is the router
  location, not attacker input.
- `v1`/`v5`/`v6`: polyfills/Arco/Axios libraries; no application flow to a
  sensitive sink.
- `v3`/`v4`: benign `createElement("script"/"iframe")` loaders.

## Interesting source-to-sink relationships

- No user-controlled query/hash/postMessage value reaches `location.assign`,
  `innerHTML`, `eval`, or `postMessage` with a sensitive payload.

## Potential real vulnerabilities

- None demonstrated.

## Result

Not Vulnerable.
Status: completed.
