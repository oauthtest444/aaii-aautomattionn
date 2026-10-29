# Notes — files-immutable-4cbc033nbd3.sptpub.com

- Bucket `spt77-nondynamic-files` (eu-central-1), public list + public read.
- Prefixes and object counts:
  - `currencies/` — 2 (EUR/USD-style icons)
  - `flags_by_code/` — 62,365 country flag SVGs
  - `rocket-league/` — 2 SVGs
  - `translations/market-tooltips/` — 55 JSON i18n files
- ACL: owner FULL_CONTROL; AllUsers READ + READ_ACP; no WRITE.
- `?policy` denied; no write test succeeded via the in-scope CloudFront host
  (PUT -> 403, no object created).
- `translations/market-tooltips/en.json` sampled: only UI tooltip strings; no
  URLs, tokens, API keys, or HTML.
- No sensitive data, no vulnerability beyond public listing
  (`VULN-20261029-001`, informational/excluded).
