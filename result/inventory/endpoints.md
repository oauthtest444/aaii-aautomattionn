# Endpoint Inventory

## Reachable

| Method | Host / Path | Auth | Result |
|---|---|---|---|
| GET | `https://static.sptpub.com/` | none | 200 S3 `ListBucketResult` for `spt77-static` (first page 1000 keys: `additional_images/...`, `404.html`) |
| GET | `https://files-immutable-4cbc033nbd3.sptpub.com/` | none | 200 S3 `ListBucketResult` for `spt77-nondynamic-files` (prefixes: `currencies/`, `flags_by_code/`, `rocket-league/`, `translations/`) |
| GET | `https://files-immutable-4cbc033nbd3.sptpub.com/translations/market-tooltips/en.json` | none | 200 i18n strings; no secrets/URLs found |
| GET | missing key on either bucket | none | 404 `NoSuchKey` XML; key name XML-escaped (no reflection as HTML) |

| GET | `https://start5.sptpub.com/bt-renderer.min.js` (same on all `startN`) | none | 200 `text/plain`, 3,678 B static `BTRenderer` geo-403 page; no input |
| GET | `https://start*.sptpub.com/` | none | 503 empty (geo block) |
| GET | `https://start*.sptpub.com/<any other path>` | none | 503 empty (geo block) |
| GET | `https://start6.sptpub.com/`, `https://start16.sptpub.com/`, `https://loop.sptpub.com/` | none | connection refused (127.0.0.1) |

## Blocked / unresolved

| Host | Paths tried | Result |
|---|---|---|
| `bettilt.sptpub.com`, `blaze.sptpub.com`, `bcgame.sptpub.com`, `joycasino.sptpub.com`, `777pub.sptpub.com`, `superboss.sptpub.com`, `roxcasino.sptpub.com`, `afun.sptpub.com`, `apostaganha.sptpub.com`, `apuestaroyal.sptpub.com`, `bahsegel.sptpub.com`, `casino-x.sptpub.com`, `dragonclub.sptpub.com` | `/`, `/login`, `/en`, `/robots.txt`, `/sitemap.xml`, `/api/`, `/api/v1/`, `/health`, `/.well-known/security.txt` | 403 `{"error":"access blocked"}` (CloudFront function / geo-bot block) |
| `api-a-c7818b61-600.sptpub.com` and other resolving `api-*` | `/`, `/health`, `/v1/`, `/v2/`, `/api/`, `/api/v1/`, `/graphql`, `/swagger.json`, `/openapi.json`, `/.well-known/openid-configuration`; GET/OPTIONS/POST | 503 `{"error":"access blocked"}`, header `bb-rsn: bc` |
| `api-help-beta.sptpub.com`, `help-beta.sptpub.com` | `/` | 403 CloudFront "Request blocked" (WAF) |
| `api-raeth4un-feed.sptpub.com`, `api1-ws.sptpub.com` | `/` | 403 CloudFront "Request blocked" |
| `static.sptpub.com` | `/<script>alert(1)</script>`, `?x=<script>` | 404 NoSuchKey XML (escaped) / cached bucket listing; no HTML reflection |
| `api.sptpub.com`, `help.sptpub.com`, `wiki.sptpub.com` | TCP 80/443 | filtered/timeout |

Header/method bypass attempts on blocked hosts (browser UA, Origin/Referer,
`X-Requested-With`, `Authorization`, cookies, `X-Forwarded-For/Host`,
`CloudFront-Viewer-Country`) all returned the same block.

## Interpretation

No server-side API could be exercised. Mass assignment, IDOR/BOLA, auth
boundary, business-logic, SSRF, and injection tests are **Unresolved** for the
dynamic API surface because the edge returns a static block page before any
application code or API route is reached.
