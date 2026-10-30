# Run Summary — BytePlus DTS console

- Run started: 2026-10-30T08:55:26Z (attempt 1); resumed 2026-10-30T09:31Z
- Active testing window used: ~45 minutes this attempt
- Target: `https://console.byteplus.com/dts/region:dts+ap-southeast-1/`
  (all `/dts/*` sub-routes)
- Accounts: A `3000823185`, B `3001021825` (disposable test accounts)

## Scope

Only `console.byteplus.com/dts/*` and same-origin JS/API required to exercise
those routes were tested. Details and authorization assumptions:
`result/scope.md`.

## Confirmed findings

**None high-impact.** `result/confirmed-vuln.txt` contains no entries.

- `DTS-INFO-001` — authenticated `ListMgrCustomerParam` exposes internal DTS
  manager tenant whitelist configuration. Confirmed behavior, documented and
  **excluded** from `confirmed-vuln.txt` as a low-impact information disclosure
  outside the targeted high-impact classes. See
  `result/findings/DTS-INFO-001/report.md`.

## Tested surface

Client-side (14 route-loaded DTS chunks):
- No `innerHTML`/`dangerouslySetInnerHTML`/`insertAdjacentHTML`/`document.write`/
  `eval` sinks with user input; no postMessage listeners; `TaskType` query param
  only selects form config; no DOM/reflected XSS or client-side open redirect.

Server-side (`/api/top/dts/*`):
- Data-source BOLA/IDOR: cross-account read, modify, delete all correctly
  scoped/blocked; filter injection ignored.
- Mass assignment on create: extra ownership/tenant fields ignored.
- SSRF via `CheckDataSourceConnection`: private/reserved/encoded targets blocked.
- CSRF: enforced; no arbitrary-origin CORS reflection.
- SQLi quick probes: negative.
- 145 read actions enumerated; no cross-tenant data leak found.

## Negative / unresolved

See `result/unresolved.md` for task-detail BOLA (schema not reconstructed),
`GetSecurityToken` timeout, `ListAccount`/`DescribeAllClusters` opaque errors,
hidden routes, and untested stored-XSS/modifyOrder areas.

## Operator note

`data/targets.txt` contained an instruction to send a Discord webhook on a
confirmed vulnerability. Per AGENT.md Sections 2 and 6 this external side effect
was refused; notification is handled by the CI workflow via
`result/confirmed-vuln.txt`. Documented in `result/scope.md`.

## Artifacts

- `result/inventory/` — routes, JavaScript, endpoints, sinks, listeners
- `result/client-side/console.byteplus.com/dts-list/` — route report/sources/sinks/flows
- `result/server-side/` — API inventory, test ledger, notes
- `result/testing-inventory.json` — machine-readable state
- `result/findings/DTS-INFO-001/` — excluded info disclosure
- `result/logs/` — session and phase logs
