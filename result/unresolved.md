# Unresolved / Out of Scope

## Unresolved

- **Sportsbook renderer and client-side sub-routes.** The real renderer is served
  from `gscplus.sptpub.com` (302 to `start9.sptpub.com`) and is geo-blocked from
  this runner. The launch page only received the 403 error renderer, so the
  sportsbook's internal routes, login flow, and UI callbacks could not be
  exercised directly.
- **`url` query parameter sink.** The launch page reads `url` and passes it as
  `url` to `BTRenderer.initialize(...)`. Whether the real renderer navigates to
  this value (open redirect) is unresolved because the renderer is geo-blocked.
- **Same-origin sportsbook API.** No API endpoints were referenced by the launch
  bootstrap. API calls are made by the out-of-scope renderer, so server-side
  classes (mass assignment, IDOR/BOLA, auth boundaries, business logic) could not
  be tested on `launch.sptpub.com`.
- **Token fixation / login CSRF.** The `token` query param is stored in
  `sessionStorage` and passed to the renderer. Whether the renderer accepts an
  attacker-supplied token to authenticate the victim's session is unresolved due
  to the geo-block. The param is JSON-escaped and not itself an XSS vector.

## Out of Scope

- `gscplus.sptpub.com`, `start9.sptpub.com` — renderer distribution origins.
- `demoapi.betby.com` — renderer origin used by other brand IDs.
- `fonts.googleapis.com`, `fonts.gstatic.com` — third-party font assets.
- Other `*.sptpub.com` hosts and any other tenant/brand beyond the supplied
  launch URL.
- Sportsbook APIs and user data on renderer/operator origins.

## Rate Limit

- CloudFront rate-limited the runner after a bounded burst of requests
  (`403`, `bb-rsn: rl-m`). Testing was paused; requests are now spaced and
  minimal. This is an operational limit, not a vulnerability.

## Continuation — 2026-10-29T22:41Z

- Re-confirmed route surface: 70 bounded path/API probes (route variants,
  API/config/manifest paths, common admin/auth/business paths) all returned
  CloudFront `403`; only `/brand/{brandId}/sportsbook/launch` is served.
- Renderer-dependent items remain Unresolved for the same geo-block reason:
  `url` sink, `token` session fixation/login CSRF, and renderer-side
  `lang`/`theme` sinks.
