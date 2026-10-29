# DOM XSS / Navigation Sink Tracing Skill

## Purpose
Find **all** matches of the required sink regexes and **all** user-controlled source matches, then trace every relevant path. Do not stop at high-signal results and do not report regex matches as vulnerabilities by themselves.

The analysis must answer:
```text
SOURCE → DATA FLOW → CONDITIONS → VALIDATION → SENSITIVE OPERATION
```

## 0. Exact XSS sink discovery regexes

**For this skill version, use ONLY these first 2 sink regexes. Do not add or broaden sink regexes.**

### Sink regex 1
```regex
(?:window\.)?location\.(?:assign|replace)\s*\(\s*(?![`'"]|\$\{|window\.location\.|location\.|\w+\.href)
```

### Sink regex 2
```regex
(?<![\w$.])(?:window\.|document\.|parent\.|top\.|self\.|frames\[\d+\.\])?location(?:\.href)?\s*=\s*(?!=)\s*(?![\w$]+(?:\.[\w$]+)*\.href\b)(?![\w$]+(?:\.[\w$]+)*\.toString\(\))(?![`'"]|`\/|""\.concat|null\b|\{)(?!\(null\s*==[\s\S]*?this\.location[\s\S]*?\.toString\(\))(?!\(0\s*,\s*[\w$]+\.[\w$]+\)\s*\()
```

A sink match is only a candidate. **Every match must be recorded and traced.**

## 1. Exact user-controlled URL source regexes

Run the source regex pack below on every XSS JS file. Do not replace it with a single broader regex.

### Source regex 1
```regex
(?<![=!<>])(?:\b[A-Za-z_$][\w$]*\s*=\s*)new\s+(?:URLSearchParams|URL)\s*\(\s*(?:(?:window\.)?location\.(?:search|href|hash|pathname)|document\.(?:URL|URLUnencoded|baseURI))\b
```

### Source regex 2
```regex
(?<![\w$.])(?:\b[A-Za-z_$][\w$]*\s*=\s*)(?:window\.)?location\.(?:search|hash|href|pathname)\b
```

### Source regex 3
```regex
(?<![\w$.])(?:\b[A-Za-z_$][\w$]*\s*=\s*)document\.(?:URL|URLUnencoded|baseURI|location(?:\.(?:search|hash|href|pathname))?)\b
```

### Source regex 4
```regex
(?:URLSearchParams\s*\([^)]*\)\s*\.|searchParams\s*\.\s*)get\s*\(\s*['"][^'"]+['"]
```

### Source regex 5
```regex
(?<![\w$.])(?:window\.)?location\.(?:search|hash|pathname)\b
```

### Source regex 6
```regex
(?:\brouter\.query\b|\broute\.query\b|\buseSearchParams\s*\(|\buseParams\s*\()
```

### Source regex 7
```regex
new\s+URL\s*\(\s*(?:(?:window\.)?location\.(?:href|search|pathname|hash)|document\.(?:URL|baseURI))
```

Also recognize and trace clear user-controlled sources discovered during tracing, including:
- query/search
- hash
- pathname/route params
- full URL/referrer
- cookies
- localStorage/sessionStorage
- postMessage data
- DOM-controlled values
- attacker-influenced API/server responses

**Cookie/storage values are not automatically attacker-controlled.** Prove how the attacker can set or influence them. They can still be interesting if they can be chained from another attacker-controlled endpoint/input.

## 2. Mandatory coverage: trace ALL sinks

For **every Sink regex 1/2 match**:
1. Record exact file, route, line, matched code, and sink expression.
2. Identify the exact value reaching the sink.
3. Trace backward through variables, functions, modules, helpers, properties, parsing, encoding/decoding, concatenation and validation.
4. Classify the original source:
   - **USER-CONTROLLED**: query/hash/path/router/postMessage or proven attacker-controlled cookie/storage/DOM/server value.
   - **SERVER-CONTROLLED**: response/config/backend value with no demonstrated attacker influence.
   - **MIXED**: server value combined with user input.
   - **CONSTANT/SAFE**.
5. Continue until the value is proven safe/dead or reaches a sensitive operation.
6. Record all conditions and route/state requirements.

### Server-controlled results
Do not hide them. If a sink is driven only by server-controlled/non-user-controlled data, include it in the complete sink table but show the explanation as **small/informational text**.

### User-controlled results
Query/hash/path sources are highest interest. Cookie/localStorage/sessionStorage sources are also interesting when the attacker can control them directly or chain control through another endpoint/input.

## 3. Mandatory forward tracing of ALL source matches

For **every source-regex hit**, trace forward even when it does not initially touch a sink.

Follow:
```text
source → variable → helper/function → transformation → branch → operation
```

Mark the source **INTERESTING** when it reaches or controls:
- XSS/navigation sink
- sensitive API request
- privileged API action
- authenticated request with attacker-controlled URL/method/body/identifier
- CSPT-relevant behavior
- postMessage/security-sensitive flow
- storage/state that can later be chained into a sensitive operation
- another security-sensitive operation discovered during tracing

If the source only performs non-sensitive work, still record it in the source table but keep the explanation **small/informational**.

## 4. What counts as sensitive

Examples:
```text
location.assign / replace / href
DOM HTML/JS execution
eval / Function
privileged/authenticated API request
account/bind/auth/token operation
security-sensitive state change
CSPT
navigation/open redirect
sensitive identifier/resource selection
```

Do not call every `fetch()` vulnerable. Prove what attacker input controls and what security impact follows.

## 5. Trace discipline

Use narrow identifier-based searches while tracing. Do not use loose `.*` source-to-sink reasoning.

For each chain record:
```text
Original source
↓
Exact variables/functions
↓
Transforms/validation
↓
Conditions
↓
Final operation
```

Classify each chain:
- **CONFIRMED** — attacker control and complete sensitive path proven; runtime proof when required.
- **LIKELY** — strong static path, but one concrete proof is still missing.
- **SAFE / NON-SENSITIVE** — no security-sensitive consequence proven.
- **SERVER-CONTROLLED / INFORMATIONAL** — sink/source exists but attacker control is not established.

## 6. Required output

Start with a short status line, then show **all matched sinks and all traced sources**.

### Executive summary
| Metric | Value |
|---|---:|
| Routes analyzed | N |
| Unique XSS JS URLs | N |
| Files downloaded | N/N |
| Sink regex 1 matches | N |
| Sink regex 2 matches | N |
| Total sink matches traced | N |
| Source regex matches traced | N |
| Sensitive source→operation chains | N |
| Confirmed | N |
| Likely | N |

### ALL matched sinks
| Route | File | Sink regex | Exact sink | Source class | Source / flow | Sensitive? | Classification |
|---|---|---|---|---|---|---|---|
| `/path` | `file.js` | 1/2 | `location...` | USER/SERVER/MIXED/SAFE | short data flow | **YES/NO** | Confirmed/Likely/Safe/Info |

**Do not omit safe or server-controlled sink matches.** For non-sensitive/server-controlled rows, keep the explanation short.

### ALL traced sources
| Route | File | Source regex | Source | Where it goes | Sensitive operation? | Classification |
|---|---|---|---|---|---|---|
| `/path` | `file.js` | 1–7 | `location.search...` | short flow | **YES/NO** | Interesting/Informational |

For **sensitive** chains, use a prominent heading and clear highlighting, then show:
- source
- exact data flow
- conditions
- validation
- final operation
- impact
- required route/state/actions
- confidence
- authorized verification steps

For non-sensitive chains, use a short informational subsection.

### Route coverage
| Route | JS files | Sink matches | Source matches | Sensitive chains | Confirmed | Likely |
|---|---:|---:|---:|---:|---:|---:|

## 7. Final rule

Never output only “no confirmed findings.”

The hunter must first establish:
```text
ALL SINK MATCHES
+
ALL SOURCE MATCHES
+
ALL RELEVANT FLOWS
```
and then prioritize the security-sensitive results.
