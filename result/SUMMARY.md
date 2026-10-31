# Scan Summary

- Target host: console.byteplus.com
- Authorized routes: /datarangers, /datatester, /ark, /ai, /alb
- Auth context: test account A (test-user-123, Account ID 3000823185); account B (testt456, Account ID 3001021825) for cross-account tests.
- Scope note: other byteplus.com subdomains are not explicitly authorized; treated as out of scope per AGENT.md Section 4.
- Assumptions: "related subdomains" note does not expand authorization beyond console.byteplus.com.
- Status: in progress (server-side discovery and core cross-tenant checks; client-side and deeper sub-route coverage pending).

## Findings

- VULN-20261031-001 (Low, Confirmed): read-only cross-project IDOR on
  `/datafinder/api/v1/projects/{project_id}/common_settings`. Both A->B and
  B->A return HTTP 200 for the foreign project. Exposes benign presentation
  settings only. Report: `result/findings/VULN-20261031-001/report.md`.
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

## Coverage status

- Server-side: datarangers, datatester, ark, ai (app list), alb (inventory).
- Client-side: not started for any route.
- Deep sub-routes (Vision AI studio/app workspace, Ark sessions/environments/
  skills/memory/channel, DataFinder analysis tools) remain.

## Next steps

1. Complete server-side inventory and IDOR checks for remaining Vision AI and
   Ark managed-agent sub-routes.
2. Run client-side source/sink and postMessage review per
   `skills/client-side-skill.md` for each sub-route.
3. Re-run any expired-session checks with `x-finder-project-id` and CSRF headers
   present (missing header caused misleading `1503` responses).
4. Update route reports, then write `result/SCAN_COMPLETE` when all routes are
   completed or documented.
