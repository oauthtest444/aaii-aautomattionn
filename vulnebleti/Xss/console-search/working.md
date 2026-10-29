```
(function() {
  const needle = "cfe2100bf92fa3fcb0527acc79901d52";
  const seen = new WeakSet();
  let matchCount = 0;

  console.log("[*] Launching complete storage & memory dump...");

  function search(obj, path = "window") {
    if (!obj || (typeof obj !== "object" && typeof obj !== "function")) {
      return;
    }

    if (seen.has(obj)) {
      return;
    }
    seen.add(obj);

    // Skip native stream, reader, or transition classes entirely to save overhead
    const className = Object.prototype.toString.call(obj);
    if (className.includes("Reader") || className.includes("Stream") || className.includes("Transition")) {
      return;
    }

    let keys = [];
    try {
      keys = Reflect.ownKeys(obj);
    } catch (e) {
      return;
    }

    for (const key of keys) {
      if (typeof key !== "string") continue; 

      try {
        // Look up the property configuration safely
        const desc = Object.getOwnPropertyDescriptor(obj, key);
        
        // CRITICAL FIX: If it is a getter method belonging to a native browser API, skip it.
        // Reading it directly causes the "Illegal invocation" error.
        if (desc && typeof desc.get === "function") {
          continue;
        }

        const value = obj[key];
        const currentPath = `${path}["${key}"]`;

        // Match strings in memory
        if (typeof value === "string") {
          if (value.includes(needle)) {
            matchCount++;
            console.log(`[+] [Memory Match #${matchCount}]`);
            console.log(`    Path:  ${currentPath}`);
            console.log(`    Value: ${value}`);
          }
        }

        // Recurse deeper
        if (value && (typeof value === "object" || typeof value === "function")) {
          search(value, currentPath);
        }
      } catch (e) {}
    }
  }

  // 1. Scan memory
  search(window);

  // 2. Scan and parse cookies (Filtered to only show if needle is found)
  console.log("[*] Parsing Document Cookies...");
  try {
    const cookies = document.cookie.split(";");
    for (const cookie of cookies) {
      const [key, value] = cookie.trim().split("=");
      if (key && value && value.includes(needle)) {
        matchCount++;
        console.log(`[+] [Cookie Match #${matchCount}]`);
        console.log(`    Access Code: document.cookie (Key: "${key}")`);
        console.log(`    Value:       ${value}`);
      }
    }
  } catch (e) {}
})();

```
