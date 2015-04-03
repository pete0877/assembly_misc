mtime= 200
ofx  = 100
ofx  = 120
ofy  = 110
ofz  = 40
npts = 64
degx  = 2
degy  = 8
degz  = 4
limit = 2000

.model Compact
.stack	 28h
.data
      Xsin	dd ?
      Xcos	dd ?
      Ysin	dd ?
      Ycos	dd ?
      Zsin	dd ?
      Zcos	dd ?
    image_file	db 'image.dat',0
    image	db 16*16 dup(0)
    curp	db 256*3 dup(0)
    pal_file	db 'pal.dat',0
    palcfg_file db 'palcfg.dat',0
    palcfg	db 3 dup(1)
    counter	dw 0
    mw		db 0

label pts0 dword
	   c = -35
	   rept 4
		b = -35
		rept 4
		     a = -35
		     rept 4
			  dd a,b,c
			  a = a + 20
		     endm
		     b = b + 20
		endm
		c = c + 20
	   endm

label pts1 dword
	   a = -64+8
	   rept 8
		b = -64+8
		rept 8
		     dd limit+a,limit+b,limit+5
		     b = b + 16
		endm
		a = a + 16
	   endm

pts   dd npts*3*4 dup(?)

dels	  dw npts*3*4 dup(0)
anx	  dw 0
any	  dw 0
anz	  dw 0
.code
.386
start: jmp over_proc

INCLUDE math.inc

over_proc:
	mov	ax,@data
	mov	ds,ax
	mov	gs,ax

	mov	ax,0013h
	int	10h
	mov	ax,0a000h
	mov	es,ax

	call	load_files
	call	set_colors

l01:
	mov	di,0
	mov	ax,counter
	inc	ax
	cmp	ax,mtime
	jne	l03
	mov	dl,1
	mov	mw,dl
l03:
	mov	counter,ax
l00:

; Rot ZZZ

	mov	bx,anz
	call	sin
	mov	Zsin,eax
	mov	bx,anz
	call	cos
	mov	Zcos,eax

	lea	si,pts0
	add	si,di
	call	RotateZ
	mov	eax,[di+pts0+8]
	mov	[di+pts+0],ebx
	mov	[di+pts+4],ecx
	mov	[di+pts+8],eax

; Rot YYY

	mov	bx,any
	call	sin
	mov	Ysin,eax
	mov	bx,any
	call	cos
	mov	Ycos,eax

	lea	si,pts
	add	si,di
	call	RotateY
	mov	[di+pts+0],ebx
	mov	[di+pts+8],ecx

	mov	ebx,[di+pts+0]
	mov	ecx,[di+pts+4]
	mov	esi,[di+pts+8]
	adc	ebx,ofx
	adc	ecx,ofy
	adc	esi,ofz
	mov	[di+pts+8],esi

	call	d32

	mov	eax,320
	mul	ecx
	add	ebx,eax

	push	di

	mov	di,bx
	call	show

	pop	di
	mov	[di+dels],bx

	add	di,3*4
	cmp	di,3*4*npts
jne	l00
	in	al,60h
	dec	al
	jz	exit

	mov	ax,anz
	add	ax,degz
	cmp	ax,1024
	jne	no_zero_angle_Z
	xor	ax,ax
no_zero_angle_Z:
	mov	anz,ax

	mov	ax,any
	add	ax,degy
	cmp	ax,1024
	jne	no_zero_angle_Y
	xor	ax,ax
no_zero_angle_Y:
	mov	any,ax

	mov	dl,mw
	cmp	dl,1
      jne     over_mor
	call	morph
      over_mor:

	call	twait
	call	erase

jmp	l01

exit:
	mov	ax,003h
	int	10h
	mov	ah,4ch
	int	21h

morph proc
	mov	di,0

m00:
	mov	eax,[di+pts0+0]
	mov	ebx,[di+pts0+4]
	mov	ecx,[di+pts0+8]
	add	eax,limit
	add	ebx,limit
	add	ecx,limit

	cmp	[di+pts1+0],eax
	ja	i1
	jb	d1
	jmp	ok1
i1:	inc	eax
	jmp	ok1
d1:	dec	eax
ok1:
	cmp	[di+pts1+4],ebx
	ja	i2
	jb	d2
	jmp	ok2
i2:	inc	ebx
	jmp	ok2
d2:	dec	ebx
ok2:
	cmp	[di+pts1+8],ecx
	ja	i3
	jb	d3
	jmp	ok3
i3:	inc	ecx
	jmp	ok3
d3:	dec	ecx
ok3:

	sub	eax,limit
	sub	ebx,limit
	sub	ecx,limit
	mov    [di+pts0+0],eax
	mov    [di+pts0+4],ebx
	mov    [di+pts0+8],ecx

	add	di,3*4
	cmp	di,3*4*npts
	jne	m00

	ret
endp


show proc
	lea	si,image
	xor	cl,cl
 loop_show:
	mov	al,es:[di]
	mov	ah,al
	lodsb
	add	al,ah
	stosb
 no_put:
	inc	cl
	cmp	cl,16
	jne	loop_show
	xor	cl,cl
	add	di,320-16
	cmp	si,16*16+offset image
	jne	loop_show
qut:
	ret
endp

;#################################################################

;  Three 2 Two Dimention
;  in: ebx - x
;      ecx - y
;      esi - z
;  out: ebx : screen x
;	ecx : screen y
d32 proc
	mov   eax,5
	mul   esi
	mov   esi,10
	div   esi
	add   ebx,eax
	sub   ecx,eax
	ret
endp

erase proc
	xor	si,si
	xor	al,al
  e01:
	mov	di,[si+dels]
	call	hide
	add	si,3*4
	cmp	si,3*4*npts
	jne	e01
	ret
endp

hide proc
	xor	dl,dl
	xor	ax,ax
 loop_hide:
	mov	cx,4
	rep	stosd
	inc	dl
	add	di,320-16
	cmp	dl,16
	jne	loop_hide
qut2:
	ret
endp

twait proc
      pusha
      mov  dx,03dah
z:    in   al,dx
      mov  ah,8
      and  al,ah
      cmp  al,0
      je   z

z2:    in   al,dx
      mov  ah,8
      and  al,ah
      cmp  al,0
      jne   z2

      popa
      ret
endp


load_files proc
       ; read in clock image :
       mov	ax,3d00h
       lea	dx,image_file
       int	21h
       mov	bx,ax
       mov	ah,3fh
       mov	cx,16*16
       lea	dx,image
       int	21h
       mov	ah,3eh
       int	21h

       ; read in pal file
       mov	ax,3d00h
       lea	dx,pal_file
       int	21h
       mov	bx,ax
       mov	ah,3fh
       mov	cx,3*256
       lea	dx,curp
       int	21h
       mov	ah,3eh
       int	21h
       ; read in palcfg file
       mov	ax,3d00h
       lea	dx,palcfg_file
       int	21h
       mov	bx,ax
       mov	ah,3fh
       mov	cx,3
       lea	dx,palcfg
       int	21h
       mov	ah,3eh
       int	21h
       ret
endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
set_colors proc
	mov	cx,1
	mov	dx,3C8H
	mov	bx,0
L1:
	mov	al,cl
	out	dx,al
	inc	dx

	mov	al,[bx+curp]
	mov	ah,[palcfg]
	cmp	ah,'0'
	jne	cok2
	xor	al,al
cok2:
	inc	bx
	out	dx,al

	mov	al,[bx+curp]
	mov	ah,[palcfg+1]
	cmp	ah,'0'
	jne	cok3
	xor	al,al
cok3:
	inc	bx
	out	dx,al

	mov	al,[bx+curp]
	mov	ah,[palcfg+2]
	cmp	ah,'0'
	jne	cok1
	xor	al,al
cok1:
	inc	bx
	out	dx,al



	dec	dx
	inc	cx
	cmp	cx,255
	jb	l1
	ret
endp

end start