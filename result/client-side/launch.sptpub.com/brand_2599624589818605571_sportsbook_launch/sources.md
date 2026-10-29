# Sources — Launch Bootstrap

Route: `https://launch.sptpub.com/brand/2599624589818605571/sportsbook/launch?lang=tr&theme=DARK`

| Source | Transport | Sink / destination | Status |
|---|---|---|---|
| `lang` | query param | `<html lang>` attribute; `const lang` -> renderer config | escaped / not vulnerable |
| `theme` | query param | `String(...).toLowerCase()` -> `themeName` -> renderer config | escaped / not vulnerable |
| `token` | query param | `let token` -> sessionStorage `token`, BroadcastChannel, renderer config | escaped / not vulnerable by itself |
| `operator_page` | query param | `const operatorPage` -> `window.location.href` in `onLogin`, `onRegister`, `onRecharge` | candidate |
| `deposit_url` | query param | `const depositUrl` -> `window.location.href` in `onRecharge` | candidate |
| `url` | query param | `sportsbookUrl` -> renderer `url` config | unresolved (renderer geo-blocked) |
| brand ID | URL path | `const brandId` -> BroadcastChannel checks, renderer config | escaped / numeric route only |
| `token` (sessionStorage) | storage | BroadcastChannel `NEW_TOKEN` / renderer config | design note |
| `token-sync` BroadcastChannel messages | same-origin channel | `sessionStorage` token; `NEW_TOKEN` reply | not externally reachable |
