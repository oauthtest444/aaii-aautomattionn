# Server-Side API Automation Skill

## Mission

Find valid, reportable server-side bugs. This file is for automation.

- **Never ask the user anything.** You have full permission to test in-scope
  APIs. Ask yourself as a top hunter, answer yourself, then act.
- **Main goal:** on every visited URL, extract all server-side API routes from
  network traffic and JavaScript, understand their valid parameters, then test
  every route for all server-side bug classes.
- **Primary focus:** mass assignment on create/edit/update endpoints, and
  guessing valid parameters for those endpoints.
  Test unique endpoint/method/variant combinations only. No duplicate testing.
- Use test-owned data only. No real users.
- Practical evidence only. A `200`, an accepted extra field, or a generic error
  is not a vulnerability by itself.

---

## Inputs

The orchestrator supplies:

- **Authorized scope** from `data/`: domain-only targets or an explicit URL
  list, plus any explicitly authorized components.
- **Visited-URL / route queue** and the current route's canonical URL.
- **Captured network traffic** for the route and safe UI actions: method, full
  URL, query, body, headers, auth context, and response shape.
- **Route-related JavaScript**: API call sites, wrappers, endpoint constants,
  GraphQL/tRPC/OpenAPI definitions, source maps, and types needed to resolve a
  request.
- **Credentials** from `creds/`, including available roles and ownership
  contexts. Test-account secrets are intentionally public; never expose
  real-user secrets.
- **Vulnerability knowledge** from `vulnebleti/` relevant to the endpoint,
  framework, or bug class.
- **Prior API ledger** from `result/inventory/endpoints.md` and
  `result/testing-inventory.json`.
- **Chrome DevTools MCP** for traffic capture, plus `curl`/HTTP tooling for
  controlled requests.
- **Time budget** and current elapsed time.
- **Output root**: `result/`.

Validate inputs before testing:

- Skip any endpoint outside the authorized scope.
- Canonicalize the endpoint and deduplicate by method + normalized path +
  meaningful parameter variant + auth context.
- Confirm the auth context and role for every request.
- If a required credential, role, or second account is unavailable, mark the
  specific test **Unresolved** and continue. Never ask the user.

## Preconditions

- Headless Chrome is running and the `chrome-devtools` MCP server is connected.
- The target route is reachable and authorized.
- Test-owned objects can be created for write/ownership tests.
- A second account is available when cross-account proof is required; otherwise
  the test is **Unresolved**.
- The current session has enough time remaining to finish the endpoint and
  write evidence. Do not start a long test with less than ~45 minutes left.

---

## Per-Visited-URL Flow

1. Open the current visited URL with Chrome DevTools MCP.
2. Capture every API request caused by the route and normal UI interactions.
3. Read route-related JavaScript and extract each API route with its method,
   query, body, path IDs, and valid parameters.
4. Build a deduplicated API inventory.
5. Test every endpoint for all server-side bug classes.
6. Verify impact, record the result, move to the next endpoint/route.
7. If a test needs unavailable access/state, mark **Unresolved** and continue.
   Do not stop to ask.

**Route-related JS:** scripts loaded/executed by the route, inline scripts,
dynamic chunks/imports, workers, source maps, and helpers needed to resolve the
API call. Do not scan unrelated files.

---

## Phase 1 — Extract All API Routes

### Network capture

For the visited URL and safe normal UI actions, capture:

- method, full URL, query parameters,
- request body (JSON/form/multipart/GraphQL),
- auth context and role (test secrets may be shown; redact real-user data),
- response status and response shape,
- GraphQL operations, WebSocket/SSE, and hidden XHR/fetch calls.

Do not create real data or trigger external side effects just to discover an
endpoint.

### JavaScript analysis

Search route-related JS for:

- `fetch`, `axios`, `XMLHttpRequest`, `$.ajax`, `navigator.sendBeacon`,
- client wrappers (`client.get/post/put/patch/delete`, `request(...)`,
  `api(...)`, `http(...)`),
- endpoint constants, `baseURL`, path concatenation, template literals,
- GraphQL `query`/`mutation`, tRPC, OpenAPI/Swagger,
- source maps, TypeScript types/interfaces, inline scripts, workers.

For each API call trace the exact path, method, path/query/body/header
parameters, ID generation, required vs server-managed fields, and response
shape. Follow helpers/imported code only as needed.

### Guess valid parameters

Derive likely valid fields from:

- JS call sites, request defaults, form schemas, TypeScript types, source maps,
- GraphQL schemas, OpenAPI/Swagger, API docs,
- response objects from GET/list/detail/create calls,
- server validation errors (`unknown field`, `required`, type errors),
- common naming conventions.

High-value candidates:

```text
id, uuid, userId, ownerId, accountId, organizationId, tenantId, role, roles,
isAdmin, admin, permissions, scopes, status, state, type, plan, tier, verified,
emailVerified, balance, credits, price, amount, quantity, isDeleted, deletedAt,
visibility, public, createdAt, updatedAt
```

Record the evidence suggesting each parameter is valid. Test one at a time with
harmless values.

### API inventory

```text
| Method | Path | Source | Query | Body | Path IDs | Auth/role | Owner |
| Response shape | Valid-param evidence | Status |
```

Deduplicate by method + normalized path + meaningful parameter variant. Keep
distinct roles, ownership contexts, and parameter sets.

---

## Phase 2 — Test Every API for All Bug Classes

### Mass assignment — primary focus

For every create, edit, update, patch, and upsert endpoint:

1. Establish a baseline with ordinary fields and a disposable test object.
2. Add **one** sensitive field at a time using test-owned values.
3. Test create and update separately; try JSON, form, and multipart bodies
   where accepted.
4. Compare the response, then re-read the persisted object.
5. Verify whether a protected property actually changed: ownership, role,
   tenant, permissions, identity, lifecycle/status, plan, credits, price, or
   verification state.
6. Ignored, encoded, or reverted fields = blocked.
7. Accepted-but-inert fields are **not** a finding. Require a security-relevant
   persisted or effective change.

Try nested objects, arrays, `null`, empty strings, type changes, and duplicate
keys only when relevant. Do not spray every field blindly.

### IDOR / BOLA

- Create a disposable object as Account A; access it as Account B when a second
  test account is available.
- With only one account, test ownership transitions using test-owned objects;
  if a second auth context is required for proof, mark **Unresolved**.
- Read first, then edit, then delete only the agent-created test object. Verify
  persisted state, not just status codes.
- Test path ID vs body/query ID, method override (`_method`,
  `X-HTTP-Method-Override`), and bounded path variants.
- Never guess or enumerate real user IDs.

Bounded path variants (one at a time, only where relevant):

```text
.json, /.json, .txt, /.txt, .xml, /.xml
..;/, //, /x/.., /*, /%, /_, /., s, *, ;
%20, %09, %0b, %0c, %1c, %1d, %1e, %1f
```

A variant matters only if it reaches an object or operation the account should
not access.

### Authentication, authorization, tenant boundaries

- Test without auth, with a lower-privilege account, and with another account.
- Test horizontal (same role, different user) and vertical (role escalation)
  access.
- Change org/tenant IDs to test-owned values; verify server-side isolation.
- Test whether the API permits actions the UI hides or blocks.
- A client-side-only restriction is not proof of a server-side bypass.

### Business logic

Test for:

- price/amount/quantity/credits/plan manipulation,
- skipped workflow steps or invalid state transitions,
- replay of sensitive/one-time actions,
- entitlement or feature-limit bypass through direct API calls,
- client-controlled status, role, ownership, or identifiers,
- inconsistent read/edit/delete authorization,
- claiming identifiers that should be server-controlled.

Use test-owned resources; no charges or external effects.

### SSRF, command injection, prototype pollution

- **SSRF:** for URL/host/webhook/import/preview parameters, establish a benign
  baseline and use only a tester-controlled callback or explicitly authorized
  destination. Do not probe internal networks, cloud metadata, localhost, or
  third-party systems unless specifically authorized.
- **Command injection:** only when a parameter plausibly reaches server-side
  command execution. Use a safe, non-destructive differential proof. A timeout
  or `500` is not proof. Never run destructive commands or establish shells.
- **Prototype pollution:** try harmless `__proto__` / `constructor.prototype`
  canaries in JSON merge/update endpoints; verify a server-side effect. Do not
  pollute shared production state or affect other tenants.

### Input validation and canonicalization

Test one reasoned variant at a time:

- missing vs `null` vs empty vs wrong type vs array/object,
- unsupported enum values, duplicate parameters, parameter pollution,
- case/encoding/Unicode normalization differences,
- email case variants only for canonicalization; never account takeover,
- `%00`, `%0a`, and encoded characters only when the framework makes them
  meaningful,
- content-type switching and method/content-negotiation differences.

Do not attempt account takeover, payment circumvention, destructive changes, or
high-volume fuzzing. Skip harmful tests and mark **Unresolved**.

---

## Phase 3 — Verification and Evidence

For each candidate record:

- endpoint, method, role/auth context, object ownership,
- baseline vs test response and persisted state,
- violated authorization boundary, validation rule, or business invariant,
- realistic attacker prerequisites and practical impact,
- duplicate status for the exact endpoint/method/variant.

Statuses:

- **Confirmed in authorized test** — behavior and impact verified with
  practical, reproducible evidence.
- **Unresolved** — required access/context/evidence unavailable.

Never report:

- a `200` alone,
- an accepted extra field alone,
- a generic `500`/error alone,
- a public or same-account object as IDOR,
- a client-side-only restriction as a server-side bypass,
- speculative behavior without evidence.

---

## Evidence Requirements

For every candidate, record evidence that proves the complete server-side
behavior:

- Endpoint, method, exact request, auth context, role, and timestamp.
- Baseline and test request/response. Test-account secrets may be shown;
  real-user secrets must be redacted.
- Persisted state re-read after the test (not just the immediate response).
- The authorization boundary, validation rule, or business invariant that was
  violated.
- Whether the effect is in the current account only, cross-account, cross-tenant,
  or unauthenticated.
- Realistic attacker prerequisites and practical impact.
- Duplicate status for the exact endpoint/method/variant/auth combination.
- For mass assignment: the sensitive field, the protected behavior it changed,
  and proof the change persisted.
- For IDOR/BOLA: test-owned object, owner account, attacker account, and the
  unauthorized read/edit/delete result.
- For BAC: the lower-privilege role and the action or data it should not reach.

A status code, an accepted extra field, a generic error, or a response echo is
not sufficient proof.

## Outputs

Write only under `result/`. Do not invent output locations.

```text
result/server-side/<host>/
├── api-inventory.md        # Method, path, params, auth, response shape
├── test-ledger.md          # Endpoint/method/variant tests and statuses
├── test-ledger.json        # Machine-readable ledger
├── traffic/                # Request/response captures (test secrets allowed)
└── notes.md                # Endpoint-specific observations
```

Also update:

- `result/inventory/endpoints.md`
- `result/inventory/routes.md` when new authorized routes are discovered
- `result/testing-inventory.json` (endpoints section)
- `result/logs/server-side.log`
- `result/unresolved.md`
- `result/SUMMARY.md`

For each confirmed finding, create:

```text
result/findings/<FINDING-ID>/
├── report.md
├── evidence/
└── payloads/
```

Append only **Confirmed**, high-impact findings to `result/confirmed-vuln.txt`:

- IDOR/BOLA with cross-account or cross-tenant impact,
- broken access control (BAC), including privilege escalation through mass
  assignment that changes a protected role, owner, tenant, or permission,
- authentication bypass with practical impact,
- other confirmed high-impact server-side issues with concrete evidence.

Use statuses: **Confirmed**, **Unresolved**, **Not Vulnerable**, **Out of
Scope**. Never write a `200`, an accepted field, a generic error, or a
speculative issue to `confirmed-vuln.txt`.

## Stop Conditions

- The endpoint or asset is outside the authorized scope.
- Testing would affect real users, real data, shared production state, or
  external systems.
- A required second account, role, or object is unavailable: mark the specific
  test **Unresolved** and continue.
- Chrome/MCP remains unavailable after one safe restart attempt. Write
  `result/BLOCKED.md` and mark affected work **Unresolved**.
- The time budget is nearly exhausted: stop starting new tests and finish
  evidence/reports.
- The endpoint is unreachable or cannot be resolved from route traffic/JS.
  Record it and move on.
- Never stop to ask the user.

---

## Hunter Mindset

At every endpoint ask yourself:

- What does this endpoint trust from the client?
- Which fields are server-managed, and can I override them?
- What are the valid parameters, and what proves they exist?
- Can I access another user's object, role, tenant, or action?
- Can I change price, quantity, status, ownership, or permissions?
- Can I skip a workflow step or bypass an entitlement?
- Does the server re-validate what the UI validates?
- What is the baseline, and what changed in persisted state?
- Is this a duplicate endpoint/method/variant?
- What is the practical impact, and would a security team accept it?
- What would a top hunter test next?

Answer yourself and act.

---

## Duplicate and Scope Rules

- Test unique endpoint + method + meaningful parameter variants only.
- Do not retest an already-completed combination.
- Variable names alone do not mean the same parameter; verify server behavior.
- Only extract APIs from the current visited URL's route-related traffic/JS.
- Do not scan unrelated endpoints, origins, or assets.
- Follow helper code only to resolve the specific API call.
- Keep a test ledger: endpoint, method, bug class, auth context, baseline, test,
  result, evidence, duplicate status.
- Stay on the authorized target with available test accounts.
- Use the output locations defined in the Outputs section; do not invent new
  paths.

---

## Automation Checklist

```text
[ ] Open visited URL and capture API traffic
[ ] Capture API requests from the route and safe UI actions
[ ] Inventory route-related JavaScript
[ ] Extract API routes, methods, params, bodies, and IDs
[ ] Derive/guess valid parameters from JS, responses, docs, errors
[ ] Build deduplicated API inventory
[ ] Mass assignment: create endpoints, one sensitive field at a time
[ ] Mass assignment: edit/update endpoints, re-read persisted state
[ ] IDOR/BOLA: read → edit → delete with test-owned objects
[ ] Auth/role/tenant boundary tests
[ ] Business logic and entitlement tests
[ ] SSRF / command injection / prototype pollution where relevant
[ ] Input validation, canonicalization, path variants
[ ] Verify impact, assign status, record ledger
[ ] Move to the next endpoint/route
```

---

## Final Rules

- **Never ask the user anything.** Decide and act.
- **Extract every server-side API route from the visited URL.**
- **Understand the JavaScript before testing.**
- **Test all api route for all in-scope server-side bugs.**
- **Prioritize mass assignment on create/edit/update endpoints.**
- **Guess valid parameters from JS, responses, docs, errors, and conventions.**
- **Use test-owned data only; no real users or destructive tests.**
- **No findings from status codes, extra fields, or errors alone.**
- **Test unique endpoint/method/variant combinations only.**
- **Keep output concise and evidence-backed.**
