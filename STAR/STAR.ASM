CODE SEGMENT PARA PUBLIC 'CODE'
	ASSUME  CS:CODE,DS:DATAS,SS:STOSIK
	MOV AX,DATAS
	MOV DS,AX
	CLI
	MOV AX,13H ;*** TRYB GRAFICZNY (#) (320X200X256C)
	INT 10H

	MOV DX,OFFSET file ;*** PLIK Star.DAT
	MOV AL,0
	MOV AH,3DH
	INT 21H
	MOV BX,AX
	
	MOV AH,3FH  ; *** 500 Stars (*3)
	MOV CX,1500
	lea DX,buf
	INT 21H
	
	MOV AH,3EH
	INT 21H

	;**** poczatek ****
	mov ax,0a000h
	mov es,ax
new:
	xor bp,bp
pocz:
	
	IN  AL,60H
	CMP AL,1
	JE QUIT 

MOV CX,2000
NIC: LOOP NIC

	mov ax,3
	mul bp
	mov bx,ax
	mov ax,320
	mov dl,buf[bx]
	xor dh,dh
	mul dx
	mov si,ax
	mov cx,si
	inc bx
	xor ah,ah
	mov al,buf[bx]
	add si,ax
	xor ax,ax
	mov es:si,ax
	mov di,bx
	inc di
	mov al,buf[bx]
	xor ah,ah
	cmp ax,255
	jna ok
	xor al,al
	mov buf[bx],al
ok: mov al,buf[di]
	add buf[bx],al
	mov di,cx
	xor ah,ah
	mov al,buf[bx]
	add di,ax
	mov cx,15
	mov es:[di],cx
	inc bp
	cmp bp,500
jnz pocz
jmp new

QUIT:    
	STI
	MOV AX,0003H
	INT 10H
	MOV AX,4C00H
	INT 21H
CODE    ENDS

STOSIK SEGMENT PARA STACK 'STACK'
	DB 2048 dup (?)
STOSIK ENDS

DATAS SEGMENT PARA PUBLIC 'DATA'
	file    DB  'Star.dat',0
	buf DB 1500 dup (10),0
DATAS   ENDS
END 
