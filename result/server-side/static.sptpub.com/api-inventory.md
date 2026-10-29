# API / Endpoint Inventory — static.sptpub.com & files-immutable host

| Method | Path | Auth | Query | Response | Status |
|---|---|---|---|---|---|
| GET | `https://static.sptpub.com/` | none | none (query strings ignored by CloudFront cache) | 200 `ListBucketResult` for `spt77-static`; first page 1000 keys (`additional_images/**`, `404.html`); `IsTruncated=true` | Tested |
| GET | `https://static.sptpub.com/404.html` | none | — | 200 static HTML 404 page | Tested |
| GET | `https://static.sptpub.com/<missing>` | none | — | 404 `application/xml` `NoSuchKey`; key XML-escaped | Tested |
| GET | `https://files-immutable-4cbc033nbd3.sptpub.com/` | none | none | 200 `ListBucketResult` for `spt77-nondynamic-files` (query stripped) | Tested |
| GET | `.../translations/market-tooltips/en.json` | none | — | 200 JSON i18n tooltips, no secrets | Tested |
| GET | `.../currencies/`, `/flags_by_code/`, `/rocket-league/`, `/translations/` | none | — | Static SVG/JSON assets | Tested |
| GET | `https://bt-app-static-themes.sptpub.com/<path>` | none | — | 403 `AccessDenied` for listing and all guessed object paths | Tested |

## Notes

- CloudFront ignores query strings on these distributions (`?prefix`, `?marker`,
  `?delimiter`, cache-busters all returned the same cached first page). Full
  enumeration of `spt77-static` was therefore not possible through the in-scope
  host.
- `spt77-nondynamic-files` was enumerable read-only via the S3 ListObjectsV2 API;
  no sensitive object was found.
- No write/delete operations were attempted.
