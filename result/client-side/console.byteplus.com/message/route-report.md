# Route: /message (message center)

- Auth: account A (test-user-123, Account ID 3000823185)
- Tested: 2026-10-29T09:23Z
- JS reviewed (saved under `javascript/`): `main.5bc4931c.js`
  (sha256 5c953209...), `337.8f0884ae.js`, `builder-runtime.e7955615.js`,
  async chunks `264`, `286`, `426`, `976`, `message_innermsg.f9a63668.js`.
- Sub-routes: `/message/innermsg` (inner message list/detail).

## Sources
- `location.search` / `location.hash` used only by the legacy `querystring`
  lookup in the shared SDK; values feed telemetry (`query`, `url`) and i18n
  locale selection, not DOM HTML.
- `postMessage` in `message_innermsg` (`readMessage` refresh) requires exact
  same-origin (`location.protocol//location.host`) before acting.
- `postMessage` in the embedded debugger SDK listeners (`devtool:web:ready`,
  `devtool:web:ssid`) accept any origin and echo SDK info/log/event back to the
  sender. Impact: the debugger panel only loads in debug mode, exposes no
  session secret or DOM HTML sink, and requires the victim to have the debugger
  open. **Not Vulnerable / low impact.**

## Sinks
- `innerHTML` occurrences in `main.5bc4931c.js` are static debugger container
  templates (`'<div id="debugger-applog-web">...'`), not attacker-controlled.
- Message title/body rendering uses React text nodes; no
  `dangerouslySetInnerHTML` in any `/message` bundle.
- Async `message_innermsg` listener is origin-checked and only refreshes message
  state.

## Result
No confirmed client-side vulnerability. No source→HTML/exec sink with
attacker-controlled data on `/message`.
