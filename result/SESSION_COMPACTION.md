# Session Compaction

Last updated: 2026-11-15T05:42:30Z
Target: `https://console.byteplus.com` (authorized top-level routes:
`/finance/overview`, `/workorder/list/`)
Target hash: `851361f8840b1efe993289fa5efa40d815c25b00e22682335fd394ab32253ba7`
Status: in progress (6th resume; account A cookie valid until 2026-11-15T06:00:21Z)

## Current target — 2026-11-15 session

- Latest run id: 43682036588 (schedule, 2026-11-15T05:40:52Z);
  target-state decision `preserved`.
- Task: enumerate/test all sub-routes of `/finance/overview` and
  `/workorder/list/`; scope-verify and test interesting related endpoints.
- Auth: Account A cached cookie works (validated GetProfileInfo HTTP 200 at
  05:41Z). Digest JWT expires 2026-11-15T06:00:21Z; re-login needed after.
  Account B has no cached cookie (unauthenticated).
- Cookie jar built at `/tmp/cj_a.txt` from `creds/auth-headers.txt`
  (helper `/tmp/mkjar.py`); CSRF in `/tmp/cj_a.txt.csrf`. Never echo secrets.
- Scope: `console.byteplus.com` authorized per `data/targets.txt` (private
  BBP), including in-scope subdomains after verification.
- Rate control: keep requests low; prior session hit "flow control limit".

## Finance sub-routes (SPA left nav, all under /finance/)

overview, bill/detail, bill/cost-analyse, order, renew, unsubscribe,
instance-manage, resource-package, saving-plan, coupon, pickup-coupon,
invoice-manage, contract-discount, contract, cost, export,
payment/transactions, payment/make-payment, payment/payment-methods,
busniess-finance/relation.

## Tested / results

- AccountID/PayerID/AccountId tampering on GetProfileInfo, GetRawProfileInfo,
  QueryCreditProtocolDetail, ListMonthlyBillOpen, GetQuotaAcctInfo,
  GetAccountActionSecurity, GetAccountLoginSecurity is ignored / session-scoped
  (not IDOR).
- 2026-11-15 validation: `GET /api/financial/const/getExpenseConfigForFE`
  -> 200 (cashier polling config only, low value).
- Findings: none confirmed yet.

## Pending / next

- Test remaining pending finance APIs for shape + IDOR/BAC/mass assignment
  (see `result/inventory/api-routes.md`).
- Enumerate `/workorder/list/` APIs and test ticket IDOR/BAC (tickets are
  high value); create only test-owned ticket if needed.
- Client-side source/sink pass per sub-route with exact skill regexes.
- Update inventories and this file after every step.

## Historical — prior completed run (2026-11-01)

Target: `https://console.byteplus.com` (authorized routes: `/datarangers`,
`/datatester`, `/ark`, `/ai`, `/alb`); target hash `03aef71f...`; status
completed (`SCAN_COMPLETE` written for that run). Confirmed low-impact read-only
cross-project IDOR `VULN-20261031-001` (DataFinder `common_settings`, benign
presentation settings only). No high-impact IDOR/BAC, XSS, or postMessage impact.
Unresolved: Ark managed-agent sub-routes not activated for test accounts.

## Authentication

- Test account A: AccountID `3000823185` (`test-user-123`).
- Test account B: AccountID `3001021825` (`testt456`).
- Secrets live only in `creds/auth-headers.txt`; never copy cookies/tokens here.

## Scope decisions

- `console.byteplus.com` authorized. Other `byteplus.com` subdomains are
  scope-unverified until verified; do not auto-exclude.

## Workflow closeout history

- 2026-11-01..2026-11-14: many scheduled/manual runs ended `failure`/`skipped`
  before completing the finance/workorder route set. Full per-run list was
  condensed here; agent-created sections above remain authoritative.

## Workflow closeout

- timestamp: 2026-11-15T05:53:41Z
- run_id: 43682036588
- event: schedule
- agent_outcome: failure
- workflow_status: failure
- note: Agent-created compaction is authoritative; this closeout records how the run ended.
