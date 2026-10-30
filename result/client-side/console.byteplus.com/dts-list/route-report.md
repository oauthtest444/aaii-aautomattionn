# Route report — /dts/region:dts+ap-southeast-1/

- Route: `https://console.byteplus.com/dts/region:dts+ap-southeast-1/`
- Auth context: Account A (`3000823185`) and Account B (`3001021825`)
- Tested: 2026-10-30T09:33–09:36Z
- Status: **Not Vulnerable** (no client-side finding)

## JavaScript analyzed

See `result/inventory/javascript.md` for the 14 route-loaded chunks and
SHA-256 hashes tested this run.

## Sources examined

- `URLSearchParams(window.location.search).get("TaskType")` in
  `6326.c2c15716.js` — selects a create-form configuration. It is not inserted
  into HTML or a code sink.
- `window.location.search` helper `l()` in `2382.bc8c653e.js` — returns a raw
  query value to callers; no reachable XSS sink in this route's chunks.
- `region`/`path`/`product` path builder `f()` in `2382.bc8c653e.js` — used by
  `p()` (`window.location.href = f(e)`), but only active in ops builds and not
  populated from attacker-controlled input.
- `document.referrer`, `location.hash`, `window.name`, `history.state` — no
  route-chunk uses.

## Sinks examined

No `dangerouslySetInnerHTML`, `.innerHTML`, `insertAdjacentHTML`,
`document.write`, `eval`, or `new Function` sinks with user-controlled input in
the route chunks. `window.open` calls use static help-doc/product links.
No postMessage listeners.

## Conclusion

No DOM/reflected XSS, CSTI, prototype pollution, client-side open redirect, or
postMessage finding in the analyzed route surface. Data rendered by the React
list views is escaped by framework defaults.

## Next steps (not pursued)

- Analyze lazily-loaded detail/create route chunks for stored-XSS rendering of
  data-source/task names if more time is available.
