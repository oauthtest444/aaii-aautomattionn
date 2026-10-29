# Sink Inventory

No JavaScript was available, so no source-to-sink flow could be traced.

Only static S3 XML/JSON was reachable. Relevant observations:

- S3 `NoSuchKey` errors reflect the requested key inside an
  `application/xml` response and XML-escape `<`/`>`; no HTML execution context.
- `translations/market-tooltips/en.json` contains only UI tooltip strings (no
  URLs, tokens, keys, or HTML sinks).
- `static.sptpub.com` returns `Access-Control-Allow-Origin: *`; data is public
  static imagery, so this is not sensitive.

Status: Unresolved for dynamic sinks; no confirmed sink.
