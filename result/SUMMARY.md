# Run Summary — account.ui.com

Last updated: 2026-10-30T05:10Z
Authorization: `data/targets.txt` (domain-only target: `account.ui.com`)
Bundle: `result/client-side/account.ui.com/_global/javascript/index-D5t7M7xo.js`
(sha256 `ce9950c975a42cac66f5c2ea759d655e96c441d34df6a6b8190b09d60ea1c468`)

## Status

- UI routes discovered: **39** (+ wildcard `*`)
- Fully tested unauthenticated: **13**
- Auth-gated routes confirmed to redirect to `/login`: **8**
- Auth-gated routes still blocked: **18**
- Test accounts created: **0 / 2** — reCAPTCHA Enterprise blocks signup
- Confirmed impactful vulnerabilities: **0**
- Discord notified: **no**
- `result/confirmed-vuln.txt`: unchanged (comments only)

## What was tested

- Route-by-route client-side review of the SPA bundle: sources, sinks,
  `postMessage`, redirects, raw-HTML paths, CSP/eval, and route guards.
- Server-side probing of unauthenticated SSO, account, geo, support, and billing
  endpoints reachable from `account.ui.com`.
- Open-redirect validation for `redirect`/`innerRedirect`, including encoded
  hosts, userinfo, backslashes, ports, and lookalike domains.
- Reflected/DOM XSS probes on `login_hint`, IdP result params, suspicious-login
  tokens, and MSP IdP setup params.
- CORS behavior on the SSO backends; a broader-than-documented `*.ui.com` /
  `*.ubnt.com` trust was found and recorded as unresolved.

## Notable non-reportable observations

See `result/findings/observations.md`:

1. User-existence oracle on `login/email` and availability checks (low/by design).
2. Public reCAPTCHA site keys named `*_SECRET` (public by design).
3. Referer-restricted Google Maps key (not usable elsewhere).
4. Attacker-controlled `description` sent to Sentry on `/idp/login-result`
   (telemetry only; not rendered).
5. Signup/password-reset anti-automation blocks account creation; no bypass used.
6. Verified-safe redirect/postMessage/login-hint behaviors.
7. `sso.ui.com` / `geo.svc.ui.com` reflect `https://*.ui.com`,
   `https://*.ubnt.com`, apex `ui.com`, and `https://uic.uidev.tools` with
   credentials. **Unresolved:** no attacker-controlled origin or session was
   available to prove data exposure. `account.svc.ui.com` rejects these origins.

## Blockers and next steps

Authenticated routes (`/security`, `/account`, `/billing`, `/payments`,
`/subscriptions`, `/invoices`, `/backups`, `/requests/:ticketId`,
`/supportform*`, `/mysupport`) remain untestable without a legitimate account.
Account creation requires a human to solve reCAPTCHA Enterprise; no bypass was
attempted.

If a legitimate session becomes available, retest those routes with focus on
IDOR/BAC, tenant isolation, billing/org authorization, and payment redirect
handling. If any accepted CORS origin can be shown to host attacker-controlled
JavaScript, revisit observation #7 with a test session and capture credentialed
cross-origin reads.

No confirmed vulnerability met the reporting bar; no Discord notification was
sent.
