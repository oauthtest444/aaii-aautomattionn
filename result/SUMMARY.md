# Run Summary

- Target: https://console.byteplus.com/ (86 top-level route entries; 85 crawled)
- Auth: A root `test-user-123` (3000823185, org `test-org` 7626704992304873535);
  B root (3001021825, org `attacker-org` 7593914919411531822, different org)
- Inventory: `result/inventory/routes.md`, `result/inventory/endpoints.md`
  (278 unique same-origin API endpoints), `result/testing-inventory.json`.
- Confirmed findings: **none** (no fabricated/whitelisted issues).

## Negatives completed (ledger `result/server-side/console.byteplus.com/test-ledger.md`)
- Cross-tenant IDOR/BOLA on: resourcecenter (Scope ignored), ticket GetTicket /
  ListTicketConversation (Forbidden), organization (B sees own org only;
  ListAccounts/OU PermissionError), cloudidentity (PermissionError),
  bill/bill_volcano_engine (balance, monthly bill, credit, TaxID, financial role,
  coupon), financial payment methods, account_verify profile, account_management
  application/security contact, network_fe, ml_platform, apmplus, seccenter.
  All return the session account only; `AccountID`/`AccountId`/`OrganizationId`
  params ignored (ledger 12–14, 19–23, 26–28).
- IAM `UpdateUser` mass assignment (`AccountId`,`IsRoot`): ignored; earlier 403
  was Akamai WAF on XSS payload, not authz (ledger 15).
- ArkClaw v2 `AccountID` override: ignored (ledger 16).
- `network_fe restfulRequest` generic service/action gateway: session-bound,
  account param ignored, fixed version per service (ledger 17).
- Unauthenticated access to `/api/top/*`, `/api/v2/*`, `/api/network_fe/*`:
  blocked by login + CSRF (ledger 18).
- CSRF: required in header for JSON, text/plain and form-urlencoded; not
  bypassable; SameSite=None + Secure cookies (ledger 25).
- CORS: ACAO fixed to `http://console.byteplus.com` (not reflected) + ACAC true;
  not exploitable from attacker origin (ledger 24).
- Stored XSS: workorder conversations sanitizer strips handlers/dangerous tags;
  IAM DisplayName/Description rendered as escaped text; attachment
  `dangerouslySetInnerHTML` uses static i18n strings (client-side report
  `result/client-side/console.byteplus.com/iam/`).
- `/iam` postMessage: weak substring-origin TEA listener only loads a hardcoded
  script; other listeners use exact origin (ledger/report above).
- Out of scope (not tested): product consoles on `*.bytepluses.com`;
  Ark/AgentKit `ImportGithubSkill`, datafinder, lark-verify subdomains.

## Next
- Remaining route-by-route client-side static pass for routes without a report
  (`/datarangers`, `/datatester`, `/ark`, `/dms`, `/config`, `/message`, ...)
  and spot server-side BOLA on write/list actions discovered from their JS.
