# Server-Side Coverage — console.byteplus.com

Status: completed (finance + workorder)
Auth: account A 3000823185 and account B 3001021825 (both HTTP 200 validated
2026-11-17). Account B used as attacker context against account A identifiers.

## Finance (/finance/overview)

Endpoints discovered across all 19 finance sub-routes are listed in
`result/inventory/api-routes.md` (Finance sub-route APIs section).

Tested classes per endpoint: IDOR/BOLA, broken access control, PII leakage,
business logic, mass assignment (where a write existed), hidden parameters,
and session/tenant scoping.

Key cross-account results:

- `ListMonthlyBillOpen?PayerID=3000823185` as B -> Total 0 (PayerID scoped).
- `ListBcProductSummaryOpen`, `GetFilterInfoForBillDetail`,
  `ListPayerAndOwnerByBillOwnerID`, `ListOperations`/`ListOrder`,
  `ListInvoiceBPV2`, `ListBalanceTransactionForPage`, `ListCoupon`,
  `volc_contract_process List` with A's IDs as B -> own empty data.
- `GetTaxID?AccountID=3000823185` as B -> returns B's own tax ID
  (AccountID 3001021825); session-scoped, not IDOR.
- `ListEmailForAccount?AccountID=3000823185` as B -> `RequestInvalid`
  `[3000823185][3001021825]无财务管理-发票授权`; authorization enforced.
- `GetQuotaAcctInfo`, `QueryCreditProtocolDetail`, `GetProfileInfo`,
  `GetRawProfileInfo`, `GetAccountActionSecurity`, `GetAccountLoginSecurity`
  remain session-scoped (prior and revalidated).
- POST actions still require `X-CSRF-Token`; no bypass.

Unresolved (documented, not confirmed):
- AddPaymentMethod / payment writes: require real card or bdms captcha; not
  exercised (no destructive/financial action permitted).
- Budget create/update and bill/invoice/contract write flows: test accounts
  have no bill/instance/invoice/contract objects to operate on.
- ListRedeemCodes / ListPickupVouchers require POST bodies and test voucher
  data, which the test accounts do not have.

## Workorder (/workorder/list/)

- B `GetTicketForUser` with A TicketID `I-2026111513500001` -> `Forbidden`.
- B `ListTicketConversationForUser` with A TicketID -> `Forbidden`.
- B `GetSensitiveConversation` with A TicketID/ConversationID -> `NotFound`.
- B `GetTicketCount` with A AccountID -> B's own counts (session-scoped).
- B `ListAuthorization` with A AccountID -> `InvalidParam`; UserID ignored ->
  own empty list.
- B IAM `ListUsers`/`ListRoles` with A AccountID -> B's own 4 users / 44 roles.
- B `GetAccountMaskedSecurityContact` -> B's own masked contact only.
- Prior: AccountID/SubmitterID mass assignment on ticket create/update ignored;
  persisted owner stayed A. CSRF enforced.

## Conclusion

No confirmed server-side vulnerability in this run. No IDOR/BOLA, BAC,
tenant-isolation break, PII leak, or mass-assignment impact was proven with
cross-account evidence. Status: Not Vulnerable for the tested combinations;
write-only flows documented Unresolved.
