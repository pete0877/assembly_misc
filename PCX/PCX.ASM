SLOW = 02222h
SPEED = 6
DOSSEG

.model tiny
.data
      fname        db "4thD.pcx",0
      file_err_mgs db "Error occured while accessing the image file !!! $"
      full_pal     db 768 dup (?)
      cur_pal      db 768 dup (?)
      img          db 36000 dup (?)
.stack  512
.code
.386
Main:
      mov     ax,0013h
      int     10h
      mov     ax,@data
      mov     ds,ax

      lea     dx,fname   ; open file
      mov     ax,3d00h
      int     21h
      jnc     no_error0
      jmp     file_error
no_error0:
      mov     bx,ax

      mov     ax,4202h   ; move to the end of file
      mov     cx,0
      mov     dx,0
      int     21h
      jnc     no_error1
      jmp     file_error
no_error1:
      mov     di,ax      ; size of the file

      mov     ax,4200h   ; move to the begining + 128
      mov     cx,0
      mov     dx,128
      int     21h
      jnc     no_error2
      jmp     file_error
no_error2:

      mov     ax,3f00h ; read in the image data
      mov     cx,di
      sub     cx,768+128
      lea     dx,img
      int     21h
      jnc     no_error3
      jmp     file_error
no_error3:

      mov     ax,3f00h ; read in the pallete
      mov     cx,768
      lea     dx,full_pal
      int     21h
      jnc     no_error4
      jmp     file_error
no_error4:

      mov     ax,3e00h   ; close file
      int     21h
      jnc     no_error5
      jmp     file_error
no_error5:

      call    clear_pallete
      call    set_pallete

      ; decode the image data:
      mov     si,di
      ; si = size of the file - 128 - 768 + offset of img
      add     si,(offset img) - 128 - 768
      lea     bx,img
      mov     di,0
      mov     ax,0a000h
      mov     es,ax
main_decode_loop:
      mov     al,[bx]
      mov     ah,al
      and     al,192
      cmp     al,192
      jne     l00
        inc     bx
        mov     cl,[bx]
        mov     ch,ah
        and     ch,63
        mov     dl,0
l02:
        inc     dl
        mov     es:[di],cl
        inc     di
        cmp     dl,ch
        jne     l02
      jmp     l01
l00:
        mov     es:[di],ah
        inc     di
l01:
      inc     bx
      cmp     bx,si
      jne     main_decode_loop

      call    light_up
      call    wait_for_ESC
      call    dark_down

exit:
      mov     ax,3
      int     10h
      mov     ax,4c00h
      int     21h
file_error:
      mov     ax,3
      int     10h
      lea     dx,file_err_mgs
      mov     ah,9
      int     21h
      call    wait_for_ESC
      jmp     exit

;############################################################
;                H e l p    F u n c t i o n s :
;############################################################

light_up proc
      mov     di,0
ll06:
      lea     bx,cur_pal
      lea     si,full_pal
      mov     al,1
      inc     di
      cmp     di,SPEED
      jne     no_sync
       xor     di,di
       call    sync_wait
      no_sync:
      mov     cx,768
ll10:
      mov     ah,[bx]
      mov     dh,[si]
      cmp     ah,dh
      je      no_inc
      inc     ah
      mov     [bx],ah
      mov     al,0
no_inc:
      inc     bx
      inc     si
      loop    ll10
      call    set_pallete
      cmp     al,0
      je      ll06
      ret
endp

dark_down proc
      mov     di,0
l06:
      lea     bx,cur_pal
      mov     al,1
      inc     di
      cmp     di,SPEED
      jne     no_sync2
       xor     di,di
       call    sync_wait
      no_sync2:
      mov     cx,768
l10:
      mov     ah,[bx]
      cmp     ah,0
      jna     no_dec
      dec     ah
      mov     [bx],ah
      mov     al,0
no_dec:
      inc     bx
      loop    l10
      call    set_pallete
      cmp     al,0
      je      l06
      ret
endp

time_wait proc
      push   ax
      push   cx
      mov    ax,1
l08:
      mov    cx,SLOW
l09:  loop   l09
      dec    ax
      cmp    ax,0
      jne    l08
      pop    cx
      pop    ax
      ret
endp

wait_for_ESC:
      in      al,60h
      cmp     al,1
      jne     wait_for_ESC
      ret
endp

clear_pallete proc
      lea     bx,cur_pal
      mov     al,0
      mov     cx,768
l05:  mov     [bx],al
      add     bx,1
      loop    l05
      ret
endp

set_pallete proc
      push    di
      pushad

      mov     bx,0
      mov     dx,3c8h
      lea     di,cur_pal
l04:
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
      jb      l04

      popad
      pop     di
      ret
endp

sync_wait proc
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

end Main




