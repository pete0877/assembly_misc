; non transparent and only 16 * 16
;     draws head first
maxnum	 =  10
speed	 =  2*4
bck	 =  0fh
dist	 =  20
mir_col  =  0ch

.model tiny
.stack	 28h
.data
    image_file	db 't.bmp',0
    image	db 16*16 dup(0)
    curve_file	db 'curve.dat',0
    curve	dw 1800 dup (0)
    pal 	db 256*4 dup(0)

.code
.386
start:
	mov ax,@data
	mov ds,ax

	call load_files
	call make_trans
	call set_13h_mode
	call set_colors

	mov	bp,0
loop_curve:

	mov	bx,bp
	call	show_all
	call	mirror
	mov	bx,bp
	call	twait
	call	hide_all

	add	bp,speed
	cmp	bp,3600
	jne	ok5
	xor	bp,bp
ok5:

check_key:
	mov	ah,2		; check keyboard for R-Shft
	int	16h
	and	al,1
	cmp	al,1
	je	exit
jmp loop_curve

exit:
	mov	ax,003h
	int	10h
	mov	ah,4ch
	int	21h

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;  Help Procedures ;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mirror proc
	mov	si,115*320
	mov	di,116*320
	push	ds
	push	es
	pop	ds
	mov	al,0
  s0:
	mov	cx,80
	rep	movsd
	sub	si,3*320
	inc	al
	cmp	al,50
	jne	s0

	mov	si,116*320
	mov	di,116*320
  s1:
	lodsw
	cmp	ax,0
	jne	chbo
	  mov	  al,mir_col
	  mov	  ah,mir_col
	  stosw
	  mov	  di,si
	  cmp	  si,(116+50)*320
	  jne	  s1
	  pop	  ds
	  ret
  chbo:
	cmp	al,mir_col
	ja	cah
	mov	al,mir_col
  cah:
	cmp	ah,mir_col
	ja	plot
	mov	ah,mir_col
  plot:
	stosw
	mov	di,si
	cmp	si,(116+50)*320
	jne	s1

	pop	ds
	ret
endp


twait proc
  mov	  dx,3dah
@l1:
  in	  al,dx
  and	  al,08h
  jnz	  @l1
@l2:
  in	  al,dx
  and	  al,08h
  jz	  @l2
      ret
endp


set_13h_mode proc
	mov	ax,0013h
	int	10h
	mov	ax,0a000h
	mov	es,ax
	ret
endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

make_trans proc
	lea	bx,image
	mov	ah,0
  ltrl:
	mov	al,[bx]
	cmp	al,bck
	jne	nnext
	mov	[bx],ah
  nnext:
	inc	bx
	cmp	bx,offset image + 16*16
	jne	ltrl
	ret
endp

load_bmp proc
       ; read in font
       mov	ax,3d00h
       lea	dx,image_file
       int	21h
       mov	bx,ax

       mov	ah,3fh	; header
       mov	cx,54
       lea	dx,image
       int	21h

       mov	ah,3fh	; pal
       mov	cx,1024
       lea	dx,pal
       int	21h

       mov	ah,3fh
       mov	cx,16*16
       lea	dx,image
       int	21h

       mov	ah,3eh
       int	21h
       ret
endp

show proc
	push	bx

	lea	si,image
	xor	cl,cl
 loop_show:
	cmp	di,115*320
	ja	get_out
	lodsb
	cmp	al,0
	je	no_put
	stosb
	inc	cl
	cmp	cl,16
	jne	loop_show
	xor	cl,cl
	add	di,320-16
	cmp	si,16*16+offset image
	jne	loop_show
	jmp	get_out

 no_put:
	inc	di
	inc	cl
	cmp	cl,16
	jne	loop_show
	xor	cl,cl
	add	di,320-16
	cmp	si,16*16+offset image
	jne	loop_show

get_out:
	pop bx
	ret
endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

hide proc
	xor	dl,dl
	xor	ax,ax
 loop_hide:
	cmp	di,115*320
	ja	hout
	mov	cx,4
	rep	stosd
	inc	dl
	add	di,320-16
	cmp	dl,16
	jne	loop_hide
hout:
	ret
endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

show_all proc
	mov	cx,maxnum
 show_one:
	mov	di,word ptr [bx+curve]
	push	cx
	call	show
	pop	cx
	add	bx,dist
	cmp	bx,3600
	jb	ok6
	sub	bx,3600
 ok6:
	loop	show_one
	ret
endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

hide_all proc
	mov	cx,maxnum
 hide_one:
	mov	di,word ptr [bx+curve]
	push	cx
	call	hide
	pop	cx
	add	bx,dist
	cmp	bx,3600
	jb	ok7
	sub	bx,3600
 ok7:
	loop	hide_one
	ret
endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

load_files proc
       ; read in curve image:
       mov	ax,3d00h
       lea	dx,curve_file
       int	21h
       mov	bx,ax
       mov	ah,3fh
       mov	cx,3600
       lea	dx,curve
       int	21h
       mov	ah,3eh
       int	21h
       call load_bmp
       ret
endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

set_colors proc
	mov	cx,0
	mov	dx,3C8H
	mov	bx,0
L1:
	mov	al,cl
	out	dx,al
	inc	dx

	mov	al,[bx+pal+2]
	out	dx,al

	mov	al,[bx+pal+1]
	out	dx,al

	mov	al,[bx+pal+0]
	add	bx,4
	out	dx,al

	dec	dx
	inc	cx
	cmp	cx,256
	jb	l1
	ret
endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

end start