# API Route Inventory

Base: `https://console.byteplus.com`
Auth: A = `adoringjepsen1@fearlessmails.com` / AccountID `3000823185`; B = `testt456` / AccountID `3001021825`.

| Method | Path | Parent | Auth | Status | Summary |
|---|---|---|---|---|---|
| POST | /api/top/ticket/ap-southeast-1/2021-01-01/ListTicket | /workorder/list/ | A, B | completed | Caller-scoped. Hidden `AccountID` (number/string), `AccountIDs`, `AccountIDList`, `Owner`, `TenantID`, `AccountId`, `SubmitterID`, `TicketIDs`, `SearchKey` are ignored. |
| POST | /api/top/ticket/ap-southeast-1/2021-01-01/ListTicketForUser | /workorder/list/ | A | completed | Caller-account tickets only. |
| POST | /api/top/ticket/ap-southeast-1/2021-01-01/GetTicketCount | /workorder/list/ | A | completed | Own counts; `AccountID`/`AccountIDs` ignored. |
| POST | /api/top/ticket/ap-southeast-1/2021-01-01/GetTicketCountForUser | /workorder/list/ | A | completed | Own counts; `AccountID` ignored. |
| POST | /api/top/ticket/ap-southeast-1/2021-01-01/GetTicket | /workorder/list/detail | A, B | completed | Cross-account `TicketID` returns `Forbidden`. ID variants (`%00`, spaces, case, `..`, arrays, null, numbers) fail. |
| POST | /api/top/ticket/ap-southeast-1/2021-01-01/GetTicketForUser | /workorder/list/detail | A | completed | Cross-account `TicketID` returns `Forbidden`. |
| POST | /api/top/ticket/ap-southeast-1/2021-01-01/ListTicketConversation | /workorder/list/detail | A, B | completed | Cross-account `TicketID` returns `Forbidden`. Own HTML/markdown content is server-sanitized at write time. |
| POST | /api/top/ticket/ap-southeast-1/2021-01-01/ListTicketConversationForUser | /workorder/list/detail | A | completed | Cross-account `TicketID` returns `Forbidden`. |
| POST | /api/top/ticket/ap-southeast-1/2021-01-01/GetSensitiveConversation | /workorder/list/detail | A, B | completed | Cross-account ConversationID/TicketID combinations fail (`NotFound`/`ResourceNotFound`); own pair returns content. |
| POST | /api/top/ticket/ap-southeast-1/2021-01-01/ListTicketExecutableAction | /workorder/list/detail | A | completed | Cross-account `TicketID` returns `Forbidden`. |
| POST | /api/top/ticket/ap-southeast-1/2021-01-01/GetTicketReviewTemplate | /workorder/list/detail | A | completed | Cross-account `TicketID` returns `Forbidden`. |
| POST | /api/top/ticket/ap-southeast-1/2021-01-01/UpdateTicket | /workorder/list/detail | A | completed | Cross-account `TicketID` returns `Forbidden`. `AccountID`, `SubmitterID`, `TicketState`, `HandleStatus`, `Status`, `NeedReview`, `ReviewStatus`, `SubProductID`, `FlowName` are ignored; only `NotificationMethods` updates. |
| POST | /api/top/ticket/ap-southeast-1/2021-01-01/HandleTicket | /workorder/list/detail | A | completed | Cross-account/invalid action returns `Forbidden`/`Unauthorized`. |
| POST | /api/top/ticket/ap-southeast-1/2021-01-01/ReviewTicket | /workorder/list/detail | A | completed | Cross-account `TicketID` returns `Forbidden`. |
| POST | /api/top/ticket/ap-southeast-1/2021-01-01/CreateTicket | /workorder/create | A | completed | Creates only under caller. `AccountID`, `SubmitterID`, `SubmitterEmail`, `TicketState`, `HandleStatus`, `Status`, `NeedReview`, `ReviewStatus`, `ConfirmedTime`, `FinishedTime` are ignored. |
| POST | /api/top/ticket/ap-southeast-1/2021-01-01/ListAllFlow | /workorder/create | A | completed | Public issue-type catalog. |
| POST | /api/top/ticket/ap-southeast-1/2021-01-01/ListTicketFlow | /workorder/create | A | unresolved | Session/AI-bound (`SessionID`, `IntelligentTaskID`). Cross-user SessionID IDOR not tested because no second valid session was created. |
| POST | /api/top/ticket/ap-southeast-1/2021-01-01/ListConsoleSubProduct | /workorder/create | A | completed | Public product catalog. |
| POST | /api/top/ticket/ap-southeast-1/2021-01-01/CreateTicketConversation | /workorder/list/detail | A, B | completed | Own ticket writes allowed; cross-account `TicketID` returns `Forbidden`. Server sanitizes stored HTML (`onerror`, `ontoggle`, `onfocus`, `javascript:` stripped; disallowed tags removed). Attachment `Url` is stored verbatim, but the client download handler rejects `javascript:`/`vbscript:`/`data:`/`file:` and image preview is `<img>` only; click test caused no execution. B-owned `FileID` is normalized to `Url:""`. |
| POST | /api/top/ticket/ap-southeast-1/2021-01-01/CreateTicketConversationForUser | /workorder/list/detail | A | completed | Cross-account `TicketID` returns `Forbidden`. |
| POST | /api/top/ticket/ap-southeast-1/2021-01-01/CommentTicket | /workorder/list/detail | A | completed | Cross-account `TicketID` returns `Forbidden`. |
| POST | /api/top/ticket/ap-southeast-1/2021-01-01/CommentTicketForUser | /workorder/list/detail | A | completed | Cross-account `TicketID` returns `Forbidden`. |
| POST | /api/top/ticket/ap-southeast-1/2021-01-01/ConversationSensitiveWordDetection | /workorder/list/detail | A | unresolved | Not exercised; requires conversation content and only returns sensitive-word matches. |
| POST | /api/top/ticket/ap-southeast-1/2021-01-01/GetFieldsRecommendation | /workorder/create | A | unresolved | AI/form helper; no cross-account data path identified. |
| POST | /api/top/ticket/ap-southeast-1/2021-01-01/GetQuestionDescription | /workorder/create | A | unresolved | AI/form helper; not exercised. |
| GET | /api/top/iam/ap-southeast-1/2018-01-01/ListRoles | /workorder/list/detail | A, B | completed | Empty for both test accounts. |
| GET | /api/top/iam/ap-southeast-1/2018-01-01/ListUsers | /workorder/list/detail | A, B | completed | Empty for both test accounts; no IAM user IDs to test `GetUserMaskedSecurityContact`. |
| GET | /api/workorder/ticket/getWorkorderConsoleConfig | /workorder/create | A | completed | Public console config; no user data. |
| POST | /api/workorder/ticket/getFormTokenAndCodeList | /workorder/create | A | completed | Field code/token mapping; no cross-account data. |
| POST | /api/workorder/ticket/GetAccountMaskedSecurityContact | /workorder/create | A, B | completed | **Cross-account IDOR confirmed:** arbitrary `AccountID` returns masked security email/phone and verification flags; account-existence oracle (`AccountNotExist`). Masked data only; low impact, not high-impact bar. |
| POST | /api/workorder/ticket/GetUserMaskedSecurityContact | /workorder/create | A, B | completed | Requires `UserId`; no IAM users exist; `UserSecurityContactNotExist`. |
| GET | /api/workorder/ticket/Tcc | /workorder/list/ | A | completed | Returns tag/config map (empty for test accounts). |
| POST | /api/workorder/ticket/ListAccountLabelsByKeys | /workorder/create | A | completed | Returns labels for caller-supplied label keys; no account data. |
| GET | /api/workorder/ticket/getWotkorderFinanceProduct | /workorder/create | A | completed | Finance-only product catalog; not applicable to test accounts. |
| POST | /api/top/authorization/ap-southeast-1/2021-01-01/ListAuthorization | /workorder/authorizationList | A | completed | Caller-scoped; empty. `AccountID` rejected as invalid parameter. |
| POST | /api/top/authorization/ap-southeast-1/2021-01-01/ListAuthorizationForUser | /workorder/authorizationList | A | completed | Caller-scoped; empty. `AccountID` rejected as invalid parameter. |
| POST | /api/top/authorization/ap-southeast-1/2021-01-01/ListDiagnosticAuthorization | /workorder/authorizationList | A | unresolved | `InternalError` without params, `BadRequest` with `AccountID`; no data returned. |
| POST | /api/top/authorization/ap-southeast-1/2021-01-01/ApproveAuthorization | /workorder/authorizationList | A | unresolved | No authorization records available to exercise. |
| POST | /api/top/authorization/ap-southeast-1/2021-01-01/TerminateAuthorization | /workorder/authorizationList | A | unresolved | No authorization records available to exercise. |
| POST | /api/top/authorization/ap-southeast-1/2021-01-01/ApproveDiagnosticAuthorization | /workorder/authorizationList | A | unresolved | No records; backend errors. |
| POST | /api/top/authorization/ap-southeast-1/2021-01-01/TerminateDiagnosticAuthorization | /workorder/authorizationList | A | unresolved | No records; backend errors. |
| POST | /api/top/authorization/ap-southeast-1/2021-01-01/RejectDiagnosticAuthorization | /workorder/authorizationList | A | unresolved | No records; backend errors. |
| POST | /api/top/ticket/2022-01-01/UploadFile | /workorder/create | A | completed | Raw upload works; file ownership enforced. |
| POST | /api/top/ticket/2022-01-01/GetPreSignedPostSignature | /workorder/create | A, B | completed | Server issues FileID + scoped TOS signature; client-supplied `FileID`/`Key` not honored; `FileType` allowlist. |
| POST | /api/top/ticket/2022-01-01/SaveFile | /workorder/create | A, B | completed | B cannot `SaveFile` A's FileID (`Forbidden`); owner succeeds. |
| GET | /api/top/ticket/2022-01-01/DownloadFile?FileID=... | /workorder/create | A, B | completed | Owner can download; B downloading A's FileID returns `Forbidden`. |
| POST | /api/top/ticket/2022-01-01/GetPreSignedDownloadURL | /workorder/create | A | completed | Not a real operation (`InvalidActionOrVersion`) for ticket service; 404 on workorder/common paths. |
| POST | /api/top/ticket/ap-southeast-1/2021-01-01/GetPreSignedDownloadURL | /workorder/create | A | completed | `InvalidActionOrVersion`. |
