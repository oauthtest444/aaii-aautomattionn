# VULN-20261029-001 — Open redirect via auth `redirectURI` (tab-character bypass)

- Status: **Confirmed** (open redirect)
- Type: Open Redirect (client-side / auth flow)
- Asset: `https://console.byteplus.com/auth/login/`
- Severity: Medium
- Authentication: unauthenticated (pre-login link); automatic for an
  already-authenticated victim
- Tested at: 2026-10-29T11:11:00Z

## Summary

The login page accepts a `redirectURI` query parameter and, after a successful
login (or immediately when the visitor already has a session), navigates the
top-level document to that value. Absolute URLs, protocol-relative URLs
(`//host`) and `/\host` are rejected, but a tab character inserted after the
leading slash (`/%09/evil.com/`) bypasses the same-origin validation. Browsers
strip the tab while parsing the URL, so `/\t/evil.com/` resolves to
`https://evil.com/`.

Impact: an attacker can send a link that, once the victim is logged in (or
right after they log in), silently takes them from the trusted
`console.byteplus.com` origin to an attacker-controlled site. This enables
credible phishing, OAuth/token-harvesting pages reached from a trusted link,
and generic open-redirect abuse. No JavaScript executes on the target origin,
so this is not reported as XSS.

## Reproduction

1. While logged in to `console.byteplus.com` (test account B), open
   `https://console.byteplus.com/auth/login/?redirectURI=%2F%09%2Fevil.com%2F`.
2. Observe the top-level document become `https://evil.com/` with no prompt.
3. Alternatively, in a clean browser open
   `https://console.byteplus.com/auth/login/?redirectURI=%2F%09%2Fexample.com%2F`,
   log in, and observe navigation to `https://example.com/`.

## Evidence

- `evidence/observation.md` — exact URLs, observed final URLs, network
  requests, and char-code verification.
- `payloads/redirect-uri.txt` — payloads.

## Affected code

`https://res.gcloudcache.com/bp-fe/vconsole-auth/byteplus/static/js/1.0.0.2811/main.adbc4e5a.js`
- login component reads `redirectURI` (`t.get("redirectURI")`) and the app
  performs `location.assign(...)` with the resulting destination.

## Remediation

- Resolve the `redirectURI` server-side with a strict URL parser and require
  the normalized origin to equal `https://console.byteplus.com`; reject any
  value containing C0 controls, backslashes, or leading `//`.
- Prefer an allowlist of relative paths and re-serialize the path instead of
  echoing the raw input.
- Do not auto-redirect already-authenticated users from the login page based on
  an unvalidated query parameter.

## Notification decision

`Confirmed-vuln.txt: excluded — Rule 9 excludes plain open redirects; a
dangerous javascript: URL was not achievable (verified, see evidence).`
