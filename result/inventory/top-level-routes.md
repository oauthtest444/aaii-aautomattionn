# Top-Level Route Inventory

Target: https://console.byteplus.com

Auth: test account A (test-user-123, Account ID 3000823185); account B (testt456, 3001021825) for cross-tenant checks.

| Top-Level Route | Status | Sub-Routes | Summary |
|---|---|---|---|
| https://console.byteplus.com/datarangers | completed | 5 | Server-side cross-tenant checks done: org APIs authorize correctly; DataFinder project APIs return 403001 except one low-severity read-only IDOR in common_settings (VULN-20261031-001). Client-side: missing-origin postMessage listeners only, no exploitable flow. |
| https://console.byteplus.com/datatester | completed | 3 | Server-side cross-tenant checks passed (301/302/400). Account A has no DataTester contract; account B only has read-only demo data. Client-side: unvalidated postMessage cookie write (low/unresolved). |
| https://console.byteplus.com/ark | completed | 7 | Server-side checks on API keys, vaults, agents, and OAuth providers: all account-scoped; foreign IDs return NotFound. Managed agents not activated. Client-side: vendor SDK listeners/redirects, no user-controlled flow. |
| https://console.byteplus.com/ai | completed | 1 | Vision AI overview and app list: AppApps returns only caller's apps. Client-side: vendor SDKs only. |
| https://console.byteplus.com/alb | completed | 2 | No ALB resources in either test account; account/quota endpoints scoped. Client-side: vendor SDKs only. |

## https://console.byteplus.com/datarangers

Status: completed

### Sub-Routes

| Sub-Route | Status | Summary |
|---|---|---|
| /datarangers | completed | App list and org APIs; foreign org rejected. |
| /datarangers/org/2100230837/app/list | completed | Own-org app list only. |
| /datafinder project workspace (common_settings, project, functions) | completed | Low read-only IDOR on common_settings; other project endpoints 403001. |
| /datafinder analysis tools (dashboards, roles, scenarios, session replay, AI GC) | completed | Foreign project: 403001 access denied. |
| /datafinder user/notification, contract_status, surveys | completed | Own-account only; no cross-tenant leak. |

## https://console.byteplus.com/datatester

Status: completed

### Sub-Routes

| Sub-Route | Status | Summary |
|---|---|---|
| /datatester app/experiment list | completed | Foreign app/org: 301/302/400; no data leak. |
| /datatester metrics / feature flags | completed | Foreign app: 301; own demo data only. |
| /datatester permission / org management | completed | Foreign org: 400 "no contract". |

## https://console.byteplus.com/ark

Status: completed

### Sub-Routes

| Sub-Route | Status | Summary |
|---|---|---|
| /ark/region:ap-southeast-1/overview | completed | Vendor SDK client-side; no flow. |
| /ark API keys | completed | Account-scoped; foreign key NotFound. |
| /ark vaults / credentials | completed | Account-scoped; foreign vault NotFound. |
| /ark agents | completed | Account-scoped; empty for test accounts. |
| /ark OAuth providers | completed | Public provider catalog. |
| /ark region switch | completed | Fixed internal redirect only. |
| /ark sessions / environments / skills / memory / channel | completed | Unresolved: managed agents not activated for test accounts; no impact shown. |

## https://console.byteplus.com/ai

Status: completed

### Sub-Routes

| Sub-Route | Status | Summary |
|---|---|---|
| /ai/overview (app list) | completed | AppApps returns caller's apps only; client-side vendor SDKs. |

## https://console.byteplus.com/alb

Status: completed

### Sub-Routes

| Sub-Route | Status | Summary |
|---|---|---|
| /alb/region:alb+cn-beijing/instance | completed | No ALB resources; client-side vendor SDKs. |
| /alb account features / quota | completed | Account-scoped. |
