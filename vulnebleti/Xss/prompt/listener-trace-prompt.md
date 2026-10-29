# JavaScript Listener Trace Request

I will paste a complete JavaScript listener below.

Analyze it for:

1. Whether `event.origin` is validated.
2. Whether `event.source` is validated.
3. Whether either validation is missing, weak, or strong.
4. Which functions receive message-controlled data.
5. Which variables and functions must be traced to reach the final sink.
6. Whether data reaches HTML, JavaScript, URL navigation, requests, script loading, or account actions.

Do not assume you can access my browser or DevTools.

First, tell me:

- What the listener does.
- Whether origin/source validation exists.
- Which function should be traced next.
- Which variable values are required.
- A short browser-console script that copies those required values with:

```js
copy(JSON.stringify(data, null, 2));
```

The script must not modify application data, navigate, or send requests.

If a variable is local and cannot be accessed globally, explain:

- Which function to pause inside.
- Which line needs a breakpoint.
- Which local variables to copy.
- How to copy them from the DevTools Console drawer.

After I provide the copied values, continue tracing the data until you identify:

```text
message input
→ validation
→ called function
→ transformation
→ final sink
```

Clearly separate:

- Confirmed behavior
- Potential security impact
- Data still required

Do not claim a vulnerability until the final sink is confirmed.

## Listener Code

```js
PASTE_FULL_LISTENER_CODE_HERE
```
