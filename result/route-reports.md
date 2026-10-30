# Per-Route Reports — account.ui.com

Bundle: `result/client-side/account.ui.com/_global/javascript/index-D5t7M7xo.js`
(sha256 `ce9950c975a42cac66f5c2ea759d655e96c441d34df6a6b8190b09d60ea1c468`)

Shared navigation/redirect primitives (apply to all routes):

- `MC(e)` — accepts an absolute URL only if `protocol` is `http(s)` and
  `hostname.split('.').slice(-2).join('.')` is one of `ubnt.com`, `ui.com`,
  `uisp.com` (bundle ~762,273–762,900). Rejects `//`, backslashes, userinfo tricks,
  encoded-dot host tricks, and arbitrary external hosts.
- `Wpe(e)` — accepts only `/login`, `/register`, `/reset-password`, `/switch`,
  `/backups`, `/payments`, `/subscriptions`, `/invoices`, `/profile`, `/account`,
  `/security`, `/billing`, `/requests`, `/supportform-uisp` (and sub-paths); rejects
  `//` and backslashes (~774,008).
- `DQ(url)` — parses `redirect`/`innerRedirect`, validates with `MC`/`Wpe`
  (~4,779,632).
- `CQ()` — post-login: `window.location.replace(redirect)` only if `redirect` came
  from the validated `DQ`; otherwise `navigate(innerRedirect || '/')` (~4,778,031).
- `AQ(kind, Component)` — route guard. `private` + unauthenticated redirects via
  `S7e(window.location)` to `/login?innerRedirect=<encoded path+search>` when the
  pathname passes `Wpe`; otherwise `/login` (~4,783,334).
- `KC()` / `fme()` — same-origin paths go through React Router; only cross-origin
  `http(s)` URLs are opened externally (`window.open(...,'noopener,noreferrer')`).

No app-level `dangerouslySetInnerHTML`/`innerHTML` sinks with user data were found;
the 18 `dangerouslySetInnerHTML` hits are React/Radix/html-react-parser internals.
CSP blocks `eval`. `postMessage` targets are either the exact origin or a validated
ancestor origin.

---

## `/` (root)

- **Client-side:** `nRt` renders the account overview inside the authenticated
  layout. Unauthenticated visit redirects to `/login`.
- **Server-side:** no API call reachable before the auth redirect.
- **Completion:** fully tested (unauthenticated). Auth body blocked.
- **Verdict:** no issue.

## `/login`

- **Client-side:** `ZRt`; reads `login_hint` and uses it as the email form value
  (`BRt` defaultValues). `login_hint` is React-escaped into an `<input value>`;
  tested payload `<img src=x onerror=alert(1)>` stayed inert (no element created).
  Login state redirect fields are parsed by `DQ` (validated).
- **Server-side:** `POST https://sso.ui.com/api/sso/v1/login/email`
  `{user, return_to, remember_me}` → `200/400` JSON with
  `user_exists`, `enforce_idp`, `login_methods`, `login_type`.
  Nonexistent user → `400 {"user_exists":false,...}` (user-existence oracle; low).
  `POST /api/sso/v1/login` requires JSON and is CORS-restricted.
- **Completion:** fully tested (unauthenticated).
- **Verdict:** user enumeration (low, by design of the email-first flow); no XSS,
  no open redirect.

## `/login/mfa`

- **Client-side:** `Azt` requires `loginState.authenticators`; without state it
  redirects to `/login`. Reads `sessionTimeout` only from in-memory state.
- **Server-side:** `POST /api/sso/v1/login/2fa` only reachable with a valid login
  state (not obtainable unauthenticated).
- **Completion:** fully tested (unauthenticated guard).
- **Verdict:** no issue.

## `/login/trust-device`

- **Client-side:** `DGt = AQ('private', ...)`. Unauthenticated → `/login`.
- **Server-side:** trusted-device APIs require session.
- **Completion:** guard tested; authenticated body blocked.
- **Verdict:** no issue.

## `/login/create-passkey`

- **Client-side:** `sRt` WebAuthn add-passkey flow; gated by auth/passkey state.
- **Server-side:** passkey endpoints require session.
- **Completion:** guard tested; authenticated body blocked.
- **Verdict:** no issue.

## `/login/change-email`

- **Client-side:** `sot`; if `emailChangeable` is false it navigates to `/login`.
  Current email rendered from navigation state; new email/password are form fields.
- **Server-side:** `POST /api/sso/v1/legacy/user/self/email` requires session.
- **Completion:** fully tested (unauthenticated guard).
- **Verdict:** no issue.

## `/login/change-email/confirm`

- **Client-side:** `cot`; same `emailChangeable` guard; 6-digit OTP input; email from
  navigation state rendered as React text.
- **Server-side:** confirm endpoint requires session/OTP.
- **Completion:** fully tested (unauthenticated guard).
- **Verdict:** no issue.

## `/register`

- **Client-side:** `Zzt`; fields username/email/password/confirm/ToS/newsletter.
  Async availability checks call `checkUsername`/`checkEmail`. Submit calls
  `getReCaptchaToken(Jzt)` then `POST /api/sso/v2/users` with
  `{captcha, site_key, email, username, password, curr_privacy_rev, curr_terms_rev,
  newsletter:{announcements,unifi,uisp}}`.
- **Server-side:** `POST https://sso.ui.com/api/sso/v2/users` → HTTP 403
  `{"error_code":"CHALLENGE_RECAPTCHA_TOKEN_REQUIRED","error":"PERMISSION_DENIED"}`
  without a challenge token. Browser shows an active reCAPTCHA challenge iframe and
  keeps "Create Account" disabled. No account created; no email sent.
- **Completion:** fully tested (unauthenticated). Signup blocked by anti-automation.
- **Verdict:** no issue; account creation not possible without solving the challenge.

## `/verify`

- **Client-side:** `Qzt` requires navigation state `{email,id}`; otherwise navigates
  to `/login`. Email rendered as React text; 6-digit code input.
- **Server-side:** verification/resend endpoints require the state `id`.
- **Completion:** fully tested (unauthenticated guard).
- **Verdict:** no issue.

## `/verify/verification-code/:uuid`

- **Client-side:** `ftt` reads `uuid` from the path and on mount calls
  `X$.verifyRegistration(uuid)` → `PUT /api/sso/v1/verify/verification-code/{uuid}`,
  then navigates to `/login` (success toast) or error toast. `uuid` is not rendered.
- **Server-side:** unknown UUID (e.g. `00000000-0000-0000-0000-000000000000`) →
  HTTP 404 `{"detail":"No SSOUser matches the given query.","error":"ERROR"}`.
  The UUID is a secret emailed verification token; not guessable.
- **Completion:** fully tested (unauthenticated).
- **Verdict:** no issue (token-based; no IDOR without a valid token).

## `/reset-password`

- **Client-side:** `oBt`; email form; on submit `getReCaptchaToken(iBt)` then
  `POST /api/sso/v1/password/{email}` with `{user, site_key, captcha}`.
  Error `CHALLENGE_RECAPTCHA_TOKEN_REQUIRED` flips to a visible reCAPTCHA widget.
- **Server-side:** `POST /api/sso/v1/password/{email}` → HTTP 403
  `CHALLENGE_RECAPTCHA_TOKEN_REQUIRED` without a token. No email sent.
- **Completion:** fully tested (unauthenticated).
- **Verdict:** no issue; reCAPTCHA enforced. Password-reset host-header poisoning
  could not be tested because no reset email is issued without a token.

## `/reset-password/password-reset-uuid/:uuid`

- **Client-side:** `dBt` reads `uuid` from the path; submits `{uuid,newPassword}` via
  `PUT /api/sso/v1/verify/password/{uuid}`. Error handling only shows generic
  "link expired" UI; `uuid` is not rendered.
- **Server-side:** unknown UUID → HTTP 404 (HTML). No data returned.
- **Completion:** fully tested (unauthenticated).
- **Verdict:** no issue (secret token required).

## `/logout`

- **Client-side:** `uot = AQ('private', ...)`; unauthenticated → `/login`. When
  authenticated, `logout({url: window.location.href})` then `DQ` + `CQ` redirect
  (validated).
- **Server-side:** `POST /api/sso/v1/logout` with `{}`; requires session.
- **Completion:** guard tested; authenticated body blocked.
- **Verdict:** no issue.

## `/switch`

- **Client-side:** `wGt`; reads `redirect` and `login_hint`. `redirect` is kept only
  if `MC(redirect)` is true; otherwise dropped. If unauthenticated it navigates to
  `/login` carrying only the validated values. If authenticated as the hinted user
  it redirects to the validated `redirect`; if signed in as another user it offers
  logout/switch.
- **Server-side:** `POST /api/sso/v1/logout` on switch.
- **Completion:** fully tested (unauthenticated).
- **Tests:**
  - `/switch?redirect=https%3A%2F%2Fevil.example%2F` → `/login` (param dropped).
  - `/switch?redirect=https%3A%2F%2Funifi.ui.com%2F` → `/login?redirect=https%3A%2F%2Funifi.ui.com%2F`
    (allowed subdomain preserved).
- **Verdict:** open-redirect protection works; no issue.

## `/idp/login-result`

- **Client-side:** `mRt`; reads `code`, `state`, `error`, `description`.
  If `error` present → `K5` error UI; `description` is only sent to Sentry via
  `Na('IdP login-result error redirect', {extra:{description}})` and is **not**
  rendered. If `code` and `state` are present it calls
  `POST /api/sso/v1/idp/login-result` and then `window.location.replace(next)`.
- **Server-side:** `POST /api/sso/v1/idp/login-result`:
  - `{code:"test",state:"test"}` → 400 `{"error":"STATE_MISSING","detail":"Login state missing or malformed."}`
  - base64 JSON state + short code → 400 `CODE_MISSING`
  - base64 JSON state + 43-char code → 400 `{"error":"STATE_MISSING","detail":"Login state cookie not present."}`
  - `state` must match the `sso_idp_state` cookie; no `next` is returned without a
    valid state/cookie. The `next` redirect is server-controlled.
- **Completion:** fully tested (unauthenticated).
- **Tests:** `?error=access_denied&description=<img src=x onerror=alert(1)>` produced
  no element/visible payload (only the percent-encoded URL inside a Stripe iframe
  `src`). No DOM XSS.
- **Verdict:** no XSS; state is cookie-bound, so no open redirect via `next`.

## `/security`

- **Client-side:** `YHt = AQ('private', ...)`; unauthenticated → `/login`.
- **Server-side:** security/session APIs require session.
- **Completion:** guard tested; authenticated body blocked.
- **Verdict:** no issue.

## `/security/suspicious/confirm`

- **Client-side:** `cUt = AQ('public', ...)`; reads `token` and `decision`. Calls
  `POST /api/sso/v1/suspicious/confirm/inspect` with `{confirm_token}`; then
  `POST /api/sso/v1/suspicious/confirm` with `{confirm_token, decision}`. `token` is
  not rendered. `decision` must be `yes`/`no` to render action UIs.
- **Server-side:** bad token → HTTP 400
  `{"detail":"Invalid token","error_code":"invalid_token","error":"INVALID_CONFIRMATION_TOKEN"}`.
  `GET` → 405 with `allow: POST, OPTIONS`.
- **Completion:** fully tested (unauthenticated).
- **Verdict:** no issue (secret token; no injection).

## `/account`

- **Client-side:** `jpt = AQ('private', ...)`; unauthenticated → `/login?innerRedirect=%2Faccount`.
- **Server-side:** profile APIs require session.
- **Completion:** guard tested; authenticated body blocked.
- **Verdict:** no issue.

## `/profile`

- **Client-side:** redirects to `/account` (`jQ`), then the account guard sends to
  `/login`.
- **Server-side:** none reachable.
- **Completion:** fully tested (unauthenticated).
- **Verdict:** no issue.

## `/billing`, `/billing/:orgId`, `/payments`, `/payments/3ds`,
`/subscriptions`, `/subscriptions/:service`,
`/subscriptions/site-support/subscribe`,
`/subscriptions/cloud-storage/subscribe`, `/invoices`, `/invoices/:invoiceId`,
`/subscribe`, `/backups`, `/requests/:ticketId`, `/supportform`,
`/supportform-umr`, `/mysupport`

- **Client-side:** all are `AQ('private')` or inside the private layout; unauth
  visits redirect to `/login` (validated `innerRedirect` only for allowlisted
  paths). Shared redirect sink `r_t()` on `/payments/3ds` validates `return_url`
  with `MC` and otherwise forces `window.location.replace(window.location.origin)`.
- **Server-side:** `https://account.svc.ui.com/{zendesk/user,zendesk/tickets,
  zendesk/tickets/closed}` all return HTTP 401
  `{"code":"UNAUTHORIZED","message":"Failed to authorize request"}` unauthenticated.
- **Completion:** guard tested; authenticated bodies blocked.
- **Verdict:** no issue found unauthenticated; retest with a session.

## `/requests` and `/supportform-uisp`

- **Client-side:** redirect components (`jQ`) to the support route with state;
  unauthenticated ends at `/login`.
- **Server-side:** support APIs require session.
- **Completion:** guard tested; authenticated body blocked.
- **Verdict:** no issue.

## `/activate`

- **Client-side:** `IGt` immediately runs
  `window.location.replace('https://activate.ui.com')` (static constant `kGt.base`).
- **Server-side:** none.
- **Completion:** fully tested.
- **Verdict:** no issue (static, trusted destination).

## `/msp/idp/setup-result`

- **Client-side:** `jzt` reads `status`, `idpId`, `message` and, if `window.opener`
  exists, `window.opener.postMessage({type,status,idpId,message}, window.location.origin)`
  then closes; otherwise `window.location.replace('/#profile')`. Target origin is the
  exact current origin, so a cross-origin opener cannot receive the message.
- **Server-side:** none.
- **Completion:** fully tested.
- **Verdict:** no issue.

## `*` (wildcard)

- **Client-side:** renders the not-found component `yJ`.
- **Server-side:** none.
- **Completion:** fully tested.
- **Verdict:** no issue.
