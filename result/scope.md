# Scope and Authorization

## Target entries
- `account.ui.com` — **domain-only target** (from `data/targets.txt`).

## User Instructions (restated)
- Discover all interesting and unique UI routes and API endpoints on `account.ui.com`.
- Use Chrome DevTools MCP for discovery.
- Visit routes one-by-one, wait 5–10 seconds for JavaScript to load, then test both
  client-side and server-side issues on that single route before moving on.
- Maintain a progress report: total routes discovered, tested, pending, and which
  routes are which.
- Read `skills/client-side-skill.md` and `skills/server-side-skill.md` and follow
  their methodologies exactly.
- Create two test accounts on this subdomain and save credentials for testing.
  If account creation is not possible, test only unauthenticated endpoints.
- If a confirmed vulnerability is found, send a Discord notification to the
  webhook provided in `data/targets.txt`.
- Do not ask questions; decide independently.

## Authorization source / assumptions
- `data/targets.txt` is the authorization source for this repository run.
- Scope is limited to `account.ui.com` and same-origin components required to
  exercise that domain (its own JS/API under `account.ui.com`).
- No sibling subdomains, third-party origins, CDNs, acquisitions, or partner
  systems are authorized unless explicitly listed.
- **Backend exception (documented assumption):** the `account.ui.com` SPA uses
  `https://sso.ui.com` (and `account.svc.ui.com`, `geo.svc.ui.com`,
  `fabric.svc.ui.com`, `ecomm.svc.ui.com`) as its own API backends. Those endpoints
  were exercised **only** as required to test the account.ui.com routes. No
  unrelated endpoints on those hosts were tested and no separate findings are
  claimed for them.

## In-scope components
- `https://account.ui.com/` and same-origin routes/APIs under that host.

## Out-of-scope components
- Any other subdomain of `ui.com`, other `ui.com` hosts, third-party OAuth/IdP
  endpoints (test only the redirect/flow behavior initiated from account.ui.com),
  CDNs, and any asset not under `account.ui.com`.
- Discovered out-of-scope assets are recorded in `result/out-of-scope.txt`.

## Program restrictions / safety
- Follow `skills/AGENT.md` Section 2: no DoS/load/brute force, no destructive
  writes, no real-user data access, test-owned data only, harmless payloads.
- Account creation: only standard, legitimate signup flow if permitted by the
  site; do not bypass verification or anti-automation controls. If signup cannot
  be completed legitimately, test unauthenticated endpoints only.
- Credentials in `creds/test-account.txt` belong to a different target
  (console.byteplus.com) and are **not** valid for `account.ui.com`; they are not
  used here.
