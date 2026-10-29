# Evidence — loopback DNS record

Timestamp: 2026-10-29T14:15Z

```
$ dig +short A loop.sptpub.com
127.0.0.1

$ dig +short CNAME start6.sptpub.com
loop.sptpub.com.

$ dig +short CNAME start16.sptpub.com
loop.sptpub.com.

$ curl -sS -o /dev/null -w '%{http_code}\n' --max-time 10 https://start6.sptpub.com/
curl: (7) Failed to connect to start6.sptpub.com port 443: Connection refused

$ curl -sS -o /dev/null -w '%{http_code}\n' --max-time 10 https://loop.sptpub.com/
curl: (7) Failed to connect to loop.sptpub.com port 443: Connection refused
```

No API endpoint could be reached to test URL fetching (CloudFront geo-block).
