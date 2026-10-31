# API Route Inventory

| Method | Path | Parent Top-Level Route | Auth | Status | Summary |
|---|---|---|---|---|---|
| GET | /datarangers/api/config | /datarangers | session | pending |  |
| GET | /datarangers/api/org/list | /datarangers | session | pending |  |
| GET | /datarangers/api/org/{org_id}/get | /datarangers | session | completed | Cross-tenant: 400 "集团不存在" for foreign org. |
| GET | /datarangers/api/org/{org_id}/user/get | /datarangers | session | completed | Org-scoped, foreign org rejected. |
| GET | /datarangers/api/org/{org_id}/user/features | /datarangers | session | completed | Org-scoped, foreign org rejected. |
| GET | /datarangers/api/org/{org_id}/app/list | /datarangers | session | completed | Org-scoped, foreign org rejected. |
| GET | /datarangers/api/org/{org_id}/role/list | /datarangers | session | completed | Org-scoped, foreign org rejected. |
| GET | /datarangers/api/user/notification | /datarangers | session | pending |  |
| GET | /datarangers/api/guest/product/version | /datarangers | session | pending |  |
| GET | /datarangers/api/contract_status?project_id= | /datarangers | session | pending |  |
| GET | /datarangers/api/user/surveys/1 | /datarangers | session | pending |  |
| GET | /datafinder/api/v1/users/current | /datarangers | session | pending |  |
| GET | /datafinder/api/v1/project?project_id= | /datarangers | session | completed | Foreign project: 403001. |
| GET | /datafinder/api/v1/init | /datarangers | session | pending |  |
| GET | /datafinder/api/v1/projects/{project_id}/common_settings | /datarangers | session | completed | IDOR (low): no project authz, both directions; only benign config returned. |
| GET | /datafinder/api/v1/projects/{project_id}/session_replay/status | /datarangers | session | completed | Foreign project: 403001 access denied. |
| GET | /datafinder/api/v1/projects/{project_id}/functions | /datarangers | session | completed | Foreign project: 403001 access denied. |
| GET | /datafinder/api/v1/projects/{project_id}/view/config | /datarangers | session | pending |  |
| GET | /datafinder/api/v1/projects/{project_id}/scenarios/label/config | /datarangers | session | pending |  |
| GET | /datafinder/api/v1/projects/{project_id}/roles | /datarangers | session | pending |  |
| GET | /datafinder/api/v1/projects/{project_id}/dashboards/level_list | /datarangers | session | pending |  |
| GET | /datafinder/api/v1/projects/{project_id}/ai/gc/config | /datarangers | session | pending |  |
| GET | /datafinder/api/v1/projects/{project_id}/ai/gc/agent/list | /datarangers | session | pending |  |
| GET | /datafinder/api/v1/projects/{project_id}/ai/gc/support_skills | /datarangers | session | pending |  |
| GET | /datafinder/api/v1/current_org?project_id= | /datarangers | session | pending |  |
| GET | /datafinder/api/v2/org/{org_id}/data_export/statistics | /datarangers | session | pending |  |
| GET | /datatester/api/v2/user_info | /datatester | session | completed | A org has no DataTester contract (404); B works. |
| GET | /datatester/api/v2/dry_run_init | /datatester | session | completed |  |
| GET | /datatester/api/v2/org_list | /datatester | session | completed | Returns only caller's orgs/apps. |
| GET | /datatester/api/v2/current_app_info?app_id= | /datatester | session | completed | Foreign app id yields org_id 0, no data leak. |
| GET | /datatester/api/v2/function_control_info?app_id= | /datatester | session | completed | Foreign app id: no leak / default flags. |
| GET | /datatester/access/api/v3/app/list?org_id= | /datatester | session | completed | Foreign org: code 302 access denied. |
| GET | /datatester/permission/api/v3/orgs/{org_id}/user_info | /datatester | session | completed | Foreign org: 400 "no contract". |
| GET | /datatester/experiment/api/v3/app/{app_id}/experiment | /datatester | session | completed | Foreign app: 301 project not accessible. |
| GET | /datatester/experiment-template/api/v2/apps/{app_id}/templates | /datatester | session | completed | Foreign app: 301. |
| GET | /datatester/metric/api/v3/apps/{app_id}/metric-groups | /datatester | session | completed | Foreign app: 301. |
| POST | /api/top/ark/ap-southeast-1/2024-01-01/ListApiKeys | /ark | session | completed | Account-scoped; only caller's keys. |
| POST | /api/top/ark/ap-southeast-1/2024-01-01/GetRawApiKey | /ark | session | completed | Account-scoped; foreign key Id returns NotFound. |
| POST | /api/top/ark/ap-southeast-1/2024-01-01/ListVaults | /ark | session | completed | Account-scoped; only caller's vaults. |
| POST | /api/top/ark/ap-southeast-1/2024-01-01/GetVault | /ark | session | completed | Foreign vault: InvalidVault.NotFound. |
| POST | /api/top/ark/ap-southeast-1/2024-01-01/ListCredentials | /ark | session | completed | No creds in test vaults; no leak observed. |
| POST | /api/top/ark/ap-southeast-1/2024-01-01/ListAgents | /ark | session | completed | Account-scoped; empty. |
| POST | /api/top/ark/ap-southeast-1/2024-01-01/ListOAuthProviders | /ark | session | completed | Public provider catalog. |
| POST | /api/top/ark/ap-southeast-1/2024-01-01/CreateCredential | /ark | session | completed | Blocked: managed agent not activated. |
| POST | /api/top/cv_console/2025-09-16/AppApps | /ai | session | completed | Returns caller's apps only (A 100051380, B 100047641). |
| GET | /api/top/alb/ap-southeast-1/2020-04-01/DescribeLoadBalancers | /alb | session | completed | No ALB resources in either test account. |
| GET | /api/top/alb/ap-southeast-1/2020-04-01/InnerGetAccountFeatures | /alb | session | completed | Account-scoped. |
| GET | /api/top/alb/ap-southeast-1/2020-04-01/InnerGetAccountQuota | /alb | session | completed | Account-scoped. |
