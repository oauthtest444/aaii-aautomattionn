# Route: /dts/region:dts+ap-southeast-1/

- Auth: account A (test-user-123, Account ID 3000823185)
- Timestamp: 2026-10-29T08:17Z
- Sub-routes discovered: /datasubscriptionv2, /datasynchronizationv2, /datavalidation, /datasource
- APIs seen:
  - POST /api/top/dts/GetFeatures/2018-01-01/ap-southeast-1
  - POST /api/top/dts/DescribeDataSourceType/2022-10-01/ap-southeast-1
  - POST /api/top/dts/DescribeTransmissionTasks/2022-10-01/ap-southeast-1
- Client-side: SPA loads ~250 JS assets from res.gcloudcache.com; truncated review pending.
- Notes: account has no DTS tasks (empty Result). No writable test object yet.
