# Scan Summary

Target: `https://console.byteplus.com`
Authorized top-level routes (from `data/targets.txt`):
- `https://console.byteplus.com/finance/overview`
- `https://console.byteplus.com/workorder/list/`

Scope: `console.byteplus.com` and in-scope subdomains of the authorized
BytePlus private bug bounty program. Related hosts are recorded and
scope-verified before testing; ambiguous hosts are marked `Scope Unverified`.

Status: completed.

Coverage:
- Finance top-level route: 19 sub-routes enumerated and visited.
- Workorder top-level route: 5 sub-routes enumerated and visited.
- API inventory: 87 endpoints/discovered actions, all completed or documented
  unresolved in `result/inventory/api-routes.md`.
- Server-side cross-account testing with accounts A and B: no IDOR/BOLA, BAC,
  tenant isolation break, PII leak, CSRF bypass, or persisted mass-assignment
  impact confirmed.
- Client-side exact source/sink regex pass: no user-controlled source reaches
  an XSS/navigation sink; postMessage listeners enforce same-origin or only
  toggle chat UI.

Findings: none confirmed for this run. `result/confirmed-vuln.txt` unchanged.

Documented unresolved: payment/budget/invoice/contract write-only flows that
require test data, a real payment instrument, or captcha; no destructive or
financial actions were performed.

Assumptions:
- Test accounts from `creds/test-account.txt` are authorized.
- No destructive, high-volume, or real-user-impacting testing.

Artifacts:
- `result/inventory/top-level-routes.md`
- `result/inventory/api-routes.md`
- `result/server-side/console.byteplus.com/route-report.md`
- `result/client-side/console.byteplus.com/<route>/route-report.md`
- `result/SESSION_COMPACTION.md`
