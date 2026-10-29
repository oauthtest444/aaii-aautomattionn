# Route Inventory

| URL | Status | JS | Notes |
|---|---|---|---|
| https://console.byteplus.com/waf/overview | unresolved | iam/service/attach_role | SPA shell returns 200 but client redirects to `/iam/service/attach_role/?ServiceName=waf`; test account has no WAF service role. Authorizing it is a state change, so not performed. |
| https://console.byteplus.com/finance | tested | finance app bundles | Redirects to `/finance/overview`. Subroutes enumerated from JS: overview, bill/detail, cost-analyse, invoice-manage, payment-methods, coupon, order, contract, transactions, budget, etc. Test account has $0.00 and no bill/order/invoice rows. |
| https://console.byteplus.com/finance/bill | tested | finance app bundles | Bill details page; test account has $0.00 and no bill rows. |
| https://console.byteplus.com/user | tested | console-user-mono 1.0.0.2492 (`main.4ec0f485.js`, `Basics.bfbeee6d.js`) | Profile renders React-escaped text. Account-name update (`UpdateAccount`) is API-callable but the UI enforces a 7-day lock; tampering with `AccountId` was not attempted because it would rename/lock the disposable test account. Marked not tested for cross-account. |
| https://console.byteplus.com/beian | not-vulnerable | — | Server returns HTTP 404 (72 KB console 404 body) for both accounts; route not provisioned for these test accounts. |
| https://console.byteplus.com/message | tested | bp-vconsole-message 1.0.0.435 (`main.5bc4931c.js`, `message_innermsg.f9a63668.js`, `853.6ebc1a89.js`) | Redirects to `/message/innermsg`. Detail uses `DOMPurify 2.5.9` on `Content` before putting it in an unsandboxed `iframe#external-frame` via `srcDoc`. `GetInMailInfo` is scoped by session AccountId (A requesting B's ID returns "站内信不存在"). postMessage listeners check strict origin. |
| https://console.byteplus.com/message/innermsg/detail | tested | bp-vconsole-message | Inspected B-owned message `InnermsgId=34886574`: server-generated ticket-reply template, no user-controlled script. |
| https://console.byteplus.com/workorder/list/ | tested | workorder-web (`main.7d5d0431.js`, `609.9d2bee7c.js`, `499.b80931e8.js`) | Ticket conversation Content is server-sanitized on write (strips `on*`, `javascript:` hrefs, iframe srcdoc) and rendered via markdown/DOMPurify 2.5.9. Cross-account ticket read/write by user B against user A's ticket is blocked. |
| https://console.byteplus.com/workorder/list/detail | tested | workorder-web | Re-rendered stored XSS probes: inert; no handler execution. |
| https://console.byteplus.com/auth/login/ | tested | vconsole-auth 1.0.0.2811 (`main.adbc4e5a.js`) | Confirmed open redirect via `redirectURI=/%09/%2Fhost/` and `/%0a/host` (VULN-20261029-001). Absolute, `//`, and `/\` forms rejected; `javascript:` rejected (HTTP 403, no execution). |
