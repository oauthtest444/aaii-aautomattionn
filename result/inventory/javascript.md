# javascript inventory

| File | Route(s) | Notes |
|---|---|---|
| `iam-main.js` | /iam | IAM console entry; no `dangerouslySetInnerHTML` |
| `iam-5771.js` | /iam | 1 `dangerouslySetInnerHTML` (i18n `span`, static translation) |
| `usermono.js` | shell (all routes) | TEA/DataRangers AB SDK `yn` message listener; weak substring origin |
| `slardar.js` | shell | telemetry `message` listener |
| `bdms.js` | shell | exact-origin bridge listener |
| `rt-main.js` | shell | runtime chunk |
| `1548.*.js` | shell | vendor chunk |
| `Basics.*.js` | /user/basics | profile basics page chunk |

Detail: `result/client-side/console.byteplus.com/iam/javascript/manifest.md`.
| `rangers-umi.61a04b83.js` | /datarangers | Datarangers app bundle; sinks reviewed 2026-10-29 |
| `platform-runtime.main.e9a0251e.js` | all routes | Shared runtime; nav/route + telemetry sinks |
| `datatester/*.js` (17 bundles) | /datatester | app + microfrontend runtime + message center; reviewed 2026-10-29 |
