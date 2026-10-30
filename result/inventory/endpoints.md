# API endpoint inventory — `/api/top/dts/{Action}/{Version}/ap-southeast-1`

All requests: `POST`, JSON body, CSRF double-submit (`csrfToken` cookie +
`x-csrf-token` header), session cookies. Test accounts A/B.

| Method | Action / Path | Auth | Variants tested | Status |
|---|---|---|---|---|
| POST | ListDataSource | A, B | PageNum/PageSize; Identifier; AccountId/AccountID/OwnerId/OwnerAccountId/UserId/TenantId/TenantID/FilterAccountId/ResourceOwner/Account | Not Vulnerable |
| POST | DescribeDataSource | A, B | own id, other-account id | Not Vulnerable (isolation holds) |
| POST | CreateDataSource | A, B | baseline; extra TenantId/AccountId/Owner/ProjectName/Tags | Not Vulnerable (extras ignored) |
| POST | ModifyDataSource | A, B | own id; other-account id; full config payload | Not Vulnerable |
| POST | DeleteDataSource | A, B | own id; other-account id | Not Vulnerable (silent no-op) |
| POST | CheckDataSourceConnection | A, B | public, private, reserved, IPv4 encodings, DNS aliases | Not Vulnerable (SSRF filter) |
| POST | ListMgrCustomerParam | A, B | `{}`; 2018-01-01 | Confirmed but excluded (info disclosure) |
| POST | ListEgressIps | A | `{}` | Not Vulnerable (expected egress ranges) |
| POST | GetSecurityToken | A, B | SecurityTokenOfBinlogInTOS | Unresolved (times out) |
| POST | ListDataSourceAccounts/Dbs/Tables/Columns/Views/etc. | A | DataSource config object | Not Vulnerable by itself (caller-supplied config) |
| POST | DescribeTasks / DescribeValidationTasks | A | `{}` | No objects / no finding |
| POST | ListAccount / DescribeAllClusters | A | paging/account params | Unresolved (InternalError) |
| POST | CreateTransmissionTask / CreateValidationTask | A, B | empty/partial configs | Unresolved (opaque InternalError; schema not reconstructed) |
| POST | ListDFlowKV / PreviewDFlowKV / DescribeDFlowList | A | `{}` | Not registered at tested versions |

Full ledger: `result/server-side/test-ledger.md`,
`result/server-side/api-inventory.md`.
