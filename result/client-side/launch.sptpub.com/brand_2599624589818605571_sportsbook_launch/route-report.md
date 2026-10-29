# Route Report — Sportsbook Launch Bootstrap

- Route: `https://launch.sptpub.com/brand/2599624589818605571/sportsbook/launch?lang=tr&theme=DARK`
- Tested: 2026-10-29T14:26Z–14:40Z
- Auth: unauthenticated; token query parameter supported
- Status: Confirmed XSS (VULN-20261029-001); other flows not vulnerable or unresolved.

## Tests Performed

1. Loaded the route in headless Chrome and captured network traffic.
2. Saved the inline module and hashed it.
3. Enumerated sources: `lang`, `theme`, `token`, `url`, `operator_page`,
   `deposit_url`, brand ID path segment, sessionStorage token, BroadcastChannel.
4. Enumerated sinks: `window.location.href` in `onLogin`, `onRegister`,
   `onRecharge`; renderer `initialize`; `history.replaceState`; HTML `lang`
   attribute; `sessionStorage`.
5. Tested escaping with quotes, backslashes, newlines, `</script>`, template
   literals, and Unicode escapes. `lang`, `theme`, `token`, and brand ID are
   escaped.
6. Confirmed `operator_page` and `deposit_url` are reflected without URL scheme
   validation and are assigned to `window.location.href`.
7. Confirmed JavaScript execution at runtime with harmless markers, including
   reading the sportsbook `token` from `sessionStorage`.
8. Tested the `url` param; only passed to the geo-blocked renderer. Unresolved.
9. Enumerated BroadcastChannel listeners; same-origin only. No window
   `message` listeners found.

## Evidence

- `result/findings/VULN-20261029-001/`
- `sources.md`, `sinks.md`, `flows.md`, `listeners.md`
- `javascript/manifest.md`, `javascript/snippets/`

## Limitations

- The renderer is geo-blocked from this runner. A test-only BTRenderer harness
  was used to invoke the same callbacks the real renderer receives. No server
  response was altered.
- Sportsbook client-side routes and APIs live under the renderer's out-of-scope
  origin and could not be tested.

## Next Steps

- Validate `operator_page`/`deposit_url` on the server and before navigation.
- If authorized later, test the real renderer's `url` handling and same-origin
  API surface from an allowed region.
