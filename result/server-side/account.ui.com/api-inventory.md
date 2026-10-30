# API Inventory and Probe Results — account.ui.com

The SPA at `https://account.ui.com` talks to several service hosts. Only the
endpoints required to exercise the account.ui.com routes were probed. Base URLs
are selected in the bundle as follows:

- `sso` = `https://sso.ui.com` when `location.host` matches `*.ui.com`, else
  `https://sso.ubnt.com` (bundle ~5014,300; ~760,000).
- `accountBE` = `https://account.svc.ui.com`
- `geo` = `https://geo.svc.ui.com`
- `msp` = `https://fabric.svc.ui.com`
- `storeBE` = `https://ecomm.svc.ui.com`

> Scope note: `sso.ui.com`/`account.svc.ui.com` are the backend services used by
> the in-scope `account.ui.com` application. They were exercised only to test the
> account.ui.com flows; no separate testing of unrelated endpoints on those hosts
> was performed.

All probes used `Origin: https://account.ui.com` and a normal desktop UA.

## Authentication / session

| Method | Path | Auth | Probe result |
|---|---|---|---|
| POST | `/api/sso/v1/login/email` | none | 400 `{"user_exists":false,"enforce_idp":false,"login_methods":[],"login_type":null}` for unknown user (user-existence oracle) |
| POST | `/api/sso/v1/login` | none | requires valid credentials; not testable without an account |
| POST | `/api/sso/v1/login/2fa` | none (login state) | requires valid MFA state |
| POST | `/api/sso/v1/idp/login-result` | none | 400 `STATE_MISSING`; state must match `sso_idp_state` cookie |
| POST | `/api/sso/v1/logout` | session | requires session |
| GET | `/api/sso/v1/user/self` | session | 401 when unauthenticated |
| GET | `/api/sso/v1/account-chooser` | none | 200 `{"accounts":[]}` |

## Registration / verification

| Method | Path | Auth | Probe result |
|---|---|---|---|
| POST | `/api/sso/v2/users` | none | 403 `{"error_code":"CHALLENGE_RECAPTCHA_TOKEN_REQUIRED","error":"PERMISSION_DENIED"}` |
| GET | `/api/sso/v1/search/username/{username}` | none | availability check (by design) |
| GET | `/api/sso/v1/search/email/{email}` | none | availability check (by design) |
| PUT | `/api/sso/v1/verify/verification-code/{uuid}` | none | unknown UUID → 404 `{"detail":"No SSOUser matches the given query.","error":"ERROR"}` |
| PUT | `/api/sso/v1/verify/email/{email}` or `/verify/userid/{username}` | none | resend verification (requires captcha) |
| POST | `/api/sso/v2/password-strength` | none | password strength check |
| POST | `/api/sso/v1/password-strength` | none | password strength check |

## Password reset

| Method | Path | Auth | Probe result |
|---|---|---|---|
| POST | `/api/sso/v1/password/{email}` | none | 403 `CHALLENGE_RECAPTCHA_TOKEN_REQUIRED` without token |
| PUT | `/api/sso/v1/verify/password/{uuid}` | none | unknown UUID → 404 (HTML) |

## Suspicious-login confirmation

| Method | Path | Auth | Probe result |
|---|---|---|---|
| POST | `/api/sso/v1/suspicious/confirm/inspect` | none | bad token → 400 `{"detail":"Invalid token","error_code":"invalid_token","error":"INVALID_CONFIRMATION_TOKEN"}` |
| POST | `/api/sso/v1/suspicious/confirm` | none | requires valid `confirm_token` + `decision` |

## Legal / geo / misc

| Method | Host | Path | Probe result |
|---|---|---|---|
| GET | sso.ui.com | `/api/sso/v1/legal` | 200 `{"rev_terms":"REV2013-01-18","rev_privacy":"REV2013-01-18","rev_terms_aircrm":"REV2015-05-19"}` |
| GET | geo.svc.ui.com | `/geo` | 200 geolocation JSON |
| POST | sso.ui.com | `/api/sso/v1/address/validator` | 400 `{"postal_code":["required"],"error":"VALIDATION_ERROR"}` (expects `postal_code`) |
| POST | sso.ui.com | `/api/sso/v1/passwordless/options` | 200 WebAuthn `publicKeyCredentialRequestOptions` for `{"user": <email>}` (challenge, `rpId: ui.com`, `allowCredentials: []`); second request → 429 `RATE_LIMITED` |
| POST | sso.ui.com | `/api/sso/v1/passwordless/login` | 400 `{"detail":"Invalid credential payload","error":"VALIDATION_ERROR"}` |
| GET | sso.ui.com | `/api/sso/v1/shopify_login` | GET-only (`POST` → 405); not called by the account.ui.com bundle |

## Account backend (`account.svc.ui.com`)

| Method | Path | Probe result |
|---|---|---|
| GET | `/zendesk/user` | 401 `{"code":"UNAUTHORIZED","message":"Failed to authorize request"}` |
| GET | `/zendesk/tickets` | 401 |
| GET | `/zendesk/tickets/closed` | 401 |
| GET | `/chat/messaging/jwt` | 404 |
| — | `/zendesk/ticket`, `/zendesk/tickets/ccd`, `/zendesk/search_tickets`, `/zendesk/search_ccd`, `/zendesk/comments`, `/zendesk/comment`, `/zendesk/ticket/{ticketId}/close` | require session |
| — | billing / organizations endpoints | require session |

## Additional unauthenticated probes

| Method | Host | Path | Probe result |
|---|---|---|---|
| POST | sso.ui.com | `/api/sso/v1/login/email` (type confusion) | array/object `user` → 400 `{"user":["Not a valid string."]}`; `' OR 1=1--` → normal `user_exists:false` (no injection) |
| POST | sso.ui.com | `/api/sso/v1/legacy/user/self/email/send` | 403 `{"detail":"Incorrect authentication credentials.","error":"AUTHENTICATION_FAILED"}` |
| POST | sso.ui.com | `/api/sso/v1/login/2fa` | 401 (login state required) |
| POST | sso.ui.com | `/api/sso/v1/suspicious/confirm` (empty) | 400 `{"confirm_token":["This field is required."],"decision":["This field is required."]}` |
| PUT | sso.ui.com | `/api/sso/v1/verify/email/{email}` | 400 requires `captcha` and `apple_devicecheck_token` |
| POST | sso.ui.com | `/api/sso/v1/user/{uuid}/roles/beta` | 401 (auth required) |
| POST | ecomm.svc.ui.com | `/graphql` | `{__typename}` → 200 `{"data":{"__typename":"Query"}}`; any field selection → 400 generic `INTERNAL_SERVER_ERROR` (introspection disabled/broken; no data leak) |
| GET | billing.svc.ui.com | `/api/v2/products`, `/api/v2/customers/self` | 401 `{"message":"Authorization is required...","metaData":{"code":8001},"data":["UBIC_AUTH"]}` |
| GET | fabric.svc.ui.com | `/api/fabrics/base/msp/v1/msp` | 401 `{"message":"Unauthorized"}` |

## CORS behavior

- `Access-Control-Allow-Origin` is returned only for `https://account.ui.com`
  (with `Access-Control-Allow-Credentials: true`).
- `Origin: https://evil.example` is **not** reflected (no ACAO header).
- Conclusion: no permissive CORS misconfiguration observed.

## Rate limiting / anti-automation

- `login/email`, `search/email`, `search/username` are usable unauthenticated and
  can be used for enumeration. No rate-limit headers were observed in the
  responses; however this was not stress-tested (no load/brute-force testing per
  AGENT.md §2).
- Registration and password reset are protected by reCAPTCHA Enterprise
  (`CHALLENGE_RECAPTCHA_TOKEN_REQUIRED`).

## Notes on exposed bundle configuration

The bundle contains several identifiers named `*_SECRET`/`*_KEY`. Tested/classified:

- `GOOGLE_RECAPTCHA_SECRET_SCORE` (`6LfGZXoj...`) and
  `GOOGLE_RECAPTCHA_SECRET_CHALLENGE` (`6LdWhNgl...`) are used by the client as
  reCAPTCHA **site keys** (`grecaptcha.enterprise` render/execute and as the
  `site_key` field), i.e. public by design despite the name.
- `GOOGLE_RECAPTCHA_SECRET_HIGH_RISK_TEST` / `MEDIUM_RISK_TEST` are unused config
  constants (test keys); they are not referenced anywhere else in the bundle.
- `GOOGLE_MAPS_SECRET` (`AIzaSyBE3JpOF9gNSsb83dpZKLUqFkmBAsPr0-w`) is referer-
  restricted: Geocoding/Places calls return `REQUEST_DENIED` ("API keys with
  referer restrictions cannot be used with this API").
- `STRIPE_PUBLISHABLE_KEYS` (`pk_live_*`), `TAPPAY_PUBLISHABLE_KEYS.appKey`,
  `IRONCLAD_*` accessId/groupKey, `SEND_SAFELY_DZ_ID`, `ZENDESK_FALLBACK_FORM_KEY`,
  `GOOGLE_ANALYTICS_KEY` are publishable/embed identifiers by design.

No usable secret was found.
