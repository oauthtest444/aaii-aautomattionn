# Server-Side Test Ledger — launch.sptpub.com

| Endpoint / Path | Method | Test | Auth | Baseline | Result | Status | Evidence |
|---|---|---|---|---|---|---|---|
| `/brand/2599624589818605571/sportsbook/launch` | GET | query reflection | none | HTML bootstrap | `operator_page`/`deposit_url` reflected; client-side sink confirmed as XSS | Confirmed (client-side) | `result/findings/VULN-20261029-001/` |
| `/brand/2599624589818605571/sportsbook/launch` | GET | `lang`/`theme`/`token`/brand injection | none | HTML bootstrap | escaped / numeric route only | Not Vulnerable | `result/client-side/.../flows.md` |
| `/brand/2599624589818605571/sportsbook/launch` | GET | brand ID path traversal / SQL-ish payloads | none | HTML bootstrap | 403 or 400; no reflected data | Not Vulnerable | `result/logs/server-side.log` |
| `/brand/{brandId}/sportsbook/launch` | GET | numeric brand ID enumeration (bounded: 570–574, 6000, 19-digit) | none | 200 template | Any numeric 19-digit ID returns default renderer config; target brand uses custom renderer | Not Vulnerable / informational | `result/logs/server-side.log` |
| `/brand/.../sportsbook/launch` | OPTIONS | CORS | none | 204 | `ACAO: *`, methods GET/POST/OPTIONS/PATCH | Informational, no sensitive data | `result/logs/server-side.log` |
| `/brand/.../sportsbook/launch` | HEAD/POST/PATCH/PUT/DELETE | method handling | none | GET 200 | HEAD 405; other methods CloudFront 403 | Not Vulnerable | `result/logs/server-side.log` |
| `/`, `/robots.txt`, `/sitemap.xml`, `/api`, `/health`, `/version` | GET | route discovery | none | n/a | CloudFront 403 | Not served | `result/server-side/launch.sptpub.com/api-inventory.md` |
| `gscplus.sptpub.com`, `start9.sptpub.com`, `demoapi.betby.com` | GET | renderer/API | none | 403 geo-block stub | Out of scope | Out of Scope | `result/unresolved.md` |

No same-origin API endpoint was available for mass-assignment, IDOR/BOLA,
auth-boundary, business-logic, SSRF, command-injection, or prototype-pollution
testing. Those classes are marked Unresolved on this host.

## Continuation Probe — 2026-10-29T22:38Z

| Endpoint / Path | Method | Test | Auth | Result | Status | Evidence |
|---|---|---|---|---|---|---|
| 14 route variants (`casino/live/poker/virtual/...`) | GET | route discovery | none | CloudFront 403 (919 bytes) | Not served | `traffic/route-probe-continuation.txt` |
| 15 API/config/manifest variants | GET | API discovery | none | CloudFront 403 (919 bytes) | Not served | `traffic/api-probe-continuation.txt` |
| brand `1234567890123456789`, `...570` | GET | renderer config | none | same template; renderer `demoapi.betby.com` (out of scope) | Not Vulnerable / informational | `/tmp/b-*.html` (not committed) |
| launch route | GET | `</script>` breakout via `operator_page` | none | `\u003c` escaped, no direct XSS | Not Vulnerable | logs |
| launch route | GET | `lang` attribute injection | none | HTML entity escaped | Not Vulnerable | logs |

| 41 common paths (`/admin`, `/login`, `/swagger`, `/actuator*`, `/brands`, `/odds`, `/wallet`, `/auth`, ...) | GET | route discovery | none | CloudFront 403 (919 bytes) | Not served | `traffic/route-probe-continuation-2.txt` |
| launch route | GET | `format=json` / `Accept: application/json` | none | `text/html` bootstrap only | Not Vulnerable | logs |
