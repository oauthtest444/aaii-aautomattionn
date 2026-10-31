# Server-Side Route Report — console.byteplus.com

Target: https://console.byteplus.com/ark/region:ap-southeast-1/tts/podcast?
Scope: `console.byteplus.com` `/ark/*` and its same-origin APIs
(`/api/top/ark/ap-southeast-1/2024-01-01/<Action>`), private BBP per
`data/targets.txt`.

## Auth contexts

| Context | Identity | AccountId | CSRF header |
|---|---|---|---|
| A | adoringjepsen1@fearlessmails.com | 3000823185 | 936ad52059ea36a969702b7276973db6 |
| B | testt456 | 3001021825 | 243b654965f4acdaf19b84f922924438 |

Both are disposable, test-owned accounts. B ran in an isolated browser context.
Requests were sent as `POST` with `Content-Type: application/json`, session
cookies, and the `x-csrf-token` header captured from the browser.

## Tested endpoints and results

### GetRawApiKey (cross-account IDOR attempt)

A requested B's test-owned key Id `301420`:

```json
{"Id": 301420}
```

Response (HTTP 200, application error):

```json
{"ResponseMetadata":{"Action":"GetRawApiKey","Error":{"Code":"NotFound.Id","Message":"The specified Id 301420 is not found."}}}
```

Adding `AccountId`, `AccountID`, or `accountId` to the body did not change the
result. Status: **Not Vulnerable**.

### ListApiKeys (tenant override attempt)

A's request with body `{"AccountId":3001021825}` returned only A's own keys
(Id 301316 and two others). `AccountID`/`accountId` variants also ignored.
Status: **Not Vulnerable**.

### GetInferenceUsage (filter injection attempt)

Body with `Filters:[{"Key":"AccountID","Values":["3001021825"]}]` returned:

```json
{"ResponseMetadata":{"Action":"GetInferenceUsage","Error":{"Code":"InvalidParameter.Filters.Key","Message":"The specified filter key is unsupported."}}}
```

A top-level `AccountId` was accepted but inert (caller's own usage returned).
Status: **Not Vulnerable**.

### GetAutoSetFreeLimit / ListDataCollectionPermissions

`AccountId:3001021825` in the body was ignored; responses contained only the
caller's own/generic configuration. Status: **Not Vulnerable**.

### GetAccountInfo / GetModelChargeItem / QueryModelPrice

Returned only caller-scoped account/billing data, or public pricing data for
`QueryModelPrice`. No tenant identifier influenced the resource set.
Status: **Not Vulnerable**.

### Tag APIs

`POST /api/tag/tag_resources_bff` and `/api/tag/untag_resources_bff` returned
`404 Not Found` on `console.byteplus.com` for ResourceType values
`apikey`, `api-key`, `ark:apikey`, `ark_apikey`, `ApiKey`, `ark-apikey`.
The endpoints are hosted on the BFF subdomain, which is Out of Scope.
Status: **Unresolved (Out of Scope endpoint)** — cross-account tagging cannot be
verified on the authorized host.

### Session endpoint

`GET /api/passport/account/getUser` returned only the current session identity
for both A and B. Status: **Not Vulnerable**.

## Out of Scope (not tested)

- `https://modelark-api.console.byteplus.com/ark/bff`
- `https://arkbff-ap-southeast1.console.byteplus.com`
- `/api/v1/ark_volc_console_proxy` → `/ark/bff-bytecloud`
- `console-embedded.byteplus.com/voice/new/*`

These are distinct subdomains/embedded origins not explicitly listed in
`data/targets.txt`; recorded per AGENT.md §4.3.

## Conclusion

No confirmed server-side vulnerability on `console.byteplus.com` within scope.
