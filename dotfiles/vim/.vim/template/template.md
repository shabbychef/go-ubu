:% s/THETIME/\=strftime('%a %b %d %Y %X')/ge
:% s/THEFILESTUB/\=expand("%:t:r")/g
:if search('<+CURSOR+>')
:  normal! "_da>
:endif
:finish
Title: 
Date: THETIME
Tags: statistics, shame
Slug: THEFILESTUB
Summary: whatsat?
Author: Steven

<+CURSOR+>

[//]:# vim:ts=2:sw=2:tw=79:fdm=indent:syn=markdown:ft=markdown:ai:si:cin:nu:fo=croql:cino=p0t0c5(0: 