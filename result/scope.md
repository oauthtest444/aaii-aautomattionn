# Scope

## Target entries and classification
- `sptpub.com` — domain-only target (from `data/targets.txt`).
- User instruction: identify all valid/interesting subdomains, save them, test each individually; discover UI routes and API endpoints; test client-side and server-side; create two test accounts on the target if possible, otherwise test unauthenticated only.
- Discovered subdomains saved to `result/inventory/subdomains.txt` (278 via
  hackertarget, rapiddns, subdomain.center, bounded DNS checks, and a live
  redirect to the `startN` family). 46 resolve.

## Authorization source / assumptions
- `data/targets.txt` explicitly authorizes `sptpub.com` and directs subdomain discovery and per-subdomain testing. Therefore `*.sptpub.com` subdomains that resolve are treated as in scope for harmless, non-destructive testing.
- Only passive recon, read-only requests, and test-account actions are in scope.
- Brand subdomains are independent operators on a shared SPT platform; tests must not affect real users, real balances, or production business state.

## In-scope components
- `sptpub.com` apex and resolving `*.sptpub.com` hosts discovered by passive sources.
- Same-origin JS/API required to exercise an in-scope host.
- Shared infra hosts: `api-*`, `help`, `wiki`, `static`, `files-immutable-*`, `bt-app-static-themes`, `gamingarttech`, `tanktech`, `gbg`, `fasw0001`, plus operator brand hosts.

## Out-of-scope components
- Third-party infrastructure itself (CloudFront, S3 global namespace, Cloudflare) — only the `*.sptpub.com` endpoint is tested.
- External domains that brand hosts redirect to (e.g. operator .com sites, payment/identity providers).
- `sptpub-infra.com` and its subdomains (related infrastructure, not authorized).
- CloudFront distribution domains (`*.cloudfront.net`), AWS ELB names, and S3
  buckets not referenced by an in-scope `*.sptpub.com` host.
- Real user accounts, real balances, real personal data.

## Network vantage / blocker
- Every dynamic `*.sptpub.com` host returns a CloudFront edge block to this
  runner: brand hosts 403 `{"error":"access blocked"}`, API hosts 503 same body,
  help/feed/WS hosts 403 WAF "Request blocked". No application code or API route
  is reached, so account creation and authenticated testing are impossible.
- Only `static.sptpub.com` and `files-immutable-4cbc033nbd3.sptpub.com` (public
  S3 listings) are reachable.

## Program restrictions (from data/ and vulnebleti/)
- No DoS/load testing, brute force, high-volume fuzzing, destructive writes, account lockout.
- No real-user harm; test-owned data only.
- No social engineering/phishing.
- Test credentials from `creds/` belong to `console.byteplus.com`, which is NOT in scope for this target; do not use them here.
- Account creation is permitted only where the target's own signup flow allows it, using disposable identities.
