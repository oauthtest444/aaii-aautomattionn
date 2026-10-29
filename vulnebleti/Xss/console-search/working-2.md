```
(function() {
    // Substitute your target value here if it changes on reload
    const needle = "cfe2100bf92fa3fcb0527acc79901d52"; 
    const seen = new WeakSet();
    let matchCount = 0;

    // 1. GLOBAL MEMORY AND OBJECT TREE SEARCH
    function extract(obj, path = "window") {
        if (!obj || (typeof obj !== "object" && typeof obj !== "function") || seen.has(obj)) return;
        try { seen.add(obj); } catch(e) { return; }

        for (const key in obj) {
            try {
                // STABILITY FIX: If the key is a dynamic React property, abstract its lookup path cleanly
                let currentPath;
                if (key.startsWith('__reactContainer')) {
                    currentPath = `${path}[Object.keys(${path}).find(k=>k.startsWith('__reactContainer'))]`;
                } else {
                    currentPath = /^[a-zA-Z_$][a-zA-Z0-9_$]*$/.test(key) ? `${path}.${key}` : `${path}["${key}"]`;
                }

                const value = obj[key];

                // Exact match check for strings containing the token value
                if (typeof value === 'string' && value.includes(needle)) {
                    matchCount++;
                    console.log(`%c[+] [Memory Match #${matchCount}]`, "color: #00ff00; font-weight: bold;");
                    console.log(`    Exact XSS Path: ${currentPath}`);
                    console.log(`    Matched Value:  ${value}`);
                }
                
                extract(value, currentPath);
            } catch (e) {}
        }
    }

    console.log(`%c[*] Scanning everything for value: "${needle}"...`, "color: orange; font-weight: bold;");
    
    // Start deep object traversal
    extract(window);

    // 2. COOKIE CONTENT SEARCH
    try {
        const rawCookies = document.cookie;
        if (rawCookies && rawCookies.includes(needle)) {
            rawCookies.split(';').forEach(cookie => {
                const [name, value] = cookie.trim().split('=');
                if (value && value.includes(needle)) {
                    matchCount++;
                    console.log(`%c[+] [Cookie Match #${matchCount}]`, "color: #ff00ff; font-weight: bold;");
                    console.log(`    Exact XSS Path: document.cookie (Find key: "${name}")`);
                    console.log(`    Matched Value:  ${value}`);
                }
            });
        }
    } catch(e) {}

    // 3. STORAGE REGISTRY SEARCH
    ['localStorage', 'sessionStorage'].forEach(storageType => {
        try {
            const storage = window[storageType];
            if (storage && storage.length > 0) {
                for (let i = 0; i < storage.length; i++) {
                    const key = storage.key(i);
                    const value = storage.getItem(key);
                    if (value && value.includes(needle)) {
                        matchCount++;
                        console.log(`%c[+] [${storageType} Match #${matchCount}]`, "color: #ffff00; font-weight: bold;");
                        console.log(`    Exact XSS Path: window.${storageType}.getItem("${key}")`);
                        console.log(`    Matched Value:  ${value}`);
                    }
                }
            }
        } catch(e) {}
    });

    console.log(`%c[*] Scan complete. Found ${matchCount} unique access paths.`, "color: orange; font-weight: bold;");
})();

```
