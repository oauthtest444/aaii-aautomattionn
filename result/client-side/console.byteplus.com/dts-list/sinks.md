# Sinks — DTS list route

- No HTML execution sinks (`innerHTML`, `dangerouslySetInnerHTML`,
  `insertAdjacentHTML`, `document.write`, `eval`, `new Function`) with user
  input.
- `window.location.href = f(...)` exists in 2382 but is ops-only and not
  attacker-controlled.
- `window.open(...)` targets static documentation/product URLs.
