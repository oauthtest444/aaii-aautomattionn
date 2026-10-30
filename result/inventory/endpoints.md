# Finance API Endpoint Inventory

All endpoints are same-origin `https://console.byteplus.com`. Auth = test account session.
Captured from `/finance/overview` and `/finance/bill/detail`.

| Method | Path | Params | Auth | Status | Notes |
|---|---|---|---|---|---|
| GET | /api/financial/const/getExpenseConfigForFE | - | user | tested negative | Returns FE feature flags |
| GET | /api/financial/trade/HasArrearsAlert | - | user | captured | |
| GET | /api/financial/qualification/GetWhitelistShortTermProducts | - | user | captured | |
| GET | /api/top/account_verify/ap-southeast-1/2018-01-01/GetProfileInfo | - | user | captured | Returns AccountId (3000823185 for A, 3001021825 for B) |
| GET | /api/top/bill/ap-singapore-1/2020-01-01/GetFilterInfoForBillDetail | BillPeriodBeginStr, BillPeriodEndStr | user | captured | |
| GET | /api/top/bill/ap-singapore-1/2020-01-01/ListBcProductSummaryOpen | BillPeriodBeginStr, BillPeriodEndStr, Limit, Offset | user | captured | |
| GET | /api/top/bill/ap-singapore-1/2020-01-01/ListPayerAndOwnerByBillOwnerID | BillPeriodBeginStr, BillPeriodEndStr, ResType | user | captured | |
| GET | /api/top/bill/ap-singapore-1/2020-01-01/ListSubscribeRecords | Offset, Limit | user | captured | |
| GET | /api/top/bill/ap-singapore-1/2022-01-01/ListMonthlyBillOpen | BillPeriodBeginStr, BillPeriodEndStr, payerID, IsFilterUnsettleData | user | tested not-vulnerable | payerID ignored; always returns session account data |
| GET | /api/top/bill/ap-singapore-1/2020-01-01/GetBcDiscountPriceAuth | - | user | captured | |

## IDOR test — ListMonthlyBillOpen `payerID`

- Account A session requested `payerID=3001021825` (account B). Response still contained
  A's own PayerID `3000823185`. Server scopes to session. **Not Vulnerable.**
- Evidence: `result/findings/` notes / testing-inventory.json flow entry.
