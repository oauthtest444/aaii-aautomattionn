# postMessage listeners — /iam

8 listeners captured at runtime (initScript hook on `addEventListener` +
`window.onmessage`).

| # | Handler / origin check | Action on message | Verdict |
|---|---|---|---|
| 1 | `yn` (TEA/DataRangers AB SDK, `usermono.js`): `gn.some(t => e.origin.indexOf(t) > -1)` | JSON-parses string data; dispatches `vn[type]`; only `tea:openHeatMapCore` → fixed script load | Weak check but no exploitable sink |
| 2 | `readMessage` (shell bridge): exact `e.origin === expected` | forwards payload to bridge | Not vulnerable |
| 3 | `workorder_count` listener: exact origin | updates unread count | Not vulnerable |
| 4 | Slardar telemetry listener | records telemetry | Low impact |
| 5 | Tinet listener | telemetry | Low impact |
| 6–8 | framework/React dev & misc listeners | no security-relevant sink | Not vulnerable |

No listener was found that both (a) validates origin weakly and (b) reaches a
dangerous sink with attacker-controlled data.
