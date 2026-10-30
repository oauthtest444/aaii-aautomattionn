# Endpoint Inventory

All console calls are session-authenticated and CSRF-protected via `csrfToken` cookie / `X-Csrf-Token` header unless noted.

| Method | Path | Source | Query/Body | Auth | Response shape | Status |
|--------|------|--------|------------|------|----------------|--------|
| POST | `https://console.byteplus.com/api/top/ark/ap-southeast-1/2024-01-01/<Action>` | `1540.1dae60cb77.js` | action-specific JSON | cookie + `X-Csrf-Token` | `ResponseMetadata` + `Result` | tested |
| POST | `.../GetAccountMeta` | overview | `{}` | cookie | account/meta | injection of `AccountId`/`AccountID` -> 500 `InternalError`; no IDOR |
| POST | `.../ListApiKeys` | overview/api key page | `{ProjectName,PageNumber,PageSize}` | cookie+CSRF | keys for session account only | tested A/B, tenant-scoped |
| POST | `.../GetRawApiKey` | overview/agents | `{Id,ProjectName}` | cookie+CSRF | `{ApiKey,SID}` for owner | B on A key -> `NotFound.Id`; A on A key 200 |
| POST | `.../CreateApiKey` | api key page | `{Name,ProjectName,ResourceInstances,AccessControlInfo,IPWhiteListInfo,Scene}` | cookie+CSRF | `{Id}` | injected `AccountId`/`AccountID` ignored; created key owned by session account A |
| POST | `.../DeleteApiKey` | api key page | `{Id,ProjectName}` | cookie+CSRF | `{}` | own key deleted 200 |
| POST | `.../UpdateApiKey` | api key page | `{Id,Name,AccessControlInfo,IPWhiteListInfo,Disable,Regen}` | cookie+CSRF | `{}` | not cross-account tested |
| POST | `.../EstimateTokenCount` | console | `{ModelName,ServiceType,FinetuneType,Url,...}` | cookie+CSRF | token count | arbitrary/SSRF URLs -> `InvalidParameter.Url`; only signed TOS likely accepted |
| POST | `https://arkbff-ap-southeast1.console.byteplus.com/api/2024-10-01/<Action>` | console | action JSON | cookie+CSRF (same-site only; no CSRF needed for `GetLocationInfo` when called same-site) | JSON | tested |
| POST | `arkbff .../GetLocationInfo` | console | `{}` | cookie | geo (NA/US) | tested |
| POST | `arkbff .../GetEnumConfiguration` | console | `{}` | cookie | enums | tested |
| POST | `arkbff .../GetConsoleVisibility` | console | `{}` | cookie | visibility | tested |
| POST | `arkbff .../GetAppLabSquareList` | App Lab | page params | cookie | starter apps | tested |
| POST | `arkbff .../ListGalleryWorks` | Gallery | `{PageNumber,PageSize}` | cookie | curated works | public curated content |
| POST | `arkbff .../GetModelSquareDefaultViewBundle` | Model Square | `{}` | cookie | model catalog | tested |
| POST | `arkbff .../GetSquareModelFuzzyQuery` | Model Square | query | cookie | model search | tested |
| POST | `arkbff .../CheckBotApplicationRelatedProductStatus` | App editor | `{}` | cookie | activation flags | tested |
| POST | `https://modelark-api.console.byteplus.com/ark/bff/api/ap-southeast-1/2024-01-29/GetConsoleUser` | console | `{}` | cookie+CSRF | user | CSRF enforced even on GET; CORS reflects Origin but token still required |
| POST | `.../GetExampleCodeItems` | console | `{}` | cookie+CSRF | code samples | tested |
| POST | `console.byteplus.com/api/top/ark/.../<ManagedAgentAction>` | `vault.js` | action JSON | cookie+CSRF | managed-agent results | tested vault scoping |
| POST | `.../CreateVault` | vault UI | `{DisplayName}` | cookie+CSRF | `{Id,...}` | works without activation |
| POST | `.../GetVault`, `DeleteVault`, `ListVaults` | vault UI | `{Id}` / `{Scene,Limit,Page}` | cookie+CSRF | vault(s) | A vault visible to A only; B -> `InvalidVault.NotFound` / empty |
| POST | `.../CreateCredential` | vault UI | credential body | cookie+CSRF | credential | blocked `ManagedAgentNotOpen` (activation) |
| POST | `.../ListCredentials`, `DeleteCredential` | vault UI | `{VaultId,...}` | cookie+CSRF | credentials | B on A vault -> empty / not found |
| POST | `.../ListOAuthProviders`, `CreateVaultOAuthFlow` | vault UI | provider/flow body | cookie+CSRF | flow | discovered, not exercised |
| GET/POST | `https://console.byteplus.com/api/top/iam/cn-north-1/2018-01-01/{GetRole,CreateRole}` | App Lab | role name/policy | cookie+CSRF | role | UI auto-created `ServerlessApplicationRole`; expected |
| POST | `https://console.byteplus.com/api/top/vefaas/ap-southeast-1/2021-03-03/ListApplications` | App Lab | `{}` | cookie+CSRF | apps | activation-gated |

CORS notes:
- `console.byteplus.com/api/top/...` preflight returns fixed `Access-Control-Allow-Origin: http://console.byteplus.com` for all origins (including `null`, evil origins) with credentials; not exploitable.
- `modelark-api...` reflects arbitrary Origin + `Access-Control-Allow-Credentials: true`, but CSRF double-submit is enforced; `x-csrf-token` is not exposed; cross-site calls fail `InvalidCSRFToken`.
- `arkbff...` preflight returns 403 and cross-site browser fetch fails.
