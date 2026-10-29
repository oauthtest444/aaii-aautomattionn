# Client-Side Path Traversal (CSPT) Discovery & Source-to-Sink Tracing Skill

## Purpose

This skill is for analyzing JavaScript (bundles, chunks, app code) when **no prior CSPT regex hits exist**.

The agent must:

1. **Discover** candidate client-side path construction and parameter interpolation in the given JS files.
2. **Trace** each candidate backward to the real source and forward to the real HTTP request.
3. **Classify** impact by HTTP method and encoding (mutating path = critical candidate; GET-only encoded reflection = informational).

Do **not** wait for a pre-supplied sink list or regex pack. Given only JS files (and optional route mapping), actively find possible CSPT scenarios, then prove or reject each chain.

The goal is not to report "interesting string concatenation." The goal is to establish a **reproducible, end-to-end chain**:

```text
Discovery of dynamic path segment
        ↓
User-controlled source (or not)
        ↓
Transformations / decoding / encoding
        ↓
Conditions / branches / feature flags
        ↓
Path construction (template / concat / replace)
        ↓
Protections (encodeURIComponent, allowlist, UUID check)
        ↓
HTTP request (method + path + auth)
        ↓
Server path decode / normalize / authorize
        ↓
Observable impact (wrong resource, mutating action, or none)
```

Only classify a finding as **confirmed exploitable CSPT** when the source is attacker-controlled, the value reaches a request path segment, and runtime evidence shows the server interprets it as a different path/resource than intended.

A **confirmed client chain** with GET-only + encoding and no runtime breakout is **informational**, not critical.

---

# 0. Discovery First (No Regex Pack Required)

When the user provides JS files only, start with discovery. Do not assume sinks are already known.

## 0.1 What to look for

Hunt for **dynamic path segments** in anything that becomes an HTTP (or WS) request path:

| Pattern family | Examples |
|----------------|----------|
| Template literals | `` `/api/user/${id}/edit` `` |
| String concat | `"/api/user/" + id + "/edit"` |
| Placeholder replace | `path.replace("{uuid}", value)` / `/\{([a-zA-Z_]+)\}/g` |
| API helpers | `useApiQuery("get", "/user/dashboard/{uuid}", { pathParams: { uuid } })` |
| Axios/fetch wrappers | `api.get("/items/" + itemId)` |
| Router params reused in API | `router.query.id` → `` `/api/${router.query.id}` `` |
| OpenAPI clients | `url.replace(\`{${name}}\`, encodeURIComponent(val))` |

Also note **UI routes** that embed IDs (often the source side):

```text
/dashboards/view?dashboardID=${e.UUID}
/users/${userId}/settings
/orders/${orderId}
```

UI path and API path sharing the same parameter name is a strong lead.

## 0.2 High-precision CSPT discovery regexes

Use these regexes to discover candidate path construction. A match is **not** a vulnerability — always trace source, encoding, HTTP method, and impact.

No regex pack is zero false-positive. These are low-FP / high-signal. Prefer hits that involve **POST / PUT / PATCH / DELETE**.

### CSPT regex 1 — Template literal API path with `${...}`

```regex
[`'"]/(?:api|user|admin|v[0-9]+|graphql|internal|gateway|services?|horizon|platform|items?|orders?|dashboard)[^`'"?]*\$\{[^}]+\}[^`'"]*[`'"]
```

Examples:

```js
fetch(`/api/user/${id}/edit`)
`/user/dashboard/${uuid}/edit_copy`
```

### CSPT regex 2 — String concat API path

```regex
[`'"]/(?:api|user|admin|v[0-9]+|graphql|internal|gateway|services?|horizon|platform|items?|orders?|dashboard)[^`'"]*[`'"]\s*\+\s*[\w$][\w$\.\[\]"']*
```

Examples:

```js
"/user/dashboard/" + id + "/edit"
api.get("/items/" + itemId)
"/users/" + router.query.userId
```

### CSPT regex 3 — useApiQuery / useApiMutation path templates

Works on both normal and minified calls such as `(0,f.useApiQuery)("get",...)`.

```regex
useApi(?:Query|Mutation|InfiniteQuery|Stream)\s*\)?\s*\(\s*[`'"](?:get|post|put|patch|delete)[`'"]\s*,\s*[`'"][^`'"]*\{[a-zA-Z_][a-zA-Z0-9_]*\}
```

Examples:

```js
useApiQuery("get", "/user/dashboard/{uuid}", { pathParams: { uuid } })
(0,f.useApiMutation)("delete","/user/dashboard/{uuid}",{...})
(0,f.useApiQuery)("get","/user/dashboard/{uuid}/edit_copy_uuid",{pathParams:{uuid:r??""}})
```

### CSPT regex 4 — `pathParams` object

```regex
pathParams\s*:\s*\{[^}]{0,160}\}
```

Examples:

```js
pathParams: { uuid: r ?? "" }
pathParams:{uuid:e}
```

Trace every value inside the object; this regex only locates the argument site.

### CSPT regex 5 — Path/URL placeholder replace

```regex
(?:\b(?:path|url|endpoint|apiPath|route|uri)\b\s*\.replace\s*\(\s*[`'"]\{[a-zA-Z_][a-zA-Z0-9_]*\}[`'"]|\.replace\s*\(\s*/\\\{(?:\([a-zA-Z_]+\)|\[[^\]]+\]|[a-zA-Z_]+)\\\}/g?\s*,)
```

Examples:

```js
path.replace("{uuid}", value)
url.replace("{id}", id)
t.replace(/\{([a-zA-Z_]+)\}/g, (_, n) => pathParams[n])
```

### CSPT regex 6 — OpenAPI-style encode replace

```regex
\.replace\s*\(\s*`\{\$\{[^}]+\}\}`\s*,\s*encodeURIComponent
```

Examples:

```js
s.replace(`{${a.name}}`, encodeURIComponent(r))
```

### CSPT regex 7 — Braced API path template `"/user/{uuid}/..."`

```regex
[`'"]/(?:api|user|admin|v[0-9]+|graphql|internal|gateway|services?|horizon|platform|dashboard)[^`'"]*\{[a-zA-Z_][a-zA-Z0-9_]*\}[^`'"]*[`'"]
```

Examples:

```js
"/user/dashboard/{uuid}/edit_copy"
"/user/dashboard/{uuid}/title"
```

### Coverage map

| Pattern family | Regex |
|----------------|--------|
| Template literals `` `/api/...${id}` `` | 1 |
| String concat `"/api/" + id` | 2 |
| `useApiQuery` / `useApiMutation` with `{param}` | 3, 4, 7 |
| `pathParams: { ... }` | 4 |
| `path.replace("{uuid}", ...)` / regex replace | 5 |
| OpenAPI `replace(\`{${name}}\`, encodeURIComponent)` | 6 |
| Braced templates `"/user/{uuid}/..."` | 7 |
| Router params in API path | 1, 2 |

### Regex usage rules

1. A regex hit is **not** a vulnerability.
2. After each hit, run full source-to-sink tracing from this skill.
3. Rank **mutating methods** (POST/PUT/PATCH/DELETE) above GET.
4. GET-only + `encodeURIComponent` → default **informational** without server decode proof.
5. If the target uses uncommon API prefixes, extend the prefix group carefully — do not widen to all `/...${...}` (UI/i18n/CSS flood).

## 0.3 Supplemental keyword search

If regexes miss custom helpers, also grep:

```text
pathParams
{uuid}
{id}
{userId}
{dashboardID}
encodeURIComponent
useApiQuery
useApiMutation
useApiInfiniteQuery
fetch(
axios.
method:"put"
method:"post"
method:"delete"
method:"patch"
"/user/
"/api/
`/user/
`/api/
router.query
useParams
URLSearchParams
location.search
location.pathname
query.
```

Then open each hit and ask: **does this string become a URL path segment for a network request?**

## 0.4 Rank discovery hits before deep tracing

Prioritize in this order:

1. **POST / PUT / PATCH / DELETE** with dynamic path segment  
2. Dynamic segment + **no** `encodeURIComponent` / allowlist  
3. Same value used in **both** GET and mutating methods  
4. Query/hash/pathname → pathParams with only GET  
5. Library noise (React internals, docs playground samples) — deprioritize  

Do not deep-trace every concat in the bundle. Select realistic application API paths first.

## 0.5 Build a candidate list

For each retained hit, record one line:

```text
CANDIDATE | METHOD | path template | dynamic var | file | why interesting
```

Example:

```text
CANDIDATE | GET  | /user/dashboard/{uuid}/edit_copy_uuid | uuid ← query.dashboardID | 1-kdpufa5yq_b.js | query into path
CANDIDATE | POST | /user/dashboard/{uuid}/title          | uuid ← same flow        | 1-kdpufa5yq_b.js | mutating
CANDIDATE | DELETE | /user/dashboard/{uuid}              | uuid ← same flow        | 1-kdpufa5yq_b.js | mutating
```

Only after the candidate list exists, perform full source-to-sink tracing on the top items.

---

# 1. Core Hunter Mindset

For every candidate path parameter, answer these questions in order:

1. **What exact request is issued?** (method, full path template, base URL)
2. **Which path segment is dynamic?**
3. **What variable supplies that segment?**
4. **Where was that variable assigned?**
5. **Is the original source actually user-controlled?**
6. **What transformations happen between source and path?**
7. **Is the value encoded?** (`encodeURIComponent`, custom encode, none)
8. **Does encoding block `/` and traversal sequences, or only cosmetics?**
9. **What HTTP method is used?** (GET vs POST/PUT/PATCH/DELETE)
10. **Are credentials included?** (`credentials: "include"`, auth headers, cookies)
11. **What server-side decode/normalize behavior is required for impact?**
12. **On which route/page does this code run?**
13. **What exact browser input reproduces the request?**
14. **Can impact be proven with a harmless marker (not a destructive call)?**

Do not stop at:

```js
fetch(`/user/dashboard/${id}/edit_copy`)
```

The important questions are:

```text
Can an attacker control `id` at the moment this request is built?
Does that value become a path segment?
Does the server treat the segment as a navigable/traversable path?
```

---

# 2. Severity Rule (Critical vs Informational)

This rule is mandatory.

### Critical / High priority

Query (or hash/path/storage) value reaches a **mutating** request path:

```text
POST   /api/resource/${attacker}
PUT    /api/resource/${attacker}
PATCH  /api/resource/${attacker}
DELETE /api/resource/${attacker}
```

Especially when:

- cookies / auth headers are attached
- the endpoint performs write, delete, publish, transfer, or admin actions
- authorization is path-ID based (IDOR + CSPT interaction)

### Medium

Attacker value reaches a **privileged GET** that returns sensitive data for arbitrary path-derived IDs, and server-side path confusion is demonstrated.

### Informational / Low (default for read-only GET)

Attacker value reaches **only GET** path segments, and/or client encoding prevents raw `/` injection:

```text
GET /user/dashboard/${encodeURIComponent(attacker)}/edit_copy_uuid
GET /dashboard/${encodeURIComponent(attacker)}
```

Even if source → sink is real, treat as **informational** unless runtime proves:

1. server decodes `%2F` (or equivalent) back to `/`
2. path normalization crosses into another resource
3. meaningful data exposure or state change occurs

**Example classification (Arkham dashboardID case):**

```text
Source:  /dashboards/view?dashboardID=VALUE
Sinks:   GET /user/dashboard/{uuid}/edit_copy_uuid
         GET /dashboard/{uuid}
Encoding: encodeURIComponent on pathParams
Mutating sinks exist in same feature, but also encoded

→ Client chain: CONFIRMED source-to-path
→ Security impact without server decode proof: INFORMATIONAL
→ Escalate only if runtime shows decode/normalize + access to another resource
```

Never upgrade GET-only encoded path reflection to Critical without server-side proof.

---

# 3. Source Classification

When tracing backward, explicitly classify the source.

### URL query (most common for CSPT)

```js
new URLSearchParams(location.search).get("dashboardID")
router.query.dashboardID
route.query.id
```

Attacker controls:

```text
https://target.example/dashboards/view?dashboardID=ATTACKER
```

### Pathname segment

```js
location.pathname.split("/")[3]
useParams().id
route.params.uuid
```

### Hash

```js
location.hash.slice(1)
```

### postMessage / storage / document.referrer

Only treat as attacker-controlled after proving how the attacker sets the value in the victim browser.

### Server/API response field used later in a path

```js
fetch(...).then(r => r.json()).then(e => {
  api.get(`/user/dashboard/${e.uuid}/edit_copy`)
})
```

Not automatically user-controlled. Trace whether the attacker can influence `e.uuid`.

---

# 4. Typical CSPT Path Construction Patterns

These are discovery targets and tracing shapes.

### Template replace

```js
path.replace(/\{([a-zA-Z_]+)\}/g, (_, name) => pathParams[name])
```

### Template literal

```js
`/user/dashboard/${uuid}/edit_copy`
```

### String concat

```js
"/user/dashboard/" + id + "/edit_copy"
```

### Router + API dual use

```js
// UI
`/dashboards/view?dashboardID=${e.UUID}`

// API
`/user/dashboard/${a.dashboardID}/edit_copy`
```

Same parameter name across UI and API is a strong hunting signal, not proof by itself.

### OpenAPI / generated clients

```js
url = url.replace(`{${param.name}}`, encodeURIComponent(value))
```

Always read whether encoding is present.

---

# 5. Build the Complete Data Flow

For every interesting parameter, construct a compact trace with exact names.

### Example (dashboardID)

```text
URL query dashboardID
    ↓
router.query.dashboardID
    ↓
idFromURL prop
    ↓
React state r
    ↓
pathParams.uuid = r
    ↓
m(template, pathParams)
    ↓
encodeURIComponent(String(uuid))
    ↓
GET {API}/user/dashboard/{encoded}/edit_copy_uuid
GET {API}/dashboard/{encoded}
```

Then annotate stages:

```text
SOURCE (query)
  ↓
PROP / STATE
  ↓
PATH PARAM OBJECT
  ↓
ENCODER
  ↓
HTTP GET SINKS
```

The trace must identify exact variable names and function names when available.

---

# 6. Encoding and Protection Analysis

Every transformation between source and path must be classified.

### Strict

Examples:

```js
if (!/^[0-9a-f-]{36}$/i.test(id)) throw new Error("invalid")
allowlist.includes(id)
```

Attacker cannot supply traversal or foreign identifiers in a practical way.

### Weak

Examples:

```js
encodeURIComponent(id)          // encodes / but server may decode
id.replace(/\.\./g, "")         // incomplete
id.startsWith("dash_")          // prefix only
```

### None

```js
`/user/dashboard/${id}/edit_copy`
```

No validation, no encoding.

### encodeURIComponent specifics

| Input | Client output | Notes |
|-------|---------------|--------|
| `../` | `%2E%2E%2F` | slash encoded |
| `..` | `..` | dot not encoded |
| `..%2f` | `..%252f` | double-encoded |
| UUID | UUID | unchanged |

**Client encoding is not the same as server safety.**

Classify:

```text
Client protection: encodeURIComponent → Weak/Partial
Server protection: unknown until runtime
```

Do not call encodeURIComponent a full CSPT kill without checking server decode behavior.

**No client bypass of a real `encodeURIComponent(pathParam)` wrapper** means: do not invent bypasses. Residual risk is server-side decode/normalize only.

---

# 7. Method-Aware Impact Model

Always record the HTTP method of each sink.

```text
Parameter: dashboardID / uuid

GET    /user/dashboard/{uuid}/edit_copy_uuid     → informational unless data breakout
GET    /dashboard/{uuid}                         → informational unless cross-user read
POST   /user/dashboard/{uuid}/title              → critical candidate
POST   /user/dashboard/{uuid}/description        → critical candidate
POST   /user/dashboard/{uuid}/toggle_publish     → critical candidate
DELETE /user/dashboard/{uuid}                    → critical candidate
POST   /user/dashboard/save  body.dashboardID    → body IDOR candidate (not path CSPT)
```

### Path CSPT vs body IDOR

- **Path CSPT:** value is in the URL path segment.
- **Body IDOR:** value is in JSON/body and server trusts it.

Both can be serious. Do not conflate them. Report with the correct class.

---

# 8. Conditions Required to Trigger the Request

List all conditions.

Example:

```text
For GET /user/dashboard/{uuid}/edit_copy_uuid to fire:

1. User opens /dashboards/view
2. query.dashboardID is present (or default dashboard loads then redirects)
3. Component eh/em mounts
4. pathParams.uuid is non-empty
5. options.enabled is true
6. API client attaches credentials
7. No earlier error aborts render
```

Do not report only:

```text
Attacker sets query → CSPT
```

unless that is actually sufficient.

---

# 9. Real-World Action Count

Classify interaction cost:

```text
0-click   attacker link only
1-click   victim must click once inside the app
N-click   additional UI steps
auth      requires logged-in victim session
role      requires specific role/feature flag
```

CSPT that depends on the victim’s authenticated session is still valuable because the request is made with the victim’s cookies.

---

# 10. Other CSPT Scenarios to Trace

### Scenario A — Query → API path (classic)

```text
?userId=...  →  /api/users/${userId}/settings
```

### Scenario B — Pathname → API path

```text
/app/orders/123  →  /api/orders/123/cancel
```

### Scenario C — Query → multiple methods

Same parameter used for GET detail and DELETE/PUT. Prioritize mutating methods.

### Scenario D — Encoded path + secondary decode

Client encodes, then middleware decodes twice or normalizes `..`.

### Scenario E — Base URL / prefix injection

```js
fetch(apiBase + "/" + userPath)
```

If `apiBase` or prefix is controllable, full URL or path prefix takeover may be possible.

### Scenario F — Batch / bulk endpoints

```js
`/api/items/${ids.join(",")}/export`
```

Traversal or segment break via delimiter.

### Scenario G — WebSocket / SSE path

```js
new WebSocket(`${ws}/rooms/${roomId}`)
```

Same tracing rules; method is not HTTP GET/POST but path still matters.

### Scenario H — Copy/edit/publish resource graphs

UI id used to resolve “edit copy” UUID, then second request uses resolved id. Trace both hops.

```text
dashboardID
  ↓
GET .../edit_copy_uuid  → returns p
  ↓
GET /dashboard/{p}
POST /user/dashboard/{p}/title
```

Attacker may influence hop 1, hop 2, or both.

---

# 11. End-to-End Workflow (JS files in → findings out)

```text
1. Ingest JS files (and route map if provided)
2. DISCOVER dynamic path construction (Section 0)
3. Build ranked CANDIDATE list
4. For each top candidate:
     - backward trace to source
     - forward trace to method + path + auth
     - classify encoding
5. Apply severity gate (mutating vs GET-only)
6. Report:
     - Confirmed exploitable CSPT (rare without runtime)
     - Confirmed client chain / Informational
     - Rejected / false positive
7. State what runtime check is still required
```

Never skip step 2 when the user did not supply sinks or regexes.

---

# 12. Runtime Verification Checklist

```text
[ ] Source parameter controllable from outside the app
[ ] Exact request URL captured in Network tab
[ ] Dynamic segment equals attacker marker
[ ] Method recorded
[ ] Encoding observed (raw vs encodeURIComponent)
[ ] Auth cookies/headers present
[ ] For GET-only: mark informational unless decode/normalize proven
[ ] For POST/PUT/PATCH/DELETE: test only under authorization with harmless markers first
[ ] Server response demonstrates different resource or privileged effect
```

---

# 13. Confirmed Finding Standard

## CONFIRMED CSPT (exploitable)

```text
[✓] Attacker-controlled source
[✓] Complete client data flow to path segment
[✓] Request actually issued
[✓] Server interprets path in an unintended way
[✓] Security impact demonstrated (read or write breakout)
```

## CONFIRMED CLIENT CHAIN / INFORMATIONAL

```text
[✓] Attacker-controlled source
[✓] Value reaches request path
[✓] Only GET (or equivalent read) sinks
[✓] Client encoding present and no runtime breakout proof
```

Example label:

```text
Informational: query.dashboardID reflected into GET API paths after encodeURIComponent
```

## NOT CONFIRMED

```text
[?] Source not user-controlled
[?] Path built only from server constants
[?] Dead code / unreachable route
[?] Value only in query string of API, not path
[?] Value only in body (track as possible IDOR, not path CSPT)
```

---

# 14. Agent Output Format

Only output high-value chains. Prefer mutating sinks.

```text
## CSPT Candidate

### Discovery
How the path template was found in JS (file + pattern)

### Source
`router.query.dashboardID` from `/dashboards/view?dashboardID=`

### User-controlled value
`dashboardID = <attacker>`

### Data flow
```text
URL query dashboardID
  ↓
idFromURL
  ↓
state uuid
  ↓
pathParams.uuid
  ↓
encodeURIComponent
  ↓
HTTP path segment
```

### Request sinks
- GET `/user/dashboard/{uuid}/edit_copy_uuid`
- GET `/dashboard/{uuid}`
- POST `/user/dashboard/{uuid}/title`   (if reached with same uuid)
- DELETE `/user/dashboard/{uuid}`     (if reached with same uuid)

### Encoding / validation
`encodeURIComponent(String(uuid))` in API client `m()`
No UUID allowlist observed in client

### Protection strength
Weak / Partial (client encode only)

### Method priority
Mutating methods = critical candidates
GET-only = informational without server decode proof

### Route
`/dashboards/view`

### Auth
credentials included / session cookies

### Runtime proof
Required for exploitability. Marker request first.
For GET-only encoded reflection, default assessment is Informational.

### Confidence
`CONFIRMED CLIENT CHAIN / INFORMATIONAL`
or
`CONFIRMED CSPT` (only with server impact proof)
```

---

# 15. Do Not Report These as Critical CSPT

Do not report as critical:

```text
GET-only path reflection with encodeURIComponent and no runtime breakout
```

```text
Value only used in React Query cache keys, not in fetch URL
```

```text
Value only in request body (call it IDOR candidate if authz is weak)
```

```text
Hardcoded path templates with no dynamic segment
```

```text
Dynamic segment proven to be server-issued opaque token that attacker cannot set
```

```text
Discovery hit that never reaches a network request
```

---

# 16. Worked Example — dashboardID (Arkham-style)

### Discovery

JS search hit: `pathParams`, `/user/dashboard/{uuid}`, `dashboardID`, `edit_copy` in dashboard chunks.

### UI source

```js
function eN(e) {
  return typeof e === "string"
    ? `/dashboards/view?dashboardID=${e}`
    : `/dashboards/view?dashboardID=${e.UUID}`;
}

r = router.query.dashboardID
  ? (Array.isArray(dashboardID) ? dashboardID[0] : dashboardID)
  : "";
// pass to view: idFromURL={r}
```

### API sinks

```js
useApiQuery("get", "/user/dashboard/{uuid}/edit_copy_uuid", {
  pathParams: { uuid: r ?? "" }
})

useApiQuery("get", "/dashboard/{uuid}", {
  pathParams: { uuid: e }
})
```

### Client encoder

```js
function m(t, e) {
  return t.replace(/\{([a-zA-Z_]+)\}/g, (t, r) => {
    if (void 0 !== e[r]) return encodeURIComponent(String(e[r]));
    throw Error(`Missing parameter ${r} in URL replacement.`);
  });
}
```

### Assessment

```text
Source-to-path chain: CONFIRMED
Client bypass of encodeURIComponent: NONE
Mutating methods in same feature also encode pathParams
Default severity: INFORMATIONAL (GET reflection + encoding)
Escalate only if runtime proves server decode/normalize leading to cross-resource access
or if a mutating call can be aimed at an unintended path/resource
```

---

# 17. Hunter Priority

### P1 — Query/path source → POST/PUT/PATCH/DELETE path, no encoding/allowlist

### P2 — Query/path source → mutating path, weak encoding, plausible server decode

### P3 — Query/path source → privileged GET, no encoding, sensitive response

### P4 — Query/path source → GET only, encodeURIComponent present

### Low

- constants
- dead templates
- body-only IDs without path use (track separately as IDOR)
- strict client UUID/allowlist that rejects attacker shapes
- pure library / docs playground code with no app route reachability

---

# 18. Final Rule

The objective is:

```text
DISCOVER → SOURCE → TRACE → ENCODING → METHOD → SERVER INTERPRETATION → IMPACT
```

When the user gives only JS files and no CSPT regexes:

> Find the dynamic path segments yourself, rank them, then prove source and method.

A good CSPT hunter does not ask only:

> "Does the query parameter appear in an API path?"

The correct questions are:

> "Which dynamic path segments exist in this JS, can I control any of them under realistic conditions with the victim’s auth, and does the server treat that segment in a way that breaks resource boundaries — especially on POST/PUT/PATCH/DELETE?"

**GET-only reflection with client encoding is a confirmed client chain and usually informational.**  
**Mutating-method path control is the critical case.**

Only output CONFIRMED exploitable CSPT when impact is proven, or the client chain leaves no meaningful protection and the method is mutating with clear privilege implications.
