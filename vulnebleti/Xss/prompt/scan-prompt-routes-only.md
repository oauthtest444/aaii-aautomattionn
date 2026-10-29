# Short scan prompt (routes + JS only)

Attach these skill files (regexes + full methodology live there — do not paste long regex blocks in the prompt):

- `dom-xss-sink-tracing-skill.md` (sink regexes 1–4, URL source regexes 1–7, source-to-sink tracing)
- `postmessage-global-event-listener-tracing-skill.md`
- `cspt-source-to-sink-tracing-skill.md`

---

## Prompt (copy below)

```text
Read and follow these skills before any analysis:
- dom-xss-sink-tracing-skill.md
- postmessage-global-event-listener-tracing-skill.md
- cspt-source-to-sink-tracing-skill.md

Route → JS URL mapping (fetch/download the full file using wget; do not ask me to paste URLs):
https://www.image2url.com/r2/default/files/REPLACE_WITH_YOUR_FILE_ID.txt

## 1. Load routes and JS

1. Fetch the complete authoritative mapping.
2. Every route → JS URL association is authoritative; preserve it exactly.
3. Deduplicate JS downloads by URL, but never merge/remove route associations.
4. Load/beautify every unique JS file. If a file fails, report its URL and failure reason.

The supplied JS sets are separate:
- `Unique javascript urls for XSS` → scan with the DOM XSS/source skill.
- `Unique javascript urls for postMassage listener` → these files are specifically for postMessage listener analysis; scan them for all message receivers.

## 2. Discovery — exact regex packs

Do not invent alternate discovery regexes.

### DOM XSS
For this task, use ONLY Sink regex 1 and Sink regex 2 from `dom-xss-sink-tracing-skill.md`.
Also run ALL user-controlled URL source regexes 1–7 from that skill.

### postMessage
Run PM regexes 1–7 from `postmessage-global-event-listener-tracing-skill.md`.

### CSPT
Run CSPT regexes 1–7 from `cspt-source-to-sink-tracing-skill.md`.

A regex hit is a candidate, not a vulnerability.

## 3. DOM XSS: mandatory complete coverage

For EVERY Sink regex 1/2 match:
- record route, JS URL, file, line, exact sink and matched regex;
- trace the exact sink value backward;
- identify whether it is USER-CONTROLLED, SERVER-CONTROLLED, MIXED, or SAFE;
- trace all variables/functions/transforms/validation/conditions;
- preserve route/state requirements.

For EVERY source regex 1–7 hit:
- trace it forward, even if it does not initially touch an XSS sink;
- query/hash/path/router sources are high-interest;
- cookie/localStorage/sessionStorage are interesting when attacker control is proven or can be chained from another endpoint/input;
- server/API values are not user-controlled unless attacker influence is demonstrated.

If a source reaches a sensitive XSS/navigation/API/CSPT/security operation, mark it high-interest and show the complete chain.

## 4. postMessage: mandatory complete coverage

For EVERY PM regex 1/2 receiver:
- resolve and read the complete handler;
- classify origin check: NONE / WEAK / STRICT;
- classify source-window check: NONE / WEAK / STRICT;
- record every event.data field and every type/action branch;
- trace every field through helpers, state, storage, navigation and API calls;
- determine whether attacker can actually send the message;
- continue until sensitive operation or proven-safe/non-sensitive end.

If origin validation is missing/weak:
- do NOT stop;
- trace all behavior;
- if attacker-controlled data reaches a sensitive operation, highlight it prominently;
- if it does not, show it briefly as informational.

Also explicitly search the high-priority OAuth/bind/identity patterns from the postMessage skill.

## 5. Sensitive-flow definition

Treat these as high-interest when attacker-controlled:
- DOM XSS / HTML / JS execution
- location navigation / open redirect
- privileged/authenticated API request
- account bind/login/token/OAuth operation
- sensitive resource/identifier selection
- security-sensitive state change
- CSPT behavior
- storage/state that can be chained into a sensitive operation

For APIs, prove what input controls URL/method/body/headers/credentials/identifier and why that matters.

## 6. Output — ALL matches, not only findings

Start with a short status line.

### Executive Summary

| Metric | Value |
|---|---:|
| Routes analyzed | N |
| Unique XSS JS URLs | N |
| Unique postMessage JS URLs | N |
| Files downloaded | N/N |
| XSS sink regex 1 matches | N |
| XSS sink regex 2 matches | N |
| XSS source matches | N |
| postMessage receivers | N |
| Receivers fully traced | N/N |
| Sensitive chains | N |
| Confirmed | N |
| Likely | N |

### ALL XSS sink matches

| Route | File | Regex | Exact sink | Source class | Short flow | Sensitive? | Classification |
|---|---|---|---|---|---|---|---|
| `/path` | `file.js` | 1/2 | `...` | USER/SERVER/MIXED/SAFE | `source → ... → sink` | YES/NO | Confirmed/Likely/Safe/Info |

Do not omit safe/server-controlled matches. Keep non-sensitive explanations short.

### ALL XSS source matches

| Route | File | Source regex | Source | Where it goes | Sensitive operation? | Classification |
|---|---|---|---|---|---|---|
| `/path` | `file.js` | 1–7 | `...` | `source → ...` | YES/NO | Interesting/Informational |

### ALL postMessage receivers

| Route | File | Receiver | Origin | Source | Data/type | Action/flow | Sensitive? | Classification |
|---|---|---|---|---|---|---|---|---|
| `/path` | `file.js` | `addEventListener("message",...)` | NONE/WEAK/STRICT | NONE/WEAK/STRICT | `...` | short flow | YES/NO | High/Info/Not confirmed |

Every PM regex 1/2 receiver must be represented.

### Sensitive findings

Use a prominent highlighted heading for every sensitive chain and include:
- route
- JS URL/file
- exact source
- exact data flow
- conditions/state/actions
- origin/source validation where relevant
- validation/encoding
- final sensitive operation
- impact
- confidence
- authorized verification/reproduction steps

### Informational results

Show safe/server-controlled/non-sensitive matches in compact text/table rows. Do not hide them.

### Route Coverage Matrix

| Route | XSS JS files | XSS sink matches | XSS source matches | PM JS files | PM receivers | Sensitive chains | Confirmed | Likely |
|---|---:|---:|---:|---:|---:|---:|---:|---:|

## 7. Final rules

- Never say “No confirmed findings” without first showing coverage counts and all required match tables.
- Never treat a regex match as a vulnerability.
- Never sample postMessage receivers.
- Never omit non-sensitive listeners/sinks/sources; keep them compact.
- Never omit a source merely because it does not reach the first obvious sink; trace where it actually goes.
- Preserve route → JS URL mapping.
- For failed downloads, report the exact URL and reason.
- End with: Send the next URL when ready.
```


### Output rules
1. Always use the structure above (Executive Summary → tracing tables → Findings → Route Matrix → Summary).
2. Confirmed findings get full detail; non-sensitive source hits are summarized in the table as Sensitive? = No — do not dump full JS.
3. Never invent line numbers, runtime behavior, or downloads that failed.
4. Regex match ≠ vulnerability.
```

Replace the mapping URL each run.

---

## Notes

- Skills hold exact regexes and deep-trace methodology.
- This prompt forces the **Affirm-style report** even when confirmed = 0.
- “Confirmed only” means: do not pad with false positives; it does **not** mean omit the summary/matrix when empty.
