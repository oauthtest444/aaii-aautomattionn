# VULN-20261031-001: Cross-project authorization bypass on DataFinder common_settings

- Status: Confirmed
- Severity: Low
- Class: IDOR / Broken object-level authorization (read-only)
- Asset: `https://console.byteplus.com/datafinder/api/v1/projects/{project_id}/common_settings`
- Auth context: authenticated console user; two independent test accounts (A: 3000823185, B: 3001021825)
- Discovered: 2026-10-31

## Summary

The DataFinder `common_settings` endpoint returns project configuration for any
`project_id` supplied by the caller. It does not verify that the authenticated
user belongs to the project, and it ignores the project context enforced by all
other project-scoped DataFinder endpoints. Both directions were confirmed:
Account A can read Account B's project 218463 settings and Account B can read
Account A's project 2111833 settings.

## Impact

Low. The endpoint exposes only benign presentation settings. The observed
response contained `custom_color` and `custom_multilang`, with optional fields
`value_quota` and `custom_timezone` reported in earlier testing. No events,
users, dashboards, credentials, or other tenant data were exposed. The endpoint
is read-only; no write was attempted against a foreign project.

This does not meet the high-impact reporting bar, so it is not listed in
`result/confirmed-vuln.txt` and no Discord notification was sent.

## Reproduction

1. Sign in as Account A and open any DataFinder project.
2. Send a GET to
   `/datafinder/api/v1/projects/218463/common_settings?options=custom_multilang,custom_color`
   with headers `x-caller: portal`, `x-finder-project-id: 218463`,
   `x-finder-app-id: 218463`, and the account's CSRF token.
3. The response is HTTP 200 with Account B's project settings.
4. Repeat with Account B and Account A's project 2111833.
5. Control: `/datafinder/api/v1/projects/218463/dashboards/level_list` returns
   `403001 Access denied`, confirming other project endpoints enforce project
   authorization.

## Evidence

- `result/findings/VULN-20261031-001/evidence/requests.txt`

## Remediation

Enforce the same project-membership authorization used by the other
`/projects/{project_id}/...` handlers before returning `common_settings`.
