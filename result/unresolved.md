# Unresolved Items and Low-Impact Observations

## OBS-20261031-001 — Cross-account masked security contact

- Endpoint: `POST /api/workorder/ticket/GetAccountMaskedSecurityContact`
- Auth: any authenticated account
- Observation: supplying another account's `AccountID` returns that account's masked security email, masked telephone, and `EmailVerified`/`TelVerified` flags. Unknown IDs return `AccountNotExist`.
- Reproduction:
  - A (`3000823185`) with `{}` → `a*************@*****************`, `+31******47048`
  - A with `{"AccountID":3001021825}` → `t***********@********`, tel empty
  - B (`3001021825`) with `{"AccountID":3000823185}` → `a*************@*****************`, `+31******47048`
- Impact: cross-account masked-PII disclosure plus account-existence/verification oracle. Data is masked (first email character, masked domain, country code + last 5 phone digits). Not high-impact under the reporting bar; not added to `confirmed-vuln.txt` and no Discord notification.
- Evidence: request/response captured during testing; see route reports under `result/client-side/console.byteplus.com/`.

## Unresolved

- `ListTicketFlow` cross-user `SessionID` IDOR: no second valid AI/create session was created, so ownership validation for another user's `SessionID` was not tested.
- `ListDiagnosticAuthorization`, `ApproveDiagnosticAuthorization`, `TerminateDiagnosticAuthorization`, `RejectDiagnosticAuthorization`: backend returned `InternalError`/`BadRequest` and no test authorization records existed.
- `ApproveAuthorization` / `TerminateAuthorization`: no authorization records existed to exercise the write path.
- `ConversationSensitiveWordDetection`, `GetFieldsRecommendation`, `GetQuestionDescription`: AI/form helpers not exercised; no cross-account data path identified.
