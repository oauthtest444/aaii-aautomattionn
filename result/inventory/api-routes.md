# API Route Inventory

Target: https://console.byteplus.com
Auth context: account A (AccountID 3000823185) unless noted.
Note: `ResponseMetadata.Error` inside HTTP 200 is the API's normal error envelope.
AccountID / AccountId / PayerID / SubmitterID tampering was ignored (session-scoped)
on every endpoint where it was tested; those are recorded as not vulnerable.

| Method | Path | Parent Top-Level Route | Auth | Status | Summary |
|---|---|---|---|---|---|
| GET | /api/top/account_verify/ap-southeast-1/2018-01-01/GetProfileInfo | /finance/overview | account A | completed | Masked profile. AccountID/body tamper ignored, session-scoped. |
| POST | /api/top/account_verify/ap-southeast-1/2018-01-01/GetRawProfileInfo | /finance/overview | account A | completed | Raw profile PII (own account). AccountID tamper ignored, session-scoped. |
| GET | /api/financial/const/getExpenseConfigForFE | /finance/overview | account A | completed | 200; cashier polling config only. |
| GET | /api/top/bill_volcano_engine/ap-singapore-1/2020-01-01/GetAccountGrayStatus | /finance/overview | account A | completed | 200; GrayStatus=false. |
| GET | /api/top/bill_volcano_engine/ap-singapore-1/2022-01-01/GetCountryAreaCfg | /finance/overview | account A | completed | MissingParam CountryArea. |
| GET | /api/top/bill/ap-singapore-1/2020-01-01/QueryCreditProtocolDetail | /finance/overview | account A | completed | AccountID ignored; returns caller account. Not IDOR. |
| POST | /api/top/bill/ap-singapore-1/2020-01-01/ListCostAnalysisTrend | /finance/overview | account A | completed | MissingParam BeginTimeStr. |
| GET | /api/top/bill/ap-singapore-1/2020-01-01/GetBcDiscountPriceAuth | /finance/overview | account A | completed | 200; HasAuth=1. |
| GET | /api/top/bill/ap-singapore-1/2022-01-01/ListMonthlyBillOpen | /finance/overview | account A | completed | PayerID scoped; B's PayerID returns empty. Not IDOR. |
| POST | /api/financial/payment/FetchStoredPaymentMethods | /finance/overview | account A | completed | 200; own account agreement, no stored cards. |
| GET | /api/financial/const/getCashierTccConfig | /finance/overview | account A | completed | 200; cashier config. |
| POST | /api/top/account_management/cn-beijing/2018-01-01/GetAccountActionSecurity | /finance/overview | account A | completed | AccountId body tamper ignored; session-scoped. |
| POST | /api/top/bill/ap-singapore-1/2020-01-01/GetBalanceFromTradeBalance | /finance/overview | account A | completed | MissingParam ReqSysNo. |
| GET | /api/top/bill/ap-singapore-1/2020-01-01/CountCoupon | /finance/overview | account A | completed | 200; Total=0. |
| GET | /api/top/bill/ap-singapore-1/2020-01-01/GetQuotaAcctInfo | /finance/overview | account A | completed | AccountID query ignored; session-scoped. |
| GET | /api/top/bill_volcano_engine/ap-singapore-1/2020-01-01/CheckPaymentQualification | /finance/overview | account A | completed | MissingParam Subject*. |
| GET | /api/top/bill/ap-singapore-1/2020-01-01/GetCurrency | /finance/overview | account A | completed | 200; USD. |
| POST | /api/financial/payment/AddPaymentMethod | /finance/overview | account A | completed | Unresolved: bdms captcha + real-card write; not exercised. |
| POST | /api/top/account_management/ap-southeast-1/2018-01-01/GetAccountLoginSecurity | /finance/overview | account A | completed | AccountId body tamper ignored; session-scoped. |
| POST | /api/top/bill/ap-singapore-1/2020-01-01/ListAccountFinancialRole | /finance/overview | account A | completed | 200; FinancialRoleList=[0]. |
| GET | /api/top/bill/ap-singapore-1/2020-01-01/GetGreyInfo | /finance/overview | account A | completed | InvalidActionOrVersion (endpoint not deployed for version). |
| POST | /api/top/consolemessage/ap-singapore-1/2024-05-01/GetInMailUnreadCount | /finance/overview | account A | completed | 200; 20 unread. |
| POST | /api/top/consolemessage/ap-singapore-1/2024-05-01/ListInMail | /finance/overview | account A | completed | Own messages; AccountId tamper ignored. |
| POST | /api/top/ticket/ap-southeast-1/2021-01-01/GetTicketCountForUser | /finance/overview | account A | completed | Empty result; AccountID tamper ignored. |
| POST | /api/financial/trade/HasArrearsAlert | /finance/overview | account A | completed | 200; empty. |
| POST | /api/financial/qualification/GetWhitelistShortTermProducts | /finance/overview | account A | completed | 200; empty. |
| GET | /api/common/plat_growth/im/im-settings | /finance/overview | account A | completed | 200; IMEnable=true. |
| GET | /signin/status/identity | /finance/overview | account A | completed | Own identity (test-user-123). |
| POST | /api/common/plat_growth/im/visitor-sign | /finance/overview | account A | completed | Own visitor ID/sign. |
| POST | /api/top/ticket/ap-southeast-1/2021-01-01/ListTicketForUser | /workorder/list/ | account A | completed | Own tickets; AccountID ignored. |
| POST | /api/top/ticket/ap-southeast-1/2021-01-01/ListTicket | /workorder/list/ | account A | completed | Returns only caller's tickets despite staff action name. |
| POST | /api/top/ticket/ap-southeast-1/2021-01-01/GetTicket | /workorder/list/ | account A | completed | Requires TicketID; staff action. |
| POST | /api/top/ticket/ap-southeast-1/2021-01-01/GetTicketForUser | /workorder/list/ | account A | completed | Own ticket; AccountID tamper ignored. |
| POST | /api/top/ticket/ap-southeast-1/2021-01-01/UpdateTicketForUser | /workorder/list/ | account A | completed | AccountID/SubmitterID mass assignment ignored; persisted owner stays A. |
| POST | /api/top/ticket/ap-southeast-1/2021-01-01/ListTicketConversationForUser | /workorder/list/ | account A | completed | Own conversation content. |
| POST | /api/top/ticket/ap-southeast-1/2021-01-01/GetSensitiveConversation | /workorder/list/ | account A | completed | Own conversation unmasked; needs ConversationID. Cross-account Unresolved (no account B). |
| POST | /api/top/ticket/ap-southeast-1/2021-01-01/GetTicketReviewTemplate | /workorder/list/ | account A | completed | Review template config. |
| POST | /api/top/ticket/ap-southeast-1/2021-01-01/ListTicketExecutableActionForUser | /workorder/list/ | account A | completed | Empty list. |
| POST | /api/top/ticket/ap-southeast-1/2021-01-01/ListAllFlow | /workorder/list/ | account A | completed | 103 public subproducts/flow config. |
| POST | /api/top/ticket/ap-southeast-1/2021-01-01/GetFlow | /workorder/list/ | account A | completed | Requires FlowKey. |
| POST | /api/top/ticket/ap-southeast-1/2021-01-01/ListConsoleSubProduct | /workorder/list/ | account A | completed | Empty object. |
| POST | /api/top/ticket/ap-southeast-1/2021-01-01/DynamicCustomFieldList | /workorder/list/ | account A | completed | Field metadata only. |
| POST | /api/top/ticket/ap-southeast-1/2021-01-01/CreateTicket | /workorder/list/ | account A | completed | Created test ticket I-2026111513500001; AccountID/SubmitterID mass assignment ignored (owned by A). |
| POST | /api/top/ticket/ap-southeast-1/2021-01-01/CreateTicketForUser | /workorder/list/ | account A | completed | InvalidActionOrVersion. |

## Cross-cutting results

- CSRF: all POST actions require `X-CSRF-Token`; missing header returns
  `InvalidCSRFToken` for JSON, text/plain, and form-encoded bodies. No CSRF bypass.
- Unauthenticated calls fail (`InvalidCSRFToken` / `NotLogin`); no auth bypass found.
- Account A cookie digest expired 2026-11-15T06:00:21Z; re-login blocked by bdms
  slider captcha, so remaining cross-account tests are Unresolved.
