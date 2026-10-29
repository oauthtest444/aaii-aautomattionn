# VULN-20261029-002 — Dangling DNS records to deleted AWS resources

Status: Not Vulnerable (informational DNS hygiene)
Type: DNS / potential subdomain takeover (not exploitable in practice)
Assets:
- `help-beta-ingress.sptpub.com` -> deleted classic ELB
- `api-help-beta-ingress.sptpub.com` -> same deleted classic ELB
- `api-h-c34e8269-1333.sptpub.com` -> deleted CloudFront distribution
  `d1z4jtnwy56ynm.cloudfront.net`
- `api-h-d6f5dd34-1091.sptpub.com` -> deleted CloudFront distribution
  `d15oykhg75c6eh.cloudfront.net`
Authentication: unauthenticated
Tested at: 2026-10-29T14:20:00Z

## Summary

Four in-scope hosts are CNAMEs whose targets no longer exist (NXDOMAIN). Three
distinct targets are dangling:

1. `a07ff76e120d64a249d5504f3705266f-1179737841.eu-central-1.elb.amazonaws.com`
   (classic ELB, deleted).
2. `d1z4jtnwy56ynm.cloudfront.net` (CloudFront distribution, deleted).
3. `d15oykhg75c6eh.cloudfront.net` (CloudFront distribution, deleted).

The ELB DNS label embeds the owning AWS account ID (`1179737841`), so an
unrelated account cannot recreate the exact name. CloudFront distribution
domains are AWS-assigned and cannot be chosen or reclaimed by another account.
No practical subdomain takeover was demonstrated. This is a DNS hygiene and
availability issue.

## Evidence

- `evidence/dns.md` — dig output for every host and target.
- `result/logs/dns-cnames.txt` — all 26 CNAME records observed in the target.

No wildcard DNS exists (`<random>.sptpub.com` is NXDOMAIN), so the dangling
records are individually registered.

## Impact

No exploitable impact demonstrated. Remove the four stale CNAMEs to avoid
future service-confusion/availability risk.

## Notification status

Confirmed-vuln.txt: excluded — not an exploitable high-impact finding and not one
of the targeted classes.
