# Unresolved Items

## 1. Dynamic application is edge-blocked (primary blocker)

All dynamic `*.sptpub.com` hosts return a CloudFront block before application
code runs, from this runner's egress:

- Brand hosts: `HTTP/2 403 {"error":"access blocked"}`.
- API hosts: `HTTP/2 503 {"error":"access blocked"}`, `bb-rsn: bc`.
- Help/feed/WS hosts: CloudFront 403 "Request blocked" (WAF).
- `startN` landing origins: `503` empty body.
- The block is geographic: the only served asset, `/bt-renderer.min.js`, renders
  "Access is forbidden from your location".

Tried: browser UA (curl + headless Chrome), `Accept-Language`,
`Origin`/`Referer`, `X-Requested-With`, cookies, `X-Forwarded-For`,
`X-Forwarded-Host`, `CloudFront-Viewer-Country`, geo cookie/query, and multiple
paths (`/`, `/login`, `/api/`, `/api/v1/`, `/health`, `/graphql`,
`/.well-known/...`). All returned the same block. No IPv6 egress is available.

Consequences:
- No UI route, JS bundle, API schema, or auth flow could be inspected.
- Client-side testing (sources/sinks/postMessage) is Unresolved.
- Server-side testing (mass assignment, IDOR/BOLA, BAC, business logic) is
  Unresolved.
- Two test accounts could not be created because signup is unreachable.

## 2. Dead / filtered origins

- `api.sptpub.com` (159.69.41.140/141): TCP 80/443 filtered.
- `help.sptpub.com` (88.208.6.60), `wiki.sptpub.com` (88.208.6.61): TCP 80/443
  filtered.
- `help-beta-ingress.sptpub.com`, `api-help-beta-ingress.sptpub.com`: CNAME to a
  deleted AWS ELB (NXDOMAIN); see `VULN-20261029-002`.
- `api-h-c34e8269-1333.sptpub.com`, `api-h-d6f5dd34-1091.sptpub.com`: CNAME to
  deleted CloudFront distributions (NXDOMAIN); not reclaimable; same finding.

## 3. Partial bucket enumeration

CloudFront ignores query strings on `static.sptpub.com`, so `?marker` /
`?prefix` / `?delimiter` cannot paginate the `spt77-static` listing. Only the
first 1000 keys (all `additional_images/**` plus `404.html`) are visible. The
bucket's direct S3 endpoint denies `ListBucket`/`?acl` (403), so the CloudFront
cache cannot be bypassed for pagination. `spt77-nondynamic-files` was fully
enumerable read-only.

`bt-app-static-themes.sptpub.com` returns 403 for every guessed object path. Its
hostname is not the bucket name (`bt-app-static-themes` -> NoSuchBucket), so the
actual origin bucket/prefix could not be determined without distribution config.

## 4. `startN` landing origins / `loop` loopback

The `startN` hosts are brand-specific landing origins discovered when brand
hosts redirected `/bt-renderer.min.js` to them. All are geo-blocked (`503`
empty) except the fixed error renderer. No app HTML/JS was served.

`start6.sptpub.com` and `start16.sptpub.com` CNAME to `loop.sptpub.com`, which
resolves to `127.0.0.1`; connections are refused. This is a potential SSRF
allowlist-bypass lead if any API accepts attacker URLs and trusts `*.sptpub.com`
names, but it is **unresolved** because the API is edge-blocked. No SSRF test
was possible and no finding is claimed.

## 5. Archived JavaScript

Wayback has one capture of `bettilt.sptpub.com/bt-renderer.min.js` (2021-01-04),
a 302 to `start.sptpub.com/<brand>/bt-renderer.min.js`. The live path now
redirects to `start5.sptpub.com/bt-renderer.min.js`. The fetched file is a
3,678-byte static error-page renderer (`class BTRenderer`) that writes a fixed
403 message via `innerHTML`; no input, no app routes, no API endpoints. Other
archived hosts timed out at the CDX API.

## 6. Credentials

`creds/test-account.txt` contains `console.byteplus.com` test accounts. That
host is not part of the `sptpub.com` scope, so the credentials were not used.
