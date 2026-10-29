# postMessage Global Event Listener Security-Tracing Skill

## Purpose
Find **ALL global postMessage/message receivers** in the supplied postMessage JS files and trace every receiver completely.

A missing/weak origin check is **not automatically a vulnerability**. The important question is what the listener does with attacker-controlled `event.data`.

## 0. Exact discovery regexes + also use your own

### PM regex 1 — message listeners
```regex
(?:window|self|globalThis|this)?\s*\.?\s*addEventListener\s*\(\s*['"]message['"]
```

### PM regex 2 — onmessage
```regex
(?:window|self|globalThis|this)\s*\.\s*onmessage\s*=
```

### PM regex 3 — postMessage senders
```regex
\.postMessage\s*\(
```

### PM regex 4 — origin
```regex
(?:e|event|evt|n|t|r|a)\s*\.\s*origin\b
```

### PM regex 5 — data
```regex
(?:e|event|evt)\s*\.\s*data\b
```

### PM regex 6 — source window
```regex
(?:e|event|evt)\s*\.\s*source\b
```

### PM regex 7 — delegated binds
```regex
(?:\.on|\.bind)\s*\(\s*['"]message['"]
```

Do not broaden these regexes into unrelated event types.

## 1. Mandatory full listener coverage

For **EVERY PM regex 1/2 receiver**, with no sampling:
1. Resolve the complete callback or named handler.
2. Read the full handler and relevant callees.
3. Check `event.origin` and `event.source`.
4. Record **NONE / WEAK / STRICT** validation.
5. Record every `event.data` field and every type/action comparison.
6. Trace every field through helpers, state setters, storage, navigation and API calls.
7. Continue until a sensitive operation or proven-safe/non-sensitive end.

**Do not stop because a listener looks harmless.** Every receiver must appear in the output.

## 2. Origin/source validation

### Origin
- **NONE** — no real `event.origin` validation.
- **STRICT** — exact trusted-origin comparison.
- **WEAK** — includes/startsWith/endsWith/indexOf or validation of attacker-controlled `data.origin` instead of `event.origin`.

Never claim a bypass without a concrete passing attacker origin.

### Source
Classify:
- **NONE**
- **WEAK**
- **STRICT**

Do not assume an attacker can satisfy strict object-identity checks.

## 3. Attacker-controlled message data

Trace:
```text
event.data
→ type/action
→ every relevant field
→ variables/functions
→ transformations
→ conditions
→ final operation
```

Establish whether an attacker-controlled window can actually send the message through:
```text
window.open / opener
iframe.contentWindow
window.parent
other reachable window
```

Record whether attacker control is:
- **PROVEN**
- **POSSIBLE / NOT PROVEN**

## 4. Sensitive operations

Escalate a listener when `event.data` reaches or controls:
- DOM XSS/HTML/JS sinks
- navigation/open redirect
- eval/Function
- authenticated or privileged API request
- bind/login/token/OAuth/identity operation
- security-sensitive state change
- CSP/CSPT behavior
- sensitive resource/identifier selection
- storage that can later be chained into one of the above

For API requests, identify what message data controls:
```text
URL / method / body / headers / credentials / identifier
```
and prove impact before calling it vulnerable.

## 5. No-origin-check listeners

If a listener has **NONE** or **WEAK** origin validation, trace **all of its behavior**.

- If it performs a sensitive operation with attacker-controlled data: **INTERESTING / HIGH PRIORITY** and show prominently.
- If it performs no sensitive operation: still show the listener, but keep the explanation **small/informational**.
- Never omit it just because it is non-sensitive.

A no-origin-check listener by itself is not a finding.

## 6. High-priority message patterns

Explicitly search the entire JS set for:
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

For OAuth/code/bind handlers, trace the complete:
```text
event.data.code → validation → bind/login/token/API operation
```

## 7. postMessage → XSS/navigation

When data reaches a DOM XSS/navigation sink, also apply the exact DOM XSS sink regexes from the DOM XSS skill to the relevant handler/callee slice and prove the data flow.

## 8. Output

Start with a short status line.

### Executive summary
| Metric | Value |
|---|---:|
| Routes analyzed | N |
| Unique postMessage JS URLs | N |
| Files downloaded | N/N |
| PM receiver matches | N |
| Receivers fully traced | N/N |
| No-origin listeners | N |
| Weak-origin listeners | N |
| Sensitive message flows | N |
| Confirmed | N |
| Likely | N |

### ALL message receivers
| Route | File | Listener | Origin check | Source check | Data/type used | What it does | Sensitive? | Classification |
|---|---|---|---|---|---|---|---|---|
| `/path` | `file.js` | `addEventListener("message",...)` | NONE/WEAK/STRICT | NONE/WEAK/STRICT | `data.type`, `data.url` | short action/flow | **YES/NO** | High/Info/Not confirmed |

**Every PM regex 1/2 receiver must have a row.**

For sensitive rows, use a prominent highlighted section:
```text
## 🔴 SENSITIVE postMessage FLOW

Listener
Route
Origin/source validation
Attacker-controlled field
Message conditions
Complete data flow
Final sensitive operation
Impact
Required state/actions
Confidence
```

For non-sensitive rows, use a compact informational section:
```text
### Informational listener
Listener → validation → short action → why non-sensitive
```

### Route coverage
| Route | JS files | Receivers | Sensitive flows | Confirmed | Likely |
|---|---:|---:|---:|---:|---:|

## 9. Classification

- **CONFIRMED** — attacker can send the message, validation is absent/bypassable, attacker data reaches the sensitive operation, and the complete path is proven/reproduced when required.
- **LIKELY** — complete static path is strong but one proof is missing.
- **NOT CONFIRMED / INFORMATIONAL** — listener exists but no sensitive attacker-controlled effect is proven.

## 10. Final rule

Never output only high-priority listeners.

Always output:
```text
ALL RECEIVERS
→ ALL ORIGIN/SOURCE CHECKS
→ ALL MESSAGE DATA/TYPE BRANCHES
→ ALL SENSITIVE AND NON-SENSITIVE ACTIONS
```

Then highlight the sensitive chains and keep safe/non-sensitive behavior compact.
