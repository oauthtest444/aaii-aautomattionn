# sinks inventory

| Sink | Location | Input | Verdict |
|---|---|---|---|
| `dangerouslySetInnerHTML.__html` | iam-5771.js | i18n formatter output (static translation) | not attacker-controlled |
| script `src` | usermono.js `loadScriptUrl` | hardcoded `V` + timestamp | not attacker-controlled |
| React text render | IAM tables | API DisplayName/Description | escaped |
| `innerHTML`/`eval`/`document.write` | — | none found on /iam | n/a |
| server sanitizer | workorder conversation | user HTML | strips handlers/dangerous tags |

Detail: `result/client-side/console.byteplus.com/iam/javascript/sinks.md`.
| `dangerouslySetInnerHTML.__html` (message center) | datarangers umi:650398,651671 | notification `thumb_content`/`message_text` | server-controlled, no delivery primitive (Unresolved) |
| docor markdown `dangerouslySetInnerHTML` | datarangers umi:4522115 | static help-doc `Content` | not attacker-controlled |
| `callback` query -> `location.href` | datarangers umi:460535 | same-host enforced by `T()` | not vulnerable |
