# listeners inventory

| Route | Handler | Origin check | Sink | Verdict |
|---|---|---|---|---|
| /iam | `yn` (TEA AB SDK) | substring `indexOf` | fixed script load (`tea:openHeatMapCore`) | weak but not exploitable |
| /iam | `readMessage` | exact | bridge | not vulnerable |
| /iam | `workorder_count` | exact | unread count | not vulnerable |
| /iam | slardar | n/a | telemetry | low impact |
| /iam | tinet | n/a | telemetry | low impact |
| /iam | misc (3) | n/a | none | no security sink |

Detail: `result/client-side/console.byteplus.com/iam/javascript/listeners.md`.
