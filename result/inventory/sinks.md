# Sink Inventory

| Sink | Location | Source | Status | Notes |
|---|---|---|---|---|
| `window.location.href = operatorPage` | inline module `onLogin()` | `operator_page` query param -> `const operatorPage` | confirmed (VULN-20261029-001) | Unvalidated navigation; `javascript:` value yields script execution when callback invoked. |
| `window.location.href = operatorPage` | inline module `onRegister()` | `operator_page` query param -> `const operatorPage` | confirmed (VULN-20261029-001) | Same flow as `onLogin`. |
| `window.location.href = depositUrl ? depositUrl : operatorPage` | inline module `onRecharge()` | `deposit_url` (and `operator_page`) query params | confirmed (VULN-20261029-001) | Unvalidated navigation on recharge callback. |
| `new BTRenderer().initialize({ url: sportsbookUrl })` | inline module | `url` query param | unresolved | Value passed to external renderer; real renderer geo-blocked, cannot verify sink behavior. |
| `<html lang="...">` | server HTML | `lang` query param | not-vulnerable | JSON/HTML entity escaped; no attribute breakout. |
| `const lang = "..."` | inline module | `lang` query param | not-vulnerable | JSON.stringify escaping of quotes, backslashes, `<`, `>`, newlines verified. |
| `const theme = String("...").toLowerCase()` | inline module | `theme` query param | not-vulnerable | Escaped; value only passed to renderer. |
| `let token = "..."` | inline module | `token` query param | not-vulnerable | Escaped; stored in sessionStorage, passed to renderer. |
| `const brandId = "..."` | inline module | path brand ID | not-vulnerable | Route only accepts numeric brand IDs; injection attempts return 403. |
| `history.replaceState({}, "", url)` | inline module | own location | not-vulnerable | Deletes `token` and `url` params. |
