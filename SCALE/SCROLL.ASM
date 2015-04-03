wtime EQU 00FFh

dosseg
.model tiny
.stack   28h
.data
    font_file   db 'horfont.dat',0
    font        db 16384 dup(1)
    text        db 'H H H H H H H H H H H H   ',0
.code
start:
        mov ax,@data
        mov ds,ax

jmp     over_proc

twait:
        push    cx
        mov     cx,wtime
wait_here:
        loop wait_here
        pop     cx
ret

move_all:
        push    ds
        mov     ax,0a000h
        mov     ds,ax
        mov     dx,0
  loop_lines:
        mov     di,dx
        mov     si,dx
        inc     si
        mov     cx,319
        rep     movsb
        add     dx,320
        cmp     dx,16*320
        jne     loop_lines
        pop     ds
ret

new_line:
        mov     cl,ds:[bp+text]
        xor     ch,ch
        sub     cl,32
        mov     ax,16*16
        mul     cx
        mov     si,ax
        mov     al,16
        mul     bx
        add     si,ax
        mov     di,319
        mov     cx,16
new_lines_loop:
        mov     al,[si+font]
        mov     es:[di],al
        inc     si
        add     di,320
        loop    new_lines_loop
ret

over_proc:

; read in fonts:
       mov      ax,3d00h
       lea      dx,font_file
       int      21h
       jnc      ok3
       jmp      exit
ok3:
       mov      bx,ax

       mov      ah,3fh
       mov      cx,16384
       lea      dx,font
       int      21h

       mov      ah,3eh
       int      21h

       mov     ax,0013h
       int     10h
       mov     ax,0a000h
       mov     es,ax
;;;;;;;;;;;
        MOV    CX,1
        MOV    DX,3C8H
        MOV    BX,0
L000:
        MOV AL,CL
        OUT DX,AL
        INC DX
        MOV AL,0
        OUT DX,AL
        MOV AL,0
        OUT DX,AL
        MOV AL,BL
        OUT DX,AL
        DEC DX
        ADD BX,5
        INC CX
        CMP CX,256
jB  L000


;;;;;;;;;;;


       mov     bp,0
       mov     bx,0
loop_main:
       call    move_all
       call    new_line
       inc     bx
       cmp     bx,16
       jne     check_key
       xor     bx,bx
       inc     bp
       mov     al,[bp+text]
       cmp     al,0
       je      exit
check_key:
        mov     ah,2            ; check keyboard for R-Shft
        int     16h
        and     al,1
        cmp     al,1
        je      exit
jmp loop_main

; THE end:

exit:
        mov     ax,003h
        int     10h

        mov     ah,4ch
        int     21h
end start