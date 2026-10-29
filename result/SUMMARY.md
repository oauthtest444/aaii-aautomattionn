# Summary — console.byteplus.com route-list assessment

- Run start: 2026-10-29T10:16:12Z
- Last update: 2026-10-29T12:21:00Z (~125 minutes elapsed)
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

---

# Workorder-only Run — 2026-10-29T11:39:08Z

- Target (current `data/targets.txt`): `https://console.byteplus.com/workorder/list/`
  and same-origin `/workorder/...` sub-routes.
- Run ID: `40866925694`; accounts A (`3000823185`) and B (`3001021825`).
- Result: **no notification-worthy vulnerability confirmed.**

## Additional coverage

- `/workorder/authorizationList` — route loads; `ListAuthorization` is empty for
  account A, so authorization-object IDOR/BAC was not testable.
- `/workorder/create` — product/flow, form-token, and console-config APIs
  captured; `GetAccountMaskedSecurityContact` cross-account lookup confirmed.
- `CreateTicketConversation` accepts arbitrary `Attachment[].Name/Url`; stored
  URL is rendered through image/download/preview components. The download helper
  rejects `javascript:`, `vbscript:`, `data:`, and `file:`; no script execution
  was achieved.
- New helper endpoints tested: `Tcc`, `getWorkorderConsoleConfig`,
  `getWotkorderFinanceProduct`, `getFormTokenAndCodeList`,
  `ListAccountLabelsByKeys`, `GetUserMaskedSecurityContact`.

## Confirmed but Excluded (this run)

- **VULN-20261029-002** — `GetAccountMaskedSecurityContact` trusts a
  caller-supplied `AccountID`, returning another account's masked security
  email/phone and verification flags. Low impact; excluded as masked-contact /
  account-existence disclosure per Section 9.
  Report: `result/findings/VULN-20261029-002/report.md`.
- `GetUserMaskedSecurityContact` accepts an arbitrary numeric `UserId` and
  returns a distinguishable `UserSecurityContactNotExist` response. Masked /
  informational; excluded.

## Unresolved (this run)

- Authorization-object IDOR: account A has no authorization objects.
- Support-console rendering: internal agent UI is not reachable.
- SSRF via `SourceURL` / `CustomerReferURL`: origin-prefixed and internal
  targets were not authorized.
- Full upload MIME allow-list: observed HTML/SVG/PDF rejection and text/plain
  acceptance; complete extraction timed out on the minified bundle.

## Workorder Continuation — 2026-10-29T12:10–12:21Z

- Run ID `40870959426`; target hash preserved; no new high-impact finding.
- Cross-account file access: A `SaveFile`/`DownloadFile` against B-owned FileID
  `01a18797-49d5-78c4-98df-67933798659e` → `Forbidden`.
- Cross-account ticket actions: `HandleTicket`,
  `ListTicketExecutableActionForUser`, and `HandleTicketForUser` against B's
  ticket → `Forbidden`.
- Same-account `HandleTicket` accepted `close` and also `confirm` on a
  `handling` ticket although only `close`/`urge` were advertised. This is a
  business-logic inconsistency on the caller's own ticket; no cross-tenant
  impact, so not notification-worthy.
- CSRF: `x-csrf-token` is required and validated; missing/wrong token returns
  `InvalidCSRFToken`.
- Authorization lists remain empty for both A and B, so authorization-object
  IDOR/BAC remains untestable.

## Workorder Continuation — 2026-10-29T12:36–12:41Z

- Run ID `40874496014`; target hash preserved; no new high-impact finding.
- Re-analyzed the create page after full JS load: `602.cd729511.js`,
  `759.5cad7c3e.js`, `770.37d57eb6.js`, and `TicketCreate.22cfeac3.js`.
- The live create page issued only already-tested helper calls:
  `GetAccountMaskedSecurityContact`, `Tcc`, `ListAllFlow`, and
  `getWorkorderConsoleConfig`.
- The inactive ticket-engine paths in `770` returned 404 with empty read-only
  bodies: `/ticket/api/v2/core/GetTicketCreateOperation`,
  `/ticket/api/v1/query/template`, and `/ticket/api/v1/tag/app/bind/list`.
  No tenant/access-party parameters were sent.
- `CreateTicket` body fields are `FlowID`, `SRTypeId`, `FormContent`,
  `PlatformFormContent`, `CreateOrigin`, optional `NotificationMethods`, and
  `CustomerReferURL` (origin-prefixed; SSRF remains untested by rule).
- No new endpoint or notification-worthy issue found.
