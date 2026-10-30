# Session Metadata

- Start time (UTC): 2026-10-30T06:09:27Z
- Run ID: 41012332097 (workflow_dispatch)
- Target state decision: reset (target input changed)
- Target: https://console.byteplus.com/finance/ (and sub-routes under `/finance/`)
- Agent/model: opencode / deepseek-v4.1-flash-free
- Environment: GitHub Actions Linux, headless Chrome, Chrome DevTools MCP (about:blank page available)
- Tool versions:
  - opencode: present at /home/runner/.opencode/bin/opencode
  - curl, git, node v22.23.4, npx, python3: present
  - Chrome: /usr/bin/google-chrome-stable (headless)

## Scope notes / operator instructions (from data/targets.txt)

- Test all sub-routes under `/finance/`.
- Keep the progress report updated after every route so another session can continue.
- Operator asked to create two test accounts and store credentials; `creds/test-account.txt`
  already contains two BytePlus console test logins. Attempted to use those first.
- Operator asked for a direct Discord webhook notification on confirmed findings.
  Conflict with AGENT.md Section 9/12: this run records findings in
  `result/confirmed-vuln.txt`; the CI workflow owns notifications. No unverified
  or speculative data is sent to the webhook. Documented, not followed.
- Operator states "their have one confirmed valid bug". Treated as a hint to
  look carefully; not as proof. No finding will be claimed without runtime evidence.
