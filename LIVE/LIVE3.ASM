CODE SEGMENT PARA PUBLIC 'CODE'
	ASSUME	CS:CODE,DS:DATAS,SS:STOSIK

mov ax,DATAS
mov ds,ax

	MOV AX,0013H
	INT 10H

mov ax,0A000h
mov es,ax

mov ax,cs
sub ax,10
mov ds,ax
mov bx,25*320
ll:
   mov al,[bx]
   cmp al,50
   jb nextcs
      mov al,10
      mov es:[bx],al
   nextcs:
   inc bx
   cmp bx,175*320
jne ll

mov ax,0A000h
mov ds,ax

	mov bx,25*320
main:
	mov al,[bx]

	xor dl,dl
	mov ah,[bx][1]
	add dl,ah
	mov ah,[bx][-1]
	add dl,ah
	mov ah,[bx][320]
	add dl,ah
	mov ah,[bx][-320]
	add dl,ah

	cmp al,10
	jne newlivecheck
	   cmp dl, 3*10
	   ja die
	   cmp dl, 2*10
	   jb die
	   jmp next
	   die:
		mov al,5
		mov [bx],al
	   jmp next
	newlivecheck:
	   cmp dl,3*10
	   jne next
	   mov al,10
	   mov [bx],al
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
DATAS	ENDS

END


