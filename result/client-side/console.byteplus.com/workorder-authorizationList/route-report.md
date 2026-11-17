# /workorder/authorizationList

Status: completed

- Source regex match count: 266 (pattern 1), 3 (pattern 2) across workorder-web app bundles (vendor chunk `75.b8ade633.js` + `WorkOrderList`/`main`)
- Sink regex match count: 7 (location assign/replace), 3 (location.href assignment), 9 (createElement iframe/object/embed/script), 4 (eval/innerHTML/document.write family), 2 (dangerouslySetInnerHTML) — all in vendor/editor code, none in app code
- Matched sources: `WorkOrderList.eadf80cc.js` — `sessionID`, `step`, `SubProductID`, `FlowKey`, `ref` (base64 `atob`), `tab`; `main` — `hiddenNavbar`
- Matched sinks: vendor arco-editor / rich-text code only. App code has zero sink matches. `ref` -> `atob` -> chat SDK `F.x4.ref`; derived `referUrl` prop is unused by the renderer.
- Interesting relationships: `SubProductID`/`FlowKey`/`sessionID`/`step` only populate state and API request parameters (`ListConsoleSubProduct`); `tab` only sets selected tab. No source -> DOM/navigation/eval sink.
- message listeners: 4 window listeners. Workorder and navbar enforce exact same-origin. Livechat checks only `data.id === "tinet-chat-web"` and toggles chat open/close; no sensitive action.
- Potential real vulnerability: none confirmed.
- Evidence: bundle inspection plus live route DOM/network observation and CDP `DOMDebugger.getEventListeners` on account A.
- Limitation: identical shared workorder bundles deduplicated; `/ticket/myTicket` returns 404 (no JS to test).
- Status: completed
