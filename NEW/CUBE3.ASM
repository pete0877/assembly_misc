x0=160
y0=100
z0=-70
ofx  = 160
ofy  = 100
ofz  = 60
npts = 216
degx  = 8
degy  = 2
degz  = 4

.model Compact
.stack	 28h
.data
      Xsin	dd ?
      Xcos	dd ?
      Ysin	dd ?
      Ycos	dd ?
      Zsin	dd ?
      Zcos	dd ?

      curp	db 256 dup(?)
      pal_file	db 'pal.dat',0

label pts0 dword
	   c = -70
	   rept 6
		b = -60
		rept 6
		     a = -52
		     rept 6
			  dd a,b,c
			  a = a + 15
		     endm
		     b = b + 15
		endm
		c = c + 15
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

	mov	eax,[di+pts+8]
	mov	es:[ebx],al
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

	call	twait

	call	erase

jmp	l01

exit:
	mov	ax,003h
	int	10h
	mov	ah,4ch
	int	21h

;  Three 2 Two Dimention
;  in: ebx - x
;      ecx - y
;      esi - z
;  out: ebx : screen x
;	ecx : screen y
;  x0=160
;  y0=100
;  z0=-50
d32 proc
	sub	ebx,x0
	sub	ecx,y0
	sub	esi,z0

	mov	eax,z0
	imul	ebx
	idiv	esi
	mov	ebx,x0
	sub	ebx,eax

	mov	eax,z0
	imul	ecx
	idiv	esi
	mov	ecx,y0
	sub	ecx,eax
	ret
endp


erase proc
	xor	si,si
	xor	al,al
  e01:
	mov	di,[si+dels]
	stosb
	add	si,3*4
	cmp	si,3*4*npts
	jne	e01
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

set_colors proc
	mov	cx,1
	mov	dx,3C8H
	mov	bx,0
L1:
	mov	al,cl
	out	dx,al
	inc	dx

	mov	al,[bx+curp]
	out	dx,al

	mov	al,0
	out	dx,al

	mov	al,[bx+curp]
	out	dx,al

	inc	bx

	dec	dx
	inc	cx
	cmp	cx,256
	jb	l1
	ret
endp

load_files proc
       ; read in pal file
       mov	ax,3d00h
       lea	dx,pal_file
       int	21h
       mov	bx,ax
       mov	ah,3fh
       mov	cx,256
       lea	dx,curp
       int	21h
       mov	ah,3eh
       int	21h
       ret
endp

end start