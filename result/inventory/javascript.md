# JavaScript Inventory

Host: console.byteplus.com. Representative route:
`/ark/region:ap-southeast-1/overview` (the `/ark/*` routes share one SPA bundle;
scripts were deduplicated by SHA-256, 34 unique files, ~4.6 MB).

## Matching summary (client-side source/sink regexes)

| Sink | Match count |
|---|---|
| `source_get` (URL/params reads) | 256 |
| `source_url` (`URLSearchParams(location...)`) | 14 |
| `sink_redirect` (`location.assign/replace`) | 11 |
| `sink_assign` (`location.href = ...`) | 5 |
| `sink_create` (`createElement(iframe/object/embed/script)`) | 23 |
| `sink_html` (`eval`, `new Function`, `document.write`, `innerHTML`, `srcdoc`) | 2 |
| `sink_react` (`dangerouslySetInnerHTML`) | 15 |
| `postMessage` | 23 |

Deduped bundles with sinks: `4271.bf2bd0cb16.js`, `5437.bcbf7c3344.js`,
`6652.c7b3bd3cb9.js`, `8627.091a1c4f24.js`, `async-main.d0a27388a1.js`, `main.js`.

## Trace results

- `4271.bf2bd0cb16.js` contains the third-party applog/Tea analytics SDK. Its
  `createElement('script')` sinks load fixed, first-party/CDN URLs
  (`lf-global-static.iapplogcdn.com`), not attacker-controlled strings.
- Its `message` listeners filter with
  `ts.some(t => e.origin.indexOf(t) > -1)` / `rH.some(...)`. The allowlist is
  populated from SDK configuration (`V`/`tc`), not from the URL. No handler
  reachable from the page performs navigational, DOM-injection, or authenticated
  fetch actions with message data (`tea:openHeatMapCore` only loads the fixed
  heatmap-core script). No exploitable source→sink path was established.
- `sink_html` matches in `5437`/`6652`/`main.js` are React runtime and vendor
  helpers operating on build-time constants; traced inputs did not reach them
  from `location`/`postMessage`/API data.
- `dangerouslySetInnerHTML` uses are framework/rendering-library constants, not
  URL- or server-data-derived.
- No route-specific code read a query/hash parameter and passed it to
  `location.assign/replace`, `innerHTML`, `eval`, or `Function` without a fixed
  allowlist or encoder. No DOM XSS or open redirect was confirmed.

## Conclusion

Client-side: Not Vulnerable (no confirmed source→sensitive-sink path).
