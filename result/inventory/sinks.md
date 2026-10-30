# Sink inventory — DTS list route chunks

Regex/sink sweep over route-related JS (see `javascript.md`):

| Sink pattern | Hits | Assessment |
|---|---|---|
| `dangerouslySetInnerHTML` | none | React renders data as text |
| `.innerHTML` / `insertAdjacentHTML` | none | not present |
| `document.write` | none | not present |
| `eval(` | none | not present |
| `new Function` | index (vendor runtime only) | no user-controlled input reaches it |
| `location.assign` / `location.replace` | none | not present |
| `location.href =` (2382) | `p(e){window.location.href=f(e)}` | `f()` builds `/${product}/region:${product}+${region}/${path}`; only used in ops builds; not attacker-controlled |
| `window.open` (6326) | help-doc / SQL Server backup links | static doc/product links, `_blank` |
| `URLSearchParams` (6326) | reads `TaskType` query param | selects form config; not rendered as HTML |
| `location.search` (2382/6326) | query helper + TaskType | no XSS-capable sink downstream |
| `postMessage` listeners | none in route chunks | none to test |
| `document.referrer` | none | not present |

`/dts/redirect` chunk: internal `history.push` based on `scene`/`taskId`; no
external open redirect.
