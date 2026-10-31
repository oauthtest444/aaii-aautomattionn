# Top-Level Route Inventory

Target: https://console.byteplus.com/workorder/list/

| Top-Level Route | Status | Sub-Routes | Summary |
|---|---|---|---|
| https://console.byteplus.com/workorder/list/ | completed | 4 | All four `/workorder/*` sub-routes tested. No high-impact finding; one low-impact cross-account masked-contact IDOR documented. |

## https://console.byteplus.com/workorder/list/

Status: completed

### Sub-Routes

| Sub-Route | Status | Summary |
|---|---|---|
| /workorder/list/ | completed | Ticket list; caller-scoped reads; hidden account overrides ignored; exact-origin count-refresh postMessage only. |
| /workorder/list/detail?id=I-... | completed | Cross-account ticket/conversation/file reads denied; mass assignment ignored; stored HTML sanitized server-side; no XSS. |
| /workorder/create | completed | CreateTicket ownership/state fields ignored; upload FileID ownership enforced; no client-side sink. |
| /workorder/authorizationList | completed | Authorization lists caller-scoped and empty; diagnostic endpoints unresolved due to backend errors/no records. |
