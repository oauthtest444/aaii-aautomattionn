# Endpoint Inventory

No same-origin API endpoints were discovered. The only reachable application
route is the launch bootstrap:

| Method | Path | Params | Auth | Status |
|---|---|---|---|---|
| GET | `/brand/{brandId}/sportsbook/launch` | `lang`, `theme`, `token`, `url`, `operator_page`, `deposit_url` | none | tested (HTML bootstrap) |
| OPTIONS | `/brand/{brandId}/sportsbook/launch` | none | none | tested (CORS preflight) |
| HEAD | `/brand/{brandId}/sportsbook/launch` | none | none | 405 `Allow: GET` |

All other same-origin paths tested return CloudFront `403`. Sportsbook API
traffic is on out-of-scope renderer origins and could not be captured.
