# Scope

## User Instructions (from data/targets.txt)

The target file says:

> Untested Top-level routes for console.byteplus.com:
> https://console.byteplus.com/waf/overview
> https://console.byteplus.com/finance
> https://console.byteplus.com/user
> https://console.byteplus.com/beian
> https://console.byteplus.com/message
> https://console.byteplus.com/workorder/list/
>
> Test all these top-level routes visiting one by one.
>
> For client-side testing, visit one top-level route and extract all sub-routes
> under it. Test each sub-route individually for client-side bugs first, then
> test for server-side bugs.

Effect on test plan:
- These six URLs are the authorized entry points (URL-list target).
- Visit each top-level route, enumerate sub-routes under it, and test each
  sub-route for client-side issues first, then server-side.
- Same-origin JavaScript and API endpoints required to exercise these routes are
  considered in scope only insofar as they are components of
  `console.byteplus.com`.
- No instruction in the target file expands scope beyond
  `console.byteplus.com`; nothing here waives the safety or evidence rules.

## Authorization Source / Assumptions

- Authorization derived solely from `data/targets.txt` in this repository.
- Target classified as **URL-list** rooted at host `console.byteplus.com`.
- Only the listed URLs and same-origin components needed to exercise them are
  in scope.

## In-Scope Components

- `https://console.byteplus.com/` and the six listed routes.
- Sub-routes discovered under those top-level routes on the same origin.
- Same-origin JavaScript bundles, source maps, inline scripts, workers, and API
  endpoints loaded by / used by those routes.

## Explicitly Out-of-Scope

- Any other subdomain of `byteplus.com` (e.g. `www`, `api`, `iam`, regional
  consoles) unless it is reached as a same-origin component of
  `console.byteplus.com`.
- Third-party services, CDNs, analytics, and partner systems.
- Any asset outside `console.byteplus.com`.

## Program Restrictions

- None stated in `data/` beyond the route list.
- Standard AGENT.md safety rules apply: no DoS/load/fuzzing, no destructive
  writes, test-owned data only, no real-user data access.
- Rate limiting: keep request volume low and human-paced.
