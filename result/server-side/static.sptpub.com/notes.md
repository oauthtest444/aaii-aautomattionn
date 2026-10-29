# Notes — static.sptpub.com

- `spt77-static` bucket is public-list via CloudFront. First page only (1000
  keys) is reachable because the CloudFront cache policy ignores query strings,
  so `marker`/`prefix` cannot paginate. All visible keys are
  `additional_images/background/*.png` and `404.html`.
- `spt77-nondynamic-files` bucket is public-list and public-read. Four prefixes:
  `currencies/` (2), `flags_by_code/` (62,365), `rocket-league/` (2),
  `translations/market-tooltips/` (55). No secrets.
- Bucket ACL for `spt77-nondynamic-files`: owner FULL_CONTROL; AllUsers READ and
  READ_ACP. No AllUsers WRITE. `?policy` denied.
- `bt-app-static-themes.sptpub.com` exists (S3 `AccessDenied`) but no object path
  was readable; likely requires signed CloudFront URLs or a private origin.
- CORS: `static.sptpub.com` returns `Access-Control-Allow-Origin: *`; public
  static content, not sensitive.
- Write probe: `PUT` of a zero-byte object to
  `files-immutable-4cbc033nbd3.sptpub.com/security-test-...-delete-me.txt`
  returned CloudFront 403; a follow-up GET remained 404, confirming no object
  was created. No direct-S3 write test was made (third-party endpoint).

No high-impact finding. See `result/findings/VULN-20261029-001/`.
