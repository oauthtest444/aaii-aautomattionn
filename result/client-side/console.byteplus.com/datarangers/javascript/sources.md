# Sources — /datarangers

Unique user-controlled sources found in route-related JS:

| Source | Location (offset) | Transport | Notes |
|---|---|---|---|
| `location.search` `callback` (CompleteProfile) | umi:460535 | query | Passed to hostname allow-list helper `T()` before `location.href`; same-host only |
| `location.search` `mp_info` | umi:3277300, umi:4749451 | query | `JSON.parse` of query value; parse failure only breaks render (no code execution) |
| `location.search` `hiddenNavbar`, `hiddenNavbarInFrame`, `disablegtm`, `user_locale`, `projectName` | main.e9a0251e.js:204428,273542,333358,38562 | query | Boolean/locale/project selection only |
| `window.location.href/pathname` | umi:326242, main.e9a0251e.js:270325 | navigation state | Used for route/host selection |
| `document.referrer` / `document.cookie` | umi:4044207,4050814; main.ef966d36.js:407756 | browser | Telemetry only (DataRangers/Slardar SDK) |
