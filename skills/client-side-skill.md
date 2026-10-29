# Client-Side Vulnerability Automation Skill

## Mission

Find valid, reportable client-side bugs. This file is for automation.

- **Never ask the user anything.** There will be no answer. Ask yourself as a
  top hunter, answer yourself, then act.
- **Main goal:** a reportable bug — attacker-controlled source → application
  code → sensitive sink/action, with missing protection and practical impact.
- **Test one route at a time.**
- **Only unique JS lines and complete flows.** No duplicate testing.
- **Only search/scan JS related to the current UI route.**
- **Practical evidence only.** Never claim confirmed without execution or
  runtime observation.

---

## Inputs

The orchestrator supplies:

- **Authorized scope** from `data/`: domain-only targets or an explicit URL
  list, plus any explicitly authorized components.
- **Route queue** and the current route's canonical URL. Test one route at a
  time.
- **Route-related JavaScript**: URLs, inline scripts, dynamic chunks, workers,
  and source maps loaded or executed by the route.
- **Credentials** from `creds/` when the route requires authentication, plus
  the account's role and ownership context.
- **Vulnerability knowledge** from `vulnebleti/` relevant to the technology,
  route, or bug class.
- **Prior testing inventory** from `result/testing-inventory.json` and
  `result/inventory/`.
- **Chrome DevTools MCP tools** for navigation, debugging, and runtime
  validation.
- **Time budget** and the current elapsed time.
- **Output root**: `result/`.

Validate inputs before testing:

- Reject or skip any route outside the authorized scope.
- Canonicalize the route URL and deduplicate it against the tested inventory.
- Hash JavaScript bodies and skip identical content already tested.
- Confirm the auth context and role; never mix accounts silently.
- If an input is unavailable, proceed with the available inputs, record the
  gap in `result/unresolved.md`, and continue. Never ask the user.

## Preconditions

- Headless Chrome is running and the `chrome-devtools` MCP server is connected.
- The target route is reachable and authorized.
- The route-related JavaScript can be inspected or downloaded.
- A local Python HTTP server can be started for HTML PoCs.
- The current session has enough time remaining to finish the route and write
  evidence. Do not start a long trace with less than ~45 minutes left.

---

## Per-Route Flow


1. **Phase 1 — Source discovery and full tracing.**
2. **Phase 2 — Sink discovery and full tracing.**
3. **Phase 3 — postMessage listener testing.**
4. **Phase 4 — Practical confirmation, self-trigger, escalation.**
5. Save results, update tested state, move to the next route.

**Route-related JS:** scripts loaded/executed by this route, inline scripts,
dynamic imports/chunks, workers, and specific dependencies needed for a trace.
Do not scan unrelated files.

---

## Phase 1 — Source Discovery and Tracing

Run these exact regexes on route-related JS:

```regex
searchParams\.get\([^)]*\)|\.get\(("([^"]*)"|'([^']*)'|`([^`]*)`)\)
```

```regex
(?<![=!<>])(?:\b[A-Za-z_$][\w$]*\s*=\s*)new\s+(?:URLSearchParams|URL)\s*\(\s*(?:(?:window\.)?location\.(?:search|href|hash|pathname)|document\.(?:URL|URLUnencoded|baseURI))\b
```

These regexes **miss many valid sources**. Also manually inspect how the route
reads user-controlled values: `location.search/hash/href/pathname`,
split/decode/parse helpers, URLSearchParams aliases, router hooks
(`useSearchParams`, `router.query`, `route.params`, etc.), `history.state`,
`request.url`, `document.referrer`, postMessage, storage/cookies, and API
responses. Extract every unique user-controlled source.

For each unique source:

- Resolve the parameter key and the object's origin.
- Trace forward through aliases, destructuring, helpers, callbacks, closures,
  transforms, checks, and cross-file calls.
- Inspect **every** meaningful use: DOM, navigation, requests/API, postMessage,
  storage, auth/business actions.
- If callee code is missing, use CDP: breakpoint, step in, inspect paused scope,
  call stack, arguments, return values, and network behavior.
- Record in a source inventory: parameter, file:line, transport, attacker
  control, transforms/validation, destinations.
- If a sink is reached, continue in Phase 2.

---

## Phase 2 — Sink Discovery and Full Tracing

Run these exact regexes on route-related JS:

```regex
(?:window\.)?location\.(?:assign|replace)\s*\(\s*(?![`'"]|\$\{|window\.location\.|location\.|\w+\.href)
```

```regex
(?<![\w$.])(?:window\.|document\.|parent\.|top\.|self\.|frames\[\d+\]\.)?location(?:\.href)?\s*=\s*(?!=)\s*(?![\w$]+(?:\.[\w$]+)*\.href\b)(?![\w$]+(?:\.[\w$]+)*\.toString\(\))(?![`'"]|`\/|""\.concat|null\b|\{)(?!\(null\s*==[\s\S]*?this\.location[\s\S]*?\.toString\(\))(?!\(0\s*,\s*[\w$]+\.[\w$]+\)\s*\()
```

```regex
document\.createElement\((['"])(iframe|object|embed|script)\1\);?
```

```regex
(\beval\s*\(\s*(?![`'"])|new\s+Function\s*\(\s*(?![`'"])|document\.write\s*\(|insertAdjacentHTML\s*\()|\.(?:inner|outer)HTML\b\s*=\s*(?!=)(?!\s*(?:[`'"]|null\b|\w+\.(?:inner|outer)HTML))|\.srcdoc\b\s*=\s*(?!=)(?!\s*(?:[`'"]|null\b))
```

```regex
dangerouslySetInnerHTML\s*=\s*\{\{|dangerouslySetInnerHTML\s*[:=]\s*\{
```

Also manually check other sinks: `document.write`, jQuery `.html()/.append()`,
`v-html`, `bypassSecurityTrustHtml`, `window.open`/router navigation,
`fetch`/XHR/Axios, postMessage sends, storage/cookies, script/iframe/object
`src`, and framework HTML escape hatches.

For every unique sink:

- Breakpoint/instrument and trigger it.
- Inspect stack, scope, arguments, and closures.
- Trace backward to the source.
- Identify controllability, transforms, validation/encoding.
- **If the source was missed in Phase 1, go back to Phase 1 and find how the
  value is user-controlled.**
- Dedupe by complete flow, not variable names.

**Main goal:** trigger the matched sink lines. If the sink needs self-triggering
(for example, API response data inserted into `innerHTML`), simulate it,
confirm self-XSS/DOM XSS, then work out escalation.

---

## Self-Trigger and Escalation

- Confirm self-XSS with a harmless marker.
- Self-XSS alone is a stepping stone. Look for:
  - stored/reflected delivery to other users or admins
  - CSRF/state-changing requests
  - low-privilege action affecting an admin
  - chaining with other bugs (open redirect, postMessage, CSPT, login CSRF,
    prototype pollution, DOM clobbering)
- Report only with concrete delivery and impact evidence.

**XSS / open redirect rule:** if user input reaches an XSS-capable sink with no
HTTP/HTTPS whitelist or protocol validation, test it practically. If execution
is blocked by WAF/CSP/filtering, identify the exact limitation. If only open
redirect is confirmed, report:

```text
Open Redirect: Confirmed
User-controlled dangerous sink: Confirmed
XSS execution: Not practically confirmed
Reason: WAF / CSP / filtering / application behavior
```

Never claim "100% XSS" without practical JavaScript execution.

---

## Phase 3 — postMessage Listener Testing

- On the visited tab, enumerate unique `message` listeners:
  **Sources → Global Event Listeners → message** and route-related JS.
- Dedupe by file:line/handler. Skip already-tested listeners.
- Check `event.origin`, `event.source`, check order, exact-origin matching,
  substring/regex bypasses, and message schema validation.
- Fully trace only listeners with **missing or weak** validation.
- Debug: breakpoint, call stack, message fields/branches, called functions, and
  sinks.
- Send minimal harmless markers such as `PM_TRACE_TEST_12345`, one field at a
  time.
- PoC: prefer `window.open()` to the target; use a local Python HTTP server;
  never use `data:` URLs as the top-level PoC. Verify the effect on the
  authorized target.
- Same-window messages alone do not prove external attacker exploitability.
- No destructive actions. Test-account credentials and cookies may be shown;
  never touch real-user secrets.

---

## Evidence Requirements

For every candidate, save evidence that proves the complete flow:

- Route URL, auth context, and timestamp.
- Source parameter and exact user-controlled transport.
- Relevant JavaScript URL, line, and code snippet.
- Runtime observation: breakpoint location, call stack, paused scope values,
  network request/response, or DOM state.
- Sink reached and the resulting security-relevant action.
- Harmless payload used and the observed execution/effect.
- For XSS: actual JavaScript execution. For open redirect: the final navigation
  target. If XSS execution is blocked, state the exact WAF/CSP/filter limitation
  and do not label it as confirmed XSS.
- Test-account cookies, tokens, and passwords may be shown. Redact real-user
  PII and real-user session data.

A reflected string, a status code, a console error, or a same-window message
alone is not sufficient proof.

## Outputs

Write only under `result/`. Do not invent output locations.

```text
result/client-side/<host>/<route-slug>/
├── javascript/
│   ├── manifest.md          # URL, content hash, loaded-by route, timestamp
│   └── snippets/            # Only the relevant sanitized code excerpts
├── sources.md               # Unique sources and transports
├── sinks.md                 # Unique sinks and file:line references
├── flows.md                 # Source -> sink traces and status
├── listeners.md             # postMessage listeners and validation result
└── route-report.md          # Tests performed, evidence, status, next steps
```

Also update:

- `result/inventory/routes.md`
- `result/inventory/javascript.md`
- `result/inventory/sinks.md`
- `result/inventory/listeners.md`
- `result/testing-inventory.json` (routes, javascript, flows, listeners)
- `result/logs/client-side.log`
- `result/unresolved.md`
- `result/SUMMARY.md`

For each confirmed finding, create:

```text
result/findings/<FINDING-ID>/
├── report.md
├── evidence/
└── payloads/
```

Append only **Confirmed**, high-impact findings to `result/confirmed-vuln.txt`:

- XSS with practical JavaScript execution,
- CSTI with practical execution,
- client-side open redirect that accepts a dangerous `javascript:` URL.

Use statuses: **Confirmed**, **Unresolved**, **Not Vulnerable**, **Out of
Scope**. Never write speculative issues to `confirmed-vuln.txt`.

## Stop Conditions

- The route or asset is outside the authorized scope.
- Chrome/MCP remains unavailable after one safe restart attempt. Write
  `result/BLOCKED.md` and mark affected work **Unresolved**.
- Testing would affect real users, real data, or shared production state.
- The time budget is nearly exhausted: stop starting new traces and finish
  evidence/reports.
- The route is unreachable or has no inspectable JavaScript. Record it and move
  to the next route.
- Never stop to ask the user.

---

## Hunter Mindset

At every decision, ask yourself:

- What can the attacker control?
- How is it delivered to a victim?
- What auth/state is required?
- What does the app trust without validation?
- What exact sink or security-sensitive action is reached?
- What protection is missing or weak?
- Can I prove it right now?
- Can I escalate it (CSRF, low-priv → admin, stored/reflected, chain)?
- Is this a duplicate complete flow?
- Would a security team accept it?

Answer yourself and act.

---

## Duplicate and Scope Rules

- Only unique JS lines, flows, and listener scenarios.
- Do not retest the same JS URL or identical JS body.
- Variable names do not mean the same sink; always trace the value.
- Search regexes only in route-related JS.
- Do not scan unrelated JS. Inspect dependency files only for the specific
  function needed to finish a trace.
- Record tested routes, JS files, flows, and listeners to avoid duplicates.
