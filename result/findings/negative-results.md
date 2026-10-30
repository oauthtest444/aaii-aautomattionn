# Negative / Excluded Results

All tests performed with two disposable accounts:
- A (victim/tenant 1): AccountID `3000823185`, org `test-org`, emails `sec-test-a-...@example.com`, `adoringjepsen1@fearlessmails.com`.
- B (attacker/tenant 2): AccountID `3001021825`, org `attacker-org`, emails `testt456@test.com`, `tijuanamama3@netn.top`.

## Cross-account (B -> A) read attempts

| Action | Parameter | Result |
|---|---|---|
| `ListEmailForAccount` | `AccountID=3000823185` | `RequestInvalid` `[3000823185][3001021825]无财务管理-发票授权` (authz enforced) |
| `ListEmailForAccount` | `AccountId`, `accountId`, `accountid`, `ACCOUNTID`, `account_id` | parameter ignored; returned B's own emails |
| `ListEmailForAccount` | duplicate `AccountID` (A then B / B then A), arrays, comma | first value used; authz still enforced |
| `GetTaxID` | all casings of AccountID | returns B's own TaxID; param ignored |
| `GetCountryAreaCfgByAccountID` | `AccountID` | session-scoped |
| `GetRawProfileInfo` / `GetProfileInfo` | `AccountID`/`AccountId`/`accountId`, GET and POST JSON | returns B's own profile; param ignored |
| `CheckPaymentQualification` | `AccountID=A&SubjectNo=1065` | returns `AccountID:3001021825` (session) |
| `QueryCreditProtocolDetail` | `AccountID=A` | returns `AccountID:3001021825` |
| `ListSubjectBalanceByAccountID` | POST `{AccountID:A}` | returns B's own subject balance |
| `CountCoupon` / `GetQuotaAcctInfo` | `AccountID=A` | session-scoped |
| `ListMonthlyBillOpen` | `PayerID=A` | empty (isolated); `PayerID=B` returns B's bill |
| `ListMonthlyBillOpen` | `BillOwnerID=A` / `AccountID=A` | ignored, returns B's own bill |
| `ListPayerAndOwnerByBillOwnerID` | `BillOwnerID=A` | empty |
| `ListAccountFinancialRole` | `AccountID=A` | `[0]` (session role) |
| `GetAccountActionSecurity` / `GetAccountLoginSecurity` | `AccountID=A` | returns `AccountId:3001021825` (session) |
| `ListInvoiceBP(V2)`, `ListRefundInvoiceBP`, `ListInvoiceAndCreditNote` | `AccountID=A` | empty own results |
| `ListInvoiceMakerInfoBP` | POST `{}`, `{AccountID:A}`, `{AccountId:A}`, `{BillOwnerID:A}`, `{PayerID:A}` | own/empty |

Cookie tamper: setting `AccountID=3000823185` cookie on B did not change server-side identity (`GetProfileInfo` still `3001021825`).

## CSRF

Requests without `x-csrf-token` to `EditBillingAddress`, `ChangeCredits`, `OperateEmail`, `RedeemPickupVoucherCode`, `AcceptTransferApplication`, `SetAccountRenewInfo`, `SetBcUserProductSplitDimensionOpen` all returned `Error.Code: InvalidCSRFToken`. Not reported (also CSRF is outside AGENT acceptance list).

## `ChangeCredits`

- `ChangeType: 1` -> `RequestInvalid: ChangeType`.
- `ChangeType: 2` -> `RequestInvalid: credits not verified, cannot cancel`, independent of `AccountID` (tested invalid IDs and B's own). Business precondition, not an authz bypass; A's ID not confirmed to be accepted because the precondition fails first.

## Excluded

- Unmasked own-profile data (`GetRawProfileInfo`) — own account only, by design.
- Account-existence oracles and verification flags — excluded by AGENT.
- Masked contact details — excluded by AGENT.
- `secureDomains` suffix check / `returnUrl` `javascript:` — not reachable from finance app; no URL source found; not proven.
