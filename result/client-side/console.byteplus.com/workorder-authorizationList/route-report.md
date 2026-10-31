# Route Report — /workorder/authorizationList

- Route: https://console.byteplus.com/workorder/authorizationList
- Status: completed
- Tested by: account A (`3000823185`)
- Route JS: `https://res.gcloudcache.com/bp-fe/workorder-web/static/js/AuthorizationList.c85cdb55.js`, `main.7d5d0431.js`

## Regex match counts (exact client-side-skill regexes)

| Regex | Count |
|---|---:|
| source1 | 8 |
| source2 | 1 |
| sink: location.assign/replace | 1 |
| sink: location = | 0 |
| sink: createElement(iframe/object/embed/script) | 0 |
| sink: eval/Function/document.write/insertAdjacentHTML/innerHTML/srcdoc | 1 |
| sink: dangerouslySetInnerHTML | 0 |

## Sources and sinks

- `.get(...)` matches are date-range/list filter and i18n reads; no URL parameter reaches a DOM/HTML sink.
- `source2` and the redirect match are the shared navbar `hiddenNavbar` mobile-sync logic in `main.js`; target is rebuilt from `window.location.href`.
- The only `innerHTML` match is the shared linkify helper in `main.js`, not used by this list view.

## Server-side coverage

`ListAuthorization` and `ListAuthorizationForUser` were tested against service `authorization` (region `ap-southeast-1`, version `2021-01-01`). The endpoints return the caller's empty authorization list. Supplying `AccountID` is rejected with `InvalidParam` (unknown parameter). No authorization records existed for the test accounts, so approve/terminate write paths could not be exercised without fabricating records.

`ListDiagnosticAuthorization` returned `InternalError` (no parameters) or `BadRequest` (with `AccountID`); no data was returned and no cross-account read was possible.

## Result

No client-side or server-side cross-account issue was confirmed on this route. The route is completed; diagnostic authorization remains unresolved due to backend errors.
