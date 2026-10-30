# Server-side notes — console.byteplus.com /dts

## Auth contexts

- Account A: `adoringjepsen1@fearlessmails.com`, cookie `AccountID=3000823185`.
- Account B: `testt456`, cookie `AccountID=3001021825`.

API pattern: `POST /api/top/dts/{Action}/{Version}/{region}` with
`x-csrf-token` copied from the `csrfToken` cookie plus
`x-storage-request-source: Web`, `x-storage-language: en`,
`x-dts-accept-language: en`.

## Test-owned objects

| Account | DataSourceId | Name | Owner |
|---|---|---|---|
| B | 2116046640132395013 | aaitest-ds-b-renamed | prior test run |
| B | 2115010358560165895 | aaitest-ma-b-20261030 | prior test run |
| A | 2115010182613307397 | aaitest-a-20261030 | this run |

## Cross-account (BOLA/IDOR) verification — NEGATIVE

Tested 2026-10-30T09:32–09:34Z with Account A against B-owned resources.

- `DescribeDataSource` B id -> `Result:{}` (no data).
- `ListDataSource` as A -> `Count:1` (only A's object); `Identifier=<B id>`
  -> `Count:0`; `AccountId`/`AccountID`/`OwnerId`/`TenantId`/`UserId` etc. set
  to `3001021825` -> still `Count:1`; no B object leaked.
- `ModifyDataSource` B id -> `InternalError` / `MgrParamInvalid`; B object
  unchanged (verified by re-reading as B).
- `DeleteDataSource` B id -> HTTP 200 `Result:{}` but a later read as B
  confirmed the object still exists (silent no-op for non-owner).
- `DescribeDataSource` A id from Account B -> `Result:{}` (symmetric).
- `ListDataSourceAccounts`/`ListDataSourceDbs`/`ListDataSourceTables` accept a
  caller-supplied `DataSource` config object, not just an owner-scoped ID; they
  attempt a connection to the supplied host and are therefore not an IDOR
  primitive by themselves.

Conclusion: horizontal isolation is enforced for DTS data sources. No
cross-account read/write/delete impact found.

## Mass assignment — NEGATIVE

- `CreateDataSource` with extra `TenantId`, `AccountId`, `Owner`,
  `ProjectName`, `Tags` fields: extras ignored/not persisted; object remains
  owned by the creating account.
- `ListDataSource` with injected `AccountId`/`TenantId`/`IsAdmin` filters:
  ignored.
- No protected property change persisted.

## SSRF / connection tests — NEGATIVE

`CheckDataSourceConnection` (`{DataSource, AsyncCheck}`) rejects private and
reserved targets with `InvalidNetworkAddress.Unavaiable`:
`127.0.0.1`, `169.254.169.254`, `127.0.0.1.nip.io`, `localtest.me`, `[::1]`,
`2130706433`, `0x7f000001`, `127.1`, `0`, `100.100.100.200`, `198.18.0.1`,
`240.0.0.1`, `255.255.255.255`. Public `1.1.1.1:3306` is allowed and times out
(no interaction possible with a MySQL-speaking target we do not control).

## Information disclosure — ListMgrCustomerParam (excluded)

`POST /api/top/dts/ListMgrCustomerParam/2018-01-01/ap-southeast-1` returns
platform-manager tenant whitelist configuration to any authenticated customer
session (tested as Account A). Fields include internal tenant/account IDs in
`EnableRDSShardingTenantWhiteList`, `EnableByteESTenantIDList`,
`EnableUsingCustomInnerByteDanceMQTenantWhiteList`,
`EnableUsingCustomByteDanceRMQTenantWhiteList`,
`EnableSyncRDSShardingTenantWhiteList`, `EnableVolcEnterpriseRedisWhiteList`.

- Evidence: `result/findings/DTS-INFO-001/response.json`.
- No credentials, tokens, or user PII.
- Class is not one of the project's confirmed-vuln classes (XSS/CSTI/IDOR/BAC/
  open redirect) and impact is limited internal-config disclosure.
- `confirmed-vuln.txt: excluded — low-impact information disclosure, not a
  targeted high-impact class.`

## Other observations

- CSRF is enforced (`InvalidCSRFToken` without a matching token/session pair).
- `ListEgressIps` returns DTS egress IP ranges (expected feature, no finding).
- `GetSecurityToken` (`SecurityTokenOfBinlogInTOS`) hangs >18s for both test
  accounts; not usable.
- `/params`, `/dflow`, `/redirect` hidden routes: console-level 404 or internal
  navigation only.
- CORS returns a fixed `access-control-allow-origin` (not arbitrary reflection);
  only weak MITM-grade behavior, not reported.

## Cleanup

- Deleted the test data source created in Account A
  (`2115010182613307397`); `ListDataSource` as A now returns `Count:0`.
- B's pre-existing test data sources were left untouched after verification.
