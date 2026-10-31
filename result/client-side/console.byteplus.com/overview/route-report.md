# Client-Side Route Report — /ark/region:ap-southeast-1/overview

Status: completed
Result: Not Vulnerable

## Method

- Loaded the route in Chrome DevTools MCP and waited for DOM/network readiness.
- Deduplicated loaded scripts by SHA-256: 34 unique bundles (~4.6 MB), shared by
  all `/ark/*` routes.
- Ran the exact regexes from `skills/client-side-skill.md` against all unique
  bundles (counts in `result/inventory/javascript.md`).
- Traced each unique source (`location.search/hash/pathname`, `URLSearchParams`)
  forward and each sink backward with the DOM/network evidence.

## Findings

- No URL/hash-derived value reaches `location.assign/replace`, `location.href`,
  `eval`, `new Function`, `document.write`, `innerHTML`, `srcdoc`, or
  `dangerouslySetInnerHTML` with attacker control.
- `createElement('iframe'|'script'|'object'|'embed')` matches are analytics/vendor
  SDK code using fixed destinations.
- `postMessage` listeners in the analytics bundle check `event.origin` against an
  SDK-configured allowlist. The only page-reachable handler
  (`tea:openHeatMapCore`) loads a fixed CDN script; no navigation, DOM write, or
  authenticated request is performed with message data. A cross-origin message
  PoC produced no security-relevant effect.
- No DOM XSS, open redirect, or postMessage-driven action was confirmed.

## Conclusion

Not Vulnerable. No evidence artifact required.
