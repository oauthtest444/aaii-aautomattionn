You can safely inspect where a CSRF token appears in browser-accessible storage using DevTools console checks like these.

Search common browser storage locations:

```js id="3ryrkp"
// token to search
const token = "cfe2100bf92fa3fcb0527acc79901d52";

// localStorage
for (let i = 0; i < localStorage.length; i++) {
  const k = localStorage.key(i);
  const v = localStorage.getItem(k);

  if ((k && k.includes(token)) || (v && v.includes(token))) {
    console.log("FOUND in localStorage:", k, v);
  }
}

// sessionStorage
for (let i = 0; i < sessionStorage.length; i++) {
  const k = sessionStorage.key(i);
  const v = sessionStorage.getItem(k);

  if ((k && k.includes(token)) || (v && v.includes(token))) {
    console.log("FOUND in sessionStorage:", k, v);
  }
}

// cookies (non-HttpOnly only)
document.cookie.split(";").forEach(c => {
  if (c.includes(token)) {
    console.log("FOUND in cookie:", c.trim());
  }
});
```

You can also check the DOM:

```js id="gxh6vq"
const token = "cfe2100bf92fa3fcb0527acc79901d52";

document.querySelectorAll("*").forEach(el => {
  if (el.innerHTML.includes(token)) {
    console.log("FOUND in DOM:", el);
  }
});
```

And inspect global JS objects:

```js id="vt93lm"
const token = "cfe2100bf92fa3fcb0527acc79901d52";

for (const k in window) {
  try {
    const v = window[k];

    if (typeof v === "string" && v.includes(token)) {
      console.log("FOUND in window object:", k, v);
    }
  } catch (e) {}
}
```

Important note:

* `HttpOnly` cookies will NOT appear in `document.cookie`.
* Tokens may also only exist in memory inside framework state (React/Vue/Redux), request interceptors, or closure scope.
