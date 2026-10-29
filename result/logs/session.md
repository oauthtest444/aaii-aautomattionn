# Session Metadata

- Start time (UTC): 2026-10-29T10:16:12Z
- Run ID: 40856058415
- Event: workflow_dispatch
- Resume decision: `reset` (target hash changed)
- Target host: console.byteplus.com
- Authorized assets (from data/targets.txt):
  - https://console.byteplus.com/waf/overview
  - https://console.byteplus.com/finance
  - https://console.byteplus.com/user
  - https://console.byteplus.com/beian
  - https://console.byteplus.com/message
  - https://console.byteplus.com/workorder/list/
- Agent/model: opencode / opencode/deepseek-v4.1-flash-free
- Environment: GitHub Actions runner, linux, headless Chrome
- Tool versions:
  - node v22.23.4
  - python 3.14.4
  - curl 8.18.0
  - Google Chrome 156.0.8078.73
- MCP: chrome-devtools connected (browser-url http://127.0.0.1:9222), list_pages OK
- Test accounts: `creds/test-account.txt` (accounts a and b; login https://console.byteplus.com/auth/login/)

## Continuation 2026-10-29T10:43Z

- Resume decision: `preserved` (target hash unchanged)
- Prior state: `result/` was reset at 10:15Z for this target; no inventory or findings
  were written before the watchdog restart. Starting testing from scratch within
  the preserved run.
- MCP: chrome-devtools connected, Chrome 156.0.8078.73, DevTools at
  http://127.0.0.1:9222.

## Continuation 2026-10-29T11:06Z (run 40862670676)

- Resume decision: `preserved` (target hash unchanged).
- Chrome DevTools MCP reachable at http://127.0.0.1:9222; fresh browser (about:blank).
- Prior-run history preserved in `result/logs/opencode.log` (extensive recon and
  negative tests). Continuing from documented state; will checkpoint verified
  negatives into inventory and focus on untested surfaces: `/user` redirectURI
  open-redirect, `/message` person/robot/org/export-task sub-routes, remaining
  `/finance` sub-routes, and update/contact mass-assignment.
- Test accounts a (3000823185) and b (3001021825).

## Finalization 2026-10-29T11:22Z

- Confirmed VULN-20261029-001 (open redirect, redirectURI `/%09/host` and
  `/%0a/host`); `javascript:` escalation verified impossible (HTTP 403).
- Recorded server-side negatives: finance `PayerID` is session-scoped; message
  `GetInMailInfo` is session-scoped; ticket cross-account read/write blocked;
  ticket/`UpdateTicket` mass assignment inert.
- `/beian` returns 404 for the test accounts; `/waf/overview` remains
  unresolved pending WAF service-role authorization.
- Wrote `result/SUMMARY.md`; `result/confirmed-vuln.txt` left header-only
  because the confirmed open redirect does not meet the Section 9 bar.
