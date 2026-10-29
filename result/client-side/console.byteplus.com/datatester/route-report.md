# Route report — /datatester

- Canonical: https://console.byteplus.com/datatester
- Auth: account A (test-user-123, AccountId 3000823185)
- Timestamp: 2026-10-29T08:58Z
- State: test org has no connected project ("您当前的集团没有已接入的项目").
- Same-origin APIs: /datatester/api/v2/dry_run_init, /datatester/api/v2/user_info,
  /datatester/api/v3/org_list (plus shared shell APIs).
- JS reviewed: 17 datatester bundles (manifest/hashes below), incl. main,
  preload, microfrontend runtime (75131), message-center (55916).

## Results (all Not Vulnerable / Unresolved, none confirmed)
- Kura microfrontend runtime (75131) uses `eval`/`new Function` on module code,
  but module URLs come from the server-provided registry manifest, not from
  query/localStorage. Not attacker-controlled.
- Message center (55916) sanitizes `content` with `N.sanitize` (DOMPurify-style)
  before `dangerouslySetInnerHTML`; fallback only on exception. Server-rendered
  platform messages; no user write path found. Unresolved.
- `pro-message-preview` `description` sink (55916:278334) renders message data
  supplied by the app; no user-controlled source found in this route.
- `ab_lang` query is used only for locale selection; cookie write uses it in a
  cookie value with no script sink. Not vulnerable.
- Auth SDK redirect sinks use server/config `redirect_url` / login path, not
  attacker URL. Not vulnerable.
- No attacker-reachable postMessage handler with a sensitive sink.

## Manifest
See `javascript/manifest.md` and `javascript/sha256.txt`.
