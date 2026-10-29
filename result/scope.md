# Scope and Instructions

## Authorization source
`data/targets.txt` — URL-list target: top-level routes for `console.byteplus.com`.
These are the only authorized assets. Same-origin JS/API required to exercise
those routes is in scope when covered by the program; no other domains,
subdomains, third-party services, or infrastructure are authorized.

## User instructions (from data/targets.txt)
- Test all listed top-level routes one by one.
- For each top-level route: visit it, extract all sub-routes under it, test each
  sub-route individually for client-side bugs first, then for server-side bugs.
- Example: under `/dts`, if 5 unique sub-routes exist, visit each one; test each
  for client-side bugs, then server-side bugs; then move to the next top-level
  route.
- Continue until all top-level routes have been fully tested.
- Effect on plan: route-by-route, client-side then server-side, breadth across
  all listed routes, depth within each route's discovered sub-routes.

## In-scope components
- `https://console.byteplus.com/` and the explicitly listed top-level routes in
  `data/targets.txt` (86 entries).
- Same-origin JavaScript, XHR/fetch APIs, and sub-routes discovered while
  exercising those listed routes.

## Out of scope
- Other domains/subdomains, third-party services, CDNs, acquisitions, partner
  systems, internal networks, cloud metadata, localhost.
- Real-user data/accounts and destructive or disruptive testing.

## Program restrictions / assumptions
- Use only the disposable test accounts in `creds/test-account.txt`.
- No DoS/load/fuzz/brute force, no real-user access, no destructive writes.
- Evidence must be practical and reproducible; confirmed findings only.
- Note: `creds/test-account.txt` lists account A (email) and account B
  (username `testt456`). Roles/ownership are not stated; determine at login.
- `TEST_NOTIFICATION=true` / `MODE: notification-test` not present, so normal
  testing applies.
