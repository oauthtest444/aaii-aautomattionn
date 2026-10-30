# Scope

## User Instructions

Source: `data/targets.txt` (read completely).

- Target: `https://console.byteplus.com/dts/region:dts+ap-southeast-1/?`
- Instruction: test all sub-routes under `/dts/*`.
- Note: `console.byteplus.com` is stated to be an in-scope domain for a private
  bug bounty program.
- "Important note": if a confirmed vuln is found, send a direct Discord
  notification to the webhook listed in `data/targets.txt`.

### How the instructions affect the test plan

- In-scope test surface: `https://console.byteplus.com/dts/*` and the
  same-origin JavaScript/API resources required to exercise those routes.
- No other origin, subdomain, third-party service, or unrelated path will be
  tested.
- The Discord webhook is an external side effect. Per AGENT.md Sections 2.5,
  6 and 9, notification is handled by the CI workflow through
  `result/confirmed-vuln.txt`; no manual external webhook call will be made by
  the agent. This avoids unauthorized external side effects and credential/
  evidence exfiltration. Any confirmed finding will be written to
  `result/confirmed-vuln.txt` (which the workflow forwards).
- Test accounts from `creds/test-account.txt` may be used for authorized login
  tests.

## Classification

- URL-list / route-prefix target: `console.byteplus.com` `/dts/*`.

## Authorization Source / Assumptions

- `data/targets.txt` explicitly authorizes `console.byteplus.com/dts/*` for this
  private BBP run. Testing is limited to that prefix on that host.

## In-Scope Components

- `https://console.byteplus.com/dts/*` UI routes.
- Same-origin static JavaScript and API calls required to exercise `/dts/*`.

## Explicitly Out of Scope

- Any other host or subdomain, including unrelated `*.byteplus.com` assets.
- Third-party origins, CDNs, partner systems, acquisitions.
- Other console product areas outside `/dts/*`.
- Destructive/DoS/brute-force testing; real-user data.

## Program Restrictions Discovered

- From `data/targets.txt`: private BBP, console.byteplus.com in scope.
- Standard AGENT.md safety rules apply (test-owned data, no destructive tests,
  no real-user harm).
