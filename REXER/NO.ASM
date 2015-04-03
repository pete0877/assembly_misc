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
