# Blocked / Unreachable Dynamic Hosts

All dynamic application hosts returned an identical edge block from this test
network (GitHub Actions US egress). No request reached application code.

## Brand hosts (403 JSON)

`bettilt`, `blaze`, `bcgame`, `joycasino`, `777pub`, `superboss`, `roxcasino`,
`afun`, `apostaganha`, `apuestaroyal`, `bahsegel`, `casino-x`, `dragonclub`,
and all other resolving brand hosts.

```
HTTP/2 403
server: CloudFront
content-type: application/json
x-cache: Error from cloudfront

{
 "error": "access blocked"
}
```

Paths tried: `/`, `/login`, `/en`, `/en-US`, `/robots.txt`, `/sitemap.xml`,
`/favicon.ico`, `/api/`, `/api/v1/`, `/health`, `/.well-known/security.txt`,
`/index.html`.

Headers/params tried: browser User-Agent (curl and headless Chrome with a normal
UA), `Accept-Language`, `Origin`/`Referer`, `X-Requested-With`, cookies,
`X-Forwarded-For`, `X-Forwarded-Host`, `CloudFront-Viewer-Country`,
`?country=GB`.

## API hosts (503 JSON)

`api-a-c7818b61-600`, `api-g-c7818b61-607`, `api-h-c7818b61-608`,
`api-i-c7818b61-624`, `api-j-c7818b61-624`, `api-k-c7818b61-623`,
`api-33-sp-c7818b61-600`, `api-y-089t2gyhf4-7756u`.

```
HTTP/2 503
server: CloudFront
bb-rsn: bc
content-type: application/json

{
 "error": "access blocked"
}
```

Paths tried: `/`, `/v1/`, `/v2/`, `/api/`, `/api/v1/`, `/graphql`, `/health`,
`/status`, `/brand`, `/config`, `/swagger.json`, `/openapi.json`,
`/.well-known/openid-configuration`. Methods: GET, OPTIONS, POST, PUT.

## Brand landing origins (`startN`, 503 empty)

`start`, `start2`, `start3`, `start5`, `start7`, `start8`, `start9`, `start26`,
`start31`, `start32`, `start33` return `503` with an empty body for `/`,
`/login`, `/robots.txt`, `/manifest.json`, `/index.html`, `/en/`, `/api/`.
The only exception is `/bt-renderer.min.js`, which returns a 200 static
`text/plain` class that renders the fixed "Access is forbidden from your
location" 403 page. Bucket/host mapping: `bettilt`,`777pub`,`bahsegel`,
`casino-x`,`roxcasino`,`tanktech` -> start5; `blaze`,`afun`,`apostaganha` ->
start31; `bcgame`,`fasw0001` -> start9; `joycasino`,`gamingarttech` -> start26;
`apuestaroyal`,`superboss`,`gbg` -> start3; `bettilt` archived -> start5.

`start6` and `start16` CNAME to `loop.sptpub.com`, which resolves to
`127.0.0.1`; connections are refused.

## Help / feed / websocket (403 HTML)

`api-help-beta.sptpub.com`, `help-beta.sptpub.com`,
`api-raeth4un-feed.sptpub.com`, `api1-ws.sptpub.com` — CloudFront
"Request blocked" WAF page.

## Dead origins

- `help-beta-ingress.sptpub.com`, `api-help-beta-ingress.sptpub.com` — CNAME to
  deleted ELB (see `result/findings/VULN-20261029-002/`).
- `api-h-c34e8269-1333.sptpub.com`, `api-h-d6f5dd34-1091.sptpub.com` — CNAME to
  deleted CloudFront distributions; targets NXDOMAIN (same finding, not
  claimable).
- `api.sptpub.com` (159.69.41.140/141), `help.sptpub.com` (88.208.6.60),
  `wiki.sptpub.com` (88.208.6.61) — TCP 80/443 filtered from the test network.
- `dragonclub.sptpub.com` — TLS handshake failure during the run (it previously
  returned the same CloudFront block; origin/CNAME out-of-scope).
- `start6.sptpub.com`, `start16.sptpub.com`, `loop.sptpub.com` — resolve to
  `127.0.0.1`; connection refused.

## Why this matters

Because the block happens at the CloudFront edge, no UI route, JS bundle, API
route, or authentication flow could be observed. Client-side and server-side
application testing is therefore Unresolved, not "Not Vulnerable".
