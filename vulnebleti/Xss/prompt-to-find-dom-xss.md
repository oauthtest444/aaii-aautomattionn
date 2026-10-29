```

In the Sources tab of the browser developer tools, read all loaded JavaScript files (ignore JavaScript code from Chrome extensions).
Search for DOM XSS sinks using the following regular expressions (Regex):

(?:window\.)?location\.(?:assign|replace)\s*\(|window\.open\s*\(
(?:window\.|document\.|parent\.|top\.)?location(?:\.href)?\s*=
href=\{
setAttribute\s*\(\s*["']href["']
href\s*=\s*["']
\{\s*href\s*:
src=\{
setAttribute\s*\(\s*["']src["']
src\s*=\s*["']
\{\s*src\s*:
\beval\s*\(
new\s+Function\s*\(
\.innerHTML\b
\.outerHTML\b
document\.write\s*\(
insertAdjacentHTML\s*\(
\.srcdoc\b
\blocation\b
setTimeout\s*\(
setInterval\s*\(

Identify sources that are potentially user-controlled from the following list:

-document.URL
-document.documentURI
-document.URLUnencoded
-document.baseURI
-location.search
-document.cookie
-document.referrer

For each sink:
Confirm 100% that the sink is user-controlled.
Determine which route (URL path or JavaScript execution context) triggers this sink.
For confirmed vulnerabilities:
Show the source and sink in the results.
Generate a full URL that, when visited, will trigger the XSS reliably.
Note:
Only include results where the sink is user-controlled.
Do not read or analyze JavaScript from Chrome extensions.
Ensure the final output includes the full working URL for testing.
```
