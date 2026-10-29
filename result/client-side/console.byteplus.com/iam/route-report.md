# Route report — /iam (client-side)

- Date: 2026-10-29
- Account: A (page 1)
- Final URL: https://console.byteplus.com/iam/identitymanage/user
- Sub-routes exercised: `/iam`, `/iam/identitymanage/user`, `/iam/identitymanage/user/*`,
  `/iam/service/attach_role/`
- JS inspected: `iam-main.js`, `iam-5771.js`, `usermono.js`, `slardar.js`,
  `bdms.js`, `rt-main.js`, `1548.*.js`, `Basics.*.js`

## Summary
No client-side vulnerability confirmed. The only weak-origin postMessage
listener (`yn` in the TEA/DataRangers AB SDK, `usermono.js`) does not give an
attacker control of any sink: the sole dispatch type it registers
(`tea:openHeatMapCore`) loads a hardcoded script URL. All other `message`
listeners use exact-origin equality. No DOM XSS sink reached by
attacker-controllable sources was identified on this route.

## Tests
| Test | Input | Result | Verdict |
|---|---|---|---|
| postMessage listener enumeration | initScript hooking `addEventListener('message')` + `window.onmessage` | 8 listeners captured | informational |
| `yn` origin check | `gn.some(t => e.origin.indexOf(t) > -1)` (substring match) | Weak by design, but only dispatch type `tea:openHeatMapCore`; handler uses fixed `V` script URL, `e.data.app_id` only gates load | Not exploitable |
| `readMessage` / workorder listener | postMessage with spoofed origin | Exact `origin ===` check | Not vulnerable |
| `dangerouslySetInnerHTML` in iam-5771 | `createElement("span",{dangerouslySetInnerHTML:{__html:o?o(e,t,n):e}})` | i18n/trans component; input is static translation string, not user data | Not exploitable |
| attach_role reflection | `ServiceName=ZZMARKER123` | Not reflected; page shows "no associated role" | Not vulnerable |
| stored HTML in DisplayName/Description | `UpdateUser` with benign + update fields | Server accepts/updates text; mass-assignment fields (`AccountId`,`IsRoot`) ignored; table render escapes text | Not vulnerable (see ledger 15) |

## Files
- `javascript/manifest.md`
- `javascript/sources.md`
- `javascript/sinks.md`
- `javascript/flows.md`
- `javascript/listeners.md`
