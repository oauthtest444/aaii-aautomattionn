# Top-Level Route Inventory

Target: https://console.byteplus.com

| Top-Level Route | Status | Sub-Routes | Summary |
|---|---|---|---|
| https://console.byteplus.com/finance/overview | completed | 19 | Server-side + client-side coverage complete. No confirmed vulnerability. |
| https://console.byteplus.com/workorder/list/ | completed | 5 | Server-side + client-side coverage complete. No confirmed vulnerability. |

## https://console.byteplus.com/finance/overview

Status: completed

Server-side: all finance sub-route APIs captured and recorded in api-routes.md.
Cross-account probes with account B and account A identifiers were rejected,
empty, or session-scoped. Client-side: exact source/sink regexes applied to the
finance bundle; no user-controlled source reached an XSS sink. Write-only
payment/budget flows remain documented unresolved because test accounts have no
bill/instance/invoice/contract data and payment writes need a real instrument or
captcha.

### Sub-Routes

| Sub-Route | Status | Summary |
|---|---|---|
| /finance/overview | completed | APIs tested (session-scoped). Client-side pass done. |
| /finance/bill/detail | completed | Bill detail APIs; B+A IDs empty/own-scope. |
| /finance/bill/cost-analyse | completed | Cost analysis APIs; own empty data. |
| /finance/order | completed | ListOrder empty for both accounts. |
| /finance/renew | completed | ListRenewSettings empty. |
| /finance/unsubscribe | completed | No finance-specific API on load. |
| /finance/instance-manage | completed | Instance APIs own-scope/empty. |
| /finance/resource-package | completed | Selector metadata only. |
| /finance/saving-plan | completed | Saving plan APIs own empty data. |
| /finance/coupon | completed | ListCoupon own empty; B+A IDs scoped. |
| /finance/pickup-coupon | completed | Redeem/voucher APIs require POST body; no test data. |
| /finance/invoice-manage | completed | Invoice/tax/email APIs; GetTaxID session-scoped, ListEmailForAccount enforced. |
| /finance/contract-discount | completed | Discount APIs own empty data. |
| /finance/contract | completed | Contract list empty for both accounts. |
| /finance/cost | completed | Budget APIs own empty data. |
| /finance/export | completed | No export record on load; write/export flow not exercised. |
| /finance/payment/transactions | completed | Balance transactions own empty; B+A PayerID scoped. |
| /finance/payment/make-payment | completed | Cashier config only; no payment initiated. |
| /finance/payment/payment-methods | completed | Stored payment methods own scope. |
| /finance/busniess-finance/relation | completed | Signing record/financial role own scope. |

## https://console.byteplus.com/workorder/list/

Status: completed

Server-side: ticket list/detail/conversation/create/update APIs tested
previously; this run revalidated cross-account isolation (B with A ticket ->
Forbidden), IAM ListUsers/ListRoles session-scoped, GetTicketCount and
ListAuthorization session-scoped. Client-side: URL params (`sessionID`, `step`,
`SubProductID`, `FlowKey`, `ref`, `tab`) feed state/API params; no XSS sink;
message listeners enforce same-origin or only toggle chat UI.

### Sub-Routes

| Sub-Route | Status | Summary |
|---|---|---|
| /workorder/list/ | completed | Ticket list APIs tested; IAM/GetTicketCount session-scoped. |
| /workorder/list/detail | completed | Covered by GetTicket/GetTicketForUser conversation APIs; B on A ticket forbidden. |
| /workorder/create | completed | Config/security-contact APIs only; no uncontrolled sink. |
| /ticket/myTicket | completed | Route returns 404 (not deployed); documented, not testable. |
| /workorder/authorizationList | completed | ListAuthorization session-scoped; B+A AccountID invalid, UserID ignored. |
