SLOW_p  = 0FFFFh
SPEED_p = 6
WAIT_TIME_IS = 3250

jmp over_pcx1
      fname        db "4thD.pcx",0
      full_pal     db 768 dup (?)
      cur_pal      db 768 dup (?)
      img          db 36000 dup (?)
over_pcx1:

LOAD_PCX proc
      push    ds

      mov     ax,0013h
      int     10h
      mov     ax,0a000h
      mov     es,ax

      mov     ax,cs
      mov     ds,ax

      lea     dx,fname   ; open file
      mov     ax,3d00h
      int     21h
      mov     bx,ax

      mov     ax,4202h   ; move to the end of file
      mov     cx,0
      mov     dx,0
      int     21h
      mov     di,ax      ; size of the file

      mov     ax,4200h   ; move to the begining + 128
      mov     cx,0
      mov     dx,128
      int     21h

      mov     ax,3f00h ; read in the image data
      mov     cx,di
      sub     cx,768+128
      lea     dx,img
      int     21h

      mov     ax,3f00h ; read in the pallete
      mov     cx,768
      lea     dx,full_pal
      int     21h

      mov     ax,3e00h   ; close file
      int     21h

      call    clear_palleteP
      call    set_palleteP

      ; decode the image data:
      mov     si,di
      ; si = size of the file - 128 - 768 + offset of img
      add     si,(offset img) - 128 - 768
      lea     bx,img
      mov     di,0
      mov     ax,0a000h
      mov     es,ax
main_decode_loopP:
      mov     al,[bx]
      mov     ah,al
      and     al,192
      cmp     al,192
      jne     l00P
        inc     bx
        mov     cl,[bx]
        mov     ch,ah
        and     ch,63
        mov     dl,0
l02P:
        inc     dl
        mov     es:[di],cl
        inc     di
        cmp     dl,ch
        jne     l02P
      jmp     l01P
l00P:
        mov     es:[di],ah
        inc     di
l01P:
      inc     bx
      cmp     bx,si
      jne     main_decode_loopP

      call    light_upP
      call    wait_a_secP
      call    dark_downP

exitP:
      pop     ds
      ret
endp

light_upP proc
      mov     di,0
ll06P:
      lea     bx,cur_pal
      lea     si,full_pal
      mov     al,1
      inc     di
      cmp     di,SPEED
      jne     no_sync
       xor     di,di
       call    sync_waitP
      no_sync:
      mov     cx,768
ll10P:
      mov     ah,[bx]
      mov     dh,[si]
      cmp     ah,dh
      je      no_incP
      inc     ah
      mov     [bx],ah
      mov     al,0
no_incP:
      inc     bx
      inc     si
      loop    ll10P

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

      call    set_palleteP
      cmp     al,0
      je      ll06P
      ret
endp

dark_downP proc
      mov     di,0
l06P:
      lea     bx,cur_pal
      mov     al,1
      inc     di
      cmp     di,SPEED
      jne     no_sync2
       xor     di,di
       call    sync_waitP
      no_sync2:
      mov     cx,768
l10P:
      mov     ah,[bx]
      cmp     ah,0
      jna     no_decP
      dec     ah
      mov     [bx],ah
      mov     al,0
no_decP:
      inc     bx
      loop    l10P

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

      call    set_palleteP
      cmp     al,0
      je      l06P
      ret
endp

wait_a_secP proc
      push   ax
      push   cx
      mov    ax,WAIT_TIME_IS
l08P:
      mov    cx,SLOW_P
l09P:  loop   l09P

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



      dec    ax
      cmp    ax,0
      jne    l08P
      pop    cx
      pop    ax
      ret
endp

wait_for_ESCP PROC

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

      in      al,60h
      cmp     al,1
      jne     wait_for_ESCP
      ret
endp

clear_palleteP proc
      lea     bx,cur_pal
      mov     al,0
      mov     cx,768
l05P:  mov     [bx],al
      add     bx,1
      loop    l05P
      ret
endp

set_palleteP proc

        pusha

        mov     cx,0
        mov     dx,3C8H
        mov     bx,0
L1pp:
        mov     al,cl
        out     dx,al
        inc     dx

        mov     al,[bx+cur_pal]
        shr     al,1
        shr     al,1
        out     dx,al

        mov     al,[bx+cur_pal+1]
        shr     al,1
        shr     al,1
        out     dx,al

        mov     al,[bx+cur_pal+2]
        shr     al,1
        shr     al,1
        out     dx,al

        add     bx,3

        dec     dx
        inc     cx
        cmp     cx,256
        jb      l1pp

        popa
        ret

      mov     bx,0
      mov     dx,3c8h
      lea     di,cur_pal
l04P:
      mov     al,bl
      out     dx,al
      inc     dx
      mov     al,ds:[di]
      shr     al,1
      shr     al,1
      out     dx,al
      mov     al,ds:[di+1]
      shr     al,1
      shr     al,1
      out     dx,al
      mov     al,ds:[di+2]
      shr     al,1
      shr     al,1
      out     dx,al
      dec     dx
      add     di,3
      inc     bl
      cmp     bl,255
      jb      l04P

endp

sync_waitP proc
      pusha
      mov  dx,03dah
zP:    in   al,dx
      mov  ah,8
      and  al,ah
      cmp  al,0
      je   zP

z2P:    in   al,dx
      mov  ah,8
      and  al,ah
      cmp  al,0
      jne   z2P

      popa
      ret
endp



