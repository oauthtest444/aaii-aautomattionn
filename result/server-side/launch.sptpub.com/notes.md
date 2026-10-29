# Notes — launch.sptpub.com

- The host is a CloudFront distribution in front of an nginx origin.
- Only `/brand/{brandId}/sportsbook/launch` is served. All other paths tested
  (`/`, `/api`, `/health`, `/version`, `/robots.txt`, deeper launch paths,
  `/brand/{id}`) return a CloudFront 403.
- Numeric 19-digit brand IDs return the same bootstrap template. The supplied
  brand (`2599624589818605571`) uses `gscplus.sptpub.com` as its renderer;
  other numeric IDs use `demoapi.betby.com`. This is public launch routing, not
  a sensitive-object IDOR.
- The launch route is GET-only in practice: HEAD returns `405 Allow: GET`;
  POST/PATCH/PUT/DELETE are blocked by CloudFront.
- OPTIONS returns `204` with `Access-Control-Allow-Origin: *` and
  `Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With`.
  No authenticated/sensitive same-origin API is exposed on this route.
- No `Set-Cookie`, CSP, or X-Frame-Options was observed.
- `operator_page` and `deposit_url` are reflected into the inline script and
  used as navigation targets; this is the confirmed XSS (VULN-20261029-001).
- `lang`, `theme`, `token`, and the brand ID are reflected but safely escaped.
- The renderer is geo-blocked from this runner, so sportsbook APIs and
  client-side sub-routes could not be enumerated.
- A CloudFront rate limit (`bb-rsn: rl-m`) was triggered by a bounded request
  burst; testing was paused and resumed with spaced requests.
