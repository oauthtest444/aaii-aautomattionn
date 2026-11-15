# Top-Level Route Inventory

Target: https://console.byteplus.com

| Top-Level Route | Status | Sub-Routes | Summary |
|---|---|---|---|
| https://console.byteplus.com/finance/overview | progress | 19 | Finance console. Account A. Server-side APIs tested; client-side per-sub-route pending. |
| https://console.byteplus.com/workorder/list/ | progress | 5 | Work order SPA. Server-side ticket APIs tested; client-side pending. |

## https://console.byteplus.com/finance/overview

Status: progress

Server-side: overview APIs captured and tested (see api-routes.md). No IDOR / mass
assignment / CSRF bypass confirmed. Remaining finance sub-routes still need
per-route API capture and testing; client-side source/sink pass pending.

### Sub-Routes

| Sub-Route | Status | Summary |
|---|---|---|
| /finance/overview | progress | APIs tested (session-scoped). Client-side pending. |
| /finance/bill/detail | pending | Bill details. |
| /finance/bill/cost-analyse | pending | Cost analysis. |
| /finance/order | pending | Order management. |
| /finance/renew | pending | Renewal management. |
| /finance/unsubscribe | pending | Unsubscription management. |
| /finance/instance-manage | pending | Instance management. |
| /finance/resource-package | pending | Resource package. |
| /finance/saving-plan | pending | Savings Plans. |
| /finance/coupon | pending | Coupon. |
| /finance/pickup-coupon | pending | Pickup voucher management. |
| /finance/invoice-manage | pending | Invoices. |
| /finance/contract-discount | pending | Business discount management. |
| /finance/contract | pending | Contract management. |
| /finance/cost | pending | Budget. |
| /finance/export | pending | Export Record. |
| /finance/payment/transactions | pending | Payment transactions. |
| /finance/payment/make-payment | pending | Make payment. |
| /finance/payment/payment-methods | pending | Payment methods. |
| /finance/busniess-finance/relation | pending | Corporate finance account linking. |

## https://console.byteplus.com/workorder/list/

Status: progress

Server-side: ticket list/detail/conversation/create/update APIs tested. AccountID
and SubmitterID mass assignment ignored; ListTicket staff action is caller-scoped;
CSRF enforced. Test ticket `I-2026111513500001` was created as account A only.

### Sub-Routes

| Sub-Route | Status | Summary |
|---|---|---|
| /workorder/list/ | progress | Ticket list + ticket APIs tested server-side. Client-side pending. |
| /workorder/list/detail | pending | Ticket detail view. |
| /workorder/create | pending | Ticket creation wizard. |
| /ticket/myTicket | pending | My tickets view. |
| /workorder/authorizationList | pending | Diagnostic authorization list. |
