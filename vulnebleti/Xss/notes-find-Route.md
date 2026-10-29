This is basically “reverse tracing” inside a webpack bundle.
```
endpoint: https://console.byteplus.com/datafinder/org/welcome
code url: https://res.gcloudcache.com/bp-fe/console-datafinder/src_AppNext_tsx~src_uba-utils_operators_takeData_ts-98daf502.js
```
You started from vulnerable code:

```js id="6b6y8x"
window.location.href = decodeURIComponent(_)
```

and want to know:

```txt id="mjlwmv"
Which route loads this component?
```

The process is:

---

# Step 1 — Identify current webpack module

You found vulnerable code inside:

```js id="6kn5n8"
614953:function(S,r,e){
```

This means:

```txt id="z12gok"
webpack module ID = 614953
```

Webpack bundles store modules like:

```js id="3q9k2t"
{
  614953: function(...) { ... },
  42896: function(...) { ... }
}
```

So vulnerable component belongs to module `614953`.

---

# Step 2 — Find exports

Inside module:

```js id="xsv26e"
e.r(r),
e.d(r,{
   default:function(){
      return i
   }
});
```

means:

```txt id="1h0y7l"
module exports default component "i"
```

Then later:

```js id="48i3ij"
var i = () => (
   t.useEffect(...)
)
```

So:

* module 614953 exports React component `i`

---

# Step 3 — Find where module imported

Now search globally for:

```txt id="qd1r0l"
614953
```

or:

```txt id="kk9ok2"
e("614953")
```

You found:

```js id="jlwm0k"
l=e("614953")
```

inside router module.

---

# Step 4 — Trace router

Then router contains:

```js id="j21xpx"
<Route
   exact:!0,
   path:"/lark-verify",
   component:l.default
>
```

Here:

```js id="b7l0jx"
l = e("614953")
```

So:

```txt id="57pgj8"
Route "/lark-verify" loads module 614953
```

And module 614953 contains vulnerable redirect.

That is the trace.

---

# Full trace visually

```txt id="7v1q06"
URL /lark-verify
        ↓
Route component:l.default
        ↓
l = e("614953")
        ↓
module 614953
        ↓
useEffect(...)
        ↓
window.location.href = decodeURIComponent(_)
```

---

# If you ONLY found vulnerable code first

Suppose you only discovered:

```js id="4z12po"
window.location.href = decodeURIComponent(_)
```

and nothing else.

How find route?

---

## Method 1 — Search module ID

Find nearest wrapper:

```js id="9cq23f"
614953:function(S,r,e){
```

Then search whole bundle:

```txt id="75jv7r"
614953
```

Usually you'll find import references:

```js id="jlz4v0"
e("614953")
```

Then trace upward into router config.

---

## Method 2 — Search unique strings

Search:

```txt id="n9vwq1"
lark-verify
```

You immediately get:

```js id="j3o9h5"
type:"lark-verify"
```

and:

```js id="pxc7jw"
path:"/lark-verify"
```

Very common recon method.

---

## Method 3 — React DevTools

If page loaded:

* inspect component tree
* component names/routes visible

---

## Method 4 — Runtime hook

Monkey-patch router:

```js id="vq6zpc"
history.pushState = new Proxy(history.pushState,{
 apply(t,a,args){
   console.log(args);
   return Reflect.apply(t,a,args);
 }
});
```

Then navigate app.

---

# Important skill

In webpack apps:

```txt id="vrpqwh"
module ID tracing
```

is extremely powerful.

You can trace:

* vulnerable sink
* importer
* route
* API caller
* auth checks
* feature flags

just by following:

```txt id="2n9mfp"
e("module_id")
```

references.

---

# Simple mental model

Think of webpack bundle as:

```txt id="xz6mlm"
Huge object of modules
```

Example:

```js id="r7wbzq"
{
  100: login component,
  200: router,
  300: api,
  614953: vulnerable component
}
```

Router imports vulnerable component:

```js id="8tt74f"
var l = e("614953")
```

then attaches it to:

```js id="weqfwj"
path:"/lark-verify"
```

That is how route discovery works from sink code.
