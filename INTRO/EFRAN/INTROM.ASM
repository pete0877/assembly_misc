.286
.Model Small
.Stack 200h

Jumps
.Code

        _StartLoc:

        Assume CS:@Code

        FALSE = 0
        TRUE = 1

        MaxStars = 300                                  ;It would be enough!
        VRAMSeg = 0A000h                                ;VGA Segment
        MaxZ =  256                                     ;"Camera" max view
        MinZ = 0                                        ;"Camera" min view
        StarSize = 6                                    ;3 Words = 6 Bytes
        Escape = 1                                      ;ESC Bios scan code
        FADE_Offs = 1 ;31
        CircMotionNum = 495
        MotionSpeed = 1;1

        SKIPINT1ACALL = TRUE                            ;Fix the overflow bug
        FValue_1 = 4628                                 ;Value for RNG
        FValue_2 = 5120                                 ;"           "

        WaitVR MACRO                                    ;Wait for vertical
        Local VR, NoVR                                  ;retrace macro
                Mov     dx, 3DAh
               VR:
                In      al, dx
                Test    al, 8
                Jnz     VR
               NoVR:
                In      al, dx
                Test    al, 8
                Jz      NoVR
               ENDM

        ClearKBDBuf MACRO
                Mov     ah, 0
                Int     16h
                    ENDM

;/////////////////////////////
;DATA
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

        Star STRUC
                X dw 0
                Y dw 0
                Z dw 0
        Star ENDS

        Stars dw MaxStars dup(Star)                     ;Array for the stars

        Param_1 dw 31FFh                                ;Param. used by RNG
        Param_2 dw 89C0h                                ;"                "
        Param_3 dw 5F8Bh                                ;"                "

       BG_Palette Label Byte
         db 0,0,0
          db 63, 63, 63
        a = 60
         rept 15
          db a, a, a
          a = a - 4
         endm
        Bug db 500 dup(0,0,0);

        TimeCounter dw 0

        XOffset dw 160                                  ;Origin for stars
        YOffset dw 13                                   ;Origin for stars
        Speed db 2
        VScreen dw ?

        CircMotion Label Word
         Include CIRCLE.INC

        CurrMotionVal dw ?

        MSG_1 db 'Time Intro Ä Copyright (c) 1997 by 4th Dimension',10,13
              db ' þ Efran''s Page Ä Beta Release',10,13
              db 10,13
              db ' þ Code by Efran',10,13
              db ' þ Graphics by Move',10,13
              db 10,13
              db 'press a key to enter the 4thD universe...',10,13,'$'

        MSG_2 db ' ThanX for watching our Intro...',13,10
              db '                                     4thD Stuff',13,10
              db 13,10,'$'


        NOMEM_MSG db 'Not enough memory!',13,10,'$'

;/////////////////////////////
;Codice ausiliario
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

        Randomize PROC
               IFNDEF SKIPINT1ACALL
                Mov     ah, 2                           ;Get Time function
                Int     1ah                             ;Call TIME INT
               ENDIF
               IFDEF SKIPINT1ACALL
                Mov     cx, FValue_1                    ;Move fixed values
                Mov     dx, FValue_2                    ;to cx & dx...
               ENDIF
                Mov     [Param_1], cx                   ;Store cx & dx values
                Mov     [Param_2], dx                   ;in my parameters...
                Ret
        Randomize ENDP

        Random PROC
                Push    ax
                Call    RandomAux
                Xor     ax, ax
                Pop     bx
                Shl     bx, 3
                Or      bx, bx
                Jz      Random_End
                Xchg    dx, ax
                IDiv     bx
                Xchg    dx, ax
               Random_End:
                Shr     ax, 3
                Ret
        Random ENDP

        RandomAux PROC
                Mov     ax, Param_1
                Mov     bx, Param_2
                Mov     cx, ax
                Mul     Param_3
                Shl     cx, 3
                Add     ch, cl
                Add     dx, cx
                Add     dx, bx
                Shl     bx, 2
                Add     dx, bx
                Add     dh, bl
                Shl     bx, 5
                Add     dh, bl
                Inc     ax
                Adc     dx, 00
                Mov     Param_1, ax
                Mov     Param_2, dx
                Ret
        RandomAux ENDP

        GraphMode MACRO
                Mov     ax, 13h
                Int     10h
                  ENDM

        TextMode MACRO
                Mov     ax, 3
                Int     10h
                 ENDM

        SavePalette PROC                                ;Req. ES:DX => Pal
                Mov     ax,1017h
                Mov     bx,0
                Mov     cx,255
                Int     10h                             ;Int 10h function
                Ret
        SavePalette ENDP

        LoadPalette MACRO Palette
                Push    @Code
                Pop     ds
                Mov     si, Offset Palette
                Mov     dx, 3c8h
                Xor     al, al
                Out     dx, al
                Mov     dx, 3c9h
                Mov     cx, 768
                RepZ    OutsB
                    ENDM

        CheckStars PROC
                Xor     si, si                          ;SI => The 1st star
               ChkLoop:
                Mov     ax, Word Ptr [Stars.z + si]     ;ax = Z
                Cmp     ax, MinZ                        ;If ax =< MinZ...
                Jbe     CreateNew                       ;...then jump there!
                Add     si, StarSize                    ;SI => The next one
                Cmp     si, MaxStars * StarSize         ;End reached?
                Jae     Done                            ;If yes jump there!
                Jmp     ChkLoop                         ;Keep on checking...
               CreateNew:
                Mov     ax, 320
                Call    Random                          ;ax = Random(320)
                Sub     ax, 160                         ;ax = [-160..160]
                Mov     Word Ptr [Stars.x + si], ax     ;X = ax
                Mov     ax, 200
                Call    Random                          ;ax = Random(200)
                Sub     ax, 100                         ;ax = [-100..100]
                Mov     Word Ptr [Stars.y + si], ax     ;Y = ax
                Mov     Word Ptr [Stars.z + si], MaxZ   ;Z = MaxZ
                Add     si, StarSize                    ;SI => The next one
                Cmp     si, MaxStars * StarSize         ;End reached?
                Jb      ChkLoop                         ;If no jump there!
               Done:
                Ret
        CheckStars ENDP

        InitStars PROC
                Xor     si, si                          ;SI => The 1st star
               InitLoop:
                Mov     ax, 320
                Call    Random                          ;ax = Random(320)
                Sub     ax, 160                         ;ax = [-160..160]
                Mov     Word Ptr [Stars.x + si], ax     ;X = ax
                Mov     ax, 200
                Call    Random                          ;ax = Random(200)
                Sub     ax, 100                         ;ax = [-100..100]
                Mov     Word Ptr [Stars.y + si], ax     ;Y = ax
                Mov     ax, MaxZ - 1
                Call    Random                          ;ax = Random(MaxZ-1)
                Inc     ax                              ;ax = [MinZ+1..MaxZ]
                Mov     Word Ptr [Stars.z + si], ax     ;Z = ax
                Add     si, StarSize                    ;SI => The next star
                Cmp     si, MaxStars * StarSize         ;End reached?
                Jb      InitLoop                        ;If no then continue
                Ret
        InitStars ENDP

        ViewStars PROC
                Push    VSeg
                Pop     es
                Xor     si, si                          ;SI => 1st star
               ViewLoop:
                Mov     cx, [Stars.Z+si]                ;cx = z
                Mov     ax, [Stars.X+si]                ;ax = x
.386
                Movsx   dx, ah
.286
                Shl     ax, 8                           ;ax = ax*256
                Idiv    cx                              ;ax = ax/cx
                Add     ax, XOffset
                Mov     di, ax                          ;di = EA(x)
                Cmp     di, 319                         ;Checking the star...
                Jae     KillStar
                Cmp     di, 0
                Jb      KillStar
                Mov     ax,[Stars.Y+si]                 ;ax = y
.386
                Movsx   dx, ah
.286
                Shl     ax, 8                           ;ax = ax*256
                Idiv    cx                              ;ax = ax/cx
                Add     ax, YOffset                     ;ax = EA(y)
                Cmp     ax, 200
                Jae     KillStar                        ;Checking the star...
                Cmp     ax, 1
                Jb      KillStar
               InRange:
                Mov     bx, ax
                Shl     bx, 8
                Shl     ax, 6
                Add     ax, bx                          ;ax = ax*320
                Add     di, ax
                Add     di, VScreen              ;di = EA(x:y)
                Shr     cx, 4                           ;cx = cx/16
                Cmp     Byte Ptr ES:[di],0              ;is x:y black?
                Jne     Inviso                          ;If no don't show
                Add     cl, FADE_Offs                   ;Add offset of fade
                Mov     byte ptr es:[di], cl            ;Show the star
               Inviso:
                Xor     ah, ah
                Mov     al, Speed
                Sub     [Stars.Z+si], ax                ;z = z - Speed
                Jmp     Continue                        ;Continue
               KillStar:
                Mov     [Stars.Z+si], MinZ              ;Kill the star!
               Continue:
                Add     si, StarSize                    ;si => the next one
                Cmp     si, StarSize*MaxStars           ;End reached?
                Jb      ViewLoop                        ;If no jump there!
                Ret
        ViewStars ENDP

        Write PROC
                push    ds
                mov     ah, 9
                push    @Code
                pop     ds
                Mov     bp, sp
                Mov     dx, [bp + 4]                    ;Get the offset of
                                                        ;the string...
                int     21h                             ;Write to the screen
                pop     ds
                ret     2
        Write ENDP

        InitTimeCounter PROC
                Xor     ah, ah
                Int     1Ah
                Mov     TimeCounter, dx
                Ret
        InitTimeCounter ENDP

        CheckTime MACRO TicksToWait, Location
                Xor     ah, ah
                Int     1Ah
.386
                Mov     ax, TimeCounter
                Sub     dx, ax
                Cmp     dx, TicksToWait
                Jae     Location
.286
                  ENDM

        CheckTimeCall MACRO TicksToWait, Location
                Xor     ah, ah
                Int     1Ah
.386
                Mov     ax, TimeCounter
                Sub     dx, ax
                Cmp     dx, TicksToWait
                Call    Location
.286
                  ENDM


START:
        Mov     ax, @Code
        Mov     es, ax
        Mov     bx, (Offset _EndLoc - Offset _StartLoc + 512) / 16 + 1
        Mov     ax, 4A00h
        Int     21h
        Jc     @@ResizeOK_1

        Push    Offset NOMEM_MSG
        Call    Write
        Mov     ax, 4c01h
        Int     21h

@@ResizeOK_1:
        Mov     ax, VSeg
        Mov     es, ax
        Mov     bx, 64000/16
        Mov     ax, 4A00h
        Int     21h
        Jc     @@ResizeOK_2

        Push    Offset NOMEM_MSG
        Call    Write
        Mov     ax, 4c01h
        Int     21h

@@ResizeOK_2:

        Push    Offset MSG_1
        Call    Write
        ClearKBDBuf                                     ;Wait for a key...

        GraphMode                                       ;Video at 320x200x256
        Call    Randomize                               ;Init Random Number
                                                        ;Generator (RNG)
        LoadPalette BG_Palette                          ;Load the palette
        Call    InitStars                               ;Init the stars
        Call    InitTimeCounter                         ;Store current time


;///////////////////////////////////////
       StarField:
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
        Push    VSeg
        Pop     es
        Mov     di,  VScreen
        Mov     cx, 320*200/4
        Xor     ax, ax
.386
        Rep     StosD
.286
        Call    ViewStars                               ;Show the stars

        Push    VRAMSeg
        Pop     es
        Push    VSeg
        Pop     ds
        Xor     di, di                                  ;ES:DI => VRAM
        Mov     si,  VScreen                      ;DS:SI => VScreen
        Mov     cx, 16000                               ;64000/4
        WaitVR                                          ;Wait for V Retrace
.386
        Rep     MovsD                                   ;VRAM^ := VScreen^
.286
        Call    CheckStars                              ;Check stars value

        CheckTime 91,  MoveStarSourceByCircle           ;10 secs. * 18.2 = 182

        In      al, 60h                                 ;Keypressed?
        Cmp     al, Escape                              ;Is it ESC?
        Jne     StarField                               ;If no then continue
        Jmp     StarFieldEnd                            ;Else END...

;///////////////////////////////////////
       MoveStarSourceByCircle:
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

        Push    VSeg
        Pop     es
        Mov     di, VScreen
        Mov     cx, 320*200/4
        Xor     ax, ax
.386
        Rep     StosD
.286
        Call    ViewStars                               ;Show the stars

        Push    VRAMSeg
        Pop     es
        Push    VSeg
        Pop     ds
        Xor     di, di                                  ;ES:DI => VRAM
        Mov     si, VScreen                      ;DS:SI => VScreen
        Mov     cx, 16000                               ;64000/4
        WaitVR                                          ;Wait for V Retrace
.386
        Rep     MovsD                                   ;VRAM^ := VScreen^
.286
        Call    CheckStars                              ;Check stars value

        Mov     di, [CurrMotionVal]
        Mov     ax, [CircMotion + di]
        Mov     bx, [CircMotion + di + 2]
        Add     [CurrMotionVal], 4 * MotionSpeed
        Cmp     di, CircMotionNum * 4
        Jb      MotValInRange
        Mov     [CurrMotionVal], 0
       MotValInRange:
        Mov     [XOffset], ax
        Mov     [YOffset], bx

        In      al, 60h                                 ;Keypressed?
        Cmp     al, Escape                              ;Is it ESC?
        Jne     StarField                      ;If no then continue
        Jmp     StarFieldEnd                            ;Else END...


;///////////////////////////////
       StarFieldEnd:
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

;///////////////////////////////
       BlastAnimEnd:
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

        ClearKBDBuf                                     ;Clear '\' from key-
                                                        ;board buffer...
        TextMode                                        ;Video at Text res.

        Push    Offset MSG_2
        Call    Write

        Mov     ax, 4C00h                               ;Error code = 0
        Int     21h                                     ;The End...

;-------------------------------
_EndLoc:

VSeg SEGMENT PARA PUBLIC
VSeg ENDS

END START
