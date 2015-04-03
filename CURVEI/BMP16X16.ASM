.model tiny
.stack   28h
.data
    img         db 16*16 dup(0)
    img_file    db 't.bmp'
    pal         db 256*4 dup(0)
.code
.386
start:
        mov ax,@data
        mov ds,ax

        mov ax,0a000h
        mov es,ax

        call    set_13h_mode
        call    load_bmp
        call    set_colors
        call    show_bmp
        call    key

exit:
        mov     ax,003h
        int     10h
        mov     ah,4ch
        int     21h

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;  Help Procedures  ;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

show_bmp proc
        lea     si,img
        mov     di,80*320+150
        mov     al,0
 ls:
        mov     cx,16/4
        rep     movsd
        add     di,320-16
        inc     al
        cmp     al,16
        jne     ls
        ret
endp

key proc
check_key:
        mov     ah,2            ; check keyboard for R-Shft
        int     16h
        and     al,1
        cmp     al,1
        jne     check_key
        ret
endp

set_13h_mode proc
        mov     ax,0013h
        int     10h
        mov     ax,0a000h
        mov     es,ax
        ret
endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

load_bmp proc
       ; read in font
       mov      ax,3d00h
       lea      dx,img_file
       int      21h
       mov      bx,ax

       mov      ah,3fh  ; header
       mov      cx,54
       lea      dx,img
       int      21h

       mov      ah,3fh  ; pal
       mov      cx,1024
       lea      dx,pal
       int      21h

       mov      ah,3fh
       mov      cx,16*16
       lea      dx,img
       int      21h

       mov      ah,3eh
       int      21h
       ret
endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

set_colors proc
        mov     cx,0
        mov     dx,3C8H
        mov     bx,0
L1:
        mov     al,cl
        out     dx,al
        inc     dx

        mov     al,[bx+pal+2]
        out     dx,al

        mov     al,[bx+pal+1]
        out     dx,al

        mov     al,[bx+pal+0]
        add     bx,4
        out     dx,al

        dec     dx
        inc     cx
        cmp     cx,256
        jb      l1
        ret
endp

end start