```
(function(targetValue) {
    const seen = new Set();
    
    function search(obj, path) {
        // Prevent infinite loops and handle null/undefined
        if (!obj || seen.has(obj)) return;
        
        // Handle standard objects and arrays
        if (typeof obj === 'object') {
            seen.add(obj);
            
            for (let key in obj) {
                try {
                    const nextPath = Array.isArray(obj) ? `${path}[${key}]` : `${path}.${key}`;
                    const val = obj[key];
                    
                    if (typeof val === 'string' && val.includes(targetValue)) {
                        console.log(`%c[FOUND] Match found at: ${nextPath}`, 'color: #00ff00; font-weight: bold;');
                        console.log(`Value: "${val}"`);
                    } else {
                        search(val, nextPath);
                    }
                } catch (e) {
                    // Ignore security/permission errors on specific properties
                }
            }
        } 
        
        // Handle specialized Navigation API entries explicitly
        if (path === 'window.navigation' && typeof obj.entries === 'function') {
            try {
                const entries = obj.entries();
                entries.forEach((entry, index) => {
                    if (entry.url && entry.url.includes(targetValue)) {
                        console.log(`%c[FOUND] Match found at: window.navigation.entries()[${index}].url`, 'color: #00ff00; font-weight: bold;');
                        console.log(`Value: "${entry.url}"`);
                    }
                });
            } catch(e) {}
        }
    }

    console.log(`Searching globally for: "${targetValue}"...`);
    search(window, 'window');
    console.log('Search complete.');
})('newfortestttt'); // <-- Put your target URL string here

```
