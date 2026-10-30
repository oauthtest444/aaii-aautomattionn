# Summary

- **Run date:** 2026-10-30 (UTC)
- **Duration:** ~30 minutes
- **Target:** `https://console.byteplus.com/ark/region:ap-southeast-1/tts/podcast`
- **Accounts:** A `3000823185` (root), B `3001021825` (root)
- **Result:** No confirmed high/critical vulnerabilities. `result/confirmed-vuln.txt` contains no entries.

## Scope
In scope: `console.byteplus.com` and `*.console.byteplus.com` route components (`arkbff-ap-southeast1`, `modelark-api`) serving the ModelArk `/ark/*` console. Out of scope and not contacted: sibling domains (`console-embedded.byteplus.com`, `res.gcloudcache.com` as a target, `exp-vod.ark.cn-beijing.volces.com`, TOS/CDN hosts, analytics hosts) and the operator Discord webhook referenced in `data/targets.txt`. See `result/scope.md` and `result/out-of-scope.txt`.

## Tested Surface
- **Server-side tenant isolation (A vs B):** API keys (`ListApiKeys`, `GetRawApiKey`, `DeleteApiKey`, `UpdateApiKey`), credentials vault (`ListVaults`, `GetVault`, `ListCredentials`, `DeleteVault`, `DeleteCredential`), dataset/inference usage and API-key IAM flag calls from the earlier pass. All tenant-scoped (`NotFound`/empty/403), no BOLA.
- **Mass assignment:** `CreateApiKey` with injected `AccountId`/`AccountID` ignored; key stayed owned by the session account. `GetAccountMeta` with injected account IDs returned 500 `InternalError` (crash, no data leak).
- **SSRF:** `EstimateTokenCount` URL field rejects all tested URLs (`InvalidParameter.Url`); only signed TOS URLs likely accepted. Only other URL-bearing method (`CreateInferenceService.ImageUrl`) is activation-gated. Managed-agent `CreateVaultOAuthFlow.McpServerUrl` is restricted to built-in MCP providers: an unknown host returns `UpstreamUnavailable` and a tester-controlled callback received no request.
- **OAuth flow redirect:** `CreateVaultOAuthFlow.RedirectUrl` enforces an origin allowlist plus absolute-URL/no-fragment rules; external origins, userinfo/prefix tricks, relative URLs, encoded dots, and `javascript:` payloads were rejected. No open redirect.
- **CORS/CSRF:** `modelark-api` reflects arbitrary Origin with credentials, but CSRF double-submit is enforced (GET included) and the token is not exposed; cross-site credentialed fetches fail. `arkbff` blocks preflight/cross-site. `api/top` returns a fixed ACAO. No exploitable CORS chain.
- **Client-side:** docs renderer, iframe bridge, managed-agent chunks, OAuth callback, model-detail `Id` parameter. Docs sinks safe; bridge validates origin/source; callback only writes same-origin `localStorage`/navigates (low UI spoofing); `Id` is never reflected and an `<img onerror>` payload did not execute.
- **Routes:** `/tts/podcast`, `/overview`, `/model`, `/model/detail?Id=`, `/gallery`, `/application`, `/assistant/edit`, `/inference`, `/managed-agents/{quickstart,agents,credentials-vault,credentials-vault-oauth/callback}`, `/docs/product-overview`, `/notfound`. Inventories in `result/inventory/`.

## Residual Observations (not reported)
- `GetAccountMeta` 500 on `AccountId`/`AccountID` mass assignment — robustness only, no confidentiality/integrity impact observed.
- `modelark-api` permissive CORS — rendered inert by enforced CSRF double-submit.
- OAuth callback accepts arbitrary `vaultId`/`credential_id`/`source` and writes a success event to `localStorage` — same-origin UI spoofing only; no backend state change.
- Bundled Tea/visual-editor SDK in `38767.69bfc8048a.js` has a non-origin-checked `message` handler that loads a script URL built from a fixed base — not demonstrated attacker-controllable.

## Unresolved / Blocked
- Managed Agents `CreateAgent`/`CreateCredential`/sessions require product activation (`ManagedAgentNotOpen`); no agent objects existed to test cross-tenant access.
- App Lab app creation requires vefaaS activation (1/6 services inactive); no app created or deployed.
- Model activation / inference / fine-tuning / batch / eval routes are activation-gated and were not deep-tested.
- `EstimateTokenCount` SSRF unproven (URL signature requirement).
