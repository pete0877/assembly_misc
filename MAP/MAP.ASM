CODE SEGMENT PARA PUBLIC 'CODE'
	ASSUME	CS:CODE,DS:DATAS,SS:STOSIK,ES:EXT
jmp start
	XMF DB 'X_MAP.DAT',0
	YMF DB 'Y_MAP.DAT',0
	xpo dw 0
	ym  db 40000 dup(?)
start:
	MOV AX,0013H
	INT 10H

	MOV AX,DATAS
	MOV DS,AX

	MOV AX,EXT
	MOV ES,AX
	mov esad,ax
	push es

	MOV AX,3D00H
	MOV DX,OFFSET FNAME
	INT 21H
	jnc okok
	jmp quit
okok:
	MOV BX,AX
	MOV AH,3FH
	MOV CX,765
	MOV DX,OFFSET PIC
	INT 21H
	MOV CX,1
	MOV DI,OFFSET PIC
	MOV DX,3C8H
L000:			; *** KOLORY ****
	MOV AL,CL
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
	INC CX
	CMP CX,256
JB  L000

	MOV AX,0A000H	;    **** LEW NA EKR :
	MOV ES,AX
	MOV AH,3FH
	MOV CX,64000
	MOV DX,OFFSET FNAME
	INT 21H

	MOV DX,3D4H
	MOV AL,0DH
	MOV AH,2
	OUT DX,AX

	MOV DX,0
	XOR AH,AH
L004:
	MOV SI,OFFSET FNAME
	MOV DI,0
	MOV BX,DX
L005:
	PUSH	DI
	MOV AL,0
	ADD DI,AX
	MOV CX,320
	REP MOVSB
	POP DI
	ADD DI,320
	INC BX
	CMP BX,146
	JB  L001
	MOV BX,1
L001:
	CMP DI,64000
	JB  L005

	INC DX
	CMP DX,147
	JB  LLL
	MOV DX,1

;   **** PRZEPISANIE 200X200 LEW POD DS:PIC
	CLD
LLL:MOV AX,0A000H
	MOV ES,AX
	MOV CX,0
	XOR BP,BP
L01:
	MOV AX,320
	MUL CX
	MOV SI,AX
	XOR BX,BX
L02:
	MOV AL,ES:[SI+60][BX]
	MOV DS:[BP][PIC],AL
	INC BP
	INC BX
	CMP BX,200
JNZ L02

	INC CX
	CMP CX,200
JNZ L01

;NOX: IN  AL,60H
;	 CMP AL,57
;JNE NOX       ;****  WAIT ****

	mov ah,1
	int 21h



	MOV AX,0A000H  ; **** CZYSC EKR
	MOV ES,AX
	XOR AL,AL
	MOV BX,0
L03:
	MOV ES:[BX],AL
	INC BX
	CMP BX,64000
JNE L03

; **** LADUJ x-MAPE POD CS:yM
	PUSH DS

	MOV AX,CS
	MOV DS,AX

	LEA DX,CS:XMF ;*** OTWORZ X_MAP.DAT
	MOV AL,0
	MOV AH,3DH
	INT 21H
	MOV BX,AX

	MOV AH,3FH  ;*** ODCZYTAJ 200X200 BAJTOW
	MOV CX,40000
	LEA DX,CS:yM
	INT 21H

	MOV AH,3EH  ;*** ZAMKNIJ PLIK X_MAP.DAT
	INT 21H

	POP DS

	POP ES

	mov bx,0
spis:
   mov al,cs:[ym][bx]
   mov es:[xm][bx],al
   inc bx
   cmp bx,40000
jne spis

; **** LADUJ Y-MAPE POD CS:yM

	PUSH DS

	MOV AX,CS
	MOV DS,AX

	LEA DX,CS:YMF ;*** OTWORZ X_MAP.DAT
	MOV AL,0
	MOV AH,3DH
	INT 21H
	MOV BX,AX

	MOV AH,3FH  ;*** ODCZYTAJ 200X200 BAJTOW
	MOV CX,40000
	LEA DX,CS:yM
	INT 21H

	MOV AH,3EH  ;*** ZAMKNIJ PLIK Y_MAP.DAT
	INT 21H

	POP DS


	xor ax,ax
	mov cs:[xpo],ax
main:
	mov bp,0
next:
	mov bl,cs:[ym][bp]
	xor bh,BH
	cmp bl,0
jne noz
	inc bp
	cmp bp,40000
jne next
	jmp spr
noz:
	mov ax,200
	mul bx
	mov si,AX
	MOV CL,es:[xm][bp]
	XOR CH,CH
	mov ax,cs:[xpo]
	add cx,ax
	cmp cx,200
jb okr2
	sub cx,200
okr2:
	ADD SI,CX
	MOV CL,DS:[PIC][SI]
	XOR CH,CH
	XOR DX,DX
	MOV AX,BP
	MOV BX,200
	DIV BX
	MOV DI,DX
	MOV BX,AX
	MOV AX,320
	MUL BX
	ADD DI,AX
	PUSH ES
	 MOV AX,0A000H
	 MOV ES,AX
	 MOV ES:[DI][60],CX
	POP ES
	inc bp
	cmp bp,40000
jne next

spr:
	mov ax,cs:[xpo]
	inc ax
	cmp ax,200
	jne okr
	xor ax,ax
okr:
	mov cs:xpo,ax
key:
	IN  AL,60H
	CMP AL,1
JE quit       ;****  ESCAPE ****
jmp main




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
	POCZ	DW  0
	FNAME	DB  '..\files\cat.ARC',0
	PIC	DB  40000 DUP(0)
			db  0,0,0,0
	esad	dw  ?

DATAS	ENDS

EXT SEGMENT PARA PUBLIC 'EXT'
	XM  DB 40000 DUP (?)
EXT ENDS
END
