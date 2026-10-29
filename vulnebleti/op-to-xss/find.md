###Open redirect methodology
-find Open redirect via google dork

### Open Redirect $ SSRF Parameters

```
site:example[.]com inurl:"=https://" OR inurl:"http=" OR inurl:"https="

```

```
curl https://web.archive.org/cdx/search/cdx?url=<d>\&matchType=domain\&fl=original\&collapse=urlkey\&output=text\&filter=statuscode:200 > urls.txt
```
```
cat urls.txt | urldedupe | uniq | p1radup | grep "=http" | tee op-urls.txt
```

```
/home/kali/Tools/chat-gpt-tools/Cache_poisoning/open-redirect/scan.sh -l op-urls.txt -o vuln-op.txt
```
```
cat op-urls.txt | sed 's/=.*/=/' | tee op-params-urls.txt
```

```
cat op-params-urls.txt | qsreplace "https://evil.com" | httpx -silent -fr -mr "evil.com"
```
```
nuclei -list urls.txt -t /home/kali/Nuclei-Custom-Templates/subs/openRedirect.yaml -o op.txt
```
