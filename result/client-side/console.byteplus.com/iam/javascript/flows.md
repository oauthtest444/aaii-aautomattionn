# Source→sink flows — /iam

## F1 — postMessage → AB SDK `yn` → script load (checked)
`window.message` → `yn(e)` → `gn.some(origin.indexOf)` (weak substring) →
dispatch `vn[type]` → `tea:openHeatMapCore` handler:
`loadScriptUrl({event:e, url: V + ".js?query=" + Date.now()})`.
- Attacker controls `type`, `payload`, `e.origin` (spoofable only if an allowed
  origin substring matches; `gn` contents are known console origins).
- Sink URL is fixed (`V`); no attacker-controlled path/query.
- **Not exploitable.**

## F2 — profile fields → table render (checked)
`GetUser`/`ListUsers` → `DisplayName`, `Description` → React table cells.
- React escapes text; HTML payload requires event handler to execute.
- `UpdateUser` with HTML-ish payload was WAF-blocked earlier; benign update
  persists raw text but renders escaped.
- **No XSS.**

## F3 — attach_role `ServiceName` reflection (checked)
`/iam/service/attach_role/?ServiceName=<x>` → request to
`GetServiceLinkedRoleTemplate` → page renders "no associated role".
- Marker not reflected. **Not vulnerable.**
