# API inventory — console.byteplus.com (account A root, 3000823185)

| Method | Path | Source | Body/Query | Auth | Status |
|--------|------|--------|-----------|------|--------|
| POST | /api/top/dts/GetFeatures/2018-01-01/ap-southeast-1 | /dts | {} | A | seen |
| POST | /api/top/dts/DescribeDataSourceType/2022-10-01/ap-southeast-1 | /dts | {} | A | seen |
| POST | /api/top/dts/DescribeTransmissionTasks/2022-10-01/ap-southeast-1 | /dts | {TaskType,PageSize,PageNumber,ProjectName} | A | seen (empty) |
| GET | /api/top/account_verify/ap-southeast-1/2018-01-01/GetProfileInfo | /user/basics | - | A | seen (masked) |
| POST | /api/top/account_verify/ap-southeast-1/2018-01-01/GetRawProfileInfo | /user/basics | {} | A | seen (own raw PII) |
| POST | /api/top/account_verify/ap-southeast-1/2018-01-01/UpdateProfile | profile edit | see JS | A | untested |
| POST | /api/top/account_verify/ap-southeast-1/2018-01-01/CompleteProfile | profile edit | see JS | A | untested |
| POST | /api/v2/batch/iam | IAM | {Actions:[...]} | A/B | tested negatives |
| POST | /api/top/resourcecenter/{region}/2023-06-01/SearchResources | resourcemanager | {Scope,...} | A | seen |
| POST | /api/top/resourcecenter/{region}/2023-06-01/GetResourceCounts | resourcemanager | {Scope,...} | A | seen |
| POST | /api/top/account_management/ap-southeast-1/2018-01-01/GetAccountLoginSecurity | /user/basics | {} | A | seen |
| GET | /api/top/account_verify/ap-southeast-1/2018-01-01/GetApplication | /user/basics | - | A | seen |
| POST | /api/top/consolemessage/ap-singapore-1/2024-05-01/ListInMail | shell | {} | A | seen |
