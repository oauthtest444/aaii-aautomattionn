## console script that extract all javascript urls from script tag
```
(() => {
    const html = document.documentElement.outerHTML;
    const pageURL = location.href;
    const results = new Set();

    // Find every <script ...> opening tag
    const scriptTagRegex = /<script\b[^>]*>/gi;

    // Extract src="...", src='...', or src=...
    const srcRegex = /\bsrc\s*=\s*(?:"([^"]+)"|'([^']+)'|([^\s"'<>]+))/i;

    let match;

    while ((match = scriptTagRegex.exec(html)) !== null) {
        const tag = match[0];

        // Position of the <script tag in the original HTML
        const start = match.index;

        // Get the beginning of the line containing <script
        const lineStart = html.lastIndexOf("\n", start - 1) + 1;
        const beforeTag = html.slice(lineStart, start).trim();

        // Ignore commented-out lines:
        // // <script ...>
        // /* <script ...>
        // <!-- <script ...>
        if (
            beforeTag.startsWith("//") ||
            beforeTag.startsWith("/*") ||
            beforeTag.startsWith("<!--")
        ) {
            continue;
        }

        const srcMatch = tag.match(srcRegex);

        if (!srcMatch) continue;

        const src = (srcMatch[1] || srcMatch[2] || srcMatch[3]).trim();

        // Ignore Chrome extensions
        if (/^chrome-extension:\/\//i.test(src)) {
            continue;
        }

        // Remove query string and fragment for .js check
        const cleanPath = src.split(/[?#]/)[0];

        // Only .js files
        if (!/\.js$/i.test(cleanPath)) {
            continue;
        }

        // Convert relative, /, // URLs into absolute URLs
        let absoluteURL;

        try {
            absoluteURL = new URL(src, pageURL).href;
        } catch {
            continue;
        }

        // Extra protection against chrome-extension URLs
        if (/^chrome-extension:\/\//i.test(absoluteURL)) {
            continue;
        }

        results.add(absoluteURL);
    }

    const urls = [...results];

    console.clear();

    console.log(`%cFound ${urls.length} JavaScript files`, "color: lime; font-weight: bold;");

    console.log(urls.join("\n"));

    // Also copy them to clipboard
    copy(urls.join("\n"));

    return urls;
})();

```
