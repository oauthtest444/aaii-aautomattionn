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
