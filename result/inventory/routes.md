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
