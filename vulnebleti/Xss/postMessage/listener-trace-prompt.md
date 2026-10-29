# Fast JavaScript postMessage Security Trace

Analyze the listener below for security impact.

## Workflow

1. First explain:

   * What the listener does.
   * `event.origin` validation: strong/weak/missing.
   * `event.source` validation: strong/weak/missing.
   * Which function receives `event.data`.
   * Which functions/variables are worth tracing.

2. **Test the actual open/visited endpoint in the SAME window/tab.**
   First give me a harmless test such as:

```js
window.postMessage({test:"trace"},"*");
```

If the listener expects another data structure, first identify it and give the correct harmless test message.

3. Work **one step at a time**:

   * Tell me exactly where to set the breakpoint.
   * Give ONE console command.
   * Command must use `copy(JSON.stringify(data,null,2));`
   * Extract as much useful information as possible in one command: local variables, arguments, function source, message data, return values, etc.
   * Handle circular objects safely.
   * Never modify data, navigate, or send requests.
   * Wait for my result before giving the next command.

4. **Trace only security-interesting paths.**
   Prioritize paths involving:

   * attacker-controlled data
   * origin/source validation
   * deserialization/dispatch
   * DOM/HTML
   * JavaScript execution
   * URLs/navigation
   * script loading
   * requests
   * privileged/account actions
   * sensitive-data access

   Do NOT trace unrelated library/framework code.

5. Maintain:

```text
message input
→ validation
→ function
→ variable
→ transformation
→ final sink
```

6. Clearly separate:

   * **Confirmed behavior**
   * **Potential security impact**
   * **Data still required**

Never claim XSS or another vulnerability until the final sink/action is confirmed.

## Listener Code

Paste the complete listener below this line:

```js
PASTE LISTENER HERE
```
