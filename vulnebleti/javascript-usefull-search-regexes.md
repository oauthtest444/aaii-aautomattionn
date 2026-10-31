# JavaScript Source Search Regexes

These patterns are starting points for searching JavaScript source files. Review matches in context; regex searches can produce false positives and miss code that is formatted or constructed differently.

## Search for `URLSearchParams.get()` and `.get()` calls

```regex
searchParams\.get\([^)]*\)|\.get\(("([^"]*)"|'([^']*)'|`([^`]*)`)\)
```

## Find `URL` or `URLSearchParams` constructed from location or document values

```regex
(?<![=!<>])(?:\b[A-Za-z_$][\w$]*\s*=\s*)new\s+(?:URLSearchParams|URL)\s*\(\s*(?:(?:window\.)?location\.(?:search|href|hash|pathname)|document\.(?:URL|URLUnencoded|baseURI))\b
```

## Find `postMessage` calls

```regex
\.postMessage\b
```

The original pattern, `\.postMessage\`, ends with an unescaped backslash and is not a valid regex. The pattern above searches for the method name.

## Find candidate route strings

```regex
(["'`])(?!//)(?!/\.)(?!/(?:\d+(?:\.\d+)?|_)\1)(?!/(?:\d+[A-Za-z]+)\1)(?![^"'`]*\.(?:js|css|png|ico|pdf|jpg|jpeg|gif|svg|webp|avif|map|json|xml|woff|woff2|ttf|eot)\1)(?:/[A-Za-z0-9_:@%+~?.-]{3,})+/?\1(?!\s*:\s*function\b)
```

These are candidate paths, not guaranteed valid or unique routes. Deduplicate results and verify each match in context.

## Find `yield` expressions that may call APIs

```regex
\byield\s+(?!(?:this|Promise)\.)[A-Za-z_$]\w*(?:\.[A-Za-z_$]\w*)+\s*\(
```

The original pattern ended with an extra backslash. The version above matches an opening parenthesis.

## Find client-side redirect calls

```regex
(?:window\.)?location\.(?:assign|replace)\s*\(\s*(?![`'"]|\$\{|window\.location\.|location\.|\w+\.href)
```

## Find client-side location assignments

```regex
(?<![\w$.])(?:window\.|document\.|parent\.|top\.|self\.|frames\[\d+\]\.)?location(?:\.href)?\s*=\s*(?!=)\s*(?![\w$]+(?:\.[\w$]+)*\.href\b)(?![\w$]+(?:\.[\w$]+)*\.toString\(\))(?![`'"]|`\/|""\.concat|null\b|\{)(?!\(null\s*==[\s\S]*?this\.location[\s\S]*?\.toString\(\))(?!\(0\s*,\s*[\w$]+\.[\w$]+\)\s*\()
```

## Find creation of selected HTML elements

```regex
document\.createElement\((['"])(iframe|object|embed|script)\1\);?
```

## Find potentially unsafe HTML or code-execution sinks

```regex
(\beval\s*\(\s*(?![`'"])|new\s+Function\s*\(\s*(?![`'"])|document\.write\s*\(|insertAdjacentHTML\s*\()|\.(?:inner|outer)HTML\b\s*=\s*(?!=)(?!\s*(?:[`'"]|null\b|\w+\.(?:inner|outer)HTML))|\.srcdoc\b\s*=\s*(?!=)(?!\s*(?:[`'"]|null\b))
```

## Find React `dangerouslySetInnerHTML` usage

```regex
dangerouslySetInnerHTML\s*=\s*\{\{|dangerouslySetInnerHTML\s*[:=]\s*\{
```
