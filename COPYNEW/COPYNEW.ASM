; Copy New v1.0 by PeterG@wpi.edu

dosseg
.model tiny
.stack	 28h
.code

start:
	mov	ax,cs
	mov	ds,ax
jmp over
	bat  db 'copynew.bat',0
	last db 'copynew.dat',0
	cfg  db 'copynew.pth',0
	DOCS db '?.???',0,0,0
	copy db 'copy ',0
	newline db 0dh, 0ah,0
	P1 db 300 dup (0)
	sl db '\',0
	pp2 db ' '
	P2 db 300 dup (0)
	da dw 0
	ti dw 0
	dan dw 0
	tin dw 0
over:

call loadps
call change

	lea	dx,last
	mov	ax,3d00h	;open last file
	int	21h
	mov	bx,ax

	mov	ah,3fh
	mov	cx,4
	lea	dx,da
	int	21h

	mov	ah,3eh		; Close last file
	int	21h

	mov	dx,[da]
	mov	cx,[ti]
	mov	[dan],dx
	mov	[tin],cx

	lea	dx,bat
	mov	ax,3c00h	;open bat file
	mov	cx,0
	int	21h
	mov	di,ax

call copyfiles

	mov	bx,di
	mov	ah,3eh		; Close bat file
	int	21h

call setnewdate

jmp exit

loadps proc
       mov ax,cs
       mov ds,ax

	lea	dx,cfg
	mov	ax,3d00h	;open cfg file
	int	21h
	mov	bx,ax

	lea	si,docs
	call	readline
	lea	si,p1
	call	readline
	lea	si,p2
	call	readline

	mov	ah,3eh		; Close cfg file
	int	21h

	ret
endp loadps

readline proc

       mov ax,cs
       mov ds,ax

    jmp over2
	buff db 5 dup (0)
    over2:

    loopy:
	mov	ah,3fh
	mov	cx,1
	lea	dx,buff
	int	21h
	mov	al,buff
	cmp	al,0ah
	jne	noa
	mov	ah,3fh
	mov	cx,1
	lea	dx,buff
	int	21h
noa:	cmp	al,13
	je	endline
	mov	[si],al
	inc	si
	jmp	loopy

    endline:
	mov	ah,3fh
	mov	cx,1
	lea	dx,buff
	int	21h
	ret
endp readline

change proc
       mov ax,cs
       mov ds,ax

	lea    bx,p1
	mov    dl,[bx+0]
	sub    dl,'a'
	mov    ah,0eh
	int    21h

	lea	dx,p1
	mov	ah,3bh
	int	21h
	ret
endp change

copyfiles proc
       mov ax,cs
       mov ds,ax

	lea	dx,docs
	mov	cx,111b 	; Set File Filter of the good files
	mov	ah,4eh
	int	21h
	jnc	GetName
	jmp	EndThis 	; Not Found

GetName:
	mov    ah,2fh		; Get FilenAme
	int    21h
	mov    dx,es
	mov    ds,dx
	mov    dx,bx
	add    dx,1eh

	mov    bp,dx

	mov	ax,3d00h	;open file
	int	21h
	jnc	ok0
	jmp	error
ok0:
	mov	bx,ax
	mov	ax,cs
	mov	ds,ax

	mov	ax,5700h	; get time / date
	int	21h
	mov	ah,3eh		     ; Close this file
	int	21h

	cmp	dx,[dan]
	ja	change_d
	je	change_t
	jmp	done
change_d:
	mov	[dan],dx
	mov	[tin],cx
	jmp	done

change_t:
	cmp	cx,[tin]
	jna	done
	mov	[tin],cx
done:

	cmp	[da],dx
	ja	notnew
	jb	go
	cmp	[ti],cx
	jnb	notnew
	go:	call	copyone
notnew:
	mov	ah,4fh
	int	21h
	jc	EndThis 	     ; No more files found
	jmp	GetName

EndThis:
	mov ax,cs
	mov ds,ax
	ret
Error:
	mov	ah,3eh		     ; Close file
	int	21h
	jmp	EndThis
endp copyfiles

setnewdate proc
       mov ax,cs
       mov ds,ax

       lea     dx,last
       mov     ax,3d01h        ;open date file
       mov     cx,0
       int     21h

       mov     bx,ax
       mov     cx,4
       lea     dx,dan
       mov     ax,4000h
       int     21h

       mov     ah,3eh		    ; Close date file
       int     21h
       ret
endp setnewdate

writeline proc

	  mov cx,1
	  push di
loopy3:
	  mov ax,4000h
	  int 21h
	  inc dx
	  mov di,dx
	  mov al,[di]
	  cmp al,0
jne loopy3

	  pop di
	  ret
endp writeline

copyone proc
       mov ax,cs
       mov ds,ax

	push	bx
	mov	bx,di

	lea	dx,copy
	call	writeline
	lea	dx,p1
	call	writeline
	lea	dx,sl
	call	writeline
mov	dx,bp
mov ax,es
mov ds,ax
	call	writeline
mov ax,cs
mov ds,ax
	lea	dx,pp2
	call	writeline
	lea	dx,newline
	call	writeline

	pop	bx
	ret
endp copyone


errm:


exit:	mov	ah,4ch		     ; terminate the program
	int	21h

end start
