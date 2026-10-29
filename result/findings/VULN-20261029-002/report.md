# VULN-20261029-002 — Cross-account masked security contact via caller-controlled AccountID

Status: Confirmed (excluded from notification)
Type: IDOR / Broken access control
Asset: https://console.byteplus.com/api/workorder/ticket/GetAccountMaskedSecurityContact
Severity: Low
Authentication: user A

## Summary

The workorder ticket helper endpoint `GetAccountMaskedSecurityContact` accepts a
caller-supplied `AccountID` and returns that account's masked security email,
masked security telephone number, and email/telephone verification flags. A user
authenticated as account A (`3000823185`) can therefore query the masked security
contact metadata of account B (`3001021825`) by changing the JSON body. The
authorization decision should be based on the authenticated session, not on a
body parameter.

The exposed values are masked, so the practical impact is limited to partial
account metadata and verification-state disclosure. This is an account-existence
oracle and masked contact disclosure, which Section 9 of the project rules
explicitly excludes from `confirmed-vuln.txt`. The behavior is recorded here for
completeness and remediation, and is not submitted for notification.

## Reproduction

1. Authenticate to `https://console.byteplus.com/` as disposable account A
   (`AccountID=3000823185`).
2. Send `POST /api/workorder/ticket/GetAccountMaskedSecurityContact` with body
   `{}` and observe account A's masked contact.
3. Send the same request with body `{"AccountID":3001021825}`.
4. Observe that the response contains account B's masked security email
   (`t***********@********`) and verification flags
   (`EmailVerified: 1`, `TelVerified: 0`) instead of an authorization error.

The alternate spellings `AccountId` and `accountID` are also accepted, confirming
that the JSON field, not the session, selects the target account.

## Impact

An authenticated low-privilege user can determine whether another account has a
security contact, retrieve a partially masked email/phone pattern, and read the
email/phone verification state. No full email address or full telephone number is
disclosed and no write operation is possible. This is a low-impact IDOR / BAC
information disclosure and is excluded from the notification list per the
masked-contact exclusion in Section 9.

## Evidence

- `result/findings/VULN-20261029-002/evidence/request-response.md`
- `result/findings/VULN-20261029-002/payloads/payloads.md`

## Affected code

- Service definition: `609.9d2bee7c.js:1` (module `94747`,
  `GetAccountMaskedSecurityContact: l("GetAccountMaskedSecurityContact")`).
- Call site: ticket creation page (`/workorder/create`) loads the endpoint via
  `/api/workorder/ticket/GetAccountMaskedSecurityContact`.

## Remediation

Derive the account from the authenticated session and ignore client-supplied
`AccountID`. If a cross-account lookup is required for an administrative role,
enforce explicit role/relationship authorization and return a uniform error for
unauthorized accounts. Consider removing verification flags from the user-facing
response or returning only the minimum data needed to prefill the current
account's ticket form.

## Notification

`Confirmed-vuln.txt: excluded — masked contact details / account-existence oracle, per Section 9.`

Tested at: 2026-10-29T11:52:44Z
