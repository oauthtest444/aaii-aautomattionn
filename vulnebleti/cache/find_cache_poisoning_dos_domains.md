
## Cache Poisoning (CP) DoS Bug Discovery Notes

### 1. Find 404 Cache Poisoning DoS Bug

```bash
# Step 1: Identify cacheable servers from subdomains
cd /home/kali/Test; /home/kali/Tools/chat-gpt-tools/Cache_poisoning/detect-cacheable-server.sh -l subs.txt -o cacheble.txt

# Step 2: Find 404 response-based cache poisoning candidates
cd /home/kali/Test; /home/kali/Tools/chat-gpt-tools/Cache_poisoning/cache-404-hit.sh -l cacheble.txt -o 404-hit.txt
```

---

### 2. Find Redirect-based Cache Poisoning DoS Bug

```bash
# Step 1: Detect cacheable redirect (3xx) responses
cd /home/kali/Test
nuclei -l subs.txt -t //home/kali/Nuclei-Custom-Templates/subs/cache-control-public-3xx.yaml -o cache-control-public-new.txt

# Step 2: Extract domains from the result and format them
cd /home/kali/Test
grep -oE '([a-zA-Z0-9.-]+\.[a-zA-Z]{2,})' cache-control-public-new.txt | sed 's/^/https:\/\//' > subs.txt; cat subs.txt | uniq > cache-control-public-3xx.txt

# Step 3: Test for X-Forwarded cache poisoning vulnerability
cd /home/kali/Test; nuclei -l cache-control-public-3xx.txt -t /home/kali/Nuclei-Custom-Templates/subs/x-forwarded.yaml -o reflected_subs.txt
```
