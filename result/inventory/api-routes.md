# API Route Inventory

| Method | Path | Parent Top-Level Route | Auth | Status | Summary |
|---|---|---|---|---|---|
| GET | /api/top/account_verify/ap-southeast-1/2018-01-01/GetProfileInfo | /finance/overview | account A | completed | Masked profile. AccountID/body tamper ignored, session-scoped. |
| POST | /api/top/account_verify/ap-southeast-1/2018-01-01/GetRawProfileInfo | /finance/overview | account A | completed | Raw profile PII (own account). AccountID tamper ignored, session-scoped. |
| GET | /api/financial/const/getExpenseConfigForFE | /finance/overview | account A | pending | FE expense config. |
| GET | /api/top/bill_volcano_engine/ap-singapore-1/2020-01-01/GetAccountGrayStatus | /finance/overview | account A | pending | Gray feature status. |
| GET | /api/top/bill_volcano_engine/ap-singapore-1/2022-01-01/GetCountryAreaCfg | /finance/overview | account A | pending | Country config. |
| GET | /api/top/bill/ap-singapore-1/2020-01-01/QueryCreditProtocolDetail | /finance/overview | account A | completed | AccountID ignored; returns caller account. Not IDOR. |
| POST | /api/top/bill/ap-singapore-1/2020-01-01/ListCostAnalysisTrend | /finance/overview | account A | pending | Cost trend. |
| GET | /api/top/bill/ap-singapore-1/2020-01-01/GetBcDiscountPriceAuth | /finance/overview | account A | pending | Discount auth. |
| GET | /api/top/bill/ap-singapore-1/2022-01-01/ListMonthlyBillOpen | /finance/overview | account A | completed | PayerID scoped; B's PayerID returns empty. Not IDOR. |
| POST | /api/financial/payment/FetchStoredPaymentMethods | /finance/overview | account A | pending | Stored payment methods. |
| GET | /api/financial/const/getCashierTccConfig | /finance/overview | account A | pending | Cashier config. |
| POST | /api/top/account_management/cn-beijing/2018-01-01/GetAccountActionSecurity | /finance/overview | account A | completed | AccountId body tamper ignored; session-scoped. |
| POST | /api/top/bill/ap-singapore-1/2020-01-01/GetBalanceFromTradeBalance | /finance/overview | account A | pending | Balance; server derives account. |
| GET | /api/top/bill/ap-singapore-1/2020-01-01/CountCoupon | /finance/overview | account A | pending | Coupon count. |
| GET | /api/top/bill/ap-singapore-1/2020-01-01/GetQuotaAcctInfo | /finance/overview | account A | completed | AccountID query ignored; session-scoped. |
| GET | /api/top/bill_volcano_engine/ap-singapore-1/2020-01-01/CheckPaymentQualification | /finance/overview | account A | pending | Payment qualification. |
| GET | /api/top/bill/ap-singapore-1/2020-01-01/GetCurrency | /finance/overview | account A | pending | Currency. |
| POST | /api/financial/payment/AddPaymentMethod | /finance/overview | account A | pending | Add payment method (write; do not submit real card). |
| POST | /api/top/account_management/ap-southeast-1/2018-01-01/GetAccountLoginSecurity | /finance/overview | account A | completed | AccountId body tamper ignored; session-scoped. |
| POST | /api/top/bill/ap-singapore-1/2020-01-01/ListAccountFinancialRole | /finance/overview | account A | pending | Financial roles; empty form body. |
| GET | /api/top/bill/ap-singapore-1/2020-01-01/GetGreyInfo | /finance/overview | account A | pending | Grey info. |
| POST | /api/top/consolemessage/ap-singapore-1/2024-05-01/GetInMailUnreadCount | /finance/overview | account A | pending | In-mail unread count. |
| POST | /api/top/consolemessage/ap-singapore-1/2024-05-01/ListInMail | /finance/overview | account A | pending | In-mail list. |
| POST | /api/top/ticket/ap-southeast-1/2021-01-01/GetTicketCountForUser | /finance/overview | account A | pending | Ticket count. |
| POST | /api/financial/trade/HasArrearsAlert | /finance/overview | account A | pending | Arrears alert. |
| POST | /api/financial/qualification/GetWhitelistShortTermProducts | /finance/overview | account A | pending | Whitelist products. |
| GET | /api/common/plat_growth/im/im-settings | /finance/overview | account A | pending | IM settings. |
| GET | /signin/status/identity | /finance/overview | account A | pending | Identity status. |
| POST | /api/common/plat_growth/im/visitor-sign | /finance/overview | account A | pending | IM visitor sign. |
