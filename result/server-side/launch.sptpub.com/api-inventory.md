# API Inventory — launch.sptpub.com

No same-origin server-side API endpoints were discovered from the only reachable
route.

| Method | Path | Source | Query | Body | Auth | Response shape | Status |
|---|---|---|---|---|---|---|---|
| GET | `/brand/{brandId}/sportsbook/launch` | launch route | `lang`, `theme`, `token`, `url`, `operator_page`, `deposit_url` | none | none | HTML bootstrap page | tested |
| OPTIONS | `/brand/{brandId}/sportsbook/launch` | preflight | none | none | none | `204`, CORS `*`, methods GET/POST/OPTIONS/PATCH | tested |
| HEAD | `/brand/{brandId}/sportsbook/launch` | method check | none | none | none | `405`, `Allow: GET` | tested |
| POST/PATCH/PUT/DELETE | `/brand/{brandId}/sportsbook/launch` | method check | n/a | n/a | none | CloudFront `403` | tested |

The sportsbook API traffic is produced by the renderer on
`gscplus.sptpub.com` / `start9.sptpub.com` (and per-brand origins), which are
different origins and outside the authorized host. The renderer is geo-blocked
from this runner, so no API calls were captured.

Common same-origin paths (`/`, `/api`, `/health`, `/version`, `/robots.txt`, and
deeper launch sub-paths) return CloudFront `403` and are not served as
application routes.
