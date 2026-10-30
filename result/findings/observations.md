# Observations (low / informational) — account.ui.com

These are **not** confirmed reportable vulnerabilities under the allowed classes
(XSS, CSTI, IDOR/BAC, open redirect). They are recorded for completeness and for
the next session.

## 1. User-existence oracle on the login and availability endpoints

- `POST https://sso.ui.com/api/sso/v1/login/email` with `{"user":"..."}` returns
  `user_exists:true/false` (HTTP 400 for a non-existent user, with
  `{"user_exists":false,"enforce_idp":false,"login_methods":[],"login_type":null}`).
- `GET /api/sso/v1/search/email/{email}` and
  `GET /api/sso/v1/search/username/{username}` are also unauthenticated
  availability checks.
- **Impact:** account/username enumeration. This is inherent to the email-first
  login and registration UX; low severity. No rate-limit headers were observed,
  but no brute-force/load testing was performed (per AGENT.md §2).
- **Status:** by design / informational.

## 2. reCAPTCHA identifiers in the client bundle

- `GOOGLE_RECAPTCHA_SECRET_SCORE` = `6LfGZXoj...` and
  `GOOGLE_RECAPTCHA_SECRET_CHALLENGE` = `6LdWhNgl...` are used client-side as
  reCAPTCHA **site keys** (`grecaptcha.enterprise` + `site_key` in requests).
  They are public by design despite the `_SECRET` name.
- `GOOGLE_RECAPTCHA_SECRET_HIGH_RISK_TEST` (`6LdaPy4j...`) and
  `GOOGLE_RECAPTCHA_SECRET_MEDIUM_RISK_TEST` (`6LfKMy4j...`) are unused config
  constants (test keys). They are not referenced elsewhere in the bundle.
- **Impact:** none demonstrated. Misleading naming only.

## 3. Google Maps API key is referer-restricted

- `GOOGLE_MAPS_SECRET` = `AIzaSyBE3JpOF9gNSsb83dpZKLUqFkmBAsPr0-w`.
- Geocoding and Places calls return `REQUEST_DENIED`:
  `"API keys with referer restrictions cannot be used with this API."`
- **Impact:** not usable from an arbitrary origin; public client-side key by design.

## 4. Attacker-controlled `description` sent to Sentry on `/idp/login-result`

- `/idp/login-result?error=...&description=...` passes `description` to
  `Na('IdP login-result error redirect', {level:'error', tags:{idp_error_code:...},
  extra:{description}})` (bundle ~6,439,271).
- The value is **not** rendered into the DOM (verified: an `<img onerror>` payload
  produced no element and no visible text), so this is not XSS. It is only a
  log/telemetry injection vector into Sentry.
- **Impact:** informational.

## 5. Signup / password-reset anti-automation

- `POST /api/sso/v2/users` and `POST /api/sso/v1/password/{email}` return
  `403 CHALLENGE_RECAPTCHA_TOKEN_REQUIRED` without a valid token.
- In a real browser the register page shows an active reCAPTCHA challenge iframe
  and the submit button stays disabled.
- **Impact:** legitimate test-account creation is not possible without a human
  solving the challenge. No bypass was attempted. Testing is limited to
  unauthenticated endpoints.

## 6. Verified-safe behaviors (for the record)

- `redirect`/`innerRedirect` are validated by `MC`/`Wpe` before any navigation;
  `https://evil.example` is dropped while `https://unifi.ui.com` is preserved.
- `/idp/login-result` `state` is bound to the `sso_idp_state` cookie; without the
  cookie the API returns `STATE_MISSING` and no `next` URL.
- `/msp/idp/setup-result` posts to `window.location.origin`, not `*`.
- Embedded-mode `postMessage` target origin is `*` only outside production
  (`Vw.Prod !== 'prd'`); production returns the validated ancestor origin.
- `login_hint` is escaped into an `<input value>`; no HTML injection.
- CSP blocks `eval`; no app-level raw-HTML sinks with user data.

## Discord notification

No confirmed impactful vulnerability was found, so no Discord notification was
sent and `result/confirmed-vuln.txt` was not modified.
