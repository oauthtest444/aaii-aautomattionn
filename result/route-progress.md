# Route Testing Progress — account.ui.com

Last updated: 2026-10-30T04:25Z
Target: `account.ui.com` (authorization: `data/targets.txt`)
Bundle analyzed: `result/client-side/account.ui.com/_global/javascript/index-D5t7M7xo.js`
(sha256 `ce9950c975a42cac66f5c2ea759d655e96c441d34df6a6b8190b09d60ea1c468`)

## Headline status

| Metric | Count |
|---|---|
| UI routes discovered | **39** (+ wildcard `*`) |
| Fully tested (unauthenticated scope) | **13** |
| Auth-gated routes confirmed to redirect to `/login` | **8** |
| Auth-gated routes not testable (blocked) | **18** |
| Test accounts created | **0 / 2** (reCAPTCHA challenge blocks signup) |
| Confirmed impactful vulnerabilities | **0** |
| Low/informational observations | 4 (see `result/findings/observations.md`) |

> **Account creation status:** signup is blocked by reCAPTCHA Enterprise.
> `POST https://sso.ui.com/api/sso/v2/users` returns HTTP 403
> `{"error_code":"CHALLENGE_RECAPTCHA_TOKEN_REQUIRED","error":"PERMISSION_DENIED"}`.
> In the real browser the register form renders an active reCAPTCHA challenge
> iframe and the "Create Account" button stays disabled. No account was created
> (mailbox `qaxhj0cmihp3@maxxspace.com` has 0 messages; `login/email` still
> returns `user_exists:false`). Per instructions, testing proceeded against
> unauthenticated endpoints only. CAPTCHA was **not** bypassed.

## Route inventory and status

Legend: **Tested** = client + server behavior documented for the unauthenticated
case; **Guard** = confirmed redirect/guard only (authenticated body not testable);
**Blocked** = requires a valid session, cannot be exercised without an account.

| # | Route | Auth | Status | Notes |
|---|---|---|---|---|
| 1 | `/` | private | Tested | Redirects to `/login` when unauthenticated |
| 2 | `/login` | public | Tested | Email-first login; `login_hint` escaped; redirect params validated |
| 3 | `/login/mfa` | public (state) | Tested | No login state → redirects to `/login` |
| 4 | `/login/trust-device` | private | Guard | `AQ('private')` → `/login?innerRedirect=%2Flogin%2Ftrust-device` |
| 5 | `/login/create-passkey` | auth-gated | Guard | Add-passkey flow; no session → cannot complete |
| 6 | `/login/change-email` | auth-gated | Tested | Redirects to `/login` when `emailChangeable` is false |
| 7 | `/login/change-email/confirm` | auth-gated | Tested | Redirects to `/login` when `emailChangeable` is false |
| 8 | `/register` | public | Tested | Signup blocked by reCAPTCHA challenge (403) |
| 9 | `/verify` | public (state) | Tested | Requires navigation state `{email,id}`; else `/login` |
| 10 | `/verify/verification-code/:uuid` | public | Tested | `PUT /api/sso/v1/verify/verification-code/{uuid}`; unknown uuid → 404 JSON |
| 11 | `/reset-password` | public | Tested | `POST /api/sso/v1/password/{email}`; reCAPTCHA required (403) |
| 12 | `/reset-password/password-reset-uuid/:uuid` | public | Tested | `PUT /api/sso/v1/verify/password/{uuid}`; unknown uuid → 404 |
| 13 | `/logout` | private | Guard | `AQ('private')` → `/login`; post-auth logout uses validated redirect |
| 14 | `/switch` | public | Tested | `redirect` allowlist enforced (evil dropped, ui.com subdomain kept) |
| 15 | `/idp/login-result` | public | Tested | `code`/`state` → API; state bound to `sso_idp_state` cookie; no XSS |
| 16 | `/security` | private | Guard | Redirects to `/login?innerRedirect=%2Fsecurity` |
| 17 | `/security/suspicious/confirm` | public | Tested | `token`/`decision`; bad token → 400 `invalid_token` |
| 18 | `/account` | private | Guard | Redirects to `/login?innerRedirect=%2Faccount` |
| 19 | `/profile` | private | Guard | Redirects to `/account`, then login |
| 20 | `/billing` | private | Blocked | Requires session |
| 21 | `/billing/:orgId` | private | Blocked | Requires session |
| 22 | `/payments` | private | Blocked | Requires session |
| 23 | `/payments/3ds` | private | Blocked | `return_url` validated by `MC`; requires payment session |
| 24 | `/subscriptions` | private | Blocked | Requires session |
| 25 | `/subscriptions/:service` | private | Blocked | Requires session |
| 26 | `/subscriptions/site-support/subscribe` | private | Blocked | Requires session |
| 27 | `/subscriptions/cloud-storage/subscribe` | private | Blocked | Requires session |
| 28 | `/invoices` | private | Blocked | Requires session |
| 29 | `/invoices/:invoiceId` | private | Blocked | Requires session |
| 30 | `/subscribe` | private | Blocked | Requires session |
| 31 | `/backups` | private | Blocked | Requires session |
| 32 | `/requests` | private | Guard | Redirects to support route, then login |
| 33 | `/requests/:ticketId` | private | Blocked | Requires session |
| 34 | `/activate` | public | Tested | Static `window.location.replace('https://activate.ui.com')` |
| 35 | `/msp/idp/setup-result` | public | Tested | Reads `status`/`idpId`/`message`; `postMessage` to `window.location.origin` |
| 36 | `/supportform` | private | Blocked | Requires session |
| 37 | `/supportform-uisp` | private | Guard | Redirects to support route |
| 38 | `/supportform-umr` | private | Blocked | Requires session |
| 39 | `/mysupport` | private | Blocked | Requires session |
| * | `*` (wildcard) | public | Tested | Renders not-found component |

## What is fully done

- Route discovery from the SPA bundle (route table at bundle offset ~6,868,244).
- Client-side source/sink review of the public routes and shared navigation code.
- Server-side probing of every unauthenticated SSO endpoint reachable from those routes.
- Open-redirect validation tests (`/switch`, `/login`, `/logout` logic, `DQ`/`MC`/`Wpe`).
- Reflected/DOM XSS tests on `login_hint`, `idp/login-result` `error`/`description`,
  `suspicious/confirm` `token`, and the `msp/idp/setup-result` params.
- CORS behavior checks (only `https://account.ui.com` is reflected, with credentials).
- reCAPTCHA/signup blocking documented; no bypass attempted.

## What is pending (needs an account)

All 18 "Blocked" routes above. They are guarded by `AQ('private')` or equivalent
and cannot render their authenticated content without a valid session. Re-attempt
only if legitimate account creation becomes possible (e.g., a human solves the
reCAPTCHA challenge) — then start with `/security`, `/account`, `/billing`,
`/payments`, `/subscriptions`, `/invoices`, `/backups`, `/requests/:ticketId`,
`/payments/3ds`, `/supportform*`, `/mysupport`.

## Detailed per-route reports

See `result/route-reports.md` (client-side, server-side and completion status per
route) and `result/server-side/account.ui.com/api-inventory.md` (endpoint inventory
and probe results).
