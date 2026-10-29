# Test ledger — prior + current attempt

Statuses: Confirmed | Not Vulnerable | Unresolved | Out of Scope

| # | Endpoint/Method | Bug class | Auth | Baseline | Result | Status | Evidence |
|---|-----------------|-----------|------|----------|--------|--------|----------|
| 1 | POST GetRawProfileInfo | IDOR (AccountId) | A | own raw profile | AccountId A/B/query all returned own AccountId 3000823185 | Not Vulnerable | result/logs/opencode.log (prior) + session eval 2026-10-29T08:19Z |
| 2 | POST /api/v2/batch/iam ListUsers | IDOR (AccountId) | B | B users | AccountId ignored, returns B users | Not Vulnerable | log prior |
| 3 | POST /api/v2/batch/iam GetUser | IDOR | B | A user id | UserNotExist | Not Vulnerable | log prior |
| 4 | DataRangers /api/org/{id}/app/list | tenant IDOR | B | B org | A org id -> 400 not belong | Not Vulnerable | log prior |
| 5 | Ark ListApiKeys | IDOR header | B | B keys | X-Ark-Meta-Account-Id ignored | Not Vulnerable | log prior |
| 6 | Multiple | CORS | A | evil Origin | static ACAO, not reflected | Not Vulnerable | log prior |
| 7 | /api/v2/batch/iam Service field | SSRF | A | ecs | metadata/file/localhost rejected | Not Vulnerable | log prior |
| 8 | login redirectURI | Open redirect | unauth | A login | external ignored; javascript: WAF 403 | Not Vulnerable | log prior |
| 9 | /api/v2/batch/iam UpdateUser | Mass assignment | B | user | HTTP 403 | Unresolved | log prior |
| 10 | byteplus-faas postMessage | DOM postMessage | unauth | go_back | no sensitive handler | Not Vulnerable | log prior |
| 11 | UpdateProfile / CompleteProfile | Mass assignment | A | - | not yet tested | Unresolved | pending |
| 12 | POST resourcecenter SearchResources / GetResourceCounts | BOLA/IDOR (Scope.Accounts) | B | own scope | Scope.Accounts ignored; returns only session account 3001021825 (counts/search identical to baseline) | Not Vulnerable | eval 2026-10-29T08:33Z (page 3) |
| 13 | POST ticket GetTicket | Cross-account IDOR | B | A test ticket I-2026102903090001 | HTTP 200 body Error Forbidden "No permission to perform this operation" | Not Vulnerable | eval 2026-10-29T08:34Z (page 3) |
| 14 | POST ticket ListTicketConversation | Cross-account IDOR | B | A test ticket I-2026102903090001 | HTTP 200 body Error Forbidden | Not Vulnerable | eval 2026-10-29T08:34Z (page 3) |
| 15 | POST /api/v2/batch/iam UpdateUser | Mass assignment (`AccountId`,`IsRoot`) | B | throwaway user zzm63430809 | Update persisted DisplayName/Description only; AccountId stayed 3001021825, IsRoot absent. Earlier HTTP 403 was Akamai WAF (empty text/plain) on XSS payload, not authz. User deleted (DeleteUser 200). | Not Vulnerable | eval 2026-10-29T08:43Z (page 3) |
| 16 | POST /api/v2/top/arkclawx/.../DescribeArkClawInstances | Cross-account BOLA (`AccountID`) | A vs B | B account 3001021825 | Param ignored; both accounts return 0 instances (inconclusive data, no cross-tenant leak) | Not Vulnerable | eval 2026-10-29T08:44Z |
| 17 | POST /api/network_fe/core/{id}/restfulRequest | Generic service/action gateway / account override | A | `service=vpc`, `action=DescribeVpcs`, `requestParams.AccountId=B` | Arbitrary service routing exists but is session-bound; AccountId ignored; iam/sts hit fixed version 2020-04-01 -> InvalidActionOrVersion | Not Vulnerable | eval 2026-10-29T08:41Z (page 1) |
| 18 | Multiple `/api/top/*`, `/api/v2/*`, `/api/network_fe/*` | Unauthenticated access | anon | no cookies/CSRF | All require login + CSRF (InvalidCSRFToken / NotLogin / AccessDenied). No data returned | Not Vulnerable | eval 2026-10-29T08:44Z (page 4, isolated anon) |
| 19 | POST /api/top/bill_volcano_engine/.../GetCountryAreaCfgByAccountID | Cross-account via `AccountID` query | B | A id 3000823185 | Returned B's own config; param ignored | Not Vulnerable | eval 2026-10-29T08:36Z (page 3) |
| 20 | GET/POST organization DescribeOrganization/ListAccounts/ListOrganizationalUnits | Cross-tenant org read (`OrganizationId`) | B vs A | A org 7626704992304873535, OU 7626704992304889919 | B sees only its own (different) org 7593914919411531822 owned by 3001003360; ListAccounts/OU as B -> PermissionError; `OrganizationId` on A ignored (returns A's own) | Not Vulnerable | eval 2026-10-29T08:46Z |
| 21 | POST/GET cloudidentity ListApplications/GetServiceStatus/GetInstanceQuota/GetIdentitySourceBindingInfo | BOLA / info leak | B and A | A has Org instance 7701212119558253632 | B -> PermissionError; A -> own empty app list + own instance | Not Vulnerable | eval 2026-10-29T08:46Z |
| 22 | POST/GET bill + bill_volcano_engine (balance, monthly bill, credit, TaxID, financial role, coupon) | Cross-account `AccountID` | A vs B | A 3000823185 / B 3001021825 | Every response returns the session account only; `AccountID` query/body ignored (B TaxID `tttt` never returned to A and vice versa) | Not Vulnerable | eval 2026-10-29T08:47Z |
| 23 | POST financial FetchStoredPaymentMethods | Cross-account payment methods | A vs B | `AccountId` param | Returns own AgreementID/empty methods; param ignored | Not Vulnerable | eval 2026-10-29T08:46Z |
| 24 | GET/POST arbitrary API with `Origin: https://evil.example` / `null` | CORS misconfig | curl with A cookies | n/a | ACAO is fixed `http://console.byteplus.com` (not reflected) + ACAC true; preflight same. No attacker-origin read; Secure+SameSite=None cookies. Not exploitable | Not Vulnerable | eval 2026-10-29T08:47Z |
| 25 | POST /api/v2/batch/iam with text/plain & form-urlencoded, no `x-csrf-token` | CSRF bypass via simple content types | A cookies, evil Origin | ListUsers probe | `InvalidCSRFToken` for all content types; token required in header (double-submit) | Not Vulnerable | eval 2026-10-29T08:47Z |
| 26 | POST/GET account_verify GetRawProfileInfo | Cross-account profile PII (`AccountID`) | A vs B | A 3000823185 / B 3001021825 | Param ignored; each session gets only its own profile (B saw `attacker-org`/US, A saw `test-org`/NL). No cross-tenant PII | Not Vulnerable | eval 2026-10-29T08:48Z |
| 27 | GET/POST account_management GetApplication / DescribeAccountSecurityContact | Cross-account (`AccountID`) | A vs B | A app 1023286 | Param ignored; own masked contact returned in both directions | Not Vulnerable | eval 2026-10-29T08:48Z |
| 28 | POST ark ListApiKeys / GetRawApiKey, POST kms DescribeSecretInstances | Cross-account key/secret read | A vs B | `AccountID` param, no valid ProjectName/Id | MissingParameter (no enumeration without valid project/id); no cross-tenant data; KMS 0 instances | Inconclusive (no data), Not Vulnerable | eval 2026-10-29T08:48Z |
