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
