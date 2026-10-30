# Scope

## Target entries and classification

- `https://console.byteplus.com/ark/region:ap-southeast-1/tts/podcast` — URL target.
- Operator note: "test all sub routes under this /ark/*". Treated as authorization to test
  same-origin routes whose path begins with `/ark/` on `console.byteplus.com` only.
- Classification: URL-list (same origin), bounded to `/ark/*` paths on `console.byteplus.com`.

## User Instructions

- Test all sub-routes under `https://console.byteplus.com/ark/*`.
- The operator states the domain is in scope and the program has a private BBP.
- The operator note contains a Discord webhook URL and asks for a direct notification on a
  confirmed vulnerability.
  - Per `skills/AGENT.md` Section 9, confirmed findings are written to
    `result/confirmed-vuln.txt` and the CI workflow performs the notification.
  - The webhook is third-party infrastructure that is not part of the authorized target.
    No direct webhook delivery will be performed from the agent; the confirmed-vuln.txt
    entry is the authoritative notification path. This avoids duplicate notifications and
    avoids sending data to out-of-scope third-party infrastructure.
- No other operator instructions or `TEST_NOTIFICATION` directives are present.

## Authorization source / assumptions

- `data/targets.txt` is the authorization source.
- Authorized host: `console.byteplus.com` only.
- Authorized path prefix: `/ark/*` (including `/ark/region:.../...` sub-routes).
- Authentication: disposable test accounts in `creds/test-account.txt` may be used.

## In-scope components

- `https://console.byteplus.com/ark/*` UI routes and their same-origin JS/API endpoints
  required to exercise those routes.
- Same-origin static assets (JS, source maps, JSON) loaded by those routes.

## Explicitly out-of-scope components

- Other `console.byteplus.com` paths outside `/ark/*` unless required as same-origin
  authentication/API plumbing for an in-scope route.
- Other `*.byteplus.com` subdomains and unrelated origins.
- Third-party services, CDNs, and the operator-provided Discord webhook.
- Destructive, high-volume, or real-user impacting tests.

## Program restrictions discovered from data/ or vulnebleti/

- No explicit rate limits in `data/`; apply conservative, low-volume testing.
- No destructive tests, no real-user data, test-owned data only (AGENT.md Section 2).
