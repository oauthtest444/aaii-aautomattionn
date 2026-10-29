# Endpoint Inventory

| Method | Path | Auth | Variants | Status |
|---|---|---|---|---|
| POST | /api/passport/login/mixtureLogin | public | redirectURI (Referer) | Confirmed: server-derived RedirectPath honors `/\t/evil.com/` and `/\n/host` → open redirect (VULN-20261029-001) |
| POST | /api/top/bill/ap-singapore-1/2022-01-01/ListMonthlyBillOpen | user | `PayerID` (own / other) | Not vulnerable: `PayerID=3001021825` (user B) from user A returned empty; own PayerID returned own bills. Session-scoped. |
| POST | /api/top/bill/ap-singapore-1/2020-01-01/CountCoupon | user | — | Not vulnerable: `Total: 0` for test accounts. |
| POST | /api/top/bill/ap-singapore-1/2020-01-01/ListAccountFinancialRole | user | — | Informational: `FinancialRoleList: [0]`. |
| POST | /api/top/consolemessage/ap-singapore-1/2024-05-01/GetInMailInfo | user | `ID` (own / other) | Not vulnerable: user A requesting B's message `34886574` → `BadRequestError` "站内信不存在"; scoped by session AccountId. |
| POST | /api/top/consolemessage/ap-singapore-1/2024-05-01/UpdateInMailStatus | user | `ID` (own / other) | Not tested cross-account (no B message ID accepted for A; read scoping implies write scoping). |
| POST | /api/top/ticket/ap-southeast-1/2021-01-01/ListTicketConversation | user | `TicketID` (own / other) | Not vulnerable: user B reading user A's ticket `I-2026102917080001` blocked. |
| POST | /api/top/ticket/ap-southeast-1/2021-01-01/CreateTicketConversation | user | `TicketID` (own / other), `ContentFormat` | Not vulnerable: cross-account write blocked; server sanitizes stored Content (strips `on*`, `javascript:` href, iframe srcdoc). |
| POST | /api/top/ticket/ap-southeast-1/2021-01-01/CreateTicket | user | create body | Not vulnerable: no cross-tenant field influence observed; no sensitive field persisted. |
| POST | /api/top/ticket/ap-southeast-1/2021-01-01/UpdateTicket | user | `TicketID`, `NotificationMethods`, extra fields | Not vulnerable: extra fields ignored; only notification methods persisted. |
| POST | /api/top/ticket/ap-southeast-1/2021-01-01/GetSensitiveConversation | user | `TicketID`, `ConversationID` | Not vulnerable: ownership checked. |
