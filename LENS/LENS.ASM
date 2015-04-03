CODE SEGMENT PARA PUBLIC 'CODE'
        ASSUME  CS:CODE,DS:DATAS,SS:STOSIK
start:
        MOV AX,0013H
        INT 10H

        MOV AX,DATAS
        MOV DS,AX

        MOV AX,3D00H
        MOV DX,OFFSET FNAME
        INT 21H

        MOV BX,AX
        MOV AH,3FH
        MOV CX,765
        MOV DX,OFFSET PIC
        INT 21H

        MOV CX,1
        MOV DI,OFFSET PIC
        MOV DX,3C8H
L000:                   ; *** KOLORY ****
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

        push ds

        MOV AX,0A000H   ;    **** LEW NA EKR :
        MOV dS,AX

        MOV AH,3FH
        MOV CX,64000
        MOV DX,0
        INT 21H

        MOV AH,3EH  ;*** ZAMKNIJ PLIK arc.DAT
        INT 21H

        pop ds


; **** LADUJ x-MAPE POD DS:xM

        LEA DX,XMF ;*** OTWORZ X_MAP.DAT
        MOV AL,0
        MOV AH,3DH
        INT 21H
        MOV BX,AX

        MOV AH,3FH  ;*** ODCZYTAJ 80X80 BAJTOW
        MOV CX,6400
        LEA DX,xm
        INT 21H

        MOV AH,3EH  ;*** ZAMKNIJ PLIK X_MAP.DAT
        INT 21H

; **** LADUJ Y-MAPE POD DS:yM

        LEA DX,YMF ;*** OTWORZ X_MAP.DAT
        MOV AL,0
        MOV AH,3DH
        INT 21H
        MOV BX,AX

        MOV AH,3FH  ;*** ODCZYTAJ 80X80 BAJTOW
        MOV CX,6400
        LEA DX,yM
        INT 21H

        MOV AH,3EH  ;*** ZAMKNIJ PLIK Y_MAP.DAT
        INT 21H

        mov al,100
        mov x,al
        mov y,al
        MOV AX,0A000H
        MOV eS,AX

mainloop:


        ; make copy of x , y
        xor bx,bx
        mov dl,y
        xor dh,dh
        mov ax,320
        mul dx
        mov si,ax
        mov al,x
        xor ah,ah
        add si,ax

push si

        lea di,copy

        mov ax,ds
        mov dx,es
        mov ds,dx
        mov es,ax
        mov ax,cx
        mov dl,0
        mj:
            mov cx,40
            rep movsw
            add si,240
            inc dl
            cmp dl,80
        jne mj
        mov cx,ax
        mov ax,ds
        mov dx,es
        mov ds,dx
        mov es,ax
ok:

        xor bx,bx
        xor cx,cx

main:
        mov al,ym[bx]
cmp al,0
        jne noz
         inc bx
           inc cl
           cmp cl,80
           jne nonew
             xor cl,cl
             inc ch
           nonew:
         cmp bx,6400
         je frame
         jmp main
        noz:
        xor ah,ah
        mov bp,80
        mul bp
        mov dl,[xm][bx]
        xor dh,dh
        add ax,dx
        mov si,ax

        mov al,y
        xor ah,ah
        mov dl,ch
        xor dh,dh
        add ax,dx
        mov dx,320
        mul dx
        mov dl,cl
        xor dh,dh
        add ax,dx
        mov dl,x
        xor dh,dh
        add ax,dx
        mov di,ax

        mov al,copy[si]
        mov es:[di],al


        inc bx
           inc cl
           cmp cl,80
           jne nonew2
             xor cl,cl
             inc ch
           nonew2:
        cmp bx,6400
        je frame
        jmp main
frame:

        mov     dx,03dah
@@33:
        in      al,dx
        test    al,08h
        jz     @@33
@@44:
        in      al,dx
        test    al,08h
        jnz      @@44

pop di

        lea si,copy

        mov ax,cx
        xor dl,dl
        mj2:
            mov cx,40
            rep movsw
            add di,240
            inc dl
            cmp dl,80
        jne mj2
        mov cx,ax

ok2:
     mov al,x
     mov ah,y
     mov dl,ddx
     mov dh,ddy


     cmp dl,1
     jne decx
         inc al
         cmp al,174
         jne nozerx2
           xor dl,dl

     decx:
         dec al
         cmp al,1
         jne nozerx2
           mov dl,1
         nozerx2:

     cmp dh,1
     jne decy
         inc ah
         cmp ah,119
         jne nozery2
           xor dh,dh

     decy:
         dec ah
         cmp ah,1
         jne nozery2
           mov dh,1
         nozery2:

     mov x,al
     mov y,ah
     mov ddx,dl
     mov ddy,dh
key:
        IN  AL,60H
        CMP AL,1
je quit
Jmp mainloop      ;****  ESCAPE ****

QUIT:
        mov ah,1
        int 21h

        STI

        MOV AX,0003H
        INT 10H
        MOV AX,4C00H
        INT 21H

CODE    ENDS

STOSIK SEGMENT PARA STACK 'STACK'
        DB 2048 DUP (?)
STOSIK ENDS

DATAS SEGMENT PARA PUBLIC 'DATA'
        POCZ    DW  0
        XMF DB 'X_MAP.DAT',0
        YMF DB 'Y_MAP.DAT',0
        ym  db 6400 dup(0)
        xm  db 6400 dup(0)
        copy db 6400 dup(0)
        x db 0
        y db 0
        ddx db 1
        ddy db 1
        FNAME   DB  'cat.ARC',0
        pic     db  1000 dup(0)
DATAS   ENDS

END


