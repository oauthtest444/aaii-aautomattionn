# Test Ledger — static bucket hosts

| # | Endpoint / method | Bug class | Auth | Baseline | Test | Result | Evidence | Duplicate |
|---|---|---|---|---|---|---|---|---|
| 1 | `GET static.sptpub.com/` | S3 listing / info disclosure | none | n/a | read bucket listing | Public list; images only | `traffic/bucket-listing-first1000.tsv` | no |
| 2 | `GET files-immutable.../` | S3 listing / info disclosure | none | n/a | read bucket listing + prefixes | Public list; flags/currencies/i18n only | `../../files-immutable.../traffic/` | no |
| 3 | `GET files-immutable.../?acl` | ACL exposure | none | n/a | read ACL | AllUsers READ + READ_ACP, no WRITE | `../files-immutable.../traffic/` | no |
| 4 | `GET static.sptpub.com/<xss>` | reflected XSS | none | missing key | `<script>` in key | 404 XML, XML-escaped, not HTML | `../../findings/VULN-20261029-001/evidence/` | no |
| 5 | `OPTIONS /` (CORS) | CORS | none | n/a | preflight PUT | `ACAO: *` only; no write shown | `../evidence/` | no |
| 6 | `GET bt-app-static-themes.../*` | object exposure | none | n/a | 20 guessed paths | All 403 AccessDenied | this file | no |
| 7 | `PUT files-immutable.../<random>.txt` | unauth write / bucket policy | none | key absent (404) | zero-byte object create + cleanup | 403 at CloudFront; GET stayed 404; no object created | `notes.md` | no |

No mass-assignment, IDOR, auth-boundary, or business-logic endpoint was
reachable, so those classes are Unresolved.
