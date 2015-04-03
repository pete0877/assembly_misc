CODE SEGMENT PARA PUBLIC 'CODE'
        ASSUME  CS:CODE,DS:DATAs,SS:STOSIK

        MOV AX,DATAs
        MOV DS,AX
        CLI

        MOV     AX,13H ;*** TRYB GRAFICZNY (#) (320X200X256C)
        INT     10H

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

        mov ax,0a000h
        mov es,ax
        xor bx,bx

        MOV AX,3D00H
        MOV DX,OFFSET F
        INT 21H
        MOV BX,AX
        MOV AH,3FH
        MOV CX,1000
        MOV DX,OFFSET B
        INT 21H
        mov ah,3eh
        int 21h

        mov ax,0a000h
        mov es,ax
        xor cx,cx
key:
        push ds
        push cx
        mov bx,125
        mov ax,0a000h
        mov ds,ax
move:
        mov ax,320
        mul bx
        add ax,10
        mov di,ax
        add ax,320
        mov si,ax
        mov cx,20
        rep movsb
        inc bx
        cmp bx,200
jne move
jmp no1
km:     jmp key
no1:
        pop cx
        pop ds


        mov ax,20
        mul cx
        mov bx,offset b
        add ax,bx
        mov si,ax
        mov ax,200*320+10
        mov di,ax
        push cx
        mov cx,20
        rep movsb
        pop cx

        inc cx
        cmp cx,50
        jne ok2
        xor cx,cx
ok2:
        push cx

        mov cx,125*320+10
lcx:    mov bx,cx
        xor di,di
lbx:
        mov al,es:[bx]
        cmp al,0
je nothere
        xor ah,ah
        mov al,es:[bx-320]
        xor dh,dh
        mov dl,es:[bx+320]
        add ax,dx
        mov dl,es:[bx]
        add ax,dx
        mov dl,3
        div dl
        mov es:[bx],al
nothere:
        add bx,320
        inc di
        cmp di,75
jne lbx
        inc cx
        cmp cx,125*320+30
jne lcx

        push ds
        push cx

        mov ax,es
        mov ds,ax
        mov bx,100
llbx:   mov ax,320
        mul bx
        add ax,10
        mov si,ax
        add ax,20
        mov di,ax
        mov cx,10
        rep movsw
        inc bx
        cmp bx,200
jne llbx

        mov bx,100
lllbx:  mov ax,320
        mul bx
        add ax,10
        mov si,ax
        add ax,40
        mov di,ax
        mov cx,20
        rep movsw
        inc bx
        cmp bx,200
jne lllbx



        pop cx
        pop ds

        pop cx

        push cx
        mov cx,64000
        nic2:loop nic2
        pop cx
        IN  AL,60H
        CMP AL,1
Je quit       ;****  ESCAPE ****
jmp km

quit:
        mov ah,1
        int 21h

        STI
        MOV AX,0003H
        INT 10H
        MOV AX,4C00H
        INT 21H
CODE    ENDS

STOSIK SEGMENT PARA STACK 'STACK'
        DB 2048 dup (?)
STOSIK ENDS

DATAs SEGMENT PARA PUBLIC 'DATA'
        FNAME db 'colors.dat',0
        f     db 'fire.dat',0
        buf   db 1000 dup(?)
        b     db 20*50 dup(?)
DATAs   ENDS
END
