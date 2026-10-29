# Unresolved items

- `UpdateProfile` / `CompleteProfile` mass-assignment: not tested (onboarding
  flow requires SMS captcha to reach `CompleteProfile`; exact payload unknown).
  Low value.
- `testtttt` IAM low-priv login failed (no login request captured); low-priv
  role context unavailable for vertical privilege-escalation checks.
- Ark/AgentKit `ImportGithubSkill` uses out-of-scope sibling subdomains; only
  pursue if reachable same-origin.
- Resolved: IAM `UpdateUser` mass assignment was WAF 403, not an authz bug
  (benign update succeeds; `AccountId`/`IsRoot` ignored). See ledger 15.
- Out of scope: product consoles hosted on `*.bytepluses.com` (TLS, Kafka, ALB
  healthcheck, resource_share) — cannot be tested from `console.byteplus.com`.
