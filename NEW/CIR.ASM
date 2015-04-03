x0=160
y0=100
z0=-50
ofx  = 160
ofy  = 100
ofz  = 40
npts = 20 * 30
.model Compact
.stack   28h
.data
      Xsin      dd ?
      Xcos      dd ?
      Ysin      dd ?
      Ycos      dd ?
      Zsin      dd ?
      Zcos      dd ?

      curp      db 256 dup(?)
      pal_file  db 'pal.dat',0
      cir_file  db 'cir.dat',0
      pts0      dd 3*20 dup (?)

dels      dw npts*3*4 dup(0)

.code
.386
start: jmp over_proc

over_proc:
        mov     ax,@data
        mov     ds,ax
        mov     gs,ax

        mov     ax,0013h
        int     10h
        mov     ax,0a000h
        mov     es,ax

        call    load_files
        call    set_colors

l01:
        mov     di,0
l00:

        mov     ebx,[di+pts0+0]
        mov     ecx,[di+pts0+4]
        mov     esi,[di+pts0+8]

        call    d32

        mov     eax,320
        mul     ecx
        add     ebx,eax

        mov     eax,3
        mov     es:[ebx],al
        mov     [di+dels],bx

        add     di,3*4
        cmp     di,3*4*npts
jne     l00
        in      al,60h
        dec     al
        jz      exit

        call    twait

        call    erase

jmp     l01

exit:
        mov     ax,003h
        int     10h
        mov     ah,4ch
        int     21h

;#################################################################

;  Three 2 Two Dimention
;  in: ebx - x
;      ecx - y
;      esi - z
;  out: ebx : screen x
;       ecx : screen y
;  x0=160
;  y0=100
;  z0=-50
d32 proc
        sub     ebx,x0
        sub     ecx,y0
        sub     esi,z0

        mov     eax,z0
        imul    ebx
        idiv    esi
        mov     ebx,x0
        sub     ebx,eax

        mov     eax,z0
        imul    ecx
        idiv    esi
        mov     ecx,y0
        sub     ecx,eax
        ret
endp

erase proc
        xor     si,si
        xor     al,al
  e01:
        mov     di,[si+dels]
        stosb
        add     si,3*4
        cmp     si,3*4*npts
        jne     e01
        ret
endp

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

        mov     al,0
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

load_files proc
       ; read in pal file
       mov      ax,3d00h
       lea      dx,pal_file
       int      21h
       mov      bx,ax
       mov      ah,3fh
       mov      cx,256
       lea      dx,curp
       int      21h
       mov      ah,3eh
       int      21h
       ; read in cir file
       mov      ax,3d00h
       lea      dx,cir_file
       int      21h
       mov      bx,ax
       mov      ah,3fh
       mov      cx,3*4*20
       lea      dx,pts0
       int      21h
       mov      ah,3eh
       int      21h
       ret
endp

end start