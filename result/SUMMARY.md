# Run Summary — sptpub.com

- Start: 2026-10-29T13:50:54Z
- End: 2026-10-29T14:18:00Z (~27 minutes)
- Target: `sptpub.com` (domain-only), plus discovered `*.sptpub.com` hosts
- Agent/model: opencode / deepseek-v4.1-flash-free
- State: reset (target hash changed)

## Scope and recon

- Read `data/targets.txt`, all skill files, creds and vulnerability notes.
- Enumerated 278 unique subdomains from public passive sources (hackertarget,
  rapiddns, subdomain.center), a bounded DNS check, and a live redirect that
  revealed the `startN` landing family. Saved to `result/inventory/subdomains.txt`.
  46 resolve; the rest are stale/NXDOMAIN.
- Identified a multi-tenant betting platform: many operator-brand hosts, per-brand
  `api-*` gateways, per-brand `startN` landing origins, help/wiki, S3 static
  CDNs, and `sptpub-infra.com` CNAMEs.

## Surface tested

- All 46 resolving hosts requested over HTTPS; representative brand/API/help
  hosts probed across paths, methods, and headers.
- Brand `/bt-renderer.min.js` redirects mapped to `startN` hosts (start5/9/26/31
  etc.); `/bt-renderer.min.js` is the only non-blocked asset and is a fixed
  3,678-byte geo-403 renderer with no input.
- `static.sptpub.com` and `files-immutable-4cbc033nbd3.sptpub.com` public S3
  buckets read/inventoried (read-only); 55 i18n files grepped, no secrets.
- `bt-app-static-themes.sptpub.com` object paths probed (all 403).
- Missing-key reflection check; CORS preflight; ACL read; zero-byte write
  permission probe (CloudFront blocked PUT, no object created).
- DNS/TCP checks for dead origins; full CNAME audit (26 records, 3 dangling
  targets). `loop.sptpub.com` resolves to 127.0.0.1 (SSRF-allowlist lead,
  untestable).
- Wayback CDX checked; only the static `bt-renderer` capture exists.

## Confirmed findings

No high-impact vulnerability meeting the `confirmed-vuln.txt` bar was confirmed.

Informational / excluded:

- `VULN-20261029-001` — Public S3 bucket listings on two static CDN hosts.
  Confirmed misconfiguration, but only public assets (flags, currency icons,
  i18n, theme PNGs); ACL has AllUsers READ/READ_ACP and no WRITE. Excluded as
  low-impact information disclosure.
- `VULN-20261029-002` — Four dangling CNAMEs to deleted AWS resources: one
  classic ELB and two CloudFront distributions. Not exploitable (ELB name embeds
  the owning AWS account; CloudFront default domains are AWS-assigned and cannot
  be reclaimed). Excluded.

Unresolved lead:

- `VULN-20261029-003` — `loop.sptpub.com` resolves to `127.0.0.1`; `start6` and
  `start16` CNAME to it. Potential `*.sptpub.com` SSRF allowlist bypass, but no
  URL-fetch endpoint was reachable (geo block). Not a confirmed finding.

## Unresolved

- Client-side testing: no app JS/HTML could be loaded; every dynamic host is
  geo-blocked at the edge (403/503, "Access is forbidden from your location").
- Server-side testing: no API route reached (403/503 before application).
- Account creation: signup unreachable; test accounts could not be created.
- `api.sptpub.com`, `help`, `wiki`: TCP filtered.
- `spt77-static` listing only partially enumerable via CloudFront (query strings
  ignored; direct S3 ListBucket denied).
- `loop.sptpub.com` -> 127.0.0.1: potential SSRF allowlist bypass, unresolved
  because the API cannot be reached.
- `dragonclub.sptpub.com`: TLS handshake failure during the run.

## State of outputs

- `result/confirmed-vuln.txt` contains only its header (no entries).
- Inventory, testing ledger, evidence and reports written under `result/`.
- No real-user data or secrets were accessed. Test creds in `creds/` belong to an
  out-of-scope host and were not used.
- No repository files outside `result/` were modified.
