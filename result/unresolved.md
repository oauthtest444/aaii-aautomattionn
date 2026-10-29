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
- Out of scope: DBW `MessageSDK` postMessage→`inject_script` DOM XSS sink in
  `res.gcloudcache.com/.../byteplus_storage_dbw/static/js/index.83bfed73.js`.
  Listener accepts `messageOrigin:"*"` and executes `evalString` via
  `script.innerHTML`, but the SDK is the iframe-side client (sends to
  `window.parent`); its document origin is the out-of-scope CDN. The sink was
  not present in any console-host bundle in the corpus.
- Auth blocked 2026-10-29: both test accounts hit the drag-puzzle CAPTCHA on
  login; no authenticated session available for remaining runtime tests.
