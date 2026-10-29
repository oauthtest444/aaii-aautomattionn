# XSS Notes

## Use custom xss-cspt finder chrome extantion

After getting results, search these words in the JS files.

best regex to search all sources

```
(?<![=!<>])(?:\b[A-Za-z_$][\w$]*\s*=\s*)new\s+(?:URLSearchParams|URL)\s*\(\s*(?:(?:window\.)?location\.(?:search|href|hash|pathname)|document\.(?:URL|URLUnencoded|baseURI))\b
```

```
(?<![\w$.])\b[A-Za-z_$][\w$]*\s*=\s*(?:(?:\b(?:request|req|response|res)\s*\.\s*(?:url|referrer))|(?:\bevent\s*\.\s*request\s*\.\s*(?:url|referrer))|(?:\bhistory\s*\.\s*state(?:\s*\.\s*[A-Za-z_$][\w$]*)?)|(?:\b(?:router|route)\s*\.\s*(?:query|params)(?:\s*\.\s*[A-Za-z_$][\w$]*)?)|(?:\buse(?:SearchParams|Params|Location)\s*\(\s*\))|(?:\b(?:new\s+)?(?:Request|EventSource|Worker|SharedWorker)\s*\(\s*(?:(?:window\.)?location\.(?:search|hash|href|pathname)|document\.(?:URL|baseURI)|location)\s*\)))
```

---

## Finding XSS Vulnerable Code Sinks

### Search these in sink search tab as regex


```
(?:window\.)?location\.(?:assign|replace)\s*\(\s*(?![`'"]|\$\{|window\.location\.|location\.|\w+\.href)
```

```
(?<![\w$.])(?:window\.|document\.|parent\.|top\.|self\.|frames\[\d+\]\.)?location(?:\.href)?\s*=\s*(?!=)\s*(?![\w$]+(?:\.[\w$]+)*\.href\b)(?![\w$]+(?:\.[\w$]+)*\.toString\(\))(?![`'"]|`\/|""\.concat|null\b|\{)(?!\(null\s*==[\s\S]*?this\.location[\s\S]*?\.toString\(\))(?!\(0\s*,\s*[\w$]+\.[\w$]+\)\s*\()
```

```
document\.createElement\((['"])(iframe|object|embed|script)\1\);?
```

```
(\beval\s*\(\s*(?![`'"])|new\s+Function\s*\(\s*(?![`'"])|document\.write\s*\(|insertAdjacentHTML\s*\()|\.(?:inner|outer)HTML\b\s*=\s*(?!=)(?!\s*(?:[`'"]|null\b|\w+\.(?:inner|outer)HTML))|\.srcdoc\b\s*=\s*(?!=)(?!\s*(?:[`'"]|null\b))
```


## all regex

```
(?:window\.)?location\.(?:assign|replace)\s*\(\s*(?![`'"]|\$\{|window\.location\.|location\.|\w+\.href)
```

```
(?<![\w$.])(?:window\.|document\.|parent\.|top\.|self\.|frames\[\d+\]\.)?location(?:\.href)?\s*=\s*(?!=)\s*(?![\w$]+(?:\.[\w$]+)*\.href\b)(?![\w$]+(?:\.[\w$]+)*\.toString\(\))(?![`'"]|`\/|""\.concat|null\b|\{)(?!\(null\s*==[\s\S]*?this\.location[\s\S]*?\.toString\(\))(?!\(0\s*,\s*[\w$]+\.[\w$]+\)\s*\()
```

```
document\.createElement\((['"])(iframe|object|embed|script)\1\);?
```

```
(\beval\s*\(\s*(?![`'"])|new\s+Function\s*\(\s*(?![`'"])|document\.write\s*\(|insertAdjacentHTML\s*\()|\.(?:inner|outer)HTML\b\s*=\s*(?!=)(?!\s*(?:[`'"]|null\b|\w+\.(?:inner|outer)HTML))|\.srcdoc\b\s*=\s*(?!=)(?!\s*(?:[`'"]|null\b))
```

```
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
```

---

### Search these in source search tab as regex

```regex
(?:window\.)?location\.(?:assign|replace)\s*\(\s*(?![`'"]|\$\{|window\.location\.|location\.|\w+\.href)
```

```
(?<![\w$.])(?:window\.|document\.|parent\.|top\.|self\.|frames\[\d+\]\.)?location(?:\.href)?\s*=\s*(?!=)\s*(?![\w$]+(?:\.[\w$]+)*\.href\b)(?![\w$]+(?:\.[\w$]+)*\.toString\(\))(?![`'"]|`\/|""\.concat|null\b|\{)(?!\(null\s*==[\s\S]*?this\.location[\s\S]*?\.toString\(\))(?!\(0\s*,\s*[\w$]+\.[\w$]+\)\s*\()
```

```
document\.createElement\((['"])(iframe|object|embed|script)\1\);?
```

```
(\beval\s*\(\s*(?![`'"])|new\s+Function\s*\(\s*(?![`'"])|document\.write\s*\(|insertAdjacentHTML\s*\()|\.(?:inner|outer)HTML\b\s*=\s*(?!=)(?!\s*(?:[`'"]|null\b|\w+\.(?:inner|outer)HTML))|\.srcdoc\b\s*=\s*(?!=)(?!\s*(?:[`'"]|null\b))
```

---

## Search this in HTML files

This can execute XSS on webpage:

```html
<script 
```

---

## If you found XSS sink then search for these keywords

```txt
new URLSearchParams
.get(
?param=
&param=
```

---

# CSPT Regex with Names

## Template Literal URL Path

```regex
`(?:https?:\/\/|\/)[^`]*\$\{[^}]+\}[^`]*`
```

---

## URL String + Variable

```regex
["'`](?:https?:\/\/|\/)[^"'`]*["'`]\s*\+\s*[a-zA-Z_$][\w.$]*
```

---

## Multiple URL Concats

```regex
["'`](?:https?:\/\/|\/)[^"'`]*["'`](?:\s*\+\s*[a-zA-Z_$][\w.$]*)+
```

---

## Dynamic Path Construction

```regex
(?:`[^`]*\$\{[^}]+\}[^`]*`|\+\s*[\w.]+\s*\+|"\s*\+\s*[\w.]+\s*|\$\{[^}]+\})
```

### automation
```
cd /home/kali/Tools/chat-gpt-tools

curl https://web.archive.org/cdx/search/cdx?url=bitrue.com\&matchType=domain\&fl=original\&collapse=urlkey\&output=text\&filter=statuscode:200 > all-urls.txt

fgrep '?' all-urls.txt | egrep -i -v '\.(js|gif|jpg|jpeg|png|css|html|htm|gz|svg|ico|webp|avif|bmp|txt|pdf|xml|json|map|mp4|webm|ogv|mov|mp3|wav|ogg|flac|aac|m4a|woff|woff2|ttf|otf|eot|zip|rar|7z|tar)(\?|$)' > list.txt || true

python /home/kali/Tools/chat-gpt-tools/test/url_param_dedup.py -f /home/kali/Tools/chat-gpt-tools/list.txt -o /home/kali/Tools/chat-gpt-tools/urls.txt

python /home/kali/Tools/chat-gpt-tools/param_path_extractor/param_path_extractor.py -l urls.txt -cp params.txt

python /home/kali/Tools/chat-gpt-tools/param_path_extractor/xss_reflect_checker.py
```
