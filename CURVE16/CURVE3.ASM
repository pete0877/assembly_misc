; non transparent and only 16 * 16
;     draws head first
;     makes it glass like
; use one direction gradient pal

maxnum          EQU     9
speed           EQU     2*3
flex_speed      EQU     90

.model tiny
.stack   28h
.data
    dist        dw 20
    distf       db 1
    count       db 0
    image_file  db 'image.dat',0
    image       db 16*16 dup(0)
    curve_file  db 'curve.dat',0
    curve       dw 1800 dup (0)
    curp        db 256*3 dup(0)
    pal_file    db 'pal.dat',0
    palcfg_file db 'palcfg.dat',0
    palcfg      db 3 dup(1)
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
        lea     si,image
        xor     cl,cl
 loop_show:
        mov     al,es:[di]
        mov     ah,al
        lodsb
        add     al,ah
        stosb
 no_put:
        inc     cl
        cmp     cl,16
        jne     loop_show
        xor     cl,cl
        add     di,320-16
        cmp     si,16*16+offset image
        jne     loop_show
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
        mov     dx,dist
        cmp     bx,dx
        jnb     do_sub
        sub     dx,bx
        mov     bx,3600
 do_sub:
        sub     bx,dx
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
        mov     dx,dist
        cmp     bx,dx
        jnb     do_sub2
        sub     dx,bx
        mov     bx,3600
 do_sub2:
        sub     bx,dx
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
       ; read in pal file
       mov      ax,3d00h
       lea      dx,pal_file
       int      21h
       mov      bx,ax
       mov      ah,3fh
       mov      cx,3*256
       lea      dx,curp
       int      21h
       mov      ah,3eh
       int      21h
       ; read in palcfg file
       mov      ax,3d00h
       lea      dx,palcfg_file
       int      21h
       mov      bx,ax
       mov      ah,3fh
       mov      cx,3
       lea      dx,palcfg
       int      21h
       mov      ah,3eh
       int      21h
       ret
endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
set_colors proc
        mov     cx,1
        mov     dx,3C8H
        mov     bx,0
L1:
        mov     al,cl
        out     dx,al
        inc     dx

        mov     al,[bx+curp]
        mov     ah,[palcfg]
        cmp     ah,'0'
        jne     cok2
        xor     al,al
cok2:
        inc     bx
        out     dx,al

        mov     al,[bx+curp]
        mov     ah,[palcfg+1]
        cmp     ah,'0'
        jne     cok3
        xor     al,al
cok3:
        inc     bx
        out     dx,al

        mov     al,[bx+curp]
        mov     ah,[palcfg+2]
        cmp     ah,'0'
        jne     cok1
        xor     al,al
cok1:
        inc     bx
        out     dx,al



        dec     dx
        inc     cx
        cmp     cx,255
        jb      l1
        ret
endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

end start