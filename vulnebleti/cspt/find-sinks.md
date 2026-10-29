**No regex can guarantee zero false positives** for CSPT (same as XSS). These are **high-precision** discovery regexes: tuned for your pattern families, low FP on UI/i18n/CSS noise, and still require full source→sink tracing after every hit.

Use them as a **pack of 7** (like your XSS sinks), not one mega-regex.

---

### CSPT regex 1 — Template literal API path with `${...}`

```regex
[`'"]/(?:api|user|admin|v[0-9]+|graphql|internal|gateway|services?|horizon|platform|items?|orders?|dashboard)[^`'"?]*\$\{[^}]+\}[^`'"]*[`'"]
```

**Hits:** `` `/api/user/${id}/edit` ``, `` `/user/dashboard/${uuid}/edit_copy` ``  
**Avoids:** `className={\`user-${id}\`}`, i18n keys, `?query=${x}` UI links (blocks `?` before `${`)

---

### CSPT regex 2 — String concat API path

```regex
[`'"]/(?:api|user|admin|v[0-9]+|graphql|internal|gateway|services?|horizon|platform|items?|orders?|dashboard)[^`'"]*[`'"]\s*\+\s*[\w$][\w$\.\[\]"']*
```

**Hits:** `"/user/dashboard/" + id`, `api.get("/items/" + itemId)`, `"/users/" + router.query.userId`  
**Avoids:** `"hello " + name`, `console.log("user " + id)`

---

### CSPT regex 3 — useApiQuery / useApiMutation path templates

```regex
useApi(?:Query|Mutation|InfiniteQuery|Stream)\s*\)?\s*\(\s*[`'"](?:get|post|put|patch|delete)[`'"]\s*,\s*[`'"][^`'"]*\{[a-zA-Z_][a-zA-Z0-9_]*\}
```

**Hits:** `useApiQuery("get", "/user/dashboard/{uuid}", …)`, `useApiMutation("delete", "/user/dashboard/{uuid}", …)`  
**Avoids:** random `useApi*` without method + `{param}` path

---

### CSPT regex 4 — `pathParams` object (follow-up required)

```regex
pathParams\s*:\s*\{[^}]{0,160}\}
```

**Hits:** `pathParams: { uuid: r ?? "" }`  
**Note:** High signal next to API helpers; always trace the values inside the object.

---

### CSPT regex 5 — Path/URL placeholder `.replace("{id}", …)` / regex replace

```regex
(?:\b(?:path|url|endpoint|apiPath|route|uri)\b\s*\.replace\s*\(\s*[`'"]\{[a-zA-Z_][a-zA-Z0-9_]*\}[`'"]|\.replace\s*\(\s*/\\\{(?:\([a-zA-Z_]+\)|\[[^\]]+\]|[a-zA-Z_]+)\\\}/g?\s*,)
```

**Hits:** `path.replace("{uuid}", value)`, `url.replace("{id}", id)`, `replace(/\{([a-zA-Z_]+)\}/g, …)`  
**Avoids:** `str.replace("{name}", userName)`, `props.replace("{count}", n)`

---

### CSPT regex 6 — OpenAPI-style encode replace

```regex
\.replace\s*\(\s*`\{\$\{[^}]+\}\}`\s*,\s*encodeURIComponent
```

**Hits:** `` s.replace(`{${a.name}}`, encodeURIComponent(r)) ``

---

### CSPT regex 7 — Braced API path template `"/user/{uuid}/..."`

```regex
[`'"]/(?:api|user|admin|v[0-9]+|graphql|internal|gateway|services?|horizon|platform|dashboard)[^`'"]*\{[a-zA-Z_][a-zA-Z0-9_]*\}[^`'"]*[`'"]
```

**Hits:** `"/user/dashboard/{uuid}/edit_copy"`, `"/user/dashboard/{uuid}/title"`  
**Pairs with:** regex 3/4 for full `useApi*` flows

---

## Coverage map

| Pattern family | Regex |
|----------------|--------|
| Template literals `` `/api/...${id}` `` | 1 |
| String concat `"/api/" + id` | 2 |
| Placeholder replace `path.replace("{uuid}", …)` | 5 |
| Regex replace `/\{([a-zA-Z_]+)\}/g` | 5 |
| `useApiQuery("get", "/x/{uuid}", { pathParams })` | 3 + 4 + 7 |
| Axios/fetch wrappers | 1, 2 |
| Router params in API path | 1, 2 |
| OpenAPI `replace(\`{${name}}\`, encodeURIComponent)` | 6 |

---

## Rules (same discipline as your XSS pack)

1. **A regex hit is not a vulnerability.** Trace source → encoding → HTTP method → impact.
2. **Prefer mutating methods** (POST/PUT/PATCH/DELETE) when ranking hits.
3. **GET-only + `encodeURIComponent`** → informational client chain unless server decode is proven.
4. **Expected residual FP:** unusual API prefixes, path-like UI strings, generated docs clients — reject by tracing.
5. **Expected residual FN:** custom helpers (`m(template, params)`), non-standard prefixes (`/k/run/`, `/horizon/`), path built across many statements — discovery search terms in the skill still catch these.

---

## Optional broader prefixes

If the target uses uncommon API roots, extend the prefix group only as needed:

```text
(?:api|user|admin|v[0-9]+|graphql|internal|gateway|services?|horizon|platform|items?|orders?|dashboard|k|res|rpc)
```

Do **not** widen to all `/...${...}` — that floods FP (CSS, i18n, UI routes).

---

**Bottom line:** These are the best high-precision CSPT discovery regexes for your scenarios. They are **not** zero-FP; they are **low-FP + high-signal**, and every hit still needs the CSPT skill trace (especially method + encoding).
