# Scan Summary

- Target: https://console.byteplus.com/ark/region:ap-southeast-1/tts/podcast?
- Scope: all sub-routes under /ark/* on console.byteplus.com only (private BBP, per data/targets.txt)
- Authorization source: data/targets.txt
- Test accounts: creds/test-account.txt (2 disposable accounts, A and B)
- Status: completed
- Completed at: 2026-10-31T08:52:28Z

## Coverage

- Top-level routes: 2 total, 2 completed (`/ark/` and the podcast route).
- Sub-routes: 20 inventoried (12 under `/ark/`, 8 `console-embedded` routes
  documented Out of Scope).
- API routes: 15 inventoried, all completed or documented Out of Scope.
- Subdomains: 6 inventoried, all completed or documented Out of Scope.
- Client-side: source/sink regex analysis on 34 deduplicated `/ark/*` bundles,
  postMessage listeners reviewed, no confirmed source→sensitive-sink path.
- Server-side: cross-account IDOR/tenant-override attempts on
  `/api/top/ark/ap-southeast-1/2024-01-01/*` with two isolated accounts.

## Findings

- Confirmed vulnerabilities: none. `result/confirmed-vuln.txt` is empty.

## Not Vulnerable (tested)

- `GetRawApiKey` cross-account Id (`301420` from A) → `NotFound.Id`.
- `ListApiKeys`, `GetInferenceUsage`, `GetAutoSetFreeLimit`,
  `ListDataCollectionPermissions`, `GetAccountInfo`, `GetModelChargeItem`,
  `QueryModelPrice` — tenant identifiers ignored or unsupported; only caller
  data returned.
- No DOM XSS, open redirect, or postMessage-driven action on the authorized
  origin.

## Unresolved / Out of Scope

- `/api/tag/tag_resources_bff` and `/api/tag/untag_resources_bff` return 404 on
  `console.byteplus.com`; the tag API is hosted on the BFF subdomain (Out of
  Scope). Cross-account tagging could not be verified in scope.
- `modelark-api.console.byteplus.com/ark/bff`,
  `arkbff-ap-southeast1.console.byteplus.com`, the
  `/api/v1/ark_volc_console_proxy` proxy, and all
  `console-embedded.byteplus.com/voice/new/*` routes were not tested: distinct
  subdomains/embedded origin not explicitly authorized by `data/targets.txt`.
