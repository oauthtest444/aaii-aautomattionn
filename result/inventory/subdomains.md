# Subdomain Inventory

Target host: console.byteplus.com (explicitly authorized via data/targets.txt).

## In Scope

| Host | Status | Summary |
|---|---|---|
| console.byteplus.com | completed | Tested: `/ark/*` SPA routes and `/api/top/ark/ap-southeast-1/2024-01-01/*` APIs. |
| www.console.byteplus.com | completed | Same application as console.byteplus.com. |

## Out of Scope

Confirmed present from network/JS analysis but not explicitly authorized by
`data/targets.txt`; not actively tested (AGENT.md §4.3).

| Host | Status | Summary |
|---|---|---|
| console-embedded.byteplus.com | out of scope | Embedded voice app mounted by the podcast page (`/voice/new/*`). |
| modelark-api.console.byteplus.com | out of scope | ModelArk BFF; `/ark/bff` and many account-scoped actions. |
| arkbff-ap-southeast1.console.byteplus.com | out of scope | Regional BFF referenced by the SPA. |
| lf-global-static.iapplogcdn.com | out of scope | Third-party analytics SDK asset CDN. |

## Notes

- `console.byteplus.com` was the only host exercised with authenticated traffic.
- `console-embedded.byteplus.com` cannot be reached through the authorized
  target host and is a distinct origin; its sub-routes were recorded but not probed.
