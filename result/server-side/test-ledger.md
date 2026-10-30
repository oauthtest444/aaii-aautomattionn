# Test ledger — server-side

Legend: Confirmed / Not Vulnerable / Unresolved / Out of Scope.
All tests used test-owned objects and harmless values.

| # | Endpoint + variant | Auth | Baseline | Test | Result | Status |
|---|---|---|---|---|---|---|
| 1 | DescribeDataSource B id `2116046640132395013` | A | B reads own object | A reads B id | `Result:{}` no data | Not Vulnerable |
| 2 | DescribeDataSource A id `2115010182613307397` | B | A reads own object | B reads A id | `Result:{}` no data | Not Vulnerable |
| 3 | ListDataSource + `Identifier=<B id>` | A | Count 1 | Count 0 | no leak | Not Vulnerable |
| 4 | ListDataSource + AccountId/OwnerId/TenantId/UserId=`3001021825` | A | Count 1 | Count 1 | filters ignored | Not Vulnerable |
| 5 | ModifyDataSource B id (minimal + full payload) | A | B object present | A modify | `InternalError`/`MgrParamInvalid`; B unchanged | Not Vulnerable |
| 6 | DeleteDataSource B id | A | B object present | A delete | `Result{}`; B still lists object | Not Vulnerable |
| 7 | CreateDataSource + TenantId/AccountId/Owner/ProjectName/Tags | A | create | create w/ extras | extras not persisted; owner unchanged | Not Vulnerable |
| 8 | CheckDataSourceConnection private/reserved/encoded IPs | A | public allowed | private targets | `InvalidNetworkAddress.Unavaiable` | Not Vulnerable |
| 9 | ListMgrCustomerParam `{}` | A | - | read | internal tenant whitelist config returned | Confirmed (excluded) |
| 10 | GetSecurityToken Type=BinlogInTOS | A/B | - | call | timeout >18s | Unresolved |
| 11 | CreateTransmissionTask / CreateValidationTask partial | A/B | - | call | opaque `InternalError`; no TaskId | Unresolved |
| 12 | ListAccount / DescribeAllClusters | A | - | paging/account params | `InternalError` | Unresolved |
| 13 | ListDFlowKV / PreviewDFlowKV / DescribeDFlowList | A | - | `{}` | InvalidActionOrVersion (not registered) | Not Vulnerable |
| 14 | CSRF: no token / token without session | A | valid call | strip token/session | `InvalidCSRFToken` / `NotLogin` | Not Vulnerable |
| 15 | ListDataSource order/name/identifier SQL metacharacters | A | Count 1/2 | quote/subquery probes | normal results, no SQL error | Not Vulnerable |

Evidence and request/response snippets: `result/server-side/notes.md`,
`result/findings/DTS-INFO-001/response.json`.
