regex for finding sinks

```
(?:window\.)?location\.(?:assign|replace)\s*\(
```

```
\b(window\.|document\.|parent\.|top\.|self\.|frames\[\d+\]\.)?location(\.href)?\s*=(?!=)
```

```
document\.createElement\((['"])(iframe|object|embed|script)\1\);?
```

```
(\beval\s*\(|new\s+Function\s*\(|document\.write\s*\(|insertAdjacentHTML\s*\()|\.(inner|outer)HTML\b\s*=(?!=)|\.srcdoc\b\s*=(?!=)
```

search for postMessage
regex:
```
,["']\*["']\)
.postMessage(
```

search these in inspect tab for xss source and sink
```
location
document
```

regex for searching called functions
```
(?<!function\s)\bu\s*\(
```
replace only `u` with function name

```
\b u\s*\([^;]*\)\s*;
```

best:
```
\bu\s*\([^;]*\)\s*;
```

xss finding 

```
cd /home/kali/Tools/chat-gpt-tools

wget -qO all-urls.txt "https://web.archive.org/cdx/search/cdx?url=powerapps.com&matchType=domain&fl=original&collapse=urlkey&output=text&filter=statuscode:200" || true

cat all-urls.txt | egrep -i -v '\.(js|gif|jpg|jpeg|png|css|gz|svg|ico|webp|avif|bmp|txt|pdf|xml|json|map|mp4|webm|ogv|mov|mp3|wav|ogg|flac|aac|m4a|woff|woff2|ttf|otf|eot|zip|rar|7z|tar)(\?|$)' > list.txt || true

python /home/kali/Tools/chat-gpt-tools/param_path_extractor/param_path_extractor.py -l list.txt -cp params.txt

python /home/kali/Tools/chat-gpt-tools/param_path_extractor/xss_reflect_checker.py
```

xss
```
python /home/kali/Tools/chat-gpt-tools/param_path_extractor/xss_reflect_checker.py -l /home/kali/Tools/chat-gpt-tools/xss_results.txt -p /home/kali/Tools/chat-gpt-tools/my_results.txt
```

httpx
```
cat /home/kali/Tools/chat-gpt-tools/xss_results.txt | httpx -sc
```
```
cat xss_results.txt | httpx -status-code -title -content-length
```

grep .js urls
```
grep -oE 'https?://[^"'\'' ]+\.js\b' all-urls.txt > js-urls.txt
```

web achive
```
https://web.archive.org/cdx/search/cdx?url=web.powerapps.com&matchType=domain&fl=original&collapse=urlkey&output=text&filter=statuscode:200
```

best regex to search all sources

```
\((window\.)?location\.(search|href|hash|pathname)\)|\(document\.(URL|URLUnencoded|baseURI)\)|new URLSearchParams
```

regex for match
t = e.get("projectName");

```
=\s*e\.get\((['"])[^'"]+\1\)
```

regex for match paths:
```
(['"`])(\/|[a-zA-Z]+:\/\/|\.\.?\/)[^\s'"`]+?\1
```

send a regex that exact match
```
.get('gtm_id');
.get("gtm_id");
```

regex:
```
\.get\((['"])gtm_id\1\);
```

