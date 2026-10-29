# Flows — Launch Bootstrap

## Flow 1 — `operator_page` / `deposit_url` -> `window.location.href` (candidate)

1. Source: request query `operator_page` (and `deposit_url`).
2. Server reflects the value into the inline module:
   - `const operatorPage = "<value>";`
   - `const depositUrl = "<value>";`
   Values are JSON-escaped, so the JavaScript string itself cannot be broken.
3. The values are passed to the renderer:
   ```js
   onLogin() { if (operatorPage) window.location.href = operatorPage; },
   onRegister() { if (operatorPage) window.location.href = operatorPage; },
   onRecharge() {
     window.location.href = depositUrl ? depositUrl : operatorPage;
   },
   ```
4. The renderer invokes these callbacks on login/register/recharge UI actions.
5. If the value starts with `javascript:`, assigning it to `location.href`
   executes script in the `launch.sptpub.com` origin, where the sportsbook
   `token` is stored in `sessionStorage`.
6. If the value is `https://attacker.example`, clicking the action performs an
   open redirect.

Status: Confirmed (VULN-20261029-001). Runtime confirmation via harness-executed
`onLogin`/`onRecharge` callbacks; `javascript:` executed and read the
sessionStorage token.

## Flow 2 — `token` query param -> sessionStorage -> renderer

1. `token` is reflected into `let token`.
2. If truthy, it is stored with `sessionStorage.setItem("token", token)` and
   broadcast on `token-sync`.
3. Passed to `BTRenderer.initialize({ token })`.
4. No direct sink in the launch page; renderer behavior unavailable (geo-blocked).
5. A crafted launch URL can pre-seed a victim's session token (session fixation
   / login CSRF) if the renderer accepts it. Unresolved due to renderer geo-block.

## Flow 3 — `url` query param -> renderer config

1. `url.searchParams.get("url")` -> `sportsbookUrl`.
2. Passed as `url` to `BTRenderer.initialize`.
3. Renderer behavior unavailable (geo-blocked). Potential open redirect if the
   real renderer navigates to this value. Unresolved.

## Flow 4 — `lang`, `theme`, `brandId` reflection

- All are JSON-escaped. Attempts with quotes, backslashes, newlines, `</script>`,
  template literals, and Unicode escapes produced escaped output and no
  breakout. Status: Not Vulnerable.
