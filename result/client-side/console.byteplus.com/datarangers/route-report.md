# Route report — /datarangers

- Canonical: https://console.byteplus.com/datarangers/org/2100230837/app/list
- Auth: account A (test-user-123, AccountId 3000823185, org 2100230837)
- Timestamp: 2026-10-29T08:56Z
- Sub-routes discovered: /org/{id}/app/list, /org/{id}/manage/org,
  /org/{id}/function/overview, /org/{id}/manage/role, /org/{id}/user/info,
  /org/{id}/user/personel; plus app-scoped routes reached via "Enter project".
- Same-origin APIs: /datarangers/api/config, /org/list, /org/{id}/user/get,
  /org/{id}/user/features, /org/{id}/app/list, /user/notification,
  /org/{id}/user/update.
- Client-side: reviewed route bundle + shared shell (see javascript/).

## Results
- Sinks `dangerouslySetInnerHTML` on notification `thumb_content`/`message_text`
  are server-controlled; notification list empty; no write/delivery primitive
  found. **Unresolved** (would need an attacker-controlled notification body).
- `callback` redirect is same-host enforced. **Not Vulnerable**.
- Help-doc markdown is static content. **Not Vulnerable**.
- No attacker-reachable postMessage handler. **Not Vulnerable**.
- No confirmed client-side finding.

## Next
- Server-side: list/detail endpoints under /datarangers/api/org/{orgId}/ were
  covered for cross-tenant IDOR in the server-side ledger (#4). Additional
  write actions (app create/delete, role management) require test resources;
  continue if time allows.
