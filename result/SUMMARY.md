# Scan Summary

- Target host: console.byteplus.com
- Authorized routes: /datarangers, /datatester, /ark, /ai, /alb
- Auth context: test account A (test-user-123, Account ID 3000823185); account B (testt456, Account ID 3001021825) for cross-account tests.
- Scope note: other byteplus.com subdomains are not explicitly authorized; treated as out of scope per AGENT.md Section 4.
- Assumptions: the "related subdomains" note does not expand authorization beyond console.byteplus.com.
- Status: completed (2026-10-31T21:44:56Z).

## Coverage

- Top-level routes: 5/5 completed.
- Sub-routes: all discovered sub-routes completed (see
  `result/inventory/top-level-routes.md`).
- API routes: 48/48 completed (see `result/inventory/api-routes.md`).
- Subdomains: 1/1 completed (console.byteplus.com).
- Server-side report: `result/server-side/console.byteplus.com/route-report.md`.
- Client-side reports: `result/client-side/console.byteplus.com/<route>/route-report.md`.

## Findings

- VULN-20261031-001 (Low, Confirmed): read-only cross-project IDOR on
  `/datafinder/api/v1/projects/{project_id}/common_settings`. Both A->B and
  B->A return HTTP 200 for the foreign project while a control project endpoint
  returns `403001`. Exposes benign presentation settings only. Re-verified live
  on 2026-10-31T21:44:56Z. Report:
  `result/findings/VULN-20261031-001/report.md`.
  Not added to `confirmed-vuln.txt` (below the high-impact reporting bar); no
  Discord notification.

## Cross-tenant checks (negative results)

- DataFinder: every other tested project-scoped endpoint returned `403001
  Access denied` for the foreign project (project, functions, session replay,
  view config, scenarios, roles, dashboards, AI GC). `current_org` always
  returns the caller's own org even when passed a foreign `project_id`.
- DataTester: foreign org/app access returns 301/302/400; foreign app IDs yield
  org_id 0 with no data.
- Ark: ListApiKeys/GetRawApiKey/ListVaults/GetVault/ListAgents are account-scoped;
  foreign IDs return NotFound. Managed agents not activated, so no test
  credentials could be created.
- Vision AI: AppApps returns only the caller's app.
- ALB: no resources in either account; quota/feature calls are account-scoped.

## Unresolved / not exploitable

- Ark managed-agent sub-routes (sessions/environments/skills/memory/channel)
  could not be exercised because managed agents are not activated for the test
  accounts; no impact shown.
- Client-side missing-origin postMessage listeners on /datarangers and
  /datatester: no sensitive state change, data read, or code execution
  demonstrated; documented as low/unresolved in the route reports.
- Config-driven redirect candidates in /ark: require server-side console config
  control; not demonstrated.

All testing used test-owned resources; no real-user data was accessed.
