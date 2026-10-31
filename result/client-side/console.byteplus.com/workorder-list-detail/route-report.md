# Route Report — /workorder/list/detail

- Route: https://console.byteplus.com/workorder/list/detail?id=I-...
- Status: completed
- Tested by: account A (`3000823185`) and account B (`3001021825`)
- Route JS: `WorkOrderDetail.ccecc8c5.js`, `499.b80931e8.js`, `609.9d2bee7c.js`, `779.936a8dda.js`

## Regex match counts (exact client-side-skill regexes)

| Regex | Count |
|---|---:|
| source1 | 3 |
| source2 | 0 |
| sink: location.assign/replace | 0 |
| sink: location = | 0 |
| sink: createElement(iframe/object/embed/script) | 0 |
| sink: eval/Function/document.write/insertAdjacentHTML/innerHTML/srcdoc | 6 |
| sink: dangerouslySetInnerHTML | 3 |

## Sources

- `id` query parameter is read by the detail page and passed to `GetTicket`.
- Conversation/ticket HTML is returned by `ListTicketConversation` / `GetSensitiveConversation` and is the primary untrusted source.
- No URL-controlled value reaches a route-level DOM sink.

## Sinks

- `609.9d2bee7c.js` — three `dangerouslySetInnerHTML` sinks render conversation `Content` when `ContentFormat === "html"`:
  - mobile message renderer: `dangerouslySetInnerHTML:{__html:(0,b.dW)(e)}`
  - desktop message renderer: `dangerouslySetInnerHTML:{__html:c}`, where `c = (0,b.dW)(e)`
- `b.dW` is the shared `linkify` helper from `main.js`; it sets `innerHTML` on a detached `<div>`, linkifies text, and returns the resulting HTML. It is not a sanitizer.
- Markdown content uses the markdown renderer with `enabledHtmlTags:!1`.
- `innerHTML` matches also include DOMPurify internals in the bundled sanitizer and the linkify helper.

## Practical testing

Test conversation content was posted to test-owned ticket `I-2026103118200002` with API `CreateTicketConversation` (Content, ContentFormat, Attachment, IsConfidential).

| Payload class | Stored result | Execution |
|---|---|---|
| `<img src=x onerror=...>` | `<img src="/nonexistent-agent.png">` — `onerror` stripped | No |
| `<details open ontoggle=...>` | `<details open>` — `ontoggle` stripped | No |
| `<input autofocus onfocus=...>` | tag removed | No |
| `<a href="javascript:...">` | `href=""` | No |
| Markdown `[x](javascript:...)` | anchor rendered without `href` | No |
| Markdown raw `<img ... onerror=...>` | `onerror` stripped | No |
| `<svg onload=...>` | WAF HTTP 403 | No |
| Confidential conversation (`IsConfidential:true`) | List masks content as `**********`; `GetSensitiveConversation` returns sanitized content | No |
| Attachment with `Url:"javascript:..."` | URL stored verbatim; download handler rejects it, preview uses `<img>` only | No |
| Attachment with B-owned `FileID` | `Attachment:[{Name:"agent-b.txt",Url:"",DetectTip:""}]` | No cross-account access |

Server-side write-time sanitization strips event handlers, dangerous URI schemes, and disallowed tags before storage. The client linkifier then preserves the already-sanitized HTML. No JavaScript execution was observed; self-XSS was not achieved.

### Attachment URL handling

Conversation attachments take a user-supplied `Url` and the server stores it verbatim. The desktop renderer does not place it in an anchor `href`; clicks call the download helper in shared module `16638`, which removes whitespace and rejects `javascript:`, `vbscript:`, `data:`, and `file:` URLs before opening an XHR. Image attachments are rendered and previewed with `<img src={Url}>` only. An attachment with `Url:"javascript:document.documentElement.setAttribute('data-agentxss','att')"` was stored; clicking it produced the invalid-link error and left `data-agentxss` unset. This is defense-in-depth rather than a confirmed XSS.

## Result

No confirmed stored/DOM XSS. Residual risk exists if the server-side sanitizer is bypassed, because `dW` preserves markup; no such bypass was found. WAF also blocks SVG `onload`.
