# Session Metadata

- Start (UTC): 2026-10-29T14:25:36Z
- Repository: ai-automation
- Target(s): https://launch.sptpub.com/brand/2599624589818605571/sportsbook/launch?lang=tr&theme=DARK
- Operator note: "find and test all routes on launch.sptpub.com" (in-scope host only)
- Agent/model: opencode / opencode/deepseek-v4.1-flash-free
- Environment: GitHub Actions ubuntu-latest, Node v22.23.4, Python 3.14.4
- Chrome: Google Chrome 156.0.8078.73 (headless), DevTools at http://127.0.0.1:9222
- Target state: decision=reset, target_hash=5691292fdec3610b1338376c2a70f4f90a09761073d6ae3a108d38206a0ca101
- Tools verified: opencode, curl, git, node, npx, python3, google-chrome-stable; chrome-devtools MCP reachable (list_pages OK)

## Continuation Run — 2026-10-29T22:36:47Z

- Run ID: 40967060851 (schedule)
- Target state: decision=preserved; target_hash=5691292fdec3610b1338376c2a70f4f90a09761073d6ae3a108d38206a0ca101
- Agent/model: opencode / opencode/deepseek-v4.1-flash-free
- Environment: GitHub Actions ubuntu-latest, Node v22.23.4, Python 3.14.4, Chrome 156 headless
- Chrome DevTools MCP: reachable (list_pages OK)
- Resume: prior VULN-20261029-001 preserved; continue untested work only

### Continuation end — 2026-10-29T22:42:30Z

- No new findings; preserved VULN-20261029-001.
- Bounded route/API probes only; no destructive or out-of-scope testing.
