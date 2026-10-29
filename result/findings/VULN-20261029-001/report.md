# VULN-20261029-001 — Public S3 bucket listings on static CDN hosts

Status: Confirmed (informational / low impact)
Type: Information disclosure (misconfiguration)
Assets:
- https://static.sptpub.com/ (bucket `spt77-static`)
- https://files-immutable-4cbc033nbd3.sptpub.com/ (bucket `spt77-nondynamic-files`)
Authentication: unauthenticated
Tested at: 2026-10-29T14:04:00Z

## Summary

Both in-scope static hosts serve unauthenticated S3 `ListBucketResult` XML. An
unauthenticated user can enumerate bucket object keys. For
`spt77-nondynamic-files` the bucket ACL grants `AllUsers` `READ` and `READ_ACP`.

No sensitive objects, credentials, personal data, or write permission were
found. The listed content is public CDN material (country flag SVGs, currency
icons, i18n tooltips, betting-theme background images). This is a
defense-in-depth / information-disclosure issue rather than a high-impact
vulnerability.

## Evidence

- `evidence/request-response.md` — exact requests, headers and response excerpts.
- `result/server-side/static.sptpub.com/traffic/bucket-listing-first1000.tsv`
- `result/server-side/files-immutable-4cbc033nbd3.sptpub.com/traffic/bucket-prefixes.txt`
- `result/server-side/files-immutable-4cbc033nbd3.sptpub.com/traffic/key-counts.json`

Object counts observed: `spt77-static` first page 1000 keys (1000-key page
limit; `IsTruncated=true`); `spt77-nondynamic-files` 62,424 keys
(62,365 flags + 55 translation files + 4 misc assets).

## Reproduction

1. `curl -sS https://static.sptpub.com/` → HTTP 200, `Content-Type:
   application/xml`, `ListBucketResult` for `spt77-static`.
2. `curl -sS https://files-immutable-4cbc033nbd3.sptpub.com/` → HTTP 200,
   `ListBucketResult` for `spt77-nondynamic-files`.
3. `curl -sS 'https://spt77-nondynamic-files.s3.eu-central-1.amazonaws.com/?acl'`
   → `AllUsers` grants `READ` and `READ_ACP` (no `WRITE`).

## Impact

Asset/key enumeration only. No confidentiality, integrity, or availability
impact demonstrated. No write access was confirmed (ACL has no `WRITE` and no
write test was performed).

## Remediation

Disable public bucket listing (`s3:ListBucket` for `AllUsers`) while keeping
object reads via CloudFront/OAI as required. Remove `READ_ACP` from `AllUsers`.

## Notification status

Confirmed-vuln.txt: excluded — low-impact information disclosure, not one of the
project's targeted high-impact classes (XSS/CSTI/IDOR/BAC/dangerous open
redirect).
