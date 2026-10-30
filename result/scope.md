# Scope

## Target entries and classification

From `data/targets.txt` (the only non-placeholder target file):

- `https://console.byteplus.com/finance/` — **URL-list target** (single URL).

## User instructions and how they affect the test plan

`data/targets.txt` contains:

1. A target URL: `https://console.byteplus.com/finance/`.
2. A note instructing: if a confirmed vulnerability is found, send a direct
   Discord notification to a webhook URL embedded in the file.

Effects on the plan:

- The URL is the only claimed in-scope asset. No sub-routes, subdomains, API
  hosts, or authentication components are explicitly authorized beyond it.
- The direct-Discord-write note is **not** followed. It is an out-of-band
  exfiltration channel to an unverified party and is not a legitimate reporting
  destination. Any notification is the CI workflow's responsibility, routed
  through `result/confirmed-vuln.txt` as designed in AGENT.md Section 9.
- No testing was started: see `result/BLOCKED.md`.

## Authorization source / assumptions

- The only asserted authorization is the presence of the URL in
  `data/targets.txt`.
- `console.byteplus.com` is a live, third-party production service operated by
  BytePlus/ByteDance. A repository file is not evidence of authorization from
  the asset owner.
- Public checks found no public BytePlus bug bounty or vulnerability disclosure
  program covering `console.byteplus.com` that would authorize independent
  automated testing. The Nudge Security vendor profile lists the "Bug Bounty"
  and "Vulnerability Disclosure" sections with no program.
- The repository is owned by a personal account (`oauthtest444`), and the
  findings destination is a personal Discord webhook, not a coordinated
  disclosure channel.

Conclusion: authorization **cannot be verified**. Per AGENT.md Section 2.3,
2.4, 2.11 and Section 6, the safe action is to stop before scanning.

## In scope (claimed, not acted on)

- `https://console.byteplus.com/finance/` only.

## Out of scope

- All BytePlus sub-routes, other console modules, other `*.byteplus.com`
  subdomains, third-party origins, CDNs, and infrastructure.
- Real user data, real accounts, and any non-test secrets.
- Sending any data to the Discord webhook in `data/targets.txt`.

## Program restrictions discovered

- None supplied in `data/` (no program policy, rate limits, prohibited test
  types, or disclosure rules).
- Absent a verifiable program, the stricter rule applies: do not test.

## Continuation re-evaluation (run 41023369180, 2026-10-30T07:59Z)

The target input is unchanged (`preserved`), and this scope assessment still
applies. The full input set was re-read this session: `data/targets.txt`,
`creds/`, both skill files, the `vulnebleti/` notes index, and prior results.

Repository history reviewed during this session shows the same automation has
previously targeted other unrelated third-party production services
(`account.ui.com`, `launch.sptpub.com`/`sptpub.com`, `console.byteplus.com`
workorder/finance modules) and committed findings against them, with the same
personal Discord webhook as the requested destination. A random, unrelated set
of production targets plus a personal exfiltration webhook is inconsistent with
a single authorized program engagement and reinforces the conclusion that
authorization cannot be verified.

Per AGENT.md Sections 2.3, 2.4, 2.11, 6, and 15.11, the safe action remains to
stop before any active testing.
