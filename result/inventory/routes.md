# Route Inventory

Target: `sptpub.com` (domain-only). Discovered subdomains: 278 (see
`result/inventory/subdomains.txt`). Only 46 resolve from the test network.
The `startN` hosts were discovered after a brand host redirected
`/bt-renderer.min.js` to one of them; they were not in passive sources.

## Resolving hosts

| Host | Classification | Reachability / status |
|---|---|---|
| `static.sptpub.com` | S3 static CDN | 200 — public bucket listing (`spt77-static`); images + 404.html only |
| `files-immutable-4cbc033nbd3.sptpub.com` | S3 static CDN | 200 — public bucket listing (`spt77-nondynamic-files`); flags/currencies/i18n |
| `api-*` (a,g,h,i,j,k,33-sp,y) | Brand API gateways | CloudFront 503 `{"error":"access blocked"}` on every path/method/header tried |
| `api-help-beta.sptpub.com`, `help-beta.sptpub.com` | Help-centre app | CloudFront 403 "Request blocked" (WAF/edge) |
| `help-beta-ingress.sptpub.com`, `api-help-beta-ingress.sptpub.com` | Ingress | CNAME to deleted AWS ELB; no origin response |
| `api-raeth4un-feed.sptpub.com`, `api1-ws.sptpub.com` | Feed / WebSocket | CloudFront 403 "Request blocked" / edge block |
| `api.sptpub.com` | Legacy API (Hetzner) | TCP 80/443 filtered from test network |
| `help.sptpub.com`, `wiki.sptpub.com` | Help/wiki (Fasthosts) | TCP 80/443 filtered from test network |
| Brand hosts (`bettilt`, `blaze`, `bcgame`, `joycasino`, ...) | Operator-facing brand UIs | CloudFront 403 `{"error":"access blocked"}` for `/`, `/login`, `/robots.txt`, `/api/`, etc. |
| `dragonclub.sptpub.com` | Brand UI | CNAME `robuvboqwvihfwe983bcae.sptpub-infra.com` -> CloudFront; TLS handshake failure during this run |
| `start`, `start2`, `start3`, `start5`, `start7`, `start8`, `start9`, `start26`, `start31`, `start32`, `start33` | Brand landing origins | `/` -> 503 empty (geo block); `/bt-renderer.min.js` -> 200 fixed 403-page renderer |
| `start6`, `start16` | Dead (CNAME `loop.sptpub.com`) | `loop` -> 127.0.0.1; connection refused |
| `loop.sptpub.com` | Loopback / sinkhole | A 127.0.0.1; connection refused |

## Non-resolving

The remaining 232 subdomains do not resolve (stale / decommissioned records).
They were not tested and are recorded as `unresolved` in
`result/testing-inventory.json`.

## Conclusion

No UI route or JavaScript bundle could be loaded from the dynamic application:
every dynamic host is blocked at the edge (403/503 "access blocked" / WAF
"Request blocked") or has no reachable origin. Client-side route testing was
therefore not possible and is marked Unresolved. The only live, inspectable
surface is the two public S3 static buckets.
