# JavaScript Inventory

| URL | Type | SHA-256 | Status | Notes |
|---|---|---|---|---|
| `https://launch.sptpub.com/brand/2599624589818605571/sportsbook/launch` (inline module) | inline JS | `6faab8a8bebba04f958c72d1b8f990e9f2350d58bd6443cf3286cbc0801ec5d2` (page body, plain) | tested | Bootstrap logic: reads query params, token sync, renderer config. Saved as `launch-plain.html`. |
| `https://gscplus.sptpub.com/bt-renderer.min.js` -> `https://start9.sptpub.com/bt-renderer.min.js` | external dependency | `n/a` (36xx-byte geo-block stub) | out-of-scope | Different origin; returned 403/geo-block stub; not actively tested. |
| `https://fonts.googleapis.com/...` | stylesheet/font | n/a | out-of-scope | Third-party font. |

No same-origin external JS files are loaded by the launch route. All same-origin
logic is the inline module embedded in the HTML response.
