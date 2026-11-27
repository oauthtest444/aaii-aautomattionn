# Session Compaction

Last updated: 2026-11-17T02:00:00Z
Target: `https://console.byteplus.com` (authorized top-level routes:
`/finance/overview`, `/workorder/list/`)
Target hash: `851361f8840b1efe993289fa5efa40d815c25b00e22682335fd394ab32253ba7`
Status: completed (finance + workorder route sets)

## Current target — 2026-11-17 session (run 43997894332)

- Target-state decision `preserved`; continued finance/workorder route set.
- Both disposable accounts validated HTTP 200 against
  `GetProfileInfo`:
  - Account A (3000823185, `test-user-123`) valid.
  - Account B (3001021825, `testt456`) valid.
- Cached cookies re-injected into the Chrome session through CDP
  `Network.setCookie`; MCP browser authenticated as A for route crawling.
- Secrets only in `creds/auth-headers.txt`; never copied here.

## Discovery — all authorized top-level routes and sub-routes

Finance SPA sub-routes (19, all enumerated and visited): overview,
bill/detail, bill/cost-analyse, order, renew, unsubscribe, instance-manage,
resource-package, saving-plan, coupon, pickup-coupon, invoice-manage,
contract-discount, contract, cost, export, payment/transactions,
payment/make-payment, payment/payment-methods, busniess-finance/relation.

Workorder sub-routes (5): `/workorder/list/`, `/workorder/list/detail`,
`/workorder/create`, `/ticket/myTicket` (404 – not deployed),
`/workorder/authorizationList`.

## New APIs captured this session

Finance: ListSubscribeRecords, GetFilterInfoForBillDetail,
ListPayerAndOwnerByBillOwnerID, ListBcProductSummaryOpen, ListOrder,
ListSubjectCodeForInstance, ListRenewSettings, ListInvoiceBPV2,
ListInvoiceMakerInfoBP, ListProfileCountry, GetTaxID, ListEmailForAccount,
GetCountryAreaCfgByAccountID, volc_contract_process `List`,
ListBalanceTransactionForPage, ListCoupon, ResourcePackageListSelector,
ListSavingPlanSelectorConsoleAPI/GetSavingAmountSummaryConsoleAPI/
ListSavingPlanConsoleAPI, ListInstanceForConsole, GetAccountExpirationAlert,
ListInstanceConfigTimeline, BatchGetInstanceOpsCapability, ListSubscribe,
ListBudget, QueryBudgetActiveInfo, ListRedeemCodes, ListPickupVouchers,
QueryContractDiscountDisclaimer, ContractDiscountTableList,
QueryContractDiscount, GetServiceSigningRecord, QuerySubscribeCostAnalysis,
QueryAmortizedCostBillUser, GetFilterInfoForCostAnalysis.

Workorder/console: ListAuthorization (POST), IAM ListUsers, IAM ListRoles,
GetTicketCount, GetAccountMaskedSecurityContact, `/api/workorder/ticket/Tcc`,
`/api/workorder/ticket/getWorkorderConsoleConfig`.

## Tested / results (cross-account, account B with account A identifiers)

- Ticket IDOR: B `GetTicketForUser`, `ListTicketConversationForUser` with A
  ticket `I-2026111513500001` -> `Forbidden`. `GetSensitiveConversation` with
  A ConversationID -> `NotFound`. Isolated.
- Finance IDOR probes with A PayerID/AccountID/BillOwnerID/UserID rejected,
  empty, or session-scoped: ListMonthlyBillOpen, ListBcProductSummaryOpen,
  GetFilterInfoForBillDetail, ListPayerAndOwnerByBillOwnerID, ListOrder,
  ListInvoiceBPV2, GetTaxID (returns caller's own tax), ListEmailForAccount
  (authorization error `无财务管理-发票授权`), ListBalanceTransactionForPage,
  ListCoupon, volc_contract_process List, ListAuthorization, IAM ListUsers,
  IAM ListRoles, GetTicketCount.
- All observations returned own-scope/empty data; no cross-account leak.
- IAM ListUsers/ListRoles require `X-CSRF-Token` even for GET.
- CSRF: POST endpoints still require `X-CSRF-Token`; no bypass observed.

## Client-side pass

- Exact skill source/sink regexes applied to finance main bundle and all
  workorder-web app bundles (identical content deduped).
- Matched sources are URLSearchParams keys (`hiddenNavbar`, `sessionID`,
  `step`, `SubProductID`, `FlowKey`, `ref`, `tab`) feeding state/API params.
- Matched sinks: namespace-safe `location.replace` with `secureDomains` +
  protocol allowlist; `document.createElement('script')` for config-driven
  loader; `textarea.innerHTML = JSON.stringify(config)`; React internal
  `innerHTML` for JSON. No user-controlled source reaches an XSS sink.
- 4 window `message` listeners: workorder/navbar validate exact same-origin;
  livechat checks only `data.id === "tinet-chat-web"` and only toggles chat UI.
  No sensitive action or sink.
- No confirmed client-side finding.

## Findings

- None confirmed this run. `result/confirmed-vuln.txt` unchanged.
- Prior historical finding `VULN-20261031-001` (DataFinder presentation
  settings IDOR) remains historical only.

## Pending / unresolved

- Finance write-only flows (AddPaymentMethod, budget create/update, ticket
  write actions beyond the existing test ticket) not exercised: test accounts
  have no bill/instance/invoice/contract data and several flows require
  captcha or real payment instruments. Documented in server-side report.
- `/workorder/list/detail` requires a live ticket ID; covered by the tested
  ticket APIs.

## Scope decisions

- `console.byteplus.com` authorized. No other `byteplus.com` subdomain was
  found to host an interesting reachable test surface during this run; any
  future host must be scope-verified before testing, never auto-excluded.

## Historical — prior completed run (2026-11-01) and prior sessions

- Confirmed low-impact read-only cross-project IDOR `VULN-20261031-001`
  (DataFinder `common_settings`, presentation settings only).
- 2026-11-15: account re-login, overview and ticket API testing; no confirmed
  finance/ticket finding. Many scheduled runs ended failure/skipped before
  completing the route set (see `result/logs/target-state.txt`).

## Workflow closeout

- timestamp: 2026-11-17T01:59:10Z
- run_id: 43997894332
- event: schedule
- agent_outcome: success
- workflow_status: success
- note: Agent-created compaction is authoritative; this closeout records how the run ended.

## Workflow closeout

- timestamp: 2026-11-17T02:00:47Z
- run_id: 43998420704
- event: workflow_dispatch
- agent_outcome: success
- workflow_status: success
- note: Agent-created compaction is authoritative; this closeout records how the run ended.

## Workflow closeout

- timestamp: 2026-11-17T15:45:17Z
- run_id: 44117560906
- event: schedule
- agent_outcome: skipped
- workflow_status: failure
- note: Agent-created compaction is authoritative; this closeout records how the run ended.

## Workflow closeout

- timestamp: 2026-11-18T00:47:27Z
- run_id: 44210537009
- event: schedule
- agent_outcome: success
- workflow_status: success
- note: Agent-created compaction is authoritative; this closeout records how the run ended.

## Workflow closeout

- timestamp: 2026-11-18T15:25:10Z
- run_id: 44335010435
- event: schedule
- agent_outcome: skipped
- workflow_status: failure
- note: Agent-created compaction is authoritative; this closeout records how the run ended.

## Workflow closeout

- timestamp: 2026-11-19T00:05:31Z
- run_id: 44425907024
- event: schedule
- agent_outcome: skipped
- workflow_status: failure
- note: Agent-created compaction is authoritative; this closeout records how the run ended.

## Workflow closeout

- timestamp: 2026-11-19T15:30:10Z
- run_id: 44555252580
- event: schedule
- agent_outcome: success
- workflow_status: success
- note: Agent-created compaction is authoritative; this closeout records how the run ended.

## Workflow closeout

- timestamp: 2026-11-20T00:27:51Z
- run_id: 44645889169
- event: schedule
- agent_outcome: success
- workflow_status: success
- note: Agent-created compaction is authoritative; this closeout records how the run ended.

## Workflow closeout

- timestamp: 2026-11-20T15:08:10Z
- run_id: 44759987021
- event: schedule
- agent_outcome: success
- workflow_status: success
- note: Agent-created compaction is authoritative; this closeout records how the run ended.

## Workflow closeout

- timestamp: 2026-11-20T23:50:32Z
- run_id: 44839575734
- event: schedule
- agent_outcome: success
- workflow_status: success
- note: Agent-created compaction is authoritative; this closeout records how the run ended.

## Workflow closeout

- timestamp: 2026-11-21T06:24:01Z
- run_id: 44875204306
- event: schedule
- agent_outcome: skipped
- workflow_status: failure
- note: Agent-created compaction is authoritative; this closeout records how the run ended.

## Workflow closeout

- timestamp: 2026-11-21T18:55:53Z
- run_id: 44938015696
- event: schedule
- agent_outcome: skipped
- workflow_status: failure
- note: Agent-created compaction is authoritative; this closeout records how the run ended.

## Workflow closeout

- timestamp: 2026-11-22T05:54:44Z
- run_id: 44991304284
- event: schedule
- agent_outcome: success
- workflow_status: success
- note: Agent-created compaction is authoritative; this closeout records how the run ended.

## Workflow closeout

- timestamp: 2026-11-22T14:22:40Z
- run_id: 45032311182
- event: schedule
- agent_outcome: skipped
- workflow_status: failure
- note: Agent-created compaction is authoritative; this closeout records how the run ended.

## Workflow closeout

- timestamp: 2026-11-22T23:27:36Z
- run_id: 45083199751
- event: schedule
- agent_outcome: skipped
- workflow_status: failure
- note: Agent-created compaction is authoritative; this closeout records how the run ended.

## Workflow closeout

- timestamp: 2026-11-23T06:43:13Z
- run_id: 45125882915
- event: schedule
- agent_outcome: success
- workflow_status: success
- note: Agent-created compaction is authoritative; this closeout records how the run ended.

## Workflow closeout

- timestamp: 2026-11-23T23:39:25Z
- run_id: 45290411212
- event: schedule
- agent_outcome: skipped
- workflow_status: failure
- note: Agent-created compaction is authoritative; this closeout records how the run ended.

## Workflow closeout

- timestamp: 2026-11-24T09:11:22Z
- run_id: 45362627906
- event: schedule
- agent_outcome: success
- workflow_status: success
- note: Agent-created compaction is authoritative; this closeout records how the run ended.

## Workflow closeout

- timestamp: 2026-11-24T22:09:09Z
- run_id: 45497937218
- event: schedule
- agent_outcome: success
- workflow_status: success
- note: Agent-created compaction is authoritative; this closeout records how the run ended.

## Workflow closeout

- timestamp: 2026-11-25T07:46:37Z
- run_id: 45570638173
- event: schedule
- agent_outcome: success
- workflow_status: success
- note: Agent-created compaction is authoritative; this closeout records how the run ended.

## Workflow closeout

- timestamp: 2026-11-25T21:25:24Z
- run_id: 45703998031
- event: schedule
- agent_outcome: success
- workflow_status: success
- note: Agent-created compaction is authoritative; this closeout records how the run ended.

## Workflow closeout

- timestamp: 2026-11-26T07:38:26Z
- run_id: 45776677606
- event: schedule
- agent_outcome: success
- workflow_status: success
- note: Agent-created compaction is authoritative; this closeout records how the run ended.

## Workflow closeout

- timestamp: 2026-11-26T21:13:01Z
- run_id: 45896324879
- event: schedule
- agent_outcome: skipped
- workflow_status: failure
- note: Agent-created compaction is authoritative; this closeout records how the run ended.

## Workflow closeout

- timestamp: 2026-11-27T07:35:58Z
- run_id: 45959445916
- event: schedule
- agent_outcome: success
- workflow_status: success
- note: Agent-created compaction is authoritative; this closeout records how the run ended.
