# Listeners — /datarangers

| Handler | Origin check | Sink | Verdict |
|---|---|---|---|
| `main.e9a0251e.js:299513` serviceWorker `message` | n/a (SW) | static-resource cache message | Not sensitive |
| `umi:1187413` setImmediate polyfill `message` | n/a | internal callback | Not sensitive |
| `umi:198102` MessageChannel `onmessage` | n/a | scheduler | Not sensitive |
| `main.ef966d36.js:145950/146078` setImmediate polyfill | n/a | internal callback | Not sensitive |

No application `window.addEventListener("message", ...)` handler with weak origin validation found on this route.
