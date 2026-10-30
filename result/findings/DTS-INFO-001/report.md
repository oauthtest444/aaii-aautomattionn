# DTS-INFO-001 — Authenticated disclosure of DTS manager tenant whitelist configuration

- Status: **Confirmed behavior — excluded from `confirmed-vuln.txt` (low-impact
  information disclosure, not a targeted high-impact class)**
- Type: Information disclosure (not XSS/CSTI/IDOR/BAC/open redirect)
- Asset: `https://console.byteplus.com/api/top/dts/ListMgrCustomerParam/2018-01-01/ap-southeast-1`
- Authentication: any authenticated console user (tested as Account A
  `3000823185`, which is a low-privilege DTS customer account)
- Severity: Low / Medium (internal configuration exposure; no secrets/PII)
- Tested at: 2026-10-30T09:17:36Z (captured) and re-confirmed 09:34:41Z

## Summary

`ListMgrCustomerParam` is a DTS platform-manager action that returns global
feature/tenant whitelist configuration. It is callable by an ordinary
authenticated customer session, not just internal operations users. The response
lists internal tenant/account IDs used in DTS feature gating.

## Reproduction

1. Sign in to `https://console.byteplus.com` with the test account.
2. Read the `csrfToken` cookie and send:

```http
POST /api/top/dts/ListMgrCustomerParam/2018-01-01/ap-southeast-1 HTTP/1.1
Host: console.byteplus.com
Content-Type: application/json; charset=UTF-8
x-csrf-token: <csrfToken cookie>
x-storage-request-source: Web
x-storage-language: en
x-dts-accept-language: en

{}
```

3. Observe HTTP 200 with `Result.Params[]` containing `Enable*WhiteList` names,
   `Desc`, and internal tenant ID values.

## Evidence

- `evidence/response.json` — full captured request/response, including the
  authenticated 200 body and the CSRF/session negative controls.
- Key values include `EnableRDSShardingTenantWhiteList`,
  `EnableSyncRDSShardingTenantWhiteList`, `EnableByteESTenantIDList`,
  `EnableUsingCustomInnerByteDanceMQTenantWhiteList`,
  `EnableUsingCustomByteDanceRMQTenantWhiteList`,
  `EnableVolcEnterpriseRedisWhiteList`.

## Why it is not in `confirmed-vuln.txt`

`skills/AGENT.md` Section 9 restricts the notification file to high-impact
classes (XSS with execution, CSTI, IDOR, BAC, dangerous open redirect). This is a
limited internal-configuration disclosure with no credentials, tokens, or
real-user PII. It is documented here and excluded.

```
Confirmed-vuln.txt: excluded — low-impact information disclosure, not a targeted high-impact class.
```

## Remediation

Restrict `ListMgrCustomerParam` to internal/operations roles and verify the
caller's service role before returning manager configuration.

## Duplicate status

First recorded entry for this endpoint/variant.
