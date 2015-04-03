.286
dosseg
.model tiny
.stack   28h
.data
        id      dw (?)
        ad      dd (?)
.code

jmp install

start:
        cli
        push es
        push ds
        pusha
        pushf
jmp     over_data
        txt     db 'R',132,'E',132,'X',132,'E',132,'R',132
        txt2    db 'visit www.tiac.net/users/rexer77      '
over_data:

        mov     ax,0b800h
        mov     es,ax
        xor     bx,bx
l0:     mov     cl,cs:[txt][bx]
        mov     es:[bx+150],cl
        inc     bx
        cmp     bx,10
        jne     l0


        xor     bx,bx
l1:     mov     al,es:[bx]
        cmp     al,100
        je      f2
        add     bx,2
        cmp     bx,4000
        jb      l1
        jmp     exit
f2:     add     bx,2
        mov     al,es:[bx]
        cmp     al,105
        je      f3
        jmp     l1
f3:     add     bx,2
        mov     al,es:[bx]
        cmp     al,114
        je      change
        jmp     l1
change:
        sub     bx,4
        mov     si,0
l2:     mov     al,cs:[txt2][si]
        mov     es:[bx],al
        add     bx,2
        inc     si
        cmp     si,35
        jne     l2
exit:
        popf
        popa
        pop ds
        pop es
        sti
        iret

install:
        mov     ah,35h
        mov     al,1ch
        int     21h
        mov     di,bx
        mov     ax,seg  start
        mov     ds,ax
        mov     si,offset start
        mov     cx,install-start-1
        cld
        rep     cmpsb
        cli
        mov     word ptr [ad],bx
        mov     ax,es
        mov     word ptr ad[2],ax
        mov     ax,SEG start
        mov     ds,ax
        mov     dx,offset start
        mov     ah,25h
        mov     al,1ch
        int     21h
        mov     ax,@code
        sub     ax,10h
        mov     ds,ax
        mov     bx,2ch
        mov     ax,[bx]
        mov     es,ax
        mov     ah,49h
        int     21h
        mov     ah,62h
        int     21h
        mov     ax,@data
        mov     ds,ax
        mov     id,bx
        sti
        mov     dx,(offset ad)-1
        mov     cl,4
        shr     dx,cl
        add     dx,11h
        mov     ax,3103h
        int     21h

        mov     ah,4ch
        int     21h
end INSTALL
