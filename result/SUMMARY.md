# Scan Summary

- Target: https://console.byteplus.com/workorder/list/
- Scope source: `data/targets.txt` (private BBP; explicit `/workorder/*` sub-routes)
- Authorization note: only `console.byteplus.com/workorder/*` was tested; no related subdomain testing was performed.
- Auth context: test accounts only — A `3000823185`, B `3001021825`
- Started: 2026-10-31T10:09:03Z
- Completed: 2026-10-31T10:30:04Z

## Coverage

| Sub-route | Status | Result |
|---|---|---|
| /workorder/list/ | completed | Caller-scoped ticket reads; hidden account overrides ignored; postMessage listener exact-origin and read-only. |
| /workorder/list/detail | completed | Cross-account ticket/conversation/file operations denied; mass assignment ignored; stored HTML sanitized server-side; no XSS. |
| /workorder/create | completed | Ownership/state fields ignored; upload ownership enforced; no client-side sink. |
| /workorder/authorizationList | completed | Caller-scoped, empty; diagnostic write/list paths unresolved (backend errors/no records). |

## Findings

**No high-impact vulnerability was confirmed.**

### OBS-20261031-001 — low-impact cross-account masked contact

- `POST /api/workorder/ticket/GetAccountMaskedSecurityContact` accepts an arbitrary `AccountID` and returns another account's masked security email, masked telephone, and verification flags, plus an `AccountNotExist` oracle.
- Confirmed bidirectionally between A and B using test accounts.
- Impact is limited to masked PII (first email character, masked domain, country code + last 5 phone digits) and account/verification state. It does not meet the high-impact reporting bar, so it is **not** in `result/confirmed-vuln.txt` and did **not** trigger a Discord notification.
- Details: `result/unresolved.md`.

## Client-side testing

- Exact source/sink regexes were run against the route bundles; counts and matched flows are in `result/client-side/console.byteplus.com/<route>/route-report.md`.
- Stored conversation HTML is sanitized at write time: `onerror`, `ontoggle`, `onfocus`, `javascript:` hrefs, and disallowed tags are stripped.
- Markdown conversation content drops `javascript:` hrefs and strips raw HTML event handlers.
- `<svg onload>` probes were blocked by the WAF (HTTP 403).
- Confidential conversation content is masked in list responses and sanitized when revealed through `GetSensitiveConversation`.
- Conversation attachment URLs are stored verbatim, but the client download handler rejects dangerous schemes and image preview uses `<img>` only; a stored `javascript:` attachment URL did not execute on click.
- Attachment `FileID` from another account is normalized to `Url:""`; no cross-account file URL is returned.
- No JavaScript execution, self-XSS, DOM XSS, stored XSS, or open redirect was confirmed.

## Unresolved

- `ListTicketFlow` cross-user `SessionID` IDOR (no second valid session created).
- Diagnostic authorization endpoints (`InternalError`/`BadRequest`, no records).
- Authorization approve/terminate write paths (no records).
- `ConversationSensitiveWordDetection` and AI form helper endpoints (not exercised).

## Artifacts

- `result/inventory/top-level-routes.md`
- `result/inventory/api-routes.md`
- `result/inventory/javascript.md`
- `result/testing-inventory.json`
- `result/unresolved.md`
- `result/client-side/console.byteplus.com/`
- `result/confirmed-vuln.txt` (no high-impact entries)
