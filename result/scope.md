# Scope

## Target Entries and Classification

`data/targets.txt`:

```text
https://launch.sptpub.com/brand/2599624589818605571/sportsbook/launch?lang=tr&theme=DARK

find and test all routes on launch.sptpub.com
```

- Classification: URL-list target plus an operator instruction.
- Primary route: `https://launch.sptpub.com/brand/2599624589818605571/sportsbook/launch?lang=tr&theme=DARK`
- Authorized host: `launch.sptpub.com` (same-origin routes and API endpoints needed to exercise the launch flow are in scope).

## User Instructions and Effect on Test Plan

- Operator note instructs: "find and test all routes on launch.sptpub.com".
- This authorizes enumeration and testing of routes on the `launch.sptpub.com` host only.
- It does **not** authorize sibling domains, other subdomains, third-party origins, CDNs, or partner systems.
- Test plan: enumerate launch.sptpub.com routes, consume route-related JS, trace client-side sources/sinks, then extract and test same-origin API endpoints.

## Authorization Source / Assumptions

- Authorization is derived from the repository's `data/targets.txt` scope file, per `skills/AGENT.md`.
- Only the origin `https://launch.sptpub.com` and its explicitly authorized components are tested.
- No real-user data is accessed. Test artifacts are harmless markers only.
- The disposable test account in `creds/test-account.txt` belongs to a different product (byteplus console); it is not assumed valid for this target.

## In-Scope Components

- `https://launch.sptpub.com/` and paths under it discovered from the launch flow.
- Same-origin JavaScript, API calls, and static assets loaded by in-scope routes.

## Explicitly Out-of-Scope Components

- Any other `*.sptpub.com` host, sibling domains, acquisitions, partner systems.
- Third-party origins (analytics, fonts, CDNs) beyond passive observation.
- Real-user accounts, data, sessions, or PII.
- Destructive/DoS/brute-force testing.

## Program Restrictions / Notes

- No program policy file beyond `data/targets.txt` was present.
- Standard rules apply: no DoS, no brute force, no destructive writes, no real-user harm, practical evidence only.
- `TEST_NOTIFICATION` directive absent; normal testing workflow applies.
