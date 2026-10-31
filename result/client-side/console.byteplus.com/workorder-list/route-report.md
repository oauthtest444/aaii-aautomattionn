# Route Report — /workorder/list/

- Route: https://console.byteplus.com/workorder/list/
- Status: completed
- Tested by: account A (`3000823185`) and account B (`3001021825`)
- Route JS: `https://res.gcloudcache.com/bp-fe/workorder-web/static/js/WorkOrderList.ce3bf66f.js`, `https://res.gcloudcache.com/bp-fe/workorder-web/static/js/main.7d5d0431.js`

## Regex match counts (exact client-side-skill regexes)

| Regex | Count |
|---|---:|
| source1 | 40 |
| source2 | 1 |
| sink: location.assign/replace | 1 |
| sink: location = | 0 |
| sink: createElement(iframe/object/embed/script) | 0 |
| sink: eval/Function/document.write/insertAdjacentHTML/innerHTML/srcdoc | 1 |
| sink: dangerouslySetInnerHTML | 0 |

## Matched sources and sinks

- `main.7d5d0431.js` — `new URLSearchParams(window.location.search).get("hiddenNavbar")` controls navbar mobile-sync only. The value is used to add/remove the `hiddenNavbar` query parameter and call `window.location.replace(i.toString())` where `i` is a `new URL(window.location.href)`. No attacker-controlled origin or redirect target.
- `WorkOrderList.ce3bf66f.js` — `.get(...)` matches are list filter reads and translation/API helper reads; no URL parameter reaches an HTML/JS sink.
- `main.7d5d0431.js` — `innerHTML` match is the shared `linkify` helper (`dW`) that parses text in a detached `<div>` and rewrites URLs. It is used by the detail route; see the detail report.
- `WorkOrderList.ce3bf66f.js` — `window.addEventListener("message", ...)` checks `event.origin === location.protocol + "//" + location.host` and only calls `GetTicketCount` to refresh the list badge. No DOM sink, no state change.

## Result

No client-side source-to-sink flow into an XSS-capable sink was found on the list route. The postMessage listener is exact-origin restricted and only triggers a read-only count refresh.

## Server-side coverage for this route

`ListTicket`, `ListTicketForUser`, `GetTicketCount`, `GetTicketCountForUser`, and `Tcc` were tested. Hidden `AccountID`/`AccountIDs`/`Owner`/`TenantID` overrides are ignored; results are scoped to the caller account. Cross-account ticket IDs are denied.
