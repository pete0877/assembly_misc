DOSSEG

slow     = 02222h
spped_p  = 6
back     = 10111111b
colof    = 70
fx       = 16
maxnum   = 6
speed    = 2*4
mir_col  = 30
dist     = 80
ofx      = 70
ofy      = 60
ofz_ok   = 50
npts     = 216
degx     = 8
degy     = 8
degz     = 4
COF      = 75
DEEP     = 1
SSUb     = 60
WHITE    = 128
BOR      = 60
START_OFZ = 3050
COFZ     = 20

TIME_2_CHANGE = 4000

;#################################################################

.model Compact
.stack   28h
.data
        ofz         dd START_OFZ
        time        dd 0
        done        db 1
        over        db 0
        fade        db 0
        bpt         dw 0
        count       db 0
        image_file  db 'image.dat',0
        curve_file  db 'curve.dat',0
        anx         dw 0
        any         dw 0
        anz         dw 0
        wpl         dw 0
        wll         dw 8
        adzn        dw 0
        font_file   db 'font.dat',0
                       ;12345678901234567890
        text        db 'BY 4TH DIMENSION...',0
                    db '        TIME INTRO ',0
        text2       db '                 '
                    DB 'HEY THERE ! THIS IS A LITTLE '
                    db 'INTRO TO OUR NEW COOL DEMO ... TIME ... COMING UP '
                    db 'SOON !     AND HERE ARE THE MEMBERS OF THE FOURTH '
                    db 'DIMENSION     '
                    db 'CODE AND DESIGN:REXER & EFRAN  '
                    db 'CYA LATER AND DONT MISS THE TIME                 ',0,0
  label pts0        dword
                c = -25
                rept 6
                        b = -35
                        rept 6
                                a = -35
                                rept 6
                                        dd a,b,c
                                        a = a + 10
                                endm
                                b = b + 10
                        endm
                        c = c + 10
                endm
        curp        db 256 dup(?)
        image       db 16*16 dup(?)
        stl         dw ?
        Xsin        dd ?
        Xcos        dd ?
        Ysin        dd ?
        Ycos        dd ?
        Zsin        dd ?
        Zcos        dd ?
        curve       dw 1801 dup (?)
        font        db 16*16*64 dup(?)
        font2        db 16*16*64 dup(?)
        pts         dd npts*3*4 dup(?)
        dels        dw npts*3*4 dup(?)
        border      db npts*3*4 dup (?)

.386
.code

include music.inc

;#################################################################

start: jmp over_proc

INCLUDE math.inc

over_proc:

        pushfd
        push    di
        push    si
        push    bp
        push    ds
        pushad
        push    es

        CALL    InitMusic               ; Initialize DemoVT lib.
        CALL    VTDisconnectTimer       ; Poll mode
        CALL    VTBeginSync
        CALL    VTWaitForStart

        pop     es
        popad
        pop     ds
        pop     bp
        pop     si
        pop     di
        popfd

        Call    Load_PCX_mid

        mov     ax,@data
        mov     ds,ax
        mov     gs,ax

        mov     bx,0
        mov     al,0
clear_cur_pal:
        mov     [bx+curp],al
        inc     bx
        cmp     bx,256
        jne     clear_cur_pal

        call    preset

l01:
        mov     di,0
l00:

; Rot ZZZ

        mov     bx,anz
        call    sin
        mov     Zsin,eax
        mov     bx,anz
        call    cos
        mov     Zcos,eax

        lea     si,pts0
        add     si,di
        call    RotateZ
        mov     eax,[di+pts0+8]
        mov     [di+pts+0],ebx
        mov     [di+pts+4],ecx
        mov     [di+pts+8],eax

; Rot YYY

        mov     bx,any
        call    sin
        mov     Ysin,eax
        mov     bx,any
        call    cos
        mov     Ycos,eax

        lea     si,pts
        add     si,di
        call    RotateY
        mov     [di+pts+0],ebx
        mov     [di+pts+8],ecx

        mov     ebx,[di+pts+0]
        mov     ecx,[di+pts+4]
        mov     esi,[di+pts+8]
        adc     ebx,ofx
        adc     ecx,ofy
        adc     esi,ofz
        mov     [di+pts+8],esi

        call    d32

        mov     al,WHITE
        mov     bp,WHITE
        cmp     ebx,BOR
        jb      no_black
        mov     al,0
        mov     bp,0
no_black:
        mov     [di+border],al

        mov     eax,320
        mul     ecx
        add     ebx,eax

        mov     eax,[di+pts+8]
        cmp     bp,WHITE
        je      do_w
         mov     cl,WHITE-50
         sub     cl,al
         mov     al,cl
         jmp     puton
        do_w:
         add    al,50
puton:
        mov     es:[ebx],al
        mov     [di+dels],bx

        add     di,3*4
        cmp     di,3*4*npts
jne     l00
        in      al,60h
        dec     al
        jnz     no_fade
        mov     al,1
        mov     [fade],al
no_fade:
        mov     al,[fade]
        cmp     al,1
        jne     no_exit

        call    fadec
        mov     al,[over]
        cmp     al,1
        je      exit
no_exit:
        mov     ax,anz
        add     ax,degz
        cmp     ax,1024
        jne     no_zero_angle_Z
        xor     ax,ax
no_zero_angle_Z:
        mov     anz,ax

        mov     ax,any
        add     ax,degy
        cmp     ax,1024
        jne     no_zero_angle_Y
        xor     ax,ax
no_zero_angle_Y:
        mov     any,ax

        mov     bp,ds:[bpt]
        call    do_rest
        mov     ds:[bpt],bp

        call    scroll

        call    twait

        call    erase


        mov     ax,@data
        mov     ds,ax

        mov     eax,ofz
        cmp     eax,ofz_ok
        je      no_ofz_change
        sub     eax,COFZ
        mov     ofz,eax
no_ofz_change:

        pushfd
        push di
        push si
        push bp
        push ds
        pushad
        push es

        CALL       CallMusic

        pop es
        popad
        pop  ds
        pop  bp
        pop  si
        pop  di
        popfd



jmp     l01

exit:
        sti
        mov     ax,003h
        int     10h

        mov     ah,4ch
        int     21h

;#################################################################
;#                       Help procedures                         #
;#################################################################

preset proc
        mov     ax,0013h
        int     10h
        mov     ax,0a000h
        mov     es,ax

        call    load_files
        call    set_colors

        mov     bp,21
        mov     stl,(15)*320
        call    put_text_on

        call    fill_screen
        mov     bp,0
        mov     stl,(200-30)*320
        call    put_text_on
        call    shadow


        ret
endp


fadec proc
        call    set_colors
        mov     bx,0
        mov     ah,1
 fade0:
        mov     al,[bx+curp]
        cmp     al,0
        jna     fade_next
         mov     ah,0
         dec     al
         mov     [bx+curp],al
fade_next:
        inc     bx
        cmp     bx,256
        jne     fade0
        mov     [over],ah
        ret
endp

scroll proc
        cmp     wll,fx
        jnz     skok
         mov    wll,0 ;*** new char
         mov    bx,wpl
         mov    dl,text2[bx]
         sub    dl,32
         mov    dh,0
         mov    ax,fx*fx
         mul    dx
         mov    adzn,ax  ;*** offset of the char in font
         inc    wpl
 skok:
        mov     si,17*320-fx
        mov     di,16*320-fx
        mov     cx,98
p1:     mov     bx,0

 p2:    mov     eax,dword ptr es:[si][bx]
        mov     es:[di][bx],eax
        add     bx,4
        cmp     bx,fx
        jnz     p2

        add     di,320
        add     si,320
        loop    p1
        mov     bx,0
        mov     si,adzn
        mov     dx,wll
        mov     ax,fx
        mul     dx
        add     si,ax
p3:     mov     al,font2[si][bx]
        mov     es:[(96+16)*320-fx][bx],al
        inc     bx
        cmp     bx,fx
        jnz     p3
        inc     wll
        mov     bx,wpl
        cmp     text2[bx],0
        je      back2start
        ret
back2start:
        push    ax
        mov     al,1
        mov     [fade],al
        pop     ax
        mov     bx,0
        mov     wpl,bx
        ret
scroll endp

do_rest proc
        mov     bx,bp
        mov     eax,time
        cmp     eax,TIME_2_CHANGE
        je      clean_up
        inc     eax
        mov     time,eax
        call    show_all
        jmp     over_clean_up
clean_up:
        mov     al,1
        mov     done,al
        call    clean_all
        mov     al,done
        cmp     al,1
        jne     over_clean_up
        xor     eax,eax
        mov     time,eax
over_clean_up:
        call    mirror
        mov     bx,bp
        add     bp,speed
        cmp     bp,3600
        jne     ok5
        xor     bp,bp
ok5:
        ret
endp

;#################################################################

Load_PCX_mid proc
        call LOAD_PCX
        ret
endp

;#################################################################

clean_all proc
        mov     cx,maxnum
clean_one:
        mov     di,word ptr [bx+curve]
        push    cx
        call    clean
        pop     cx
        mov     dx,dist
        cmp     bx,dx
        jnb     do_sub_c
        sub     dx,bx
        mov     bx,3600
 do_sub_c:
        sub     bx,dx
 ok6_c:
        loop    clean_one
        ret
endp

;#################################################################

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

;#################################################################

clean proc

        lea     si,image
        xor     cl,cl
 loop_clean:
        mov     al,es:[di]
        mov     ah,al
        lodsb
        cmp     al,0
        je      no_put_c_at_all
        cmp     ah,0
        je      no_put_c_at_all
        mov     al,0
        mov     done,al
        sub     ah,3
        jnc     no_put_c_at_all
        xor     ah,ah
no_put_c_at_all:
        mov     al,ah
        stosb

        inc     cl
        cmp     cl,16
        jne     loop_clean
        xor     cl,cl
        add     di,320-16
        cmp     si,16*16+offset image
        jne     loop_clean

        ret
endp

;#################################################################

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

;#################################################################

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

;#################################################################

;  Three 2 Two Dimention
;  in: ebx - x
;      ecx - y
;      esi - z
;  out: ebx : screen x
;       ecx : screen y
d32 proc
                mov     eax,200                  ; x*200\z+200 = x
                imul    ebx
                add     esi,200
                idiv    esi
                mov     ebx,eax

                mov     eax,200                  ; y*200\z+200 = y
                imul    ecx
                idiv    si
                mov     ecx,eax
        ret
endp

;#################################################################

shadow proc
        mov     ax,stl
        mov     si,ax
        add     si,15*320
        mov     di,ax
        add     di,16*320
        push    ds
        push    es
        pop     ds
        push    ax
        mov     al,0
  s0x:
        mov     cx,80
        rep     movsd
        sub     si,3*320
        inc     al
        cmp     al,8
        jne     s0x

        pop     bx
        push    bx

        add     bx,16*320
  s1:
        mov     al,ds:[bx]
        cmp     al,0
        jna     snext
        sub     al,1
        mov     ds:[bx],al
  snext:
        inc     bx
        pop     ax
        push    ax
        add     ax,(16+8)*320
        cmp     bx,ax
        jne     s1

        pop     AX
        pop     ds

        ret
endp

;#################################################################

put_text_on proc
        mov     bx,ds:[stl]
 put_chars:
        mov     al,ds:[text+bp]
        sub     al,32
        xor     ah,ah
        mov     cx,16*16
        mul     cx
        mov     si,ax
        add     si,offset font
        mov     di,bx
        mov     dl,0
  put_char_lines:
        mov     cx,4
        rep     movsd
        add     di,320-16
        inc     dl
        cmp     dl,16
        jne     put_char_lines

        ;next char:
        inc     bp
        mov     al,0
        cmp     al,ds:[text+bp]
        je      done_text_put
        add     bx,16
        jmp     put_chars

 done_text_put:
        inc     bp
        ret
endp

;#################################################################

fill_screen proc
        mov     dx,0
        mov     ah,WHITE
lines:
        mov     bx,dx
        add     dx,320
        mov     cl,BOR
        cmp     dx,100*320
        jb      fillone
        add     ah,8
  fillone:
        mov     es:[bx],ah
        inc     bx
        dec     cl
        cmp     cl,0
        jne     fillone
        mov     cx,0FFFFh
here1:  loop    here1
        call    twait

        pushfd
        push di
        push si
        push bp
        push ds
        pushad
        push es

        CALL       CallMusic

        pop es
        popad
        pop  ds
        pop  bp
        pop  si
        pop  di
        popfd


        cmp     dx,(115)*320
        jne     lines
        ret
endp

;#################################################################

erase proc
        xor     si,si
e01:
        mov     di,[si+dels]
        mov     al,[si+border]
        stosb
        add     si,3*4
        cmp     si,3*4*npts
        jne     e01
        ret
endp

;#################################################################

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

;#################################################################

set_colors proc
        mov     cx,1
        mov     dx,3C8H
        mov     bx,0
L1:
        mov     al,cl
        out     dx,al
        inc     dx

        mov     al,[bx+curp]
        out     dx,al

        mov     al,[bx+curp]
        out     dx,al

        mov     al,[bx+curp]
        out     dx,al

        inc     bx

        dec     dx
        inc     cx
        cmp     cx,256
        jb      l1
        ret
endp

;#################################################################

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

       ; read in font
       mov      ax,3d00h
       lea      dx,font_file
       int      21h
       mov      bx,ax
       mov      ah,3fh
       mov      cx,16384
       lea      dx,font
       int      21h
       mov      ah,3eh
       int      21h

       ; format font:
       mov      bx,0
form_font:
       mov      cl,0
       mov      al,[bx+font]
       cmp      al,0
       je       nomore
       mov      cl,8
       mul      cl
       mov      cl,255
       sub      cl,al
nomore:
       mov      [bx+font],cl
       inc      bx
       cmp      bx,16384
       jne form_font

       ;create another 16 x 16 font :
       xor      bx,bx
char16:
       mov      al,[bx+font]
       add      al,colof
       mov      [bx+font2],al
       inc      bx
       cmp      bx,16384
       jne      char16

       ; create pallete :
       mov      bx,0
       mov      al,0
ccc:
       mov      [bx+curp+1],al
       inc      bx
       mov      [bx+curp+3],al
       inc      bx
       inc      al
       cmp      al,63
       jne      ccc
ccc2:
       mov      [bx+curp],al
       inc      bx
       mov      [bx+curp],al
       inc      bx
       dec      al
       cmp      al,0
       jne      ccc2
       ret
endp

INCLUDE  pcx2.inc

end start

;#################################################################
;#################################################################
