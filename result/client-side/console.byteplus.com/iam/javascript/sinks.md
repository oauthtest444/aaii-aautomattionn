# Sinks reviewed — /iam

| Sink | File | Input | Verdict |
|---|---|---|---|
| `dangerouslySetInnerHTML.__html` | `iam-5771.js` | `o ? o(e,t,n) : e` (i18n formatter output) | Not attacker-controlled (static translation) |
| `innerHTML` / `outerHTML` | — | none found on route | n/a |
| `eval` / `new Function` | — | none on route | n/a |
| `document.write` | — | none on route | n/a |
| script `src` assignment | `usermono.js` (`loadScriptUrl`) | hardcoded `V` + `Date.now()` | Not attacker-controlled |
| `location` assignment | — | none with user input | n/a |
