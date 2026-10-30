# Route Inventory

Base: `https://console.byteplus.com/ark/region:ap-southeast-1/`

| Route | Auth | Status | Notes | Evidence |
|-------|------|--------|-------|----------|
| `/tts/podcast` | A session | tested | Seed target. Authenticated shell loads; actual app content is a cross-origin iframe on an out-of-scope host. postMessage bridge validates origin/source. | `result/logs/client-side.log` |
| `/overview` | A session | tested | Home. `GetAccountMeta`, `GetLocationInfo`, `GetAccountInfo`, `ListApiKeys`, `GetRawApiKey`, price calls. No user-controlled rendering. | `result/logs/server-side.log` |
| `/model` | A session | tested | Public model catalog (`GetModelSquareDefaultViewBundle`, `GetSquareModelFuzzyQuery`). No user content. | `result/logs/server-side.log` |
| `/gallery` | A session | tested | Public curated gallery (`ListGalleryWorks`, `GetGalleryFilterOptions`, `GetGalleryPageConfigs`). Content authored by BytePlus; no user submissions. | `result/logs/server-side.log` |
| `/application` | A session | tested | App Lab list (`GetAppLabSquareList`). Accessible. | `result/logs/server-side.log` |
| `/assistant/edit?botType=ProCode&formType=create` | A session | tested (gated) | Agent builder editor. Requires activating vefaaS (1/6 services inactive); no app created. UI auto-created IAM `ServerlessApplicationRole` (expected side effect). | `result/logs/server-side.log` |
| `/inference` | A session | tested | Redirects to `/overview`. | `result/logs/server-side.log` |
| `/managed-agents/quickstart` | A session | tested | Guest-accessible managed-agent UI. Creation paths blocked by `ManagedAgentNotOpen`. | `result/logs/server-side.log` |
| `/managed-agents/agents` | A session | tested | Empty agent list; no list API returns tenant data; creation gated. | `result/logs/server-side.log` |
| `/managed-agents/credentials-vault` | A session | tested | Vault CRUD scoping tested A vs B; see endpoints log. | `result/logs/server-side.log` |
| `/managed-agents/credentials-vault-oauth/callback` | A session | tested | Query params only feed `localStorage` + `navigate`; no backend completion call, no state validation. Low (UI spoofing). | `result/logs/client-side.log` |
| `/docs/product-overview` | A session | tested | Docs module `6390.72c02fadf9.js`; no unsafe HTML sink; content from trusted CDN. | `result/logs/client-side.log` |
| `/notfound` | B session | tested | B cannot render region UI; APIs still callable via session. | `result/logs/server-side.log` |
| `http://127.0.0.1:8000/` | local harness | tested | CORS/cross-site fetch harness sharing A cookie jar; not a target. | `result/logs/client-side.log` |
