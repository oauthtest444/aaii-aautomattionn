# Route report — /ark (client-side static)

- Date: 2026-10-29
- Auth: unavailable (login CAPTCHA); runtime route showed region-not-available /
  unauthenticated shell. Analysis is static over public bundles only.
- Final URL (unauthenticated): https://console.byteplus.com/ark/region:ap-southeast-1/overview
- Bundles reviewed (saved under `javascript/`, hashes in `sha256.txt`):
  `main.ac478a41e8.js`, `async-main.f0b90c71f0.js`, `4271.bf2bd0cb16.js`,
  `4708.188ebd1e2e.js`, `5198.9e6274e168.js`, `9196.7496d55a81.js`,
  `zod.c048e7ffac.js`.

## Summary
No client-side vulnerability confirmed.

## Sinks
- `dangerouslySetInnerHTML` occurrences (main + 4271) are React Router / SSR
  hydration internals: stream controller bootstrap, `ld+json`, import map,
  route module payload, and stylesheet/link injection. Values derive from the
  framework's own manifest and server-rendered payload, not attacker input.
- `innerHTML` in `main.*` is used by the same SSR loader plumbing.
- No `eval` / `new Function` / `document.write` reachable from URL, hash,
  postMessage, or storage.

## Listeners
- All `addEventListener("message", ...)` handlers in `4271.*` belong to the TEA
  / DataRangers SDK (multiple copies of the same SDK).
  - Device-debugger handlers accept any origin but only echo SDK info/log/events
    back to the sender, and enable a debugger panel; no HTML/script sink and no
    session secret.
  - `tea:openHeatMapCore` loads a hardcoded `lf-global-static.iapplogcdn.com`
    heatmap script; `app_id` only gates loading, not the URL.
- No route-specific postMessage listener found in the Ark app bundles.

## Flows checked
- URL/hash/query reflection: none into HTML or script sinks.
- Redirect/open: no attacker-controlled open redirect in reviewed bundles.
- `ImportGithubSkill` remains out-of-scope (uses sibling subdomains); not tested.

## Result
No confirmed client-side vulnerability on `/ark` from static review.
Auth-gated runtime testing (region enablement, in-app Flows) not performed due to
login CAPTCHA.
