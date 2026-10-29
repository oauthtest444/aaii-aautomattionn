# Summary — console.byteplus.com route-list assessment

- Run start: 2026-10-29T10:16:12Z
- Last update: 2026-10-29T11:22:00Z (~66 minutes elapsed)
- Runs: 40856058415 → 40859611597 → 40862670676 (preserved target hash)
- Agent/model: opencode / opencode/deepseek-v4.1-flash-free
- Environment: GitHub Actions runner, headless Google Chrome 156 / DevTools MCP
  at 127.0.0.1:9222
- Authorization: `data/targets.txt` (URL-list rooted at
  `https://console.byteplus.com`); six listed top-level routes and their
  same-origin sub-routes/APIs only.
- Test accounts (disposable, published in `creds/`):
  A = account 3000823185 (`test-user-123`), B = account 3001021825
  (`testt456`).

## Scope / tested surface

| Route | Result |
|---|---|
| `/waf/overview` | **Unresolved** — SPA shell loads but client redirects to `/iam/service/attach_role/?ServiceName=waf`; test account has no WAF service role. Authorizing is a state change; not performed. |
| `/finance` (+ `/finance/overview`, `/finance/bill`) | **Tested** — both test accounts are $0.00 with no bill/order/invoice/coupon objects. `PayerID` is session-scoped (A using B's PayerID returns an empty list). |
| `/user` | **Tested** — profile fields are React-escaped. `UpdateAccount` is UI-gated by a 7-day name lock; cross-account `AccountId` tampering was not attempted because it would rename/lock the disposable test account. |
| `/beian` | **Not vulnerable** — server returns HTTP 404 for both test accounts; route is not provisioned. |
| `/message` (+ `innermsg`, `innermsg/detail`, sub-route list) | **Tested** — message detail puts server-generated `Content` through DOMPurify 2.5.9 before `iframe#external-frame` `srcDoc`. `GetInMailInfo` is scoped by session AccountId (A requesting B's `ID=34886574` → "站内信不存在"). postMessage origin checks are strict. |
| `/workorder/list/` (+ detail/create) | **Tested** — ticket Content is server-sanitized on write (strips `on*`, `javascript:` hrefs, `iframe srcdoc`) and rendered via markdown/DOMPurify 2.5.9; stored XSS probes were inert. Cross-account ticket read/write (B against A's `I-2026102917080001`) is blocked. `UpdateTicket` extra fields are ignored. |
| `/auth/login/` (flow used by all routes) | **Tested — confirmed open redirect** (below). |

Supporting JS analyzed: vconsole-auth `main.adbc4e5a.js`; console-user-mono
`main.4ec0f485.js` / `Basics.bfbeee6d.js`; bp-vconsole-message
`main.5bc4931c.js` / `message_innermsg.f9a63668.js` / `853.6ebc1a89.js`;
workorder-web `main.7d5d0431.js` / `609.9d2bee7c.js` / `499.b80931e8.js`.

## Confirmed findings

### VULN-20261029-001 — Open redirect via auth `redirectURI` control-character bypass

- Asset: `https://console.byteplus.com/auth/login/`
- Severity: Medium
- Auth: unauthenticated link; automatic for an already-authenticated victim
- Payload: `redirectURI=/%09/evil.com/` (decoded `/\t/evil.com/`); `/%0a/host`
  also works.
- Impact: after login — or immediately for an authenticated visitor — the
  top-level document navigates to `https://evil.com/` from the trusted console
  origin. Enables credible phishing and generic open-redirect abuse.
- `javascript:` escalation was tested (plain and `java%09script:`) and is
  **not** achievable (HTTP 403 console error page, no execution).
- Evidence/report: `result/findings/VULN-20261029-001/` (`report.md`,
  `evidence/observation.md`, `payloads/redirect-uri.txt`).
- `confirmed-vuln.txt`: **excluded** — AGENT.md Section 9 requires an open
  redirect to allow a dangerous `javascript:` URL; this one only reaches
  `https://` origins.

## Unresolved

- `/waf/overview` — requires attaching the WAF service role
  (`ServiceRoleForWaf`) to the test account. Not performed (state change /
  authorization the operator did not grant).
- `/finance` object-level IDOR/BAC — not testable end-to-end because neither
  test account owns bills, orders, invoices, contracts, or coupons (all $0.00).
- `/user` cross-account account-name/identity manipulation — deliberately not
  attempted: renaming/locking another test account would break the shared
  disposable credentials and is destructive.
- `/beian` — not provisioned for these accounts (404), so no surface to test.

## Out of scope

- Any `byteplus.com` subdomain other than `console.byteplus.com` (e.g. IAM,
  regional consoles), third-party CDNs/analytics, partner systems, and the
  `vakaspajjjce.byteplus.com` app referenced in the notes archive.

## Notification decision

`result/confirmed-vuln.txt` intentionally contains **no entries**. The only
confirmed issue is a plain (non-`javascript:`) open redirect, which Section 9
excludes. It is documented as a full finding with evidence and an explicit
exclusion statement in the report.

## Definition-of-done check

- Scope and operator instructions documented: `result/scope.md`. ✔
- Client-side coverage of the six routes and their sub-routes: done or blocked
  with reason (above). ✔
- Server-side coverage of discovered endpoints: done; negatives recorded in
  `result/inventory/endpoints.md`, `result/logs/server-side.log`,
  `result/testing-inventory.json`. ✔
- Confirmed finding has report + evidence + explicit exclusion. ✔
- `result/confirmed-vuln.txt` contains only high-impact entries (none). ✔
- Unresolved/out-of-scope items documented (this file). ✔
- No real-user data or temporary files under `result/`. ✔
