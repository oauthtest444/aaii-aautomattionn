# Client-Side Route Report — /datarangers

- Exact route: `https://console.byteplus.com/datarangers`
- Sub-routes covered: `/datarangers` app list, `/datarangers/org/2100230837/app/list`,
  and the `/datafinder` project workspace reached from it.
- Auth: test account A (org `2100230837`, project `2111833`).
- JavaScript: first-party DataFinder chunks (`chunks/c1`–`c52`) plus shared
  platform bundles, scanned with the exact skill regexes.

## Match counts (route-related chunks)

| Chunk | source1 | source2 | sink_redirect | sink_locassign | sink_elem | sink_html | postMessage | msglistener |
|---|---|---|---|---|---|---|---|---|
| main `main-d8aa8d89.js` | 1 | 0 | 0 | 0 | 1 | 0 | 0 | 0 |
| `~src_utils_i18n...` | 4 | 0 | 0 | 0 | 0 | 0 | 3 | 0 |
| `~...takeData_ts` (c36) | 14 | 3 | 0 | 2 | 0 | 0 | 1 | 0 |
| `c45` | 0 | 0 | 0 | 1 | 0 | 0 | 1 | 1 |
| `c46` | 5 | 1 | 0 | 0 | 0 | 0 | 2 | 1 |
| `c48` | 2 | 1 | 0 | 0 | 0 | 0 | 0 | 1 |
| `c49` | 0 | 0 | 0 | 1 | 1 | 0 | 0 | 0 |
| `echarts.min` (vendor) | 875 | 0 | 0 | 0 | 0 | 5 | 0 | 0 |
| `vconsole` (vendor) | 51 | 1 | 1 | 0 | 3 | 0 | 4 | 2 |

## Matched sources and sinks

- `source1`/`source2`: mostly URLSearchParams/`new URL` internals in vendor
  bundles and i18n helpers; no application source reaching a sensitive sink.
- `main-d8aa8d89.js`: only a benign `document.createElement("input")` CSRF
  helper and a webpack script loader (`sink_elem`).
- `c45`: `addEventListener("message", ...)` implementing the Lark auth
  `messageHandler`. It accepts `data.type === "lark-verify"` with `data.code`
  without checking `event.origin`/`event.source`. The subsequent redirect is
  gated by a same-origin check and a `cloud-volc.bytebalance.net` host check, so
  no open redirect or token theft was achieved.
- `c46`: `useIframeCommunication` / `createPostMessageListener` listener does
  not validate `event.origin` (validates type/source/timestamp only). No
  sensitive action reachable from a foreign origin was found.
- `c48`: NPS feedback `did-submit` listener without origin validation; only
  records feedback state.
- `c36` `takeData` helper: `location` assignments are internal route changes
  with fixed prefixes; no user-controlled target.

## Interesting source-to-sink relationships

- postMessage (attacker-controllable) → Lark handler → redirect check: blocked
  by same-origin + host allowlist.
- postMessage → iframe communication → in-app state only.

## Potential real vulnerabilities

- Missing origin validation on three `message` listeners (low/unresolved).
  None demonstrated a sensitive state change, data read, or code execution, so
  not reported as confirmed.

## Result

Not Vulnerable (no confirmed client-side issue). The only confirmed finding on
this route remains the low-severity server-side IDOR VULN-20261031-001.
Status: completed.
