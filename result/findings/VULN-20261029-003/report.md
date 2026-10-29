# VULN-20261029-003 — `loop.sptpub.com` resolves to 127.0.0.1 (SSRF allowlist lead)

Status: Unresolved (lead only; no impact demonstrated)
Type: Potential SSRF / DNS allowlist bypass
Assets:
- `loop.sptpub.com` -> A `127.0.0.1`
- `start6.sptpub.com`, `start16.sptpub.com` -> CNAME `loop.sptpub.com`
Authentication: unauthenticated
Tested at: 2026-10-29T14:15:00Z

## Summary

`loop.sptpub.com` is an in-scope host that resolves to the loopback address
`127.0.0.1`. `start6.sptpub.com` and `start16.sptpub.com` CNAME to it, so they
are dead from a normal client (connection refused).

If any server-side feature on the platform accepts a URL/host and enforces an
allowlist based on `*.sptpub.com`, `loop.sptpub.com` could bypass that allowlist
and reach the server's own loopback services. This is a plausible SSRF
primitive, but it is **not confirmed**: the API is geo-blocked at CloudFront and
no URL-fetching feature or request parameter could be reached.

## Evidence

```
$ dig +short A loop.sptpub.com
127.0.0.1

$ dig +short CNAME start6.sptpub.com
loop.sptpub.com.

$ dig +short CNAME start16.sptpub.com
loop.sptpub.com.
```

See `evidence/dns.md`.

## Impact

None demonstrated. The record is a dead end for browsers (connection refused to
localhost). It is recorded because it could be useful in an SSRF allowlist-bypass
test if an authenticated URL-fetch endpoint becomes reachable.

## Notification status

Confirmed-vuln.txt: excluded — Unresolved lead, not a verified vulnerability.
