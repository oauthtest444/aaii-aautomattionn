# Sinks — /datarangers

| Sink | Location (offset) | Input | Verdict |
|---|---|---|---|
| `dangerouslySetInnerHTML.__html` | umi:650398,651671 | `thumb_content` / `message_text` from GET /datarangers/api/user/notification | Server-controlled notification body; no user-controlled write path found. Notification list was empty for the test account. Unresolved (needs a delivery primitive). |
| `docor` markdown `dangerouslySetInnerHTML` | umi:4522115 | `Content` from GET `/doc` help API (static help docs) | Server/static content, not user input. Not vulnerable. |
| `location.href` / `location.replace` | umi:240243,240656,240969,460535,2139244,2827169,2827504; main.e9a0251e.js:270325 | auth SDK `redirect_url`, route strings, `callback` query | `callback` is forced same-host by `T()`; others are config/route. No `javascript:` acceptance found. Not vulnerable. |
| `createElement("script")` | umi:133540,137135,137280,1235788,1338109; main.e9a0251e.js:3153,86044,105159,153173,242390 | hardcoded UDesk/CDN/window-loader URLs | Not attacker-controlled. |
| `innerHTML` | umi:727308,728032,3808294,4501413...; main.e9a0251e.js:121663,200336,301254 | library-internal (antd icon, DOMPurify, styled-components, GTM) | Not attacker-controlled. |
| postMessage listeners | umi:1187413 (polyfill), main.e9a0251e.js:299513 (service worker) | n/a | Telemetry/SW only, no sensitive sink. |

No `eval`/`new Function` on user input; no `document.write` on user input found.
