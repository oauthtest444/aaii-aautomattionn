# Route Inventory

| URL | Status | JS | Notes |
|---|---|---|---|
| https://console.byteplus.com/waf/overview | unresolved | iam/service/attach_role | Redirects to IAM cross-service authorization page; test account has no WAF service role. Did not authorize (state change). |
| https://console.byteplus.com/finance | tested | finance app bundles | Redirects to /finance/overview. Subroutes enumerated from JS: overview, bill/detail, cost-analyse, invoice-manage, payment-methods, coupon, order, contract, transactions, budget, etc. |
| https://console.byteplus.com/finance/bill | tested | finance app bundles | Bill details page; test account has $0.00 and no bill rows. |
