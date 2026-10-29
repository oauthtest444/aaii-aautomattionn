# Test Ledger — files-immutable-4cbc033nbd3.sptpub.com

| # | Endpoint / method | Bug class | Auth | Baseline | Test | Result | Evidence | Duplicate |
|---|---|---|---|---|---|---|---|---|
| 1 | `GET /` | S3 listing | none | n/a | read listing | 200 public `ListBucketResult` | `traffic/bucket-prefixes.txt` | no |
| 2 | `GET /?acl` (S3) | ACL exposure | none | n/a | read ACL | AllUsers READ+READ_ACP, no WRITE | `notes.md` | no |
| 3 | `GET /translations/market-tooltips/en.json` | secret/PII exposure | none | n/a | read content | UI strings only | `notes.md` | no |
| 4 | `GET /<missing>` | reflected XSS | none | 404 | `<script>` key | XML-escaped NoSuchKey | `../static.sptpub.com/notes.md` | no |
| 5 | `PUT /<random>.txt` | unauth write | none | 404 | zero-byte create | CloudFront 403; GET still 404; no object | `../static.sptpub.com/notes.md` | no |
