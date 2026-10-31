# Client-Side Route Report — /datatester

- Exact route: `https://console.byteplus.com/datatester`
- Sub-routes covered: app/experiment list, metrics/feature-flag views,
  permission/org views (lazy chunks loaded by the SPA).
- Auth: test account A (no DataTester contract) and B (read-only demo data).
- JavaScript: first-party DataTester chunks (`dt/d1`–`d17`), scanned with the
  exact skill regexes.

## Match counts (route-related chunks)

| Chunk | source1 | source2 | sink_redirect | sink_locassign | sink_elem | sink_html | sink_react | postMessage | msglistener |
|---|---|---|---|---|---|---|---|---|---|
| `preload.js` (d1) | 3 | 0 | 0 | 3 | 0 | 0 | 0 | 4 | 1 |
| `75131` (d3) | 16 | 0 | 8 | 11 | 9 | 12 | 0 | 5 | 1 |
| `main.590222ea.js` (d4) | 23 | 1 | 0 | 0 | 0 | 1 | 0 | 1 | 0 |
| `7454` (d12) | 20 | 0 | 0 | 0 | 0 | 0 | 0 | 2 | 1 |
| `69821` (d13) | 0 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 |
| `55916` (d15) | 1 | 0 | 1 | 2 | 0 | 2 | 3 | 4 | 3 |

## Matched sources and sinks

- `preload.js`: `location.href = redirect_url` from the auth SDK response
  (`/oauth/redirectUrl`), plus logout redirects defaulting to
  `window.location.origin`. Server-controlled; no user-controlled target.
- `d3`/`d4`/`d12`: vendor libraries (moment, React wrappers, polyfills); sinks
  are library internals, not reachable from a user-controlled source.
- `d15`:
  - `window.addEventListener("message", ...)` accepts `data.type ===
    "set_x_rgw_dor"` and sets `document.cookie = "x-rgw-dor=" + data.data`
    without any origin/source validation.
  - Oncall iframe listener handles `getParentUrl` / `oncallEnd` /
    `getCustomStyle` without origin validation; `getParentUrl` posts
    `window.location.href` to `"*"` inside the trusted iframe.
  - `dangerouslySetInnerHTML` sites use `sanitize(...)`/`getHTML` (React Intl)
    and server-rendered message HTML; no raw user input path found.
  - API 401 handling redirects to a fixed login path with the current URL
    encoded as `redirectURI`.

## Interesting source-to-sink relationships

- postMessage (any origin) → `document.cookie` write for `x-rgw-dor` (cookie
  injection, low impact; value is not used for authz in observed flows).
- postMessage → oncall iframe state callbacks (feedback only).
- API response → `dangerouslySetInnerHTML` only after sanitization.

## Potential real vulnerabilities

- Unvalidated postMessage cookie injection (`set_x_rgw_dor`) — Unresolved, low.
  No privilege change or script execution was demonstrated.
- Unvalidated oncall iframe listeners — Unresolved, low; no sensitive action.

## Result

Not Vulnerable (no confirmed exploitable client-side issue).
Status: completed.
