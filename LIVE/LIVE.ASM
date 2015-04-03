CODE SEGMENT PARA PUBLIC 'CODE'
	ASSUME	CS:CODE,DS:DATAS,SS:STOSIK

mov ax,DATAS
mov ds,ax

	MOV AX,0013H
	INT 10H

	MOV AX,3D00H
	MOV DX,OFFSET FNAME
	INT 21H
	MOV BX,AX

	MOV AH,3FH
	MOV CX,765
	MOV DX,OFFSET BUF
	INT 21H

	mov ah,3eh
	int 21h


	MOV bX,1
	MOV DX,3C8H
	LEA DI,BUF
L000:
	MOV AL,BL
	OUT DX,AL
	INC DX
    MOV AL,[DI]
	OUT DX,AL
    MOV AL,[DI+1]
	OUT DX,AL
    MOV AL,[DI+2]
	OUT DX,AL
	DEC DX
	ADD DI,3
	INC BL
	CMP BL,255
JB  L000




mov ax,0A000h
mov es,ax
mov ds,ax

mov al,10
mov bx,100*320+155
mov es:[bx],al
mov bx,105*320+160
mov es:[bx],al
mov bx,95*320+165
mov es:[bx],al
mov bx,100*320+110
mov es:[bx],al
mov bx,100*320+80
mov es:[bx],al


	mov ch,0
	mov bx,25*320
	mov di,0
main:
	mov al,[bx]
	xor dx,dx
	mov cl,[bx][1]
	add dx,cx
	mov cl,[bx][-1]
	add dx,cx
	mov cl,[bx][320]
	add dx,cx
	mov cl,[bx][-320]
	add dx,cx
	cmp dx,10
	jb next
	   cmp dx,200 * 4
	   ja die
	      cmp al,250
	      je nomore
		 add al,1
		 mov [bx],al
	      nomore:
	      jmp next
	   die:
		cmp al,0
		je noless
		   sub al,1
		   mov [bx],al
		noless:
	next:
	inc bx
	cmp bx, 175*320
	jne nz
	    mov bx,25*320
	nz:

	IN  AL,60H
	CMP AL,1
je quit
Jmp main      ;****  ESCAPE ****

QUIT:
	mov ah,1
	int 21h

	STI

	MOV AX,0003H
	INT 10H
	MOV AX,4C00H
	INT 21H

CODE	ENDS

STOSIK SEGMENT PARA STACK 'STACK'
	DB 2048 DUP (?)
STOSIK ENDS

DATAS SEGMENT PARA PUBLIC 'DATA'
	FNAME db 'colors.dat',0
	buf   db 1000 dup(?)
	b     db 20*50 dup(?)
DATAS	ENDS

END


