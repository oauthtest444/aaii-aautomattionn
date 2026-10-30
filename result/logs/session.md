# Session Metadata

- Start time (UTC): 2026-10-30T06:09:27Z
- Run ID: 41012332097 (workflow_dispatch)
- Target state decision: reset (target input changed)
- Target: https://console.byteplus.com/finance/ (and sub-routes under `/finance/`)
- Agent/model: opencode / deepseek-v4.1-flash-free
- Environment: GitHub Actions Linux, headless Chrome, Chrome DevTools MCP (about:blank page available)
- Tool versions:
  - opencode: present at /home/runner/.opencode/bin/opencode
  - curl, git, node v22.23.4, npx, python3: present
  - Chrome: /usr/bin/google-chrome-stable (headless)

## Scope notes / operator instructions (from data/targets.txt)

- Test all sub-routes under `/finance/`.
- Keep the progress report updated after every route so another session can continue.
- Operator asked to create two test accounts and store credentials; `creds/test-account.txt`
  already contains two BytePlus console test logins. Attempted to use those first.
- Operator asked for a direct Discord webhook notification on confirmed findings.
  Conflict with AGENT.md Section 9/12: this run records findings in
  `result/confirmed-vuln.txt`; the CI workflow owns notifications. No unverified
  or speculative data is sent to the webhook. Documented, not followed.
- Operator states "their have one confirmed valid bug". Treated as a hint to
  look carefully; not as proof. No finding will be claimed without runtime evidence.

---

## Continuation session

- Resume time (UTC): 2026-10-30T06:34:00Z
- Run ID: 41014704909 (workflow_dispatch, decision=preserved)
- Resume state: prior run reached /finance/overview and /finance/bill/detail baseline;
  most routes pending. No testing-inventory.json or findings were preserved.
- MCP: chrome-devtools available (list_pages -> about:blank).
- Plan: log in with test account A, re-capture finance routes/APIs, build inventory,
  continue untested routes, checkpoint findings immediately.

## Return-URL validator analysis (2026-10-30)

- Two return-URL validators found:
  - `M` (module 55150, chunk 2607) - SAFE: same-origin check uses parsed `e.origin`; rejects backslash tricks; used by order-pay storage (`cm`/`qc`/`Rp`, chunk 7967 module 77523 imports `x=r(55150)`).
  - `v` (module 66659, chunk 4430) - FLAWED: `i=/^\/[^\/]/; i.test(A)` accepts `/\evil.com` because backslash is not `/`; URL parser normalizes `\` to `/`, so `new URL("/\\/evil.com", origin)` = `https://evil.com/`.
- `v` is used post-payment: `(0,di.OB)(decodeURIComponent(returnUrl)) && (location.href=returnUrl)` and `window.open(returnUrl)` in payment-success handlers (chunks 2693/4430/1309). Raw `returnUrl` prop = `Ua(...) || searchObj.returnUrl`, so query `return_url` reaches the flawed validator.
- Live tests:
  - `/finance/order/pay?orderNo=999999999999&return_url=%2F%5C%2Fevil.example&auto_return=true` -> "Failed to obtain order information"; no sessionStorage `_return_url` stored (safe `M` rejected value). No redirect.
  - `/finance/order?orderNo=...&return_url=...` -> route stripped query, order list.
  - login `/signin/login?redirectURI=%2F%5C%2Fevil.example` -> rewritten to `https://signin.byteplus.com/auth/login?redirectURI=https%3A%2F%2Fconsole.byteplus.com%2F%5C%2Fevil.example`; after login -> `console.byteplus.com/home` (origin-prefix neutralizes backslash; safe).
  - login `redirectURI=https://console.byteplus.com.evil.example/` -> after login -> `/home` (rejected; allowlist safe).
- Status: open-redirect candidate UNRESOLVED (sink requires successful payment / free order to reach). Not written to confirmed-vuln.txt.
