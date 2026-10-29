Use a recursive search. Your previous script only searched:

* `window.someProperty`
* and one level deeper like `window.location.origin`

It did NOT fully traverse nested objects.

This version recursively walks through accessible properties globally and prints the full path when it finds the value:

```js id="5k0jxr"
const needle = "https://console.byteplus.com/";

const seen = new WeakSet();

function search(obj, path = "window") {
  // avoid null / primitives
  if (!obj || (typeof obj !== "object" && typeof obj !== "function")) {
    return;
  }

  // avoid circular references
  if (seen.has(obj)) {
    return;
  }

  seen.add(obj);

  for (const key in obj) {
    try {
      const value = obj[key];
      const currentPath = `${path}.${key}`;

      // match strings
      if (typeof value === "string") {
        if (value.includes(needle)) {
          console.log("FOUND:", currentPath, value);
        }
      }

      // recurse deeper
      if (
        value &&
        (typeof value === "object" || typeof value === "function")
      ) {
        search(value, currentPath);
      }

    } catch (e) {}
  }
}

search(window);
```

This checks deeply like:

```js id="x72h4a"
window.location.href
window.location.origin
window.document.cookie
window.navigator.userAgent
window.localStorage.someKey
window.some.deep.object.token
```

and even deeper paths like:

```js id="t3j6yv"
window.app.config.api.baseURL
```

It also handles:

* circular references
* inaccessible properties
* nested objects/functions

But note:

* `HttpOnly` cookies still cannot be read
* some browser internal properties are non-enumerable, so `for...in` may skip them
* extremely deep objects can make the search slow
