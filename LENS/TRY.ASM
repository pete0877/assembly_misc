.model tiny
.stack   28h
.code
.386
START:
        mov     ax,cs
        mov     ds,ax
        mov     ax,48h
        mov     bx,320*200/16
        int     21h
        jnc     ok
        lea     dx,text
        mov     ah,9
        int     21h
        jmp     EXIT
ok:
        mov     ax,13h
        int     10h
        mov     dx,3d4h
        mov     al,0ch
        mov     ah,0ah
        out     dx,ax
        inc     al
        mov     ah,00
        out     dx,ax
CHECK_ESC:
        in      al,60h
        cmp     al,1
        jne     CHECK_ESC
EXIT:
        mov     ah,4ch               ; terminate the program
        int     21h

        text db 'No mem!!!  $'

end START