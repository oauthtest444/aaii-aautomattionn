# Client-Side Route Report — /ark

- Exact route: `https://console.byteplus.com/ark/region:ap-southeast-1/overview`
- Sub-routes covered: overview, API keys, vaults/credentials, agents, OAuth
  providers, and region switch (lazy chunks loaded by the SPA).
- Auth: test account A and B.
- JavaScript: first-party Ark chunks (`ark/a1`–`a45`), scanned with the exact
  skill regexes.

## Match counts (route-related chunks)

| Chunk | source1 | source2 | sink_redirect | sink_locassign | sink_elem | sink_html | sink_react | postMessage | msglistener |
|---|---|---|---|---|---|---|---|---|---|
| `async-main` (a14) | 39 | 5 | 2 | 1 | 0 | 0 | 0 | 0 | 0 |
| `7085` (a15) | 191 | 3 | 4 | 2 | 19 | 0 | 1 | 20 | 7 |
| `main.18bb113fc7` (a16) | 22 | 2 | 3 | 2 | 4 | 0 | 12 | 0 | 0 |
| `9027` (a29) | 2 | 0 | 0 | 0 | 1 | 0 | 0 | 3 | 1 |
| `page.b620b9fa93` (a37) | 2 | 0 | 2 | 1 | 0 | 0 | 2 | 0 | 0 |
| `9764` (a44) | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 1 |
| `6652` (a45) | 1 | 0 | 1 | 0 | 0 | 1 | 2 | 1 | 0 |

## Matched sources and sinks

- `a15` (`7085`): vendor SDK bundle (Slardar/TEAVisualEditor/applog). Its
  `message` listeners validate `origin` (devtool) or only handle devtool
  messages; `postMessage` targets are devtool/metrics.
- `a14`: region-switch redirect (`e8(...)`) and guest-access guard
  (`window.location.replace(rf)`); targets are internal/fixed.
- `a16`: React app shell; `dangerouslySetInnerHTML` uses sanitized/static
  content.
- `a29`/`a44`: vendor postMessage bridges (iframe/editor). `a44` supports a
  `strictOrigin` option; default `"*"` is library-level, not reachable from a
  page-controlled message to a sensitive action.
- `a37` (`page.*`): model-card "upgrade detail" click handler — if the target
  matches `/^https?:\/\//i` it uses `window.location.assign(t)`, otherwise
  internal navigation. `t` comes from the upgrade-detail config (API/console
  data), not from a URL/query/postMessage source.
- `a45` (`6652`): dialog `Href` is parsed with `new URL`, protocol restricted
  to http/https, then `location.assign`. Source is dialog config, not user input.

## Interesting source-to-sink relationships

- No user-controlled source (query/hash/postMessage) reaches a redirect or HTML
  sink. Redirects are driven by server/console configuration.
- postMessage listeners are vendor SDKs with origin checks or devtool-only
  behavior.

## Potential real vulnerabilities

- Config-driven open redirect in `a37`/`a45` — Unresolved, low; requires
  control of server-side console config, not demonstrated.

## Result

Not Vulnerable (no confirmed exploitable client-side issue).
Status: completed.
