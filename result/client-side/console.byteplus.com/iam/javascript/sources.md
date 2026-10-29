# Sources reviewed — /iam

| Source | Controlled by | Reaches sink? |
|---|---|---|
| `message` event (`e.data`, `e.origin`) | attacker page via postMessage | `yn` (weak origin) → hardcoded script load only; `readMessage`/workorder exact-origin |
| `location` params (query/hash) | attacker via link | No controlled sink identified |
| `document.referrer` | attacker via link | No sink |
| API response fields (UserName, DisplayName, Description) | account user (self) | Rendered as React text (escaped); i18n span uses static translation |
| `ServiceName` query param on attach_role | attacker via link | Passed to `GetServiceLinkedRoleTemplate`; not reflected |
