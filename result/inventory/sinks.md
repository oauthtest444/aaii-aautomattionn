# Sink Inventory

| Sink | file:line | Source flow | Status | Evidence |
|------|-----------|-------------|--------|----------|
| `dangerouslySetInnerHTML` | `6390.72c02fadf9.js` (docs module 87093) | highlight.js token output `__html:e` | safe: markup produced by local highlighter from code text | `result/logs/client-side.log` |
| `innerHTML` (detached div) | `6390.72c02fadf9.js` (docs) | `n.innerHTML=e.html; n.textContent` | safe: used to derive description text; never inserted into document | `result/logs/client-side.log` |
| `location.href` | `6390.72c02fadf9.js` (docs) | anchor hrefs | restricted to http(s), no credentials, same origin/allowlisted host, path regex `^\/(?:ark(?:-stg)?\/)?(?:region:[^/]+\/)?(apiKey\|openManagement)\/?$` | `result/logs/client-side.log` |
| `innerHTML` (x2) | `38767.69bfc8048a.js` | bundled Tea/analytics + visual-editor SDK | not reachable with attacker markup from page data; vendor SDK | `result/logs/client-side.log` |
| `innerHTML` (x2) | `41100.547627448f.js` | managed-agent chunk | reviewed, no attacker-controlled source found | `result/logs/client-side.log` |
| `localStorage.setItem("managed-agent:vault-oauth-flow-complete")` | `8627.091a1c4f24.js` | OAuth callback query params (`vaultId`, `credential_id`, `source`, `eventId`) | writes attacker-suppliable values; consumed by `vault.js` to show toast / navigate to SPA route. No backend action. Low. | `result/logs/client-side.log` |
| `navigate(/managed-agents/credentials-vault/${vaultId})` | `vault.js` | `storage`/`message` event payload | destination restricted to same-origin SPA route; no script execution | `result/logs/client-side.log` |
