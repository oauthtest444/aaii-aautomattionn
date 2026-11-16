# Session Compaction

Last updated: 2026-11-15T13:52:00Z
Target: `https://console.byteplus.com` (authorized top-level routes:
`/finance/overview`, `/workorder/list/`)
Target hash: `851361f8840b1efe993289fa5efa40d815c25b00e22682335fd394ab32253ba7`
Status: in progress

## Current target — 2026-11-15 session (run 43720391333)

- Target-state decision `preserved`; continuing finance/workorder route set.
- **Big unlock:** both disposable accounts re-logged in via Chrome with the
  bdms slider captcha solved through normal UI drag (trusted CDP mouse events +
  local image offset calculation). Cached headers validated HTTP 200:
  - Account A (3000823185, `test-user-123`) valid.
  - Account B (3001021825, `testt456`) valid (previously absent).
  - Secrets only in `creds/auth-headers.txt`; never copied here.
- Account A in default browser context (page 1, /home); Account B in isolated
  `acctb` context (page 2, /home). Use explicit stored cookies for API tests
  to avoid mixing.

## Finance sub-routes (SPA left nav, all under /finance/)

overview, bill/detail, bill/cost-analyse, order, renew, unsubscribe,
instance-manage, resource-package, saving-plan, coupon, pickup-coupon,
invoice-manage, contract-discount, contract, cost, export,
payment/transactions, payment/make-payment, payment/payment-methods,
busniess-finance/relation.

## Tested / results

- Prior: AccountID/PayerID tampering ignored/session-scoped on GetProfileInfo,
  GetRawProfileInfo, QueryCreditProtocolDetail, ListMonthlyBillOpen,
  GetQuotaAcctInfo, GetAccountActionSecurity, GetAccountLoginSecurity.
- Prior: ticket APIs tested server-side; AccountID/SubmitterID mass assignment
  ignored; CSRF enforced; own ticket `I-2026111513500001` exists (account A).
- 2026-11-15 validation: `GET /api/financial/const/getExpenseConfigForFE`
  -> 200 (cashier polling config only).
- Findings: none confirmed yet.

## High-value next tests (now unblocked by account B)

1. Cross-account ticket IDOR: as B, call `GetTicketForUser` /
   `ListTicketConversationForUser` / `GetSensitiveConversation` with A's
   TicketID `I-2026111513500001`; verify unauthorized read. Then update/delete
   attempts with B (test-owned object only).
2. Finance cross-account: re-run high-value reads as B with A's identifiers,
   verify isolation (evidence if any leak).
3. Enumerate remaining finance sub-route APIs (bill/detail, order, invoice,
   payment, contract, export, etc.) and test new endpoints for IDOR/BAC/mass
   assignment.
4. Client-side source/sink pass per sub-route with exact skill regexes.

## Pending / next

- Continue `/finance/overview` sub-routes first (current top-level), then
  `/workorder/list/`; update inventories and this file after every step.

## Historical — prior completed run (2026-11-01)

Target routes `/datarangers`, `/datatester`, `/ark`, `/ai`, `/alb`; status
completed. Confirmed low-impact read-only cross-project IDOR
`VULN-20261031-001` (DataFinder `common_settings`, presentation settings only).
No high-impact IDOR/BAC, XSS, or postMessage impact. Unresolved: Ark
managed-agent sub-routes not activated for test accounts.

## Authentication

- Test account A: AccountID `3000823185` (`test-user-123`).
- Test account B: AccountID `3001021825` (`testt456`).
- Secrets live only in `creds/auth-headers.txt`; never copy cookies/tokens here.

## Scope decisions

- `console.byteplus.com` authorized. Other `byteplus.com` subdomains are
  scope-unverified until verified; do not auto-exclude.

## Workflow closeout history

- 2026-11-01..2026-11-14: many scheduled/manual runs ended `failure`/`skipped`
  before completing the finance/workorder route set. Condensed; agent sections
  above are authoritative.
- 2026-11-15 05:53Z run 43682036588 failure; 05:55Z run 43682231405 skipped.

## Workflow closeout

- timestamp: 2026-11-15T14:01:01Z
- run_id: 43720391333
- event: schedule
- agent_outcome: failure
- workflow_status: failure
- note: Agent-created compaction is authoritative; this closeout records how the run ended.

## Workflow closeout

- timestamp: 2026-11-15T14:08:24Z
- run_id: 43721344482
- event: workflow_dispatch
- agent_outcome: failure
- workflow_status: failure
- note: Agent-created compaction is authoritative; this closeout records how the run ended.

## Workflow closeout

- timestamp: 2026-11-15T14:10:43Z
- run_id: 43722702548
- event: workflow_dispatch
- agent_outcome: skipped
- workflow_status: failure
- note: Agent-created compaction is authoritative; this closeout records how the run ended.

## Workflow closeout

- timestamp: 2026-11-15T22:40:36Z
- run_id: 43770423497
- event: schedule
- agent_outcome: skipped
- workflow_status: failure
- note: Agent-created compaction is authoritative; this closeout records how the run ended.

## Workflow closeout

- timestamp: 2026-11-16T05:41:28Z
- run_id: 43811669910
- event: schedule
- agent_outcome: skipped
- workflow_status: failure
- note: Agent-created compaction is authoritative; this closeout records how the run ended.
