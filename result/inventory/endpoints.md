# Endpoint / Client Inventory

Target: `https://console.byteplus.com/finance/`
Source bundles (versioned path): `https://res.gcloudcache.com/bp-fe/finance/byteplus/static/js/1.0.1.2888/`
Local copies: `result/client-side/console.byteplus.com/finance-overview/javascript/`

## URL pattern

`/api/top/<service>/<region>/<version>/<Action>`

- Session auth: cookies + `x-csrf-token` (value of `csrfToken` cookie).
- Finance regions: `ap-singapore-1` (bill, bill_volcano_engine), `ap-southeast-1` (account_verify, account_management).
- Default versions: `bill`/`bill_volcano_engine` 2020-01-01, account_verify/account_management 2018-01-01.
- Some invoice/tax actions use `bill_volcano_engine` 2022-01-01; region stable `ap-southeast-1`, non-stable `ap-singapore-1`.

## Read actions observed in use

| Service | Action | Method | Notes |
|---|---|---|---|
| account_verify | `GetProfileInfo` | GET | masked (`a***********`), session-scoped |
| account_verify | `GetRawProfileInfo` | GET | unmasked own profile, session-scoped; `AccountID` ignored |
| bill_volcano_engine | `GetTaxID` | GET | session-scoped; exact `AccountID` ignored |
| bill_volcano_engine | `GetCountryAreaCfg` | GET | `CountryArea` honored |
| bill_volcano_engine | `GetCountryAreaCfgByAccountID` | GET | session-scoped |
| bill_volcano_engine | `ListEmailForAccount` | GET | accepts exact `AccountID`; enforces invoice authz |
| bill_volcano_engine | `ListInvoiceBP`/`ListInvoiceBPV2` | GET | session-scoped |
| bill_volcano_engine | `ListRefundInvoiceBP` | GET | session-scoped |
| bill_volcano_engine | `ListInvoiceAndCreditNote(BP)` | GET | session-scoped |
| bill_volcano_engine | `DownloadBP` | GET | `DownloadID` -> signed URL |
| bill_volcano_engine | `CheckPaymentQualification` | GET | `AccountID`/`SubjectNo`; returns session account |
| bill_volcano_engine | `ListAccountFinancialRole` | GET | `[0]` main-account role |
| bill_volcano_engine | `GetAccountGrayStatus` / `GetGreyInfo` | GET | session-scoped |
| bill | `ListMonthlyBillOpen` | GET | `PayerID` honored as filter, isolated; `BillOwnerID`/`AccountID` ignored |
| bill | `ListPayerAndOwnerByBillOwnerID` | GET | isolated, empty when no sub-accounts |
| bill | `CountCoupon` | GET | session-scoped |
| bill | `ListCoupon` | GET | session-scoped |
| bill | `GetQuotaAcctInfo` | GET | no `AccountID` field |
| bill | `QueryCreditProtocolDetail` | GET | `AccountID` ignored |
| bill | `ListSubjectBalanceByAccountID` | POST JSON | `AccountID` ignored, returns session subject |
| bill | `GetBcDiscountPriceAuth` | GET | auth flag only |
| bill | `GetBalanceFromTradeBalance` | POST JSON | query form rejected; UI sends JSON |
| bill | `ListCostAnalysisTrend` | GET | session-scoped |
| bill | `ListRedeemCodes` / `ListPickupVouchers` | GET | empty for test accounts |
| account_management | `GetAccountActionSecurity`/`GetAccountLoginSecurity` | GET | session-scoped |
| volc_contract_process | `List` | GET | `Scene=1`, contracts empty |

## Write actions (CSRF enforced)

All tested state-changing actions reject missing token with `Error.Code: InvalidCSRFToken`:

- `bill_volcano_engine/2020-01-01/SetBcUserProductSplitDimensionOpen`
- `bill_volcano_engine/2020-01-01/ChangeCredits` (valid `ChangeType` observed: 2)
- `bill_volcano_engine/2020-01-01/OperateEmail`
- `bill_volcano_engine/2020-01-01/RedeemPickupVoucherCode`
- `bill_volcano_engine/2020-01-01/SetAccountRenewInfo`
- `bill_volcano_engine/2022-01-01/EditBillingAddress`
- `bill_volcano_engine/2022-01-01/AcceptTransferApplication`

## Additional actions present in JS maps (not exercised)

From `main.def4a3cd.js` @135690 (invoice module):
`GetInvoiceBP, GetRefundInvoiceBP, ListInvoiceDetailBP, ListInvoiceMakerInfoBP (POST JSON), ValidateTaxID, EditTaxExt (POST JSON), UploadBillingInfoDocument (POST raw)`.

From `main.def4a3cd.js` @14306 (`bill_volcano_engine` map):
`ListOptionForTransfer, ListInstanceForTransfer, CreateTransferApplication, ListMyinitiatedTransferApplication, ListMyReceivedTransferApplication, GetTransferApplicationDetail, ListTransferDstAccount, ListTransferDetails, ConfirmTransferApplication, ListTransferAcceptParam, CancelTransferApplication, CalculateRenewPrice, ModifyRenewSettings, CalculatePrice, SetAccountRenewInfo, RenewInstance, AsyncCreatePreorder, AsyncCreateOrder, CreateOrderAndPayForTerminate, QueryOrderPrice (2022), QueryWriteOffRecord, GetRedeemCodeDetail, GetRedeemCodeValue, ExportRedeemCodes, ListTemplateByProduct, ListPickupVouchers, EditBillingAddress (2022), QueryContractDiscount, QueryContractDiscountDisclaimer, ContractDiscountFilterOptions, QueryOrderPrice`.

## Client-side sinks reviewed

- `async_2693.00351e26.js`: pay component uses `props.returnUrl`; `location.href = returnUrl` (only `^/[^/]` prefixed with origin); `Pay` sends `ReturnUrl`. No consumer/URL source found in finance bundles.
- `async_4430.a89ed579.js`: validates redirect with default regex only (relative or fixed allowlist); `window.open` targets are constants.
- `main.def4a3cd.js` @93845: redirect guard uses `host.endsWith(secureDomain)`; `secureDomains` from runtime config, unresolved; `javascript:` blocked.
- No app-level `dangerouslySetInnerHTML`/`innerHTML` with user data in finance chunks.
- No app `message` event handlers in finance chunks.
- `AddPaymentMethod`/`payOrder` use server-supplied `redirect_details.url` or prop-derived callback URL.
