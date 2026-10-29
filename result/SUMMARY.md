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

## Continuation Run — 2026-10-29T22:36Z–22:42Z

- Resumed preserved state (`decision=preserved`); prior VULN-20261029-001 kept.
- Re-fetched the launch route: body SHA-256 unchanged
  (`6faab8a8bebba04f958c72d1b8f990e9f2350d58bd6443cf3286cbc0801ec5d2`), so the
  confirmed flow was not re-run.
- Re-verified escaping: `operator_page=</script>...` is rendered as `\u003c...`;
  `lang` attribute injection is HTML-entity escaped. No direct XSS.
- Bounded route discovery: 14 route variants, 15 API/config variants, and 41
  common paths all returned CloudFront `403`. `format=json`,
  `_format=json`, `output=json`, and `Accept: application/json` still return the
  HTML bootstrap. Other numeric brand IDs use the same template with an
  out-of-scope renderer origin.
- Result: no new routes, endpoints, or confirmed findings. The only served
  application route remains `/brand/{brandId}/sportsbook/launch`.
