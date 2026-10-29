# sinks inventory

| Sink | Location | Input | Verdict |
|---|---|---|---|
| `dangerouslySetInnerHTML.__html` | iam-5771.js | i18n formatter output (static translation) | not attacker-controlled |
| script `src` | usermono.js `loadScriptUrl` | hardcoded `V` + timestamp | not attacker-controlled |
| React text render | IAM tables | API DisplayName/Description | escaped |
| `innerHTML`/`eval`/`document.write` | — | none found on /iam | n/a |
| server sanitizer | workorder conversation | user HTML | strips handlers/dangerous tags |

Detail: `result/client-side/console.byteplus.com/iam/javascript/sinks.md`.
