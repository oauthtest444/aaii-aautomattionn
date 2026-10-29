# SUMMARY

## Scope

- Target: `https://launch.sptpub.com/brand/2599624589818605571/sportsbook/launch?lang=tr&theme=DARK`
- Operator instruction: find and test all routes on `launch.sptpub.com`.
- Authorization: `data/targets.txt`; only the `launch.sptpub.com` host was tested.

## Tested Surface

- Only reachable application route: `/brand/{brandId}/sportsbook/launch`.
- Inline bootstrap JavaScript (sources, sinks, listeners, token flow).
- Query params: `lang`, `theme`, `token`, `url`, `operator_page`, `deposit_url`.
- Brand ID path handling and bounded route/method enumeration.
- No same-origin API endpoints were discovered; sportsbook APIs live on
  out-of-scope renderer origins and are geo-blocked from this runner.

## Confirmed Findings

- **VULN-20261029-001 — DOM XSS / token theft via `operator_page` and
  `deposit_url` (High).**
  `operator_page=javascript:...` (and the same via `deposit_url`) is reflected
  into the launch page's inline script and assigned to `window.location.href`
  in the login, register, and recharge callbacks. Runtime confirmation executed
  a harmless marker and read the sportsbook `token` from `sessionStorage`.
  The same flow also permits an open redirect.
  Evidence: `result/findings/VULN-20261029-001/`.

## Not Vulnerable / Blocked

- `lang`, `theme`, `token`, and brand ID are reflected but safely escaped.
- BroadcastChannel `token-sync` listener is same-origin only.
- The renderer and sportsbook routes/APIs are on out-of-scope origins and are
  geo-blocked (`Access is forbidden from your location`).
- `url` parameter is passed to the renderer but its sink behaviour is unresolved.
- CloudFront rate-limited the runner after a bounded burst (`bb-rsn: rl-m`);
  requests were paused and spaced.

## Time

- Start: 2026-10-29T14:25:36Z
- Results checkpointed: 2026-10-29T14:38Z
