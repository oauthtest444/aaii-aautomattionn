## ## Prompt (copy below)

````text

Read and follow these skills before any analysis:

- dom-xss-sink-tracing-skill.md
- postmessage-global-event-listener-tracing-skill.md
- cspt-source-to-sink-tracing-skill.md

---

# 1. Authoritative route → JS URL mapping

Fetch the COMPLETE mapping file. Do not ask me to paste URLs:

https://www.image2url.com/r2/default/files/REPLACE_WITH_YOUR_FILE_ID.txt

This mapping file is authoritative.

The file contains TWO SEPARATE JavaScript datasets:

1. `Unique javascript urls for postMassage listener`
2. `Unique javascript urls for XSS`

The datasets MUST remain separate for download, scanning, tracing and reporting.

Example:

```text
Unique javascript urls for postMassage listener

Routes

/datafinder/app/189104/overview

Js urls

https://example.com/a.js
https://example.com/b.js

Routes

/datafinder/bridge

Js urls

https://example.com/c.js


Unique javascript urls for XSS

Routes

/datafinder/app/189104/overview

Js urls

https://example.com/x.js
https://example.com/y.js
````

Do NOT treat all URLs in the mapping file as one combined JS set.

---

# 2. Parse the mapping before downloading

First parse the complete mapping file and create two independent datasets:

```text
POSTMESSAGE_DATASET
XSS_DATASET
```

For every URL store:

```text
dataset
route
js_url
```

Preserve every route association.

If the same JS URL appears under multiple routes:

* download it only once;
* preserve every route association;
* analyze the file against the correct skill;
* report all relevant routes.

Do NOT merge routes simply because they share a JS file.

---

# 3. MANDATORY separate JS download folders

Download the two datasets into separate folders.

Use:

```text
js/
├── postmessage/
└── xss/
```

The folder contents MUST be:

```text
js/postmessage/
    ONLY JS URLs from:
    Unique javascript urls for postMassage listener

js/xss/
    ONLY JS URLs from:
    Unique javascript urls for XSS
```

Do NOT download both datasets into one directory.

Do NOT create:

```text
js/
    all-file-1.js
    all-file-2.js
    ...
```

because this loses dataset separation.

---

# 4. Use wget separately

Create two URL lists:

```text
postmessage-urls.txt
xss-urls.txt
```

`postmessage-urls.txt` MUST contain ONLY URLs from:

```text
Unique javascript urls for postMassage listener
```

`xss-urls.txt` MUST contain ONLY URLs from:

```text
Unique javascript urls for XSS
```

Then download separately:

```bash
mkdir -p js/postmessage
mkdir -p js/xss

wget -c -P js/postmessage -i postmessage-urls.txt
wget -c -P js/xss -i xss-urls.txt
```

If wget cannot safely preserve filenames because two URLs have the same basename, use collision-safe filenames.

For example:

```text
main.js
main_<url-hash>.js
```

Never overwrite one URL's file with another URL.

Maintain metadata:

```text
local_file
original_js_url
dataset
route(s)
```

---

# 5. Download accounting

Track the two datasets independently.

Report:

```text
PostMessage URLs: N
PostMessage downloaded: N
PostMessage failed: N

XSS URLs: N
XSS downloaded: N
XSS failed: N
```

For every failed download report:

```text
URL
reason
HTTP status/error if available
```

Do not silently ignore failed JS files.

---

# 6. STRICT DATASET SEPARATION

## Dataset A — postMessage

Input:

```text
Unique javascript urls for postMassage listener
```

These JS files are specifically provided for postMessage listener analysis.

Primary analysis:

```text
ALL message listeners
        ↓
origin check
        ↓
source-window check
        ↓
event.data
        ↓
type/action
        ↓
complete data flow
        ↓
sensitive operation
```

You MUST scan ALL files in this dataset for message receivers.

Do NOT stop after finding one listener.

Do NOT skip files because their filename does not contain:

```text
message
postMessage
listener
```

A file belongs to this dataset because it appears under the authoritative postMessage section.

---

## Dataset B — XSS

Input:

```text
Unique javascript urls for XSS
```

These JS files are specifically provided for DOM XSS/source/sink analysis.

Primary analysis:

```text
ALL required XSS sink matches
+
ALL required user-controlled source matches
        ↓
complete tracing
        ↓
sensitive operation
```

You MUST scan ALL files in this dataset.

Do NOT stop after finding one XSS sink.

Do NOT skip a file because it has no obvious `location` string.

---

# 7. Important rule about dataset boundaries

A file from:

```text
Unique javascript urls for postMassage listener
```

must primarily be analyzed by the postMessage skill.

A file from:

```text
Unique javascript urls for XSS
```

must primarily be analyzed by the DOM XSS skill.

Do NOT silently mix the datasets.

Exception:

If a postMessage handler receives attacker-controlled `event.data` and that data reaches a DOM XSS/navigation sink, use the DOM XSS skill on that specific flow to prove the postMessage → sink chain.

Likewise, if XSS/source tracing discovers a CSPT or security-sensitive API chain, continue tracing using the relevant skill.

---

# 8. Load and follow the skills

Read the complete:

```text
dom-xss-sink-tracing-skill.md
postmessage-global-event-listener-tracing-skill.md
cspt-source-to-sink-tracing-skill.md
```

before analysis.

The skills are authoritative for their respective discovery regexes and tracing rules.

Do NOT invent replacement regexes.

---

# 9. DOM XSS discovery

For the XSS dataset, run the exact sink regexes defined by:

```text
dom-xss-sink-tracing-skill.md
```

For this task, the DOM XSS skill MUST use ONLY:

### Sink regex 1

```regex
(?:window\.)?location\.(?:assign|replace)\s*\(\s*(?![`'"]|\$\{|window\.location\.|location\.|\w+\.href)
```

### Sink regex 2

```regex
(?<![\w$.])(?:window\.|document\.|parent\.|top\.|self\.|frames\[\d+\.\])?location(?:\.href)?\s*=\s*(?!=)\s*(?![\w$]+(?:\.[\w$]+)*\.href\b)(?![\w$]+(?:\.[\w$]+)*\.toString\(\))(?![`'"]|`\/|""\.concat|null\b|\{)(?!\(null\s*==[\s\S]*?this\.location[\s\S]*?\.toString\(\))(?!\(0\s*,\s*[\w$]+\.[\w$]+\)\s*\()
```

Do NOT add additional XSS sink regexes.

---

# 10. DOM XSS source discovery

For the XSS dataset, run ALL user-controlled URL source regexes defined by the DOM XSS skill:

```text
Source regex 1
Source regex 2
Source regex 3
Source regex 4
Source regex 5
Source regex 6
Source regex 7
```

Do not stop after the first source match.

Every source match must be traced.

---

# 11. XSS sink tracing — mandatory

For EVERY XSS sink regex match:

1. Record:

   * route
   * JS URL
   * local file
   * regex number
   * line
   * exact matched code

2. Identify the value reaching the sink.

3. Trace backward through:

```text
variable
→ function
→ helper
→ module
→ property
→ parser
→ transformation
→ encoding
→ decoding
→ validation
→ allowlist
→ concatenation
→ final sink
```

4. Determine the original source.

Classify as:

```text
USER-CONTROLLED
SERVER-CONTROLLED
MIXED
CONSTANT/SAFE
```

5. Determine whether attacker control is actually proven.

6. Continue tracing until:

```text
sensitive operation
OR
safe termination
OR
dead/unreachable path
```

A regex match alone is NEVER a vulnerability.

---

# 12. User-controlled source tracing — mandatory

For EVERY source regex match:

Trace forward.

Do NOT only trace sources that immediately appear near a sink.

Trace:

```text
source
→ variable
→ function
→ helper
→ transformation
→ branch
→ API
→ storage
→ navigation
→ DOM
→ CSP/CSPT
→ final operation
```

Particularly prioritize:

```text
query
search
hash
pathname
route params
router query
URL
```

These are high-interest attacker-controlled sources.

Also trace:

```text
cookie
localStorage
sessionStorage
```

but do NOT automatically classify them as attacker-controlled.

For cookies/storage prove whether:

```text
attacker can directly control it
OR
attacker-controlled query/hash/path/input can cause it to be written
OR
another vulnerable endpoint can control it
```

If such a chain exists, it becomes interesting.

---

# 13. What makes a source interesting

A source is HIGH INTEREST when attacker-controlled data reaches:

```text
DOM XSS
navigation
open redirect
eval
Function
HTML/JS execution
sensitive API request
privileged API
authenticated API
account bind
login
token
OAuth
security-sensitive state change
CSP/CSPT
sensitive resource selection
sensitive identifier
postMessage security flow
```

A source that only performs:

```text
analytics
telemetry
UI flags
logging
non-sensitive GET
normal state rendering
safe encoding
hardcoded navigation
```

is informational/non-sensitive.

Still account for it, but keep the explanation short.

---

# 14. Server-controlled sink handling

If a navigation/XSS/API value comes only from:

```text
server response
backend configuration
trusted static configuration
hardcoded value
```

and attacker influence is not proven:

classify it:

```text
SERVER-CONTROLLED / INFORMATIONAL
```

Do NOT call it a vulnerability.

Still include important examples in:

```text
Navigation sinks checked
```

or:

```text
Informational / non-sensitive results
```

---

# 15. postMessage discovery

For the postMessage dataset, run the exact PM regexes from:

```text
postmessage-global-event-listener-tracing-skill.md
```

Run ALL PM regexes.

Most importantly, find EVERY:

```text
window.addEventListener("message", ...)
self.addEventListener("message", ...)
globalThis.addEventListener("message", ...)
window.onmessage = ...
```

Do NOT stop after finding one listener.

---

# 16. postMessage listener tracing — mandatory

For EVERY global message listener:

1. Resolve the complete callback.
2. Resolve named handler functions.
3. Read relevant callees.
4. Check:

```text
event.origin
event.source
event.data
```

5. Classify origin:

```text
NONE
WEAK
STRICT
```

6. Classify source-window validation:

```text
NONE
WEAK
STRICT
```

7. Trace EVERY relevant:

```text
event.data
data.type
data.action
data.id
data.code
data.token
data.projectId
data.url
data.path
data.params
```

8. Trace every branch.

9. Trace every helper/callback.

10. Continue until the data reaches:

```text
sensitive operation
OR
safe/non-sensitive operation
```

---

# 17. Missing origin check

If a message listener has:

```text
NO origin check
```

or:

```text
WEAK origin check
```

DO NOT immediately call it vulnerable.

Instead:

```text
missing/weak origin
        ↓
trace ALL event.data
        ↓
trace ALL branches
        ↓
trace ALL operations
```

If attacker-controlled message data reaches a sensitive operation:

```text
HIGH INTEREST
```

and show it prominently.

If it only performs non-sensitive behavior:

```text
INFORMATIONAL
```

and show it briefly.

---

# 18. Origin validation classification

### STRICT

Examples:

```javascript
event.origin === "https://trusted.example"
```

or an equivalent exact trusted-origin allowlist.

### WEAK

Examples:

```javascript
event.origin.includes(...)
event.origin.startsWith(...)
event.origin.endsWith(...)
event.origin.indexOf(...)
```

or validation based on attacker-controlled message data rather than the real:

```text
event.origin
```

### NONE

No meaningful origin validation.

Do NOT claim a bypass unless the bypass condition is actually demonstrated.

---

# 19. Source-window validation

Classify:

```text
NONE
WEAK
STRICT
```

Do not assume an attacker can satisfy strict object identity such as:

```javascript
event.source === trustedWindow
```

unless the complete flow proves it.

---

# 20. postMessage attacker control

Determine whether an attacker-controlled window can actually send the message.

Trace possible relationships:

```text
window.open
iframe.contentWindow
window.parent
window.opener
embedded frame
popup
```

Classify:

```text
PROVEN
POSSIBLE / NOT PROVEN
NOT ATTACKER-CONTROLLED
```

---

# 21. Sensitive postMessage operations

A postMessage flow is interesting if attacker-controlled data reaches:

```text
DOM XSS
navigation
open redirect
eval
Function
authenticated API
privileged API
account bind
login
OAuth
token handling
identity operation
security-sensitive state change
CSP/CSPT
sensitive resource selection
sensitive identifier
proxy HTTP request
storage that creates a later sensitive chain
```

For API requests identify exactly what attacker data controls:

```text
URL
method
path
query
body
headers
credentials
identifier
```

Do not call every API request vulnerable.

---

# 22. High-priority postMessage patterns

Explicitly search the postMessage dataset for important identity/authentication/bridge patterns such as:

```text
lark-verify
API_REQUEST
API_RESPONSE
BRIDGE_READY
SAVE_RESULT
oauth
auth-code
auth_code
bind
verify
postBindFeishuUser
BindFeishu
feishuAuth
LarkAccessVerify
idpBindLink
bindThirdParty
UnBindUserThirdParty
UnBindAccountThirdParty
```

If found, trace the complete flow.

For example:

```text
event.data.code
→ validation
→ helper
→ API
→ account/token/bind operation
```

---

# 23. CSPT analysis

Run the exact CSPT regexes 1–7 from:

```text
cspt-source-to-sink-tracing-skill.md
```

Trace:

```text
attacker-controlled source
→ path parameter
→ URL/path construction
→ encoding
→ HTTP request
→ sensitive endpoint/action
```

Determine:

```text
source
method
path template
encoding
validation
attacker control
impact
```

A dynamic API path is NOT automatically CSPT.

---

# 24. Sensitive classification

Use:

```text
CONFIRMED
LIKELY
SAFE
INFORMATIONAL
SERVER-CONTROLLED
```

### CONFIRMED

Use only when:

```text
attacker control is proven
+
complete data flow is proven
+
sensitive operation is reached
+
required conditions are understood
```

### LIKELY

Use when:

```text
static flow strongly indicates impact
```

but one important proof remains.

Clearly state what must still be verified.

### SAFE

No security-sensitive consequence is proven.

### INFORMATIONAL

Interesting code/path exists but has no demonstrated security impact.

### SERVER-CONTROLLED

The operation depends on server/trusted data and attacker influence is not demonstrated.

---

# 25. FINAL OUTPUT FORMAT

The final report MUST resemble this structure.

Do NOT replace it with a giant raw regex dump.

The analysis itself MUST be exhaustive, but the final report should prioritize useful security information.

Start:

**Skills followed.** Mapping authoritative. Routes isolated.
URL-source regex applied; **sensitive flows reported after deep trace.**

---

## Executive Summary

| Metric                                        |                           Value |
| --------------------------------------------- | ------------------------------: |
| Routes analyzed                               |                           **N** |
| Unique JavaScript URLs                        |                           **N** |
| Files downloaded                              |                       **N / N** |
| Confirmed vulnerabilities                     |                           **N** |
| Likely (needs more verification)              |                           **N** |
| Sensitive source→sink chains                  |                           **N** |
| Non-sensitive source matches (omitted detail) | `short list of important names` |

If two datasets exist, also show:

| Dataset     |  URLs | Downloaded | Failed | Fully scanned |
| ----------- | ----: | ---------: | -----: | ------------: |
| postMessage | **N** |      **N** |  **N** |       **N/N** |
| XSS         | **N** |      **N** |  **N** |       **N/N** |

---

## Source tracing (sensitive only)

### Exact source-regex hits that touched navigation / storage / postMessage / API path

| Source                                                | File      | Flow                                       | Sensitive?             |
| ----------------------------------------------------- | --------- | ------------------------------------------ | ---------------------- |
| `URLSearchParams(location.search).get("redirectURI")` | `file.js` | decoded → helper → final operation         | No — short reason      |
| `event.data`                                          | `file.js` | attacker message → handler → sensitive API | **Yes — Confirmed #1** |

Do NOT dump every harmless analytics source here.

Only include important source traces.

---

## Navigation sinks checked

| Pattern                            | Classification                       |
| ---------------------------------- | ------------------------------------ |
| `window.location.href = "/logout"` | Safe — hardcoded                     |
| `location.href = redirect_url`     | Safe — server-controlled response    |
| `location.assign(...)`             | Likely/Confirmed/Safe — short reason |

Include important sink traces.

---

## postMessage

| Listener                   | Origin     | Source   | Data use                    | Sensitive? |
| -------------------------- | ---------- | -------- | --------------------------- | ---------- |
| **MessageBus** (`file.js`) | **None**   | None     | message data → RPC callback | **Yes**    |
| Devtool listener           | **Strict** | Strict/— | initialization only         | No         |
| Webchat                    | **None**   | None     | UI/track action             | **Yes**    |

Show important/sensitive listeners first.

Non-sensitive listeners should remain compact.

---

## CSPT

| Path template    | Method | Param source | Encoding          | Classification        |
| ---------------- | ------ | ------------ | ----------------- | --------------------- |
| `/api/.../${id}` | POST   | route/state  | encoded/unencoded | Safe/Likely/Confirmed |

---

## Findings

### Confirmed

For every confirmed issue:

#### 1. Finding title

| Field          | Value                        |
| -------------- | ---------------------------- |
| **Type**       | postMessage / DOM XSS / CSPT |
| **Severity**   | Critical/High/Medium/Low     |
| **Route(s)**   | `...`                        |
| **JS URL**     | `...`                        |
| **Source**     | `...`                        |
| **Sink**       | `...`                        |
| **Validation** | `...`                        |
| **Data-flow**  | `...`                        |
| **Impact**     | `...`                        |
| **Confidence** | Confirmed                    |

Then provide a short authorized verification/PoC when appropriate.

---

### Likely

Use the same structure.

Clearly explain:

```text
what is proven
what is not proven
what runtime verification is needed
```

Do NOT promote a result to Confirmed merely because:

```text
origin check is missing
```

or:

```text
regex matched
```

---

## Informational / non-sensitive results

Keep this section compact.

Examples:

```text
server-controlled redirects
hardcoded navigation
analytics/session telemetry
UI-only postMessage actions
safe storage reads
non-sensitive API calls
safe query propagation
```

Explain briefly.

Do NOT produce hundreds of lines of harmless matches.

---

## Route Coverage Matrix

If both datasets exist:

| Route   | XSS JS files | XSS matches | postMessage JS files | PM receivers | Confirmed | Likely |
| ------- | -----------: | ----------: | -------------------: | -----------: | --------: | -----: |
| `/path` |            N |           N |                    N |            N |         0 |      0 |

If only one dataset exists, use:

| Route   | JS files | Source matches (exact) | Confirmed | Likely |
| ------- | -------: | ---------------------: | --------: | -----: |
| `/path` |        N |          Yes/Limited/– |         0 |      0 |

---

# 26. Coverage verification before final answer

Before producing the report, internally verify ALL of the following:

1. Complete mapping file downloaded/read.
2. Both dataset sections identified.
3. PostMessage URLs separated from XSS URLs.
4. `js/postmessage/` contains only postMessage dataset files.
5. `js/xss/` contains only XSS dataset files.
6. Every unique URL downloaded or failure reported.
7. Every route association preserved.
8. Every XSS file scanned.
9. Every postMessage file scanned.
10. Every required XSS sink regex match counted.
11. Every required XSS source match traced.
12. Every postMessage receiver traced.
13. Every CSPT candidate traced.
14. Server-controlled values separated from attacker-controlled values.
15. Query/hash/path sources prioritized.
16. Cookie/storage sources traced for possible attacker-control chains.
17. Missing/weak postMessage origin checks fully traced.
18. Sensitive operations highlighted.
19. Non-sensitive operations kept compact.
20. Regex matches are never automatically called vulnerabilities.

---

# 27. Critical anti-omission rule

NEVER do this:

```text
Find first vulnerable listener
→ stop scanning
```

NEVER do this:

```text
Find first XSS sink
→ stop scanning
```

NEVER do this:

```text
Download all JS into one folder
→ scan everything with every skill
```

NEVER do this:

```text
Only report vulnerable matches
```

Instead:

```text
Parse mapping
↓
Separate datasets
↓
Separate folders
↓
Download ALL files
↓
Scan ALL files
↓
Trace ALL required matches
↓
Trace ALL relevant flows
↓
Prioritize sensitive results
↓
Compactly report safe/informational results
```

---

# 28. Important reporting principle

The internal analysis must be exhaustive.

The final report must be useful.

Therefore:

```text
ALL matches are scanned
ALL relevant flows are traced
```

but:

```text
SENSITIVE = detailed + prominent
NON-SENSITIVE = compact
SERVER-CONTROLLED = compact/informational
```

This prevents missing vulnerabilities without producing an unreadable report.

If zero confirmed and zero likely:

**No confirmed vulnerabilities** on this mapping set.

Then explain briefly why.

End with:

Send the next URL when ready.

```
```
