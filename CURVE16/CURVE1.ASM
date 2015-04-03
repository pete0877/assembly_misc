; non transparent and only 16 * 16
;     draw tail first
maxnum          EQU     10
speed           EQU     2*3
flex_speed      EQU     80

.model tiny
.stack   28h
.data
    dist        dw 10
    distf       db 1
    count       db 0
    image_file  db 'image.dat',0
    image       db 16*16 dup(0)
    curve_file  db 'curve.dat',0
    curve       dw 1800 dup (0)

.code
.386
start:
        mov ax,@data
        mov ds,ax

        call load_files
        call set_13h_mode
        call set_colors

        mov     bp,0
loop_curve:
        pusha
        mov     al,count
        inc     al
        mov     count,al
        cmp     al,flex_speed
        jne     no_change

        xor     al,al
        mov     count,al
        mov     dx,dist

        mov     bl,distf
        cmp     bl,0
        jne     increase
        sub     dx,2
        mov     dist,dx
        cmp     dx,10
        ja      dist_fin
        mov     bl,1
        mov     distf,bl
        jmp     dist_fin
increase:
        add     dx,2
        mov     dist,dx
        cmp     dx,180
        jb      dist_fin
        mov     bl,0
        mov     distf,bl
dist_fin:
no_change:
        popa

        mov     bx,bp
        call    show_all
        mov     bx,bp
        call    twait
        call    hide_all

        add     bp,speed
        cmp     bp,3600
        jne     ok5
        xor     bp,bp
ok5:

check_key:
        mov     ah,2            ; check keyboard for R-Shft
        int     16h
        and     al,1
        cmp     al,1
        je      exit
jmp loop_curve

exit:
        mov     ax,003h
        int     10h
        mov     ah,4ch
        int     21h

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;  Help Procedures ;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

set_13h_mode proc
        mov     ax,0013h
        int     10h
        mov     ax,0a000h
        mov     es,ax
        ret
endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

show proc
        push    bx
        lea     bx,image
        xor     cl,cl
 loop_show:
        mov     ah,[bx]
        cmp     ah,0
        je      no_put
        mov     es:[di],ah
 no_put:
        inc     di
        inc     bx
        inc     cl
        cmp     cl,16
        jne     loop_show
        xor     cl,cl
        add     di,320-16
        cmp     bx,16*16+offset image
        jne     loop_show
        pop bx
        ret
endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

hide proc
        xor     dl,dl
        xor     ax,ax
 loop_hide:
        mov     cx,4
        rep     stosd
        inc     dl
        add     di,320-16
        cmp     dl,16
        jne     loop_hide
        ret
endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

twait proc
      pusha
      mov  dx,03dah
z:    in   al,dx
      mov  ah,8
      and  al,ah
      cmp  al,0
      je   z

z2:    in   al,dx
      mov  ah,8
      and  al,ah
      cmp  al,0
      jne   z2

      popa
      ret
endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
show_all proc
        mov     cx,maxnum
 show_one:
        mov     di,word ptr [bx+curve]
        push    cx
        call    show
        pop     cx
        add     bx,dist
        cmp     bx,3600
        jb      ok6
        sub     bx,3600
 ok6:
        loop    show_one
        ret
endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

hide_all proc
        mov     cx,maxnum
 hide_one:
        mov     di,word ptr [bx+curve]
        push    cx
        call    hide
        pop     cx
        add     bx,dist
        cmp     bx,3600
        jb      ok7
        sub     bx,3600
 ok7:
        loop    hide_one
        ret
endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

load_files proc
       ; read in clock image :
       mov      ax,3d00h
       lea      dx,image_file
       int      21h
       mov      bx,ax
       mov      ah,3fh
       mov      cx,16*16
       lea      dx,image
       int      21h
       mov      ah,3eh
       int      21h
       ; read in curve image:
       mov      ax,3d00h
       lea      dx,curve_file
       int      21h
       mov      bx,ax
       mov      ah,3fh
       mov      cx,3600
       lea      dx,curve
       int      21h
       mov      ah,3eh
       int      21h
       ret
endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

set_colors proc
        MOV     CX,1
        MOV     DX,3C8H
        MOV     BX,0
L000:
        MOV     AL,CL
        OUT     DX,AL
        INC     DX
        MOV     AL,0
        OUT     DX,AL
        MOV     AL,0
        OUT     DX,AL
        MOV     AL,BL
        OUT     DX,AL
        DEC     DX
        ADD     BX,5
        INC     CX
        CMP     CX,256
        JB      L000
        ret
endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

end start