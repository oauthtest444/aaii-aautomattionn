# Client-Side Route Report — /alb

- Exact route: `https://console.byteplus.com/alb/region:alb+cn-beijing/instance`
- Sub-routes covered: instance list and region/quota views (lazy chunks loaded
  by the SPA).
- Auth: test account A.
- JavaScript: first-party ALB bundles (`alb/b1`–`b13`) under
  `console-alb/core-alb`, scanned with the exact skill regexes.

## Match counts (route-related chunks)

| Chunk | source1 | source2 | sink_redirect | sink_locassign | sink_elem | sink_html | postMessage | msglistener |
|---|---|---|---|---|---|---|---|---|
| `index-1.25.0.24` (b1) | 46 | 0 | 0 | 0 | 5 | 1 | 7 | 1 |
| `materials-common-083aa757` (b5) | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| `895` (b8) | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 |
| `2220` (b9) | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 |

## Matched sources and sinks

- `b1` (`index-*`): bundled vendor SDKs (applog collector, React scheduler).
  The single `message` listener validates `e.devToolOrigin === t.origin` before
  acting; `postMessage` sends devtool/metrics messages.
- `b5`: benign URLSearchParams usage.
- `b8`: one `location` assignment inside library navigation with a fixed path.
- `b9`: one `new URLSearchParams` over `location` in a library helper.

## Interesting source-to-sink relationships

- No user-controlled source reaches a redirect, HTML, or code sink.

## Potential real vulnerabilities

- None demonstrated.

## Result

Not Vulnerable.
Status: completed.
