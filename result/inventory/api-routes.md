# API Route Inventory

Auth: `session` = browser session cookie (disposable account A/B).
Status vocabulary: `completed` | `out of scope`.
Tested endpoints were checked for missing authorization, cross-account access
(A→B, B→A), AccountId/tenant-id injection, and parameter/IDOR issues.

| Method | Path | Parent Top-Level Route | Auth | Status | Summary |
|---|---|---|---|---|---|
| POST | /api/top/ark/ap-southeast-1/2024-01-01/GetAccountInfo | /ark/ | session | completed | Returns caller's own account only; no cross-account leak. |
| POST | /api/top/ark/ap-southeast-1/2024-01-01/ListApiKeys | /ark/ | session | completed | Account-scoped; `AccountId`/`AccountID`/`accountId` body overrides ignored. |
| POST | /api/top/ark/ap-southeast-1/2024-01-01/GetRawApiKey | /ark/ | session | completed | Cross-account Id 301420 (B) from A → `NotFound.Id`; AccountId injection ignored. |
| POST | /api/top/ark/ap-southeast-1/2024-01-01/GetInferenceUsage | /ark/ | session | completed | `Filters[Key=AccountID]` → `InvalidParameter.Filters.Key`; top-level AccountId ignored. |
| POST | /api/top/ark/ap-southeast-1/2024-01-01/GetAutoSetFreeLimit | /ark/ | session | completed | Returns caller's own setting; AccountId override ignored. |
| POST | /api/top/ark/ap-southeast-1/2024-01-01/ListDataCollectionPermissions | /ark/ | session | completed | Own/generic data only. |
| POST | /api/top/ark/ap-southeast-1/2024-01-01/GetModelChargeItem | /ark/ | session | completed | Billing data scoped to caller; no cross-account access. |
| POST | /api/top/ark/ap-southeast-1/2024-01-01/QueryModelPrice | /ark/ | session | completed | Public pricing data; no per-tenant data. |
| GET | /api/passport/account/getUser | /ark/ | session | completed | Returns own session identity only. |
| POST | /api/tag/tag_resources_bff | /ark/ | session | completed | 404 on console.byteplus.com for all tried ResourceType values; not hosted here. |
| POST | /api/tag/untag_resources_bff | /ark/ | session | completed | 404 on console.byteplus.com; not hosted here. |
| POST | /api/common/plat_growth/im/* | /ark/ | session | completed | Growth/IM helpers; no sensitive object references identified. |
| POST | https://modelark-api.console.byteplus.com/ark/bff | /ark/ | session | out of scope | BFF on a different subdomain; not tested per AGENT.md §4.3. |
| POST | https://arkbff-ap-southeast1.console.byteplus.com | /ark/ | session | out of scope | BFF on a different subdomain; not tested per AGENT.md §4.3. |
| ANY | /api/v1/ark_volc_console_proxy → /ark/bff-bytecloud | /ark/ | session | out of scope | Proxy to the BFF host; not tested per AGENT.md §4.3. |

## Notes

- Related `<Action>` names present in the SPA bundle and observed: `ListFunctionAllowedItems`,
  `CheckServiceLinkedRole`, `GetModelChargeItem`, `QueryModelPrice`.
- No in-scope endpoint accepted a client-supplied tenant/account identifier in a
  way that changed the returned resource set.
- `/api/tag/*_bff` returning 404 indicates the tag API lives on the BFF host, which
  is Out of Scope; cross-account tagging remains unverified in scope.
