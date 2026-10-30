# API inventory — console.byteplus.com /dts

Base: `POST https://console.byteplus.com/api/top/dts/{Action}/{Version}/{region}`

Required headers (verified):
`content-type: application/json; charset=UTF-8`, `x-csrf-token: <csrfToken cookie>`,
`x-storage-request-source: Web`, `x-storage-language: en`,
`x-dts-accept-language: en`. Session cookies required.

| Method | Path (Action/Version) | Source | Body params | Auth | Response shape | Status |
|---|---|---|---|---|---|---|
| POST | ListDataSource/2022-10-01 | JS/network | PageNum, PageSize, Identifier, filters | user | `Result.Count`, `DataSourceList` | tested |
| POST | DescribeDataSource/2022-10-01 | JS/network | DataSourceId | user | `Result.DataSource` | tested |
| POST | CreateDataSource/2022-10-01 | JS/network | DataSource{Category,EndpointType,Name,PublicMySQLSettings} | user | `Result.DataSourceId` | tested |
| POST | ModifyDataSource/2022-10-01 | JS/network | DataSourceId, DataSource{...} | user | `Result` | tested |
| POST | DeleteDataSource/2022-10-01 | JS/network | DataSourceId | user | `Result{}` | tested |
| POST | CheckDataSourceConnection/2022-10-01 | chunk 6326 | DataSource, AsyncCheck | user | connection status/error | tested |
| POST | ListMgrCustomerParam/2018-01-01 | JS/network | `{}` | user | `Result.Params[]` | confirmed (excluded) |
| POST | ListEgressIps/2022-10-01 | JS/network | `{}` | user | `Result.Ips[]` | informational |
| POST | GetSecurityToken/2022-10-01 | chunk 9864 | Type=SecurityTokenOfBinlogInTOS | user | STS creds | unresolved (timeout) |
| POST | ListDataSourceAccounts/Dbs/Tables/Columns/Views/.../2022-10-01 | chunk 6326 | DataSource config, Db, TaskId | user | DB metadata | caller-supplied config |
| POST | DescribeTables/2022-10-01 | chunk 6326 | DBNames, DataSource, ObjectType, TaskId | user | table list | tested |
| POST | CreateTransmissionTask/2022-10-01 | JS/network | SrcConfig, DestConfig, SolutionSettings, TaskType | user | TaskId | unresolved (schema) |
| POST | CreateValidationTask/2022-10-01 | JS/network | SrcConfig, DestConfig, SolutionSettings, TaskType, IdempotencyKey | user | TaskId | unresolved (schema) |
| POST | DescribeTasks/2022-10-01 | JS/network | paging | user | `Result.Total` | tested |
| POST | DescribeValidationTasks/2022-10-01 | JS/network | paging | user | `Result{}` | tested |
| POST | ListAccount/2018-01-01 | chunk 606 | paging/account | user | InternalError | unresolved |
| POST | DescribeAllClusters/2018-01-01 | chunk 606 | paging | user | InternalError | unresolved |

No endpoints outside the `/dts/*` origin/scope were tested.
