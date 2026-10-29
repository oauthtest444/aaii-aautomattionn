# Evidence — public S3 bucket listings

Timestamp: 2026-10-29T13:53–14:05Z

## 1. static.sptpub.com

Request:
```
GET / HTTP/2
Host: static.sptpub.com
User-Agent: curl/8.x
```

Response (excerpt):
```
HTTP/2 200
content-type: application/xml
server: AmazonS3
x-amz-bucket-region: eu-central-1
x-cache: Hit from cloudfront

<?xml version="1.0" encoding="UTF-8"?>
<ListBucketResult xmlns="http://s3.amazonaws.com/doc/2006-03-01/">
<Name>spt77-static</Name>
<Prefix></Prefix><Marker></Marker><MaxKeys>1000</MaxKeys><IsTruncated>true</IsTruncated>
<Contents><Key>404.html</Key>...
<Contents><Key>additional_images/background/1811895090055090176.png</Key>...
```

First-page keys saved at
`result/server-side/static.sptpub.com/traffic/bucket-listing-first1000.tsv`
(all `additional_images/**` plus `404.html`).

## 2. files-immutable-4cbc033nbd3.sptpub.com

Request:
```
GET / HTTP/2
Host: files-immutable-4cbc033nbd3.sptpub.com
```

Response (excerpt):
```
HTTP/2 200
content-type: application/xml
server: AmazonS3

<ListBucketResult ...><Name>spt77-nondynamic-files</Name>
<Contents><Key>currencies/</Key>...
<Contents><Key>flags_by_code/ABW.svg</Key>...
```

Top-level prefixes (read-only list API against the same bucket):
`currencies/`, `flags_by_code/`, `rocket-league/`, `translations/`.

## 3. Bucket ACL

Request:
```
GET /?acl HTTP/1.1
Host: spt77-nondynamic-files.s3.eu-central-1.amazonaws.com
```

Response (parsed):
```
Owner: b7d6b6d75dc5ae9655cb5424cc2884fb01e9247cb39ae6614fc732f015c4c9e8
Grant: CanonicalUser owner  FULL_CONTROL
Grant: Group AllUsers       READ
Grant: Group AllUsers       READ_ACP
```

No `WRITE` grant. `?policy` is `AccessDenied`. No write test was performed.

## 4. Negative control

```
GET https://static.sptpub.com/%3Cscript%3Ealert(1)%3C/script%3E
-> 404 application/xml, <Key>&lt;script&gt;alert(1)&lt;/script&gt;</Key>
```
Escaped XML, not an HTML execution context.
