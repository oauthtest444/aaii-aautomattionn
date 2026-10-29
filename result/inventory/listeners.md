# Listener Inventory

| Listener | Location | Validation | Status | Notes |
|---|---|---|---|---|
| `BroadcastChannel("token-sync").message` | inline module | same-origin channel; checks `brand_id` when present | not-vulnerable (no cross-origin delivery) | BroadcastChannel is same-origin only. Handler propagates `NEW_TOKEN` token to `sessionStorage` and responds to `REQUEST_TOKEN` with the current token. |
| `window` `message` listeners | none observed | n/a | n/a | No postMessage listeners found in the launch bootstrap. |

Potential design note: every brand launch page on `launch.sptpub.com` shares the
same origin and the `token` sessionStorage key and `token-sync` channel name.
A script from another brand's renderer (third-party dependency) could read or
receive the token. This requires a malicious/compromised brand renderer or
attacker-controlled script on the same origin; no direct external delivery was
demonstrated.
