# Reverse Engineering Notes: Tracing a Query Parameter to a Redirect Sink

https://seller-eu.tiktok.com/account/login?__hack_redirect_now__=https://test.tiktok.com/

## Goal

This is a reusable workflow for reversing minified/bundled JavaScript when you find an interesting navigation sink and want to determine:

- where the value comes from,
- whether it is user-controlled,
- which module/function validates it,
- whether the validation is strong or weak,
- and whether the final behavior is actually exploitable.

The example below is based on the `account.208772.js` / related module investigation.

---

## 1. Start from the interesting sink

The first interesting line we found was:

```js
window.location.href =
    n
        ? new P.Z(i).addQuery("isNewUser", "1").href()
        : i;
```

At first glance, this tells us only:

```text
i  --->  window.location.href
```

Do **not** immediately call this an open redirect.

The first reverse-engineering question is:

> Where does `i` come from?

---

## 2. Trace the sink variable backward

We searched backward for the assignment to `i` and found:

```js
let e = new URLSearchParams(location.search),
    i = e.get(Z);
```

This is a major finding because:

```text
location.search
      ↓
URLSearchParams
      ↓
e.get(Z)
      ↓
i
```

Now the sink has a direct connection to the current URL.

---

## 3. Find what `Z` actually means

The next step was not to assume that `Z` was a harmless internal variable.

We searched for its declaration and found:

```js
let B = "__hack_redirect__",
    Z = "__hack_redirect_now__";
```

Therefore:

```js
i = e.get(Z)
```

really means:

```js
i = new URLSearchParams(location.search)
        .get("__hack_redirect_now__");
```

So the real data flow is:

```text
Attacker-controlled URL
        ↓
?__hack_redirect_now__=...
        ↓
location.search
        ↓
URLSearchParams
        ↓
.get("__hack_redirect_now__")
        ↓
i
        ↓
window.location.href
```

This is the important reverse-engineering technique:

> Always resolve minified variable names back to their declarations before judging the source/sink relationship.

---

## 4. Don't stop at the source → sink connection

At this point it looked like a direct open redirect.

But the surrounding code contained:

```js
if (
    i &&
    i.startsWith("https:") &&
    (0, T.bK)(i)
) {
    window.location.href = i;
}
```

So the real flow became:

```text
__hack_redirect_now__
        ↓
       i
        ↓
 startsWith("https:")
        ↓
      T.bK(i)
        ↓
 window.location.href
```

This is why reverse engineering should continue through **every function between the source and sink**.

---

# 5. Find what `T.bK` actually is

`T.bK` looked like an opaque bundled-module function.
```js
var N = i("8075")
              , k = i.n(N)
              , T = i("26903")
              , A = i("38514");

            let B = "__hack_redirect__"
              , Z = "__hack_redirect_now__"
```
Instead of guessing what `bK` means, we searched for its export.

We found another module:

```js
26903: function(e, t, o) {
    "use strict";
    o.d(t, {
        Q9: function() {
            return u
        },
        Wj: function() {
            return c
        },
        bK: function() {
            return l
        }
    });

    ...

    let l = e => {
        ...
    }
}
```

This establishes:

```text
T.bK
  ↓
module 26903
  ↓
export bK
  ↓
function l
```

This is a key technique for reversing Webpack-style bundles:

> When you see `T.bK(...)`, find where `T` comes from, then find the module exporting `bK`, then resolve `bK` to its actual implementation.

Do not treat a minified export name as meaningful by itself.

---

# 6. Read the actual validation function

The implementation was:

```js
let l = e => {
    if (!e)
        return !1;

    let t = /^https?:\/\//i.test(e)
        ? new (i())(e).host()
        : e;

    return (r[window.location.hostname] ?? s)
        .some(e => t.endsWith(e))
}
```

Now the redirect validation can be understood.

It does approximately:

```text
input
  ↓
is it an http/https URL?
  ↓
yes → parse URL → extract host
  ↓
check host against allowed suffixes
```

The default allowed suffixes included:

```js
[
    ".tiktok.com",
    ".tiktokglobalshop.com",
    ...,
    ".fannoshop.com"
]
```

There was also a special mapping:

```js
{
    "seller-id.tokopedia.com": [".tokopedia.com"]
}
```

So `T.bK()` is not an arbitrary "is this URL valid?" function.

It is an **allowed-host/domain-suffix check**.

---

# 7. Reconstruct the complete data flow

After resolving all the minified variables and modules, the useful mental model became:

```text
                    USER CONTROL
                         │
                         ▼
              ?__hack_redirect_now__=...
                         │
                         ▼
                 location.search
                         │
                         ▼
              URLSearchParams(...)
                         │
                         ▼
                  e.get(Z)
                         │
                         │ Z = "__hack_redirect_now__"
                         ▼
                         i
                         │
                         ▼
               i.startsWith("https:")
                         │
                         ▼
                      T.bK(i)
                         │
                         ▼
                 module 26903
                         │
                         ▼
                    function l
                         │
                         ▼
                  extract hostname
                         │
                         ▼
                allowed suffix check
                         │
                         ▼
                window.location.href
```

This is much more useful than simply finding:

```js
window.location.href = i
```

because now we understand the complete security boundary.

---

# 8. Why this was NOT immediately an arbitrary open redirect

The final validator uses:

```js
t.endsWith(e)
```

with an allowlist such as:

```text
.tiktok.com
.tiktokglobalshop.com
.fannoshop.com
```

Therefore:

```text
https://evil.com
```

does not pass the shown allowlist.

But a URL such as:

```text
https://foo.tiktok.com/
```

can pass the suffix check.

This changes the security question from:

> "Can I redirect to any domain?"

to:

> "Can I control or abuse a hostname that passes the application's trusted-domain validation?"

That is a much better security-research question.

---

# 9. Important lesson: don't confuse source control with exploitability

A useful classification is:

### Level 1 — Sink found

```js
window.location.href = value;
```

Interesting, but not enough.

### Level 2 — User-controlled source found

```js
value = new URLSearchParams(location.search).get("...");
```

Now there is a real source → sink relationship.

### Level 3 — Validation found

```js
validate(value)
```

Now the validator must be reversed.

### Level 4 — Validator understood

```text
only trusted domains accepted
```

Now determine whether that trust boundary can be bypassed or abused.

### Level 5 — Exploitability demonstrated

Only after establishing that an attacker can reach an unintended destination should you classify it as a confirmed open redirect.

---

# 10. Another related parameter

The same code also defined:

```js
let B = "__hack_redirect__",
    Z = "__hack_redirect_now__";
```

So don't stop after finding one parameter.

Search for both:

```text
__hack_redirect__
__hack_redirect_now__
```

The code contains another redirect-related flow for `__hack_redirect__` as well.

This is a general technique:

> Once you find one interesting parameter, search for sibling constants and all references to them. Developers often implement several variants of the same mechanism.

---

# 11. How to reverse minified modules efficiently

When you encounter something like:

```js
T.bK(i)
```

use this sequence:

### Step A — Find `T`

Determine where the variable/object was assigned.

Example:

```js
T = o(26903)
```

### Step B — Find module `26903`

Search:

```text
26903:
```

### Step C — Find its exports

Look for:

```js
o.d(t, {
    bK: function() {
        return l
    }
})
```

This tells you:

```text
bK → l
```

### Step D — Read `l`

Now you have the actual implementation:

```js
let l = e => {
    ...
}
```

### Step E — Reconstruct semantics

Translate minified code into normal language:

```text
T.bK(input)
→ checks input
→ parses host
→ compares host with trusted suffixes
→ returns boolean
```

This is much faster than trying to understand the whole bundle linearly.

---

# 12. The most useful habit: follow data, not code order

When reversing a large bundle, don't read thousands of lines from top to bottom.

Instead:

```text
Interesting sink
      ↓
sink variable
      ↓
variable assignment
      ↓
source
      ↓
validation
      ↓
validation implementation
      ↓
module export
      ↓
caller / route / trigger
```

This is a **data-flow-first** approach.

For security research, it is usually much more productive than reading the entire bundle sequentially.

---

# 13. Practical checklist for future investigations

When you find:

```js
location.href = x
```

use this checklist:

```text
[ ] Find every assignment to x
[ ] Resolve minified aliases
[ ] Check whether x comes from location/search/hash/pathname
[ ] Check URLSearchParams.get(...)
[ ] Resolve the parameter-name constant
[ ] Check API response fields
[ ] Check localStorage/sessionStorage
[ ] Check postMessage/event data
[ ] Identify every validation function
[ ] Find the implementation of the validation function
[ ] Resolve its Webpack module/export
[ ] Determine exact allowlist/denylist behavior
[ ] Check hostname parsing
[ ] Check protocol validation
[ ] Check subdomain handling
[ ] Check redirects after validation
[ ] Determine the actual route/trigger
[ ] Only then classify exploitability
```

---

# 14. The core lesson from this case

The initial observation was simply:

```js
window.location.href = ...
```

The useful result came from repeatedly asking:

```text
Where does this value come from?
        ↓
What is this variable?
        ↓
What is this constant?
        ↓
What does this function actually do?
        ↓
Which module exports that function?
        ↓
What security boundary does it enforce?
```

That turned an apparently suspicious redirect into a much more precise finding:

```text
User-controlled query parameter
        ↓
redirect sink
        ↓
HTTPS restriction
        ↓
trusted-host validation
        ↓
domain-suffix allowlist
```

That is the reverse-engineering pattern worth remembering.

---

## Short version

When reversing bundled JavaScript:

```text
SINK
 ↓
VALUE
 ↓
SOURCE
 ↓
CONSTANT
 ↓
VALIDATOR
 ↓
MODULE
 ↓
VALIDATOR LOGIC
 ↓
TRUST BOUNDARY
 ↓
EXPLOITABILITY
```

**Never stop at the sink.**

The most valuable part of the investigation is usually the 2–5 functions *before* the sink and the module that implements their validation.
