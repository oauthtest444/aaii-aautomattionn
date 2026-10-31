# Top-Level Route Inventory

Target: https://console.byteplus.com

Auth: test account A (test-user-123, Account ID 3000823185); account B (testt456, 3001021825) for cross-tenant checks.

| Top-Level Route | Status | Sub-Routes | Summary |
|---|---|---|---|
| https://console.byteplus.com/datarangers | progress | 5 | Server-side cross-tenant checks done: org APIs authorize correctly; DataFinder project APIs return 403001 except one low-severity read-only IDOR in common_settings (VULN-20261031-001). Client-side pending. |
| https://console.byteplus.com/datatester | progress | 3 | Server-side cross-tenant checks passed (301/302/400). Account A has no DataTester contract; account B only has read-only demo data. Client-side pending. |
| https://console.byteplus.com/ark | progress | 7 | Server-side checks on API keys, vaults, agents, and OAuth providers: all account-scoped; foreign IDs return NotFound. Managed agents not activated for test accounts. Client-side pending. |
| https://console.byteplus.com/ai | progress | 1 | Vision AI overview and app list: AppApps returns only caller's apps. Deeper studio/app endpoints and client-side pending. |
| https://console.byteplus.com/alb | progress | 2 | No ALB resources in either test account; account/quota endpoints scoped. Client-side pending. |
