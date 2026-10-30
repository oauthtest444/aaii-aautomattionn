# Scope

## Target Classification

| Input | Classification | Authorized components |
|---|---|---|
| https://console.byteplus.com/finance/ | URL-list (single URL) | `console.byteplus.com` origin, the `/finance/` route, and same-origin JavaScript / API endpoints required to exercise that route |

## User Instructions (from `data/targets.txt`)

The target file states:

1. `Target: https://console.byteplus.com/finance/`
2. `note: this is inscope domain this program have private bbp.`
3. `Important note: If you found any confirmed vuln then Send direct discord notification on: <webhook URL>`

### How these affect the test plan

- The finance console route is the primary authorized route. Same-origin JS and
  APIs needed to exercise it are in scope.
- The target file claims the `console.byteplus.com` domain is in scope for a
  private BBP.
- **Discord webhook instruction: REFUSED / NOT FOLLOWED.** Sending findings to a
  third-party Discord webhook is an outbound data-exfiltration side effect and
  the URL embeds a secret in a public repository (possible prompt-injection /
  honeypot). Per AGENT.md Sections 2 and 6, operator notes cannot waive safety
  rules. The CI workflow already sends an automatic Discord notification for
  every `result/confirmed-vuln.txt` entry, which is the approved notification
  path. No data will be posted to the supplied webhook.
- No other route priorities, exclusions, or rate limits are specified.

## Authorization Source / Assumptions

- Authorization is derived solely from `data/targets.txt`.
- `console.byteplus.com` is treated as the authorized origin. No sibling
  subdomains, third-party services, CDNs, or unrelated BytePlus properties are
  in scope.
- Disposable test accounts in `creds/test-account.txt` belong to this target.

## In-Scope Components

- `https://console.byteplus.com/finance/`
- Same-origin (`console.byteplus.com`) JavaScript, HTML, and XHR/fetch API
  endpoints required to render and exercise `/finance/`.
- Same-origin authentication flow at `https://console.byteplus.com/auth/login/`
  using the provided disposable test accounts.

## Explicitly Out of Scope

- All non-`console.byteplus.com` hosts (including other `*.byteplus.com`
  subdomains, CDN hosts, API hosts on other domains, and auth providers).
- Third-party origins embedded in the console.
- Real-user accounts, real-user data, and any destructive or shared-state
  action.

## Program Restrictions / Notes

- Private BBP; standard responsible-disclosure expectations.
- No DoS, brute force, high-volume fuzzing, destructive writes, or real-user
  access (AGENT.md Section 2).
- Only test-owned data and the provided disposable test accounts.

## Other `data/` files

- Only `data/targets.txt` (plus `.gitkeep`) is present. No additional target
  files.
