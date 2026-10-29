# Scope

## User Instructions (from data/targets.txt)

The target file contains:

> https://console.byteplus.com/workorder/list/$
>
> ---
>
> 1st wait 10 second to load all js files releted this ui then extract all subroutes and start testing

Effect on test plan:
- Authorized entry point is `https://console.byteplus.com/workorder/list/`.
- Wait ~10 seconds for the route to load all JavaScript before analysis.
- Enumerate sub-routes reachable under `/workorder/` on the same origin and test
  each one for client-side issues first, then server-side.
- Do not expand scope to unrelated routes or other byteplus.com subdomains.

## Authorization Source / Assumptions

- Authorization derived solely from `data/targets.txt`.
- Target classified as **URL-list** rooted at host `console.byteplus.com`.
- In scope: the listed workorder route, its sub-routes on the same origin, and
  same-origin JavaScript/API components required to exercise them.

## In-Scope Components

- `https://console.byteplus.com/workorder/...` routes (list, detail, create,
  and any sub-route discovered from the workorder UI).
- Same-origin JS bundles, inline scripts, workers, source maps, and API
  endpoints loaded by / used by those routes.
- `https://console.byteplus.com/auth/login/` only as the authentication flow
  needed to reach the workorder surface.

## Explicitly Out-of-Scope

- Other console.byteplus.com top-level routes (waf, finance, user, beian,
  message) except as required navigation for authentication.
- Any other byteplus.com subdomain, third-party CDN/analytics, partner systems.
- Destructive actions, real-user data, mass/fuzzing/DoS.

## Program Restrictions

- None stated beyond the route list.
- Standard AGENT.md safety rules: test-owned data only, no destructive writes,
  no real-user data, low request volume, harmless payloads.
