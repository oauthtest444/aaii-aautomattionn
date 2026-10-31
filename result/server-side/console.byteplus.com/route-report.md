# Server-Side Route Report — console.byteplus.com

Tested with account A (`test-user-123`, Account ID `3000823185`, org
`2100230837`, project `2111833`) and account B (`testt456`, Account ID
`3001021825`, org `26172`, project `218463`). Both accounts are test-owned.

## /datarangers (DataFinder / DataRangers)

- Org-scoped APIs (`/datarangers/api/org/{org_id}/{get,user/get,user/features,app/list,role/list}`)
  reject foreign org `26172` with `400 Organization does not exist`; user/info
  and management paths return 404.
- `/datafinder/api/v1/current_org?project_id=218463` returns the caller's own
  org (no leak).
- `/datafinder/api/v2/org/26172/data_export/statistics` returns a generic 400.
- Project-scoped DataFinder APIs for foreign project `218463` return `403001
  Access denied`: `project`, `functions`, `session_replay/status`,
  `view/config`, `scenarios/label/config`, `roles`, `dashboards/level_list`,
  `ai/gc/config`, `ai/gc/agent/list`, `ai/gc/support_skills`.
- `GET /datafinder/api/v1/projects/{project_id}/common_settings` lacks project
  authorization: A can read B's project `218463` and B can read A's project
  `2111833` (HTTP 200). Only benign presentation settings are returned
  (`custom_color`, `custom_multilang`, `value_quota`, `custom_timezone`,
  `data_audit.enable_strict_verify`, `ssid_alias`, `client_ip_forbidden`,
  `spider`, `embed_report.safe_domain`, `finder_query_trigger_type`,
  `is_support_weekend_option`, `record_query_log`). `event_quota` is rejected
  as invalid.
- Write attempt `POST .../projects/218463/common_settings/custom_color` (then
  revert) returns `403001`, so writes are authorized correctly.
- Status: Confirmed low-impact read-only IDOR (VULN-20261031-001). All other
  tested endpoints: Not Vulnerable.

## /datatester

- Account A has no DataTester contract (404 on user_info); account B has
  read-only demo data.
- Foreign org/app access returns 301/302/400: `access/api/v3/app/list?org_id=`
  (302), `permission/api/v3/orgs/{org_id}/user_info` (400),
  `experiment/api/v3/app/{app_id}/experiment` (301),
  `experiment-template/...` (301), `metric/...` (301).
- Foreign `app_id` on `current_app_info`/`function_control_info` yields
  `org_id 0` and default flags, no data leak.
- Status: Not Vulnerable.

## /ark

- `ListApiKeys`, `GetRawApiKey`, `ListVaults`, `GetVault`, `ListCredentials`,
  `ListAgents` are account-scoped; foreign IDs return NotFound
  (`InvalidVault.NotFound`). `ListOAuthProviders` is a public catalog.
- `CreateCredential` could not be exercised because managed agents are not
  activated for the test accounts (documented unresolved, no impact shown).
- Status: Not Vulnerable on tested endpoints; managed-agent surface unresolved.

## /ai (Vision AI)

- `POST /api/top/cv_console/2025-09-16/AppApps` returns only the caller's apps
  (A `100051380`, B `100047641`).
- Status: Not Vulnerable.

## /alb

- No ALB resources exist in either test account.
- `DescribeLoadBalancers`, `InnerGetAccountFeatures`, `InnerGetAccountQuota`
  are account-scoped.
- Status: Not Vulnerable.

## Notes

- Missing CSRF header (`x-csrf-token`) caused misleading `1503` responses on
  some DataFinder calls; those were re-tested with the header present.
- All testing used test-owned resources; no real-user data was accessed.
