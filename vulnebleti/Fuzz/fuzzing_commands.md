
# Fuzzing Commands Cheat Sheet

## Note:
Use `-k` with `feroxbuster` if the subdomain or IP gives an HTTPS certificate error.

---

## Feroxbuster Commands

### General Usage with HTTPS Cert Error Bypass
```
/home/kali/Tools/feroxbuster -k -u https://208.54.55.92/index.html#FUZZ -w /home/kali/wordlist/all-files-leaked.txt -C 404,429,400,481,405,500

/home/kali/Tools/feroxbuster -k -u https://tfb.t-mobile.com/ -w /home/kali/wordlist/common.txt -C 404,429,400,481,405,500
```

### LFI Fuzzing
```
/home/kali/Tools/feroxbuster -k -u https://tfb.t-mobile.com/ -w /home/kali/wordlist/common.txt -W 'root'
```

---

## FFUF Commands

### 1. Path Fuzzing (Content Discovery)
```
ffuf -u https://example.com/FUZZ -w /path/to/wordlist.txt -mc 200

ffuf -u https://example.com/FUZZ -w /home/kali/wordlist/common.txt -mr "200|404|401"

ffuf -u https://example.com/FUZZ -w wordlist.txt -mr "404.*HIT"
```

### 2. Header Fuzzing (e.g., for Cache Poisoning, Auth Bypass)
```
ffuf -u https://example.com/ -w /usr/share/seclists/Fuzzing/values.txt -H "X-Forwarded-For: FUZZ" -X GET
```

---

Keep your response status filters (`-mc`) and match regex (`-mr`) updated based on the target’s behavior.

### List
```
/home/kali/wordlist/all-files-leaked.txt

/home/kali/wordlist/common.txt

/home/kali/wordlist/Logins.fuzz.txt

/home/kali/wordlist/lfi.txt

/home/kali/wordlist/lfi/lfi.txt

/home/kali/wordlist/delimiters.txt

/home/kali/wordlist/extensions.txt

/home/kali/wordlist/CGIs.txt

/home/kali/wordlist/Apache.txt

/home/kali/wordlist/nginx.txt

/home/kali/wordlist/icons.txt
```
### Link
https://github.com/danielmiessler/SecLists/tree/master/Discovery/Web-Content/Web-Servers
