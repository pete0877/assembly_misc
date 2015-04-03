; non transparent and only 16 * 16
;     draws head first
;     makes it glass like

maxnum          EQU     10
speed           EQU     2*3
flex_speed      EQU     80
mir_col         =       10
dist            equ     40
mwait           = 10

.model tiny
.stack   28h
.data


    count       db 0
    image_file  db 'image.dat',0
    image       db 16*16 dup(0)
    image2_file  db 'image2.dat',0
    image2       db 16*16 dup(0)
    curve_file  db 'curve.dat',0
    curve       dw 1800 dup (0)
    curp        db 256*3 dup(0)
    pal_file    db 'pal.dat',0
    palcfg_file db 'palcfg.dat',0
    palcfg      db 3 dup(1)
    mw          db mwait
.code
.386
start:
        cli
        mov ax,@data
        mov ds,ax

        call load_files
        call set_13h_mode

        call set_colors

        mov     bp,0
loop_curve:

        mov     bx,bp
        call    show_all

        mov     dl,mw
        dec     dl
        cmp     dl,0
        jne     go_o

          mov     dl,mwait
          call    morph
go_o:
        mov     mw,dl
        CALL    mirror
        mov     bx,bp
        call    twait
        call    hide_all

        add     bp,speed
        cmp     bp,3600
        jne     ok5
        xor     bp,bp
ok5:
check_key:

        in      al,60h
        dec     al
        jz      exit
        jmp     loop_curve

exit:
        sti
        mov     ax,003h
        int     10h
        mov     ah,4ch
        int     21h

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;  Help Procedures ;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

morph proc
        xor     bx,bx
        mov     cx,16*16
m00:
        mov     al,[bx+image]
        mov     ah,[bx+image2]
        cmp     al,ah
        ja      do_dec
        jb      do_inc
        jmp     over2
do_dec:
        dec     al
        jmp     over2
do_inc:
        inc     al
over2:
        mov     [bx+image],al
        inc     bx
        loop    m00
        ret
endp


mirror proc
        mov     si,115*320
        mov     di,116*320
        push    ds
        push    es
        pop     ds
        mov     dh,0
  s0:
        mov     cx,80*2
do_mir:
        lodsw

        cmp     ax,0
        jne     chbo
          mov     al,mir_col
          mov     ah,mir_col
          stosw
          loop    do_mir
          sub     si,3*320
          inc     dh
          cmp     dh,50
          jne     s0
          pop     ds
          ret
  chbo:
        cmp     al,mir_col
        ja      cah
        mov     al,mir_col
  cah:
        cmp     ah,mir_col
        ja      plot
        mov     ah,mir_col
plot:   stosw
        loop    do_mir
        sub     si,3*320
        inc     dh
        cmp     dh,50
        jne     s0
        pop     ds
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
        cmp     di,120*320
        ja      qut
        cmp     si,16*16+offset image
        jne     loop_show
qut:
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
        cmp     di,120*320
        ja      qut2
        cmp     dl,16
        jne     loop_hide
qut2:
        ret
endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

twait proc
      pusha

  mov     dx,3dah
@l1:
  in      al,dx
  and     al,08h
  jnz     @l1
@l2:
  in      al,dx
  and     al,08h
  jz      @l2
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
       ; read in clock image2 :
       mov      ax,3d00h
       lea      dx,image2_file
       int      21h
       mov      bx,ax
       mov      ah,3fh
       mov      cx,16*16
       lea      dx,image2
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