# Session Metadata

- Start (UTC): 2026-10-29T13:50:54Z
- Target input: sptpub.com (domain-only)
- Agent/model: opencode / deepseek-v4.1-flash-free
- Environment: GitHub Actions runner, linux
- Tools: node v22.23.4, python 3.14.4, Chrome 156.0.8078.73 headless (CDP 127.0.0.1:9222), curl, git
- Chrome DevTools MCP: connected
- Repo HEAD: 6560caa
- Resume state: reset (target hash changed)
- End (UTC): 2026-10-29T14:18:00Z (~27 min)
- Outcome: no confirmed high-impact finding; dynamic app geo-blocked at
  CloudFront. Two informational/excluded reports (public S3 listings, dangling
  DNS) and one unresolved SSRF lead (loopback DNS). Inventory covers 278
  subdomains (46 resolving).
