# Route inventory — console.byteplus.com /dts/*

Canonical base: `https://console.byteplus.com/dts/region:dts+ap-southeast-1/`

Observed DTS UI routes (from prior run's chunk/route analysis and this run):

| Route | Status | Notes |
|---|---|---|
| `/dts/region:dts+ap-southeast-1/` | tested | data migration list; loads t_ListDataMigration |
| `/dts/datasource/...` | tested (API) | data source list/create/describe/modify/delete |
| `/dts/datasynchronizationv2` (+ detail) | tested (API) | actions enumerated, no high-impact finding |
| `/dts/datasubscriptionv2` (+ detail) | tested (API) | actions enumerated, no high-impact finding |
| `/dts/datavalidation` (+ detail) | tested (API) | actions enumerated, no high-impact finding |
| `/dts/tasksearch` (+ `/detail/:id`) | tested (API) | no task objects available |
| `/dts/datamigrationv2/detail(/:id)` | tested (API) | no task objects available |
| `/dts/overview` | tested | no separate privileged API |
| `/dts/createV2` | tested (API) | create flows probed |
| `/dts/dflow` | unresolved | console-level 404 as test user |
| `/dts/etl-playground` | tested (API) | no high-impact finding |
| `/dts/event` | tested (API) | no high-impact finding |
| `/dts/modifyOrder` | not tested | order/billing action — out of safe scope |
| `/dts/params` | unresolved | console-level 404 as test user |
| `/dts/redirect` | tested | internal history.push only, no open redirect |
| `/dts/subscriptiontasksearch` | tested (API) | no high-impact finding |
| `/dts/synchronizationtasksearch` | tested (API) | no high-impact finding |
| `/dts/assessment/detail` | tested (API) | no high-impact finding |
| `/dts/datareplay/detail` | tested (API) | no high-impact finding |

No route outside `/dts/*` on `console.byteplus.com` was tested.
