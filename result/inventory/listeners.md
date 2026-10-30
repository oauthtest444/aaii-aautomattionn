# postMessage Listener Inventory

| file:line | Origin check | Source check | Schema check | Status | Evidence |
|-----------|--------------|--------------|--------------|--------|----------|
| `7006.*.js` iframe bridge | yes (expected origin) | yes (`event.source` matches iframe) | message type switch | safe | `result/logs/client-side.log` |
| `38767.69bfc8048a.js` `devtool:web:ready` | no explicit origin check; sets `devToolOrigin=t.origin` | vendor devtools/monitoring SDK | message `type` | vendor SDK; not attacker-reachable from app UI | `result/logs/client-side.log` |
| `38767.69bfc8048a.js` `tea:openHeatMapCore` (visual editor) | handler does not verify origin before acting | uses `e.data.app_id`, loads `K+".js?query="+Date.now()` | message `type` | base script URL is fixed; not shown to be attacker-controllable. Unresolved/low. | `result/logs/client-side.log` |
| `vault.js` remote app | `event.origin === window.location.origin` | `tc(e)` validates `eventId` dedupe | `type`, `status`, `vaultId`, `source` | low: same-origin only; leads to toast + SPA navigation | `result/logs/client-side.log` |
| `vault.js` `storage` listener | same-origin by definition | `event.key` match + `eventId` dedupe | JSON parse + fields | low (same as above) | `result/logs/client-side.log` |
