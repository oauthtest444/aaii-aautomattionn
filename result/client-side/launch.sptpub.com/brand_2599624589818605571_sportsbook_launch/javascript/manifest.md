# JavaScript Manifest — Launch Bootstrap

| URL | Type | SHA-256 | Loaded by | Retrieved (UTC) | Notes |
|---|---|---|---|---|---|
| `https://launch.sptpub.com/brand/2599624589818605571/sportsbook/launch` | inline module | `6faab8a8bebba04f958c72d1b8f990e9f2350d58bd6443cf3286cbc0801ec5d2` (plain page body) | launch route | 2026-10-29T14:26:04Z | Contains query-param reflection, token sync, renderer config. Saved `snippets/launch-plain.html`. |
| `https://launch.sptpub.com/brand/2599624589818605571/sportsbook/launch` (token param) | inline module | `1b89ef9c5c6d920858640e606b11fa873ffa754d03be4aeba5b62d86f680c667` | launch route | 2026-10-29T14:28:00Z | `token` reflection; saved `snippets/launch-token-param.html`. |
| `https://gscplus.sptpub.com/bt-renderer.min.js` | external classic script | n/a (36xx-byte geo-block stub after 302 to `start9.sptpub.com`) | launch route | 2026-10-29T14:26:14Z | Out-of-scope origin; only error renderer served from this runner. |
| `https://fonts.googleapis.com/css2?...` | third-party stylesheet | n/a | launch route | 2026-10-29T14:26:04Z | Out of scope. |

The only same-origin JavaScript is the inline module. No same-origin API
endpoints are referenced by it.
