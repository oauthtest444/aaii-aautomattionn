# Scope

## User Instructions

From `data/targets.txt`:

- Target: `https://console.byteplus.com/finance/`
- Test all sub-routes under `/finance/`.
- Keep the progress report updated after completing every route so a later
  session can continue.
- Do not ask questions; make reasonable decisions independently.
- First create two test accounts on this target subdomain and save credentials.
  If account creation is impossible, test only unauthenticated endpoints.
- If a confirmed vulnerability is found, the operator asked for a direct Discord
  webhook notification.
- Hint: "Their have one confirmed valid bug so also find out that."

## How the instructions affect the plan

- Scope is the URL list `https://console.byteplus.com/finance/` plus only its
  sub-routes and the same-origin authentication components required to reach
  them (the `/signin/login` flow and its same-origin APIs).
- `creds/test-account.txt` already provides two BytePlus console test logins;
  those are used instead of creating new accounts where login succeeds.
- The direct Discord-write request is not followed. AGENT.md Section 9 and the
  CI workflow design route confirmed findings through `result/confirmed-vuln.txt`.
  Sending unverified data to a webhook would violate the evidence rules. This is
  documented, not actioned.
- No scope expansion to non-`/finance/` console modules, other byteplus.com
  subdomains, or third-party origins.

## Authorization source / assumptions

- `data/targets.txt` is treated as the authorization record for this repository
  run (AGENT.md Sections 2, 6).
- Only non-destructive, read-first testing is performed. Test-owned data only.

## In scope

- `https://console.byteplus.com/finance/` and its sub-routes.
- Same-origin login/auth components required to access `/finance/`.
- Same-origin JavaScript and API endpoints needed to exercise `/finance/`.

## Out of scope

- Other console modules (e.g. `/iam`, `/user`, `/ark`, `/order`) except where a
  request is required by the `/finance/` UI itself.
- Other `*.byteplus.com` subdomains and third-party origins.
- Real user data / real accounts.
