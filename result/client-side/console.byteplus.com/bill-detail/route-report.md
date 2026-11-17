# /finance/bill/detail

Status: completed

- Source regex match count: 11 (pattern 1), 0 (pattern 2)
- Sink regex match count: 2 (location assign/replace), 4 (location.href assignment), 1 (createElement iframe/object/embed/script), 1 (eval/innerHTML/document.write family), 0 (dangerouslySetInnerHTML)
- Matched sources: shared finance bundle `main.40edfafd.js` — `URLSearchParams` keys `hiddenNavbar` (navbar sync), `user_locale`/`csrfToken` from storage (not URL), `csrfToken` header injection
- Matched sinks: `main.40edfafd.js` `location.replace` inside `secureDomains` + `http` protocol allowlist (open-redirect guarded); `document.createElement('script')` in config-driven loader; `textarea.innerHTML = JSON.stringify(config)` (stringified config)
- Interesting relationships: no URL-controlled source reaches a navigation or HTML/eval sink. `hiddenNavbar` only toggles navbar state. CSRF token read from cookie storage, not attacker URL.
- Potential real vulnerability: none confirmed; matched sink paths are guarded or non-user-controlled.
- Evidence: bundle inspection and live route network/DOM observation on authenticated account A.
- Limitation: shared finance bundle deduplicated across all finance sub-routes; no `data:`-URL or postMessage surface on these routes.
- Status: completed
