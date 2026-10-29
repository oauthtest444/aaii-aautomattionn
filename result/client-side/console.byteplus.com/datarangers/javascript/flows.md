# Flows — /datarangers

| # | Source | Sink | File:offset | Status | Notes |
|---|---|---|---|---|---|
| 1 | `callback` query | `location.href` | umi:460535 | Not Vulnerable | `T(p)` returns `p` only when `hostname === window.location.hostname`, else `/`; also reached only after profile completion. |
| 2 | notification `thumb_content`/`message_text` | `dangerouslySetInnerHTML` | umi:650398,651671 | Unresolved | Server-rendered HTML from notification API; no user-writable notification/body found. Requires a delivery primitive to confirm. |
| 3 | help-doc `Content` | docor markdown `dangerouslySetInnerHTML` | umi:4522115 | Not Vulnerable | Static help content from `/doc` API. |
| 4 | `mp_info` query | `JSON.parse` | umi:3277300,4749451 | Not Vulnerable | Parse error only; no code/DOM injection. |
| 5 | route strings | `window.open` / `location.href` | main.e9a0251e.js:270325 | Not Vulnerable | Values originate from same-origin router/href, not an attacker URL. |

PostMessage: only polyfill/service-worker listeners; no attacker-reachable sensitive handler.
