# Route Inventory

Target host: `launch.sptpub.com`

| Route | Method | Status | Evidence / Notes |
|---|---|---|---|
| `/brand/2599624589818605571/sportsbook/launch` | GET | tested | Bootstrap HTML, inline module, geo-blocked sportsbook renderer. Confirmed DOM XSS in launch callbacks (VULN-20261029-001). Evidence: `result/client-side/launch.sptpub.com/brand_2599624589818605571_sportsbook_launch/`. |
| `/brand/{brandId}/sportsbook/launch` | GET | tested | Numeric brand IDs render the same template; renderer origin comes from per-brand config. Only brand `...571` is the supplied target. |
| `/brand/2599624589818605571/sportsbook/launch/` | GET | out-of-scope-behavior | 403 from CloudFront (route not served). |
| `/brand/2599624589818605571/sportsbook/launch/*` | GET | not-served | Additional path segments return CloudFront 403. |
| `/brand/{id}` | GET | not-served | CloudFront 403. |
| `/`, `/robots.txt`, `/sitemap.xml`, `/api`, `/health`, `/version` | GET | not-served | CloudFront 403; not distinct application routes. |

The only reachable application route on the authorized host is the sportsbook launch bootstrap.
Client-side sub-routes belong to the renderer/sportsbook application served by an
out-of-scope origin (`gscplus.sptpub.com` -> `start9.sptpub.com`) and are geo-blocked
from this runner.

## Continuation Probe — 2026-10-29T22:38Z

Re-probed route variants on `launch.sptpub.com` with spaced requests (CloudFront
rate limit respected). All returned CloudFront `403` (919-byte block page):

- `/brand/2599624589818605571/{casino,live,poker,virtual}/launch`
- `/brand/2599624589818605571/{sportsbook,casino,launch}`
- `/brand/2599624589818605571`
- `/{launch,sportsbook/launch,casino/launch}`
- `/.well-known/security.txt`, `/security.txt`
- `/api/v1/brand/...`, `/api/brand/...`, `/api/v1/brands/...`
- `/graphql`, `/api/graphql`, `/config`, `/config.json`, `/manifest.json`,
  `/asset-manifest.json`
- `/brand/.../sportsbook/launch/{config,config.json,manifest.json}`,
  `/brand/.../sportsbook/{config,launch.json}`

Conclusion unchanged: the only served application route is
`/brand/{brandId}/sportsbook/launch`. Raw probe output:
`result/server-side/launch.sptpub.com/traffic/route-probe-continuation.txt` and
`api-probe-continuation.txt`.

## Continuation Probe 2 — 2026-10-29T22:41Z

41 additional high-value paths (`/admin`, `/login`, `/swagger`, `/openapi.json`,
`/actuator*`, `/metrics`, `/brands`, `/sports`, `/odds`, `/wallet`, `/auth`,
`/oauth`, `/callback`, `/redirect`, etc.) all returned CloudFront `403`
(919-byte block page). `format=json`, `_format=json`, and `output=json` with
`Accept: application/json` still returned the HTML bootstrap. Raw output:
`result/server-side/launch.sptpub.com/traffic/route-probe-continuation-2.txt`.
