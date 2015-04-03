uses crt;
label l000;
var dn,ddx,ddy,x2,y2,a,b,c,an,dyx,d0,xk2,yk2:integer;
    dxr,dy,xn,yn,n,x,y,x0,y0,xk,yk,cc,xs,d,dl,pocz,co:byte;
    ang:array[0..359,0..1] of byte;
    t:array[0..200,0..150] of byte;
    his:array[1..50,1..100] of byte;
    ceg:array[0..49,0..49] of byte;
    tt:array[1..5,1..2] of byte;
    ns:array[0..50,0..50] of byte;
    r:real;
    z:char;

procedure l;
label end1,ok1,lcc1;
label end2,ok2,lcc2;
label end3,ok3,lcc3;
label end4,ok4,lcc4;
label end5,ok5,lcc5;
label end6,ok6,lcc6;
label end7,ok7,lcc7;
label end8,ok8,lcc8;
label end9,ok9,lcc9;
label end10,ok10,lcc10;
label end11,ok11,lcc11;
label end12,ok12,lcc12;

{label jn1,sec1,nosec1,exi1;}
begin
     dxr:=xk-x0;
     dy:=yk-y0;
     xn:=x0;
     yn:=y0;
if (b=0) or (b=90) or (b=180) or (b=270) then
begin
     case b of
          0 : begin
                   n:=x0;
                   repeat inc(n) until (n=xk) or (t[n,y0]<>0);
     if t[n,y0]=0 then n:=49 else n:=abs(x0-n);
     asm
        mov ax,0a000h
        mov es,ax

        mov cl,n
        add cl,y
        sub cl,y0

        cmp cl,50
        jb ok9
        mov cl,50
        ok9:
        mov al,x
        mov dl,151
        mul dl
        mov bl,y
        xor bh,bh
        add bx,ax
        lea si,t
        mov dl,ds:si[bx]
        cmp dl,0
        je end9;
        xor ch,ch
        dec cl
        dec ch
        lcc9:
             inc ch
{        ; cl - n - 1
        ; dl - co
        ; ch - cc - 1}
          mov al,100
          mul cl
          mov bl,ch
          xor bh,bh
          add bx,ax
          lea si,his
          mov dh,ds:si[bx]
{          ; dh - his[]}
          mov al,50
          mul dl
          mov bl,dh
          xor bh,bh
          add bx,ax
          lea si,ceg
          add si,bx
          mov bl,ds:[si]
{          ; bl - kolor}
          push dx
          push bx
          mov dl,ch
          xor dh,dh
          mov ax,320
          mul dx
          mov bl,xs
          xor bh,bh
          add ax,bx
          mov di,ax
          pop bx
          pop dx
          mov es:[di],bl
             cmp ch,100
        jne lcc9
        end9:
     end;
              end;
         90 : begin
                   n:=y0;
                   repeat inc(n) until (n=yk) or (t[x0,n]<>0);
     if t[x0,n]=0 then n:=49 else n:=abs(y0-n);
     asm
        mov ax,0a000h
        mov es,ax

        mov cl,n
        add cl,y
        sub cl,y0

        cmp cl,50
        jb ok10
        mov cl,50
        ok10:
        mov al,x
        mov dl,151
        mul dl
        mov bl,y
        xor bh,bh
        add bx,ax
        lea si,t
        mov dl,ds:si[bx]
        cmp dl,0
        je end10;
        xor ch,ch
        dec cl
        dec ch
        lcc10:
             inc ch
{        ; cl - n - 1
        ; dl - co
        ; ch - cc - 1}
          mov al,100
          mul cl
          mov bl,ch
          xor bh,bh
          add bx,ax
          lea si,his
          mov dh,ds:si[bx]
{          ; dh - his[]}
          mov al,50
          mul dl
          mov bl,dh
          xor bh,bh
          add bx,ax
          lea si,ceg
          add si,bx
          mov bl,ds:[si]
{          ; bl - kolor}
          push dx
          push bx
          mov dl,ch
          xor dh,dh
          mov ax,320
          mul dx
          mov bl,xs
          xor bh,bh
          add ax,bx
          mov di,ax
          pop bx
          pop dx
          mov es:[di],bl
             cmp ch,100
        jne lcc10
        end10:
     end;
              end;
        180 : begin
                   n:=x0;
                   repeat dec(n) until (n=xk) or (t[n,y0]<>0);
     if t[n,y0]=0 then n:=49 else n:=abs(x0-n);
     asm
        mov ax,0a000h
        mov es,ax

        mov cl,n
        add cl,y
        sub cl,y0

        cmp cl,50
        jb ok11
        mov cl,50
        ok11:
        mov al,x
        mov dl,151
        mul dl
        mov bl,y
        xor bh,bh
        add bx,ax
        lea si,t
        mov dl,ds:si[bx]
        cmp dl,0
        je end11;
        xor ch,ch
        dec cl
        dec ch
        lcc11:
             inc ch
{        ; cl - n - 1
        ; dl - co
        ; ch - cc - 1}
          mov al,100
          mul cl
          mov bl,ch
          xor bh,bh
          add bx,ax
          lea si,his
          mov dh,ds:si[bx]
{          ; dh - his[]}
          mov al,50
          mul dl
          mov bl,dh
          xor bh,bh
          add bx,ax
          lea si,ceg
          add si,bx
          mov bl,ds:[si]
{          ; bl - kolor}
          push dx
          push bx
          mov dl,ch
          xor dh,dh
          mov ax,320
          mul dx
          mov bl,xs
          xor bh,bh
          add ax,bx
          mov di,ax
          pop bx
          pop dx
          mov es:[di],bl
             cmp ch,100
        jne lcc11
        end11:
     end;
              end;
        270 : begin
                   n:=y0;
                   repeat dec(n) until (n=yk) or (t[x0,n]<>0);
                   if t[x0,n]=0 then n:=49 else n:=abs(y0-n);

     asm
        mov ax,0a000h
        mov es,ax

        mov cl,n
        add cl,y
        sub cl,y0

        cmp cl,50
        jb ok12
        mov cl,50
        ok12:
        mov al,x
        mov dl,151
        mul dl
        mov bl,y
        xor bh,bh
        add bx,ax
        lea si,t
        mov dl,ds:si[bx]
        cmp dl,0
        je end12;
        xor ch,ch
        dec cl
        dec ch
        lcc12:
             inc ch
{        ; cl - n - 1
        ; dl - co
        ; ch - cc - 1}
          mov al,100
          mul cl
          mov bl,ch
          xor bh,bh
          add bx,ax
          lea si,his
          mov dh,ds:si[bx]
{          ; dh - his[]}
          mov al,50
          mul dl
          mov bl,dh
          xor bh,bh
          add bx,ax
          lea si,ceg
          add si,bx
          mov bl,ds:[si]
{          ; bl - kolor}
          push dx
          push bx
          mov dl,ch
          xor dh,dh
          mov ax,320
          mul dx
          mov bl,xs
          xor bh,bh
          add ax,bx
          mov di,ax
          pop bx
          pop dx
          mov es:[di],bl
             cmp ch,100
        jne lcc12
        end12:
     end;
              end;
     end;
end
 else
begin
x2:=2*x0;
y2:=2*y0;
if b<45 then
begin
{   asm
     mov ax,dy
     shl dx,1
     mov si,ax
     mov di,ax
     mov ax,dxr
     mov bp,ax
     shl ax,1
     sub di,ax
     mov dx,si
     sub dx,bx
     mov cl,1
     mov al,xn
     mov ah,yn
jn1: inc al
     sub dx,0
jb sec1
     add dx,di
     inc ah
jmp nosec1
sec1:
     add dx,si
nosec1:
       inc cl
       mov bx,bp
       cmp cl,bl
je exi1
       push ax
       push bp
       mov bx,ax
       mov bl,201
       mul bl
       mov bl,bh
       xor bh,bh
       add bx,ax
       lea bp,t
       add bp,bx
       mov bl,ds:[si]
       pop bp
       pop ax
       cmp bl,0
jne exi1
     jmp jn1
exi1:
     end;}

     ddy:=2*dy;
     dyx:=ddy-2*dxr;
     dn:=ddy-dxr;
     n:=1;
     repeat
          inc(xn);
          if dn>=0 then
          begin
               dn:=dn+dyx;
               inc(yn);
          end
           else dn:=dn+ddy;
           x:=xn;
           y:=yn;
           {putpixel(x,getmaxy-y,white);}
           inc(n);
     until (n=dxr) or (t[x,y]<>0);


     if t[x,y]=0 then n:=49 else n:=ns[abs(x0-xn),abs(y0-yn)];
     asm
        mov ax,0a000h
        mov es,ax

        mov cl,n
        add cl,y
        sub cl,y0

        cmp cl,50
        jb ok1
        mov cl,50
        ok1:
        mov al,x
        mov dl,151
        mul dl
        mov bl,y
        xor bh,bh
        add bx,ax
        lea si,t
        mov dl,ds:si[bx]
        cmp dl,0
        je end1;
        xor ch,ch
        dec cl
        dec ch
        lcc1:
             inc ch
{        ; cl - n - 1
        ; dl - co
        ; ch - cc - 1}
          mov al,100
          mul cl
          mov bl,ch
          xor bh,bh
          add bx,ax
          lea si,his
          mov dh,ds:si[bx]
{          ; dh - his[]}
          mov al,50
          mul dl
          mov bl,dh
          xor bh,bh
          add bx,ax
          lea si,ceg
          add si,bx
          mov bl,ds:[si]
{          ; bl - kolor}
          push dx
          push bx
          mov dl,ch
          xor dh,dh
          mov ax,320
          mul dx
          mov bl,xs
          xor bh,bh
          add ax,bx
          mov di,ax
          pop bx
          pop dx
          mov es:[di],bl
             cmp ch,100
        jne lcc1
        end1:
     end;
end
 else
if b<90 then
begin
     ddx:=2*dxr;
     dyx:=ddx-2*dy;
     dn:=ddx-dy;
     n:=1;
     repeat
          inc(yn);
          if dn>=0 then
          begin
               dn:=dn+dyx;
               inc(xn);
          end
           else dn:=dn+ddx;
           x:=xn;
           y:=yn;
           {putpixel(x,getmaxy-y,white);}
           inc(n);
     until (n=dy) or (t[x,y]<>0);
     if t[x,y]=0 then n:=49 else n:=ns[abs(x0-x),abs(y0-y)];
     asm
        mov ax,0a000h
        mov es,ax

        mov cl,n
        add cl,y
        sub cl,y0

        cmp cl,50
        jb ok2
        mov cl,50
        ok2:
        mov al,x
        mov dl,151
        mul dl
        mov bl,y
        xor bh,bh
        add bx,ax
        lea si,t
        mov dl,ds:si[bx]
        cmp dl,0
        je end2;
        xor ch,ch
        dec cl
        dec ch
        lcc2:
             inc ch
{        ; cl - n - 1
        ; dl - co
        ; ch - cc - 1}
          mov al,100
          mul cl
          mov bl,ch
          xor bh,bh
          add bx,ax
          lea si,his
          mov dh,ds:si[bx]
{          ; dh - his[]}
          mov al,50
          mul dl
          mov bl,dh
          xor bh,bh
          add bx,ax
          lea si,ceg
          add si,bx
          mov bl,ds:[si]
{          ; bl - kolor}
          push dx
          push bx
          mov dl,ch
          xor dh,dh
          mov ax,320
          mul dx
          mov bl,xs
          xor bh,bh
          add ax,bx
          mov di,ax
          pop bx
          pop dx
          mov es:[di],bl
             cmp ch,100
        jne lcc2
        end2:
     end;
end
 else
if b<135 then
begin
     ddx:=2*dxr;
     dyx:=ddx-2*dy;
     dn:=ddx-dy;
     n:=1;
     repeat
          inc(yn);
          if dn>=0 then
          begin
               dn:=dn+dyx;
               inc(xn);
          end
           else dn:=dn+ddx;
           x:=x2-xn;
           y:=yn;
           {putpixel(x,getmaxy-y,white);}
           inc(n);
     until (n=dy) or (t[x,y]<>0);
     if t[x,y]=0 then n:=49 else n:=ns[abs(x0-x),abs(y0-y)];
     asm
        mov ax,0a000h
        mov es,ax

        mov cl,n
        add cl,y
        sub cl,y0

        cmp cl,50
        jb ok3
        mov cl,50
        ok3:
        mov al,x
        mov dl,151
        mul dl
        mov bl,y
        xor bh,bh
        add bx,ax
        lea si,t
        mov dl,ds:si[bx]
        cmp dl,0
        je end3;
        xor ch,ch
        dec cl
        dec ch
        lcc3:
             inc ch
{        ; cl - n - 1
        ; dl - co
        ; ch - cc - 1}
          mov al,100
          mul cl
          mov bl,ch
          xor bh,bh
          add bx,ax
          lea si,his
          mov dh,ds:si[bx]
{          ; dh - his[]}
          mov al,50
          mul dl
          mov bl,dh
          xor bh,bh
          add bx,ax
          lea si,ceg
          add si,bx
          mov bl,ds:[si]
{          ; bl - kolor}
          push dx
          push bx
          mov dl,ch
          xor dh,dh
          mov ax,320
          mul dx
          mov bl,xs
          xor bh,bh
          add ax,bx
          mov di,ax
          pop bx
          pop dx
          mov es:[di],bl
             cmp ch,100
        jne lcc3
        end3:
     end;
end
 else
if b<180 then
begin
     ddy:=2*dy;
     dyx:=ddy-2*dxr;
     dn:=ddy-dxr;
     n:=1;
     repeat
          inc(xn);
          if dn>=0 then
          begin
               dn:=dn+dyx;
               inc(yn);
          end
           else dn:=dn+ddy;
           x:=x2-xn;
           y:=yn;
           {putpixel(x,getmaxy-y,white);}
           inc(n);
     until (n=dxr) or (t[x,y]<>0);
   if t[x,y]=0 then n:=49 else  n:=ns[abs(x0-x),abs(y0-y)];
     asm
        mov ax,0a000h
        mov es,ax

        mov cl,n
        add cl,y
        sub cl,y0

        cmp cl,50
        jb ok4
        mov cl,50
        ok4:
        mov al,x
        mov dl,151
        mul dl
        mov bl,y
        xor bh,bh
        add bx,ax
        lea si,t
        mov dl,ds:si[bx]
        cmp dl,0
        je end4;
        xor ch,ch
        dec cl
        dec ch
        lcc4:
             inc ch
{        ; cl - n - 1
        ; dl - co
        ; ch - cc - 1}
          mov al,100
          mul cl
          mov bl,ch
          xor bh,bh
          add bx,ax
          lea si,his
          mov dh,ds:si[bx]
{          ; dh - his[]}
          mov al,50
          mul dl
          mov bl,dh
          xor bh,bh
          add bx,ax
          lea si,ceg
          add si,bx
          mov bl,ds:[si]
{          ; bl - kolor}
          push dx
          push bx
          mov dl,ch
          xor dh,dh
          mov ax,320
          mul dx
          mov bl,xs
          xor bh,bh
          add ax,bx
          mov di,ax
          pop bx
          pop dx
          mov es:[di],bl
             cmp ch,100
        jne lcc4
        end4:
     end;
end
 else
if b<225 then
begin
     ddy:=2*dy;
     dyx:=ddy-2*dxr;
     dn:=ddy-dxr;
     n:=1;
     repeat
          inc(xn);
          if dn>=0 then
          begin
               dn:=dn+dyx;
               inc(yn);
          end
           else dn:=dn+ddy;
           x:=x2-xn;
           y:=(y2-yn);
           {putpixel(x,getmaxy-y,white);}
           inc(n);
     until (n=dxr) or (t[x,y]<>0);
    if t[x,y]=0 then n:=49 else n:=ns[abs(x0-x),abs(y0-y)];
     asm
        mov ax,0a000h
        mov es,ax

        mov cl,n
        add cl,y
        sub cl,y0

        cmp cl,50
        jb ok5
        mov cl,50
        ok5:
        mov al,x
        mov dl,151
        mul dl
        mov bl,y
        xor bh,bh
        add bx,ax
        lea si,t
        mov dl,ds:si[bx]
        cmp dl,0
        je end5;
        xor ch,ch
        dec cl
        dec ch
        lcc5:
             inc ch
{        ; cl - n - 1
        ; dl - co
        ; ch - cc - 1}
          mov al,100
          mul cl
          mov bl,ch
          xor bh,bh
          add bx,ax
          lea si,his
          mov dh,ds:si[bx]
{          ; dh - his[]}
          mov al,50
          mul dl
          mov bl,dh
          xor bh,bh
          add bx,ax
          lea si,ceg
          add si,bx
          mov bl,ds:[si]
{          ; bl - kolor}
          push dx
          push bx
          mov dl,ch
          xor dh,dh
          mov ax,320
          mul dx
          mov bl,xs
          xor bh,bh
          add ax,bx
          mov di,ax
          pop bx
          pop dx
          mov es:[di],bl
             cmp ch,100
        jne lcc5
        end5:
     end;
end
 else
if b<270 then
begin
     ddx:=2*dxr;
     dyx:=ddx-2*dy;
     dn:=ddx-dy;
     n:=1;
     repeat
          inc(yn);
          if dn>=0 then
          begin
               dn:=dn+dyx;
               inc(xn);
          end
           else dn:=dn+ddx;
          x:=x2-xn;
          y:=y2-yn;
{          putpixel(x,getmaxy-y,white);}
          inc(n);
     until (n=dy) or (t[x,y]<>0);
    if t[x,y]=0 then n:=49 else n:=ns[abs(x0-x),abs(y0-y)];
     asm
        mov ax,0a000h
        mov es,ax

        mov cl,n
        add cl,y
        sub cl,y0

        cmp cl,50
        jb ok6
        mov cl,50
        ok6:
        mov al,x
        mov dl,151
        mul dl
        mov bl,y
        xor bh,bh
        add bx,ax
        lea si,t
        mov dl,ds:si[bx]
        cmp dl,0
        je end6;
        xor ch,ch
        dec cl
        dec ch
        lcc6:
             inc ch
{        ; cl - n - 1
        ; dl - co
        ; ch - cc - 1}
          mov al,100
          mul cl
          mov bl,ch
          xor bh,bh
          add bx,ax
          lea si,his
          mov dh,ds:si[bx]
{          ; dh - his[]}
          mov al,50
          mul dl
          mov bl,dh
          xor bh,bh
          add bx,ax
          lea si,ceg
          add si,bx
          mov bl,ds:[si]
{          ; bl - kolor}
          push dx
          push bx
          mov dl,ch
          xor dh,dh
          mov ax,320
          mul dx
          mov bl,xs
          xor bh,bh
          add ax,bx
          mov di,ax
          pop bx
          pop dx
          mov es:[di],bl
             cmp ch,100
        jne lcc6
        end6:
     end;
end
 else
if b<315 then
begin
     ddx:=2*dxr;
     dyx:=ddx-2*dy;
     dn:=ddx-dy;
     n:=1;
     repeat
          inc(yn);
          if dn>=0 then
          begin
               dn:=dn+dyx;
               inc(xn);
          end
           else dn:=dn+ddx;
           x:=xn;
           y:=y2-yn;
          {putpixel(x,getmaxy-y,white);}
          inc(n);
     until (n=dy) or (t[x,y]<>0);
    if t[x,y]=0 then n:=49 else n:=ns[abs(x0-x),abs(y0-y)];
     asm
        mov ax,0a000h
        mov es,ax

        mov cl,n
        add cl,y
        sub cl,y0

        cmp cl,50
        jb ok7
        mov cl,50
        ok7:
        mov al,x
        mov dl,151
        mul dl
        mov bl,y
        xor bh,bh
        add bx,ax
        lea si,t
        mov dl,ds:si[bx]
        cmp dl,0
        je end7;
        xor ch,ch
        dec cl
        dec ch
        lcc7:
             inc ch
{        ; cl - n - 1
        ; dl - co
        ; ch - cc - 1}
          mov al,100
          mul cl
          mov bl,ch
          xor bh,bh
          add bx,ax
          lea si,his
          mov dh,ds:si[bx]
{          ; dh - his[]}
          mov al,50
          mul dl
          mov bl,dh
          xor bh,bh
          add bx,ax
          lea si,ceg
          add si,bx
          mov bl,ds:[si]
{          ; bl - kolor}
          push dx
          push bx
          mov dl,ch
          xor dh,dh
          mov ax,320
          mul dx
          mov bl,xs
          xor bh,bh
          add ax,bx
          mov di,ax
          pop bx
          pop dx
          mov es:[di],bl
             cmp ch,100
        jne lcc7
        end7:
     end;
end
 else
if b<360 then
begin
     ddy:=2*dy;
     dyx:=ddy-2*dxr;
     dn:=ddy-dxr;
     n:=1;
     repeat
          inc(xn);
          if dn>=0 then
          begin
               dn:=dn+dyx;
               inc(yn);
          end
           else dn:=dn+ddy;
           x:=xn;
           y:=y2-yn;
           {putpixel(x,getmaxy-y,white);}
           inc(n);
     until (n=dxr) or (t[x,y]<>0);
    if t[x,y]=0 then n:=49 else n:=ns[abs(x0-x),abs(y0-y)];
     asm
        mov ax,0a000h
        mov es,ax

        mov cl,n
        add cl,y
        sub cl,y0

        cmp cl,50
        jb ok8
        mov cl,50
        ok8:
        mov al,x
        mov dl,151
        mul dl
        mov bl,y
        xor bh,bh
        add bx,ax
        lea si,t
        mov dl,ds:si[bx]
        cmp dl,0
        je end8;
        xor ch,ch
        dec cl
        dec ch
        lcc8:
             inc ch
{        ; cl - n - 1
        ; dl - co
        ; ch - cc - 1}
          mov al,100
          mul cl
          mov bl,ch
          xor bh,bh
          add bx,ax
          lea si,his
          mov dh,ds:si[bx]
{          ; dh - his[]}
          mov al,50
          mul dl
          mov bl,dh
          xor bh,bh
          add bx,ax
          lea si,ceg
          add si,bx
          mov bl,ds:[si]
{          ; bl - kolor}
          push dx
          push bx
          mov dl,ch
          xor dh,dh
          mov ax,320
          mul dx
          mov bl,xs
          xor bh,bh
          add ax,bx
          mov di,ax
          pop bx
          pop dx
          mov es:[di],bl
             cmp ch,100
        jne lcc8
        end8:
     end;
end;
end;
end;

procedure show;
begin
     xs:=181;
     for a:=45 to 135 do
     begin
          dec(xs);
          b:=a+an;
          if b>359 then b:=b-359;
          if b<0 then b:=360+b;
          xk:=x0+ang[b,0];
          yk:=y0+ang[b,1];
          l;
     end;
end;

procedure showl;
begin
     xs:=90;
     b:=135+an;
     if b>359 then b:=b-359;
     if b<0 then b:=360+b;
     xk:=x0+ang[b,0];
     yk:=y0+ang[b,1];
     l;
end;

procedure showr;
begin
     xs:=180;
     b:=45+an;
     if b>359 then b:=b-359;
     if b<0 then b:=360+b;
     xk:=x0+ang[b,0];
     yk:=y0+ang[b,1];
     l;
end;

procedure movl;
label mmm1;
begin
asm
     xor        bx,bx
     push       ds
     mov        ax,0a000h
     mov        ds,ax
     mov        es,ax
     cld
mmm1:
     mov        ax,320
     mul        bx
     add        ax,90
     mov        di,ax
     inc        ax
     mov        si,ax
     mov        cx,90
     rep        movsb
     inc        bx
     cmp        bx,100
jne mmm1
    pop ds
end;
end;

procedure movr;
label mmm1;
begin
asm
     xor        bx,bx
     push       ds
     mov        ax,0a000h
     mov        ds,ax
     mov        es,ax
     std
mmm1:
     mov        ax,320
     mul        bx
     add        ax,180
     mov        di,ax
     dec        ax
     mov        si,ax
     mov        cx,90
     rep        movsb
     inc        bx
     cmp        bx,100
jne mmm1
    pop ds
    cld
end;
end;

begin
     asm
        MOV AX,0013H
            INT 10H

        MOV CX,2
        MOV DX,3C8H
    xor bl,bl

L000:
        MOV AL,CL
        OUT DX,AL
        INC DX

        MOV AL,bl
        OUT DX,AL

        MOV AL,0
        OUT DX,AL

        MOV AL,0
        OUT DX,AL

        DEC DX
        inc bl
        INC CX
        CMP CX,256
JB  L000

     end;
     randomize;
     for a:=0 to 359 do
     begin
          if a<91 then
          begin
           ang[a,0]:=round(50*cos(a/57.3));
           ang[a,1]:=round(50*sin(a/57.3));
          end;
          if (a>90) and (a<180) then
          begin
           ang[a,0]:=round(50*cos((180-a)/57.3));
           ang[a,1]:=round(50*sin((180-a)/57.3));
          end;
          if (a>180) and (a<270) then
          begin
           ang[a,0]:=round(50*cos((a-180)/57.3));
           ang[a,1]:=round(50*sin((a-180)/57.3));
          end;
          if (a>270) and (a<360) then
          begin
           ang[a,0]:=round(50*cos((360-a)/57.3));
           ang[a,1]:=round(50*sin((360-a)/57.3));
          end;
     end;
     for a:=0 to 200 do for b:=0 to 150 do t[a,b]:=0;
     for a:=0 to 150 do
     begin
          t[50,a]:=random(49)+1;
          t[150,a]:=random(49)+1;
     end;
     for a:=0 to 200 do
     begin
          t[a,50]:=random(49)+1;
          t[a,100]:=random(49)+1;
     end;
     for a:=0 to 49 do for b:=0 to 49 do ceg[a,b]:=random(250)+2;
     for a:=0 to 49 do
     begin
          ceg[a,0]:=0;
          ceg[a,49]:=1;
     end;
     for a:=1 to 50 do for b:=1 to 100 do if b<50 then his[a,b]:=0 else his[a,b]:=49;
     for a:=1 to 50 do
     begin
          dl:=round(((101-a)*100)/100);
          pocz:=round((100-dl)/2);
          for b:=pocz to pocz+dl-1 do
          begin
               his[a,b+1]:=round(((b-pocz)*50)/dl);
               if his[a,b+1]>49 then his[a,b+1]:=1;
          end;
     end;
     for a:=0 to 50 do for b:=0 to 50 do
     begin
         ns[a,b]:=round(sqrt((a*a)+(b*b)));
         if ns[a,b]=0 then ns[a,b]:=1;
     end;
     an:=0;
     x0:=100;
     y0:=75;
     show;
     repeat
      repeat
           z:=upcase(readkey);
      until z in ['A','S','E','I','K','J','L'];
      if z<>'E' then
      begin
       case z of
            'A' :begin
                      movr;
                      showl;
                      an:=an+1;
                      if an>=360 then an:=0;
                 end;
            'S' :begin
                      movl;
                      showr;
                      an:=an-1;
                      if an<=0 then an:=359;
                 end;
            'I' :if t[x0,y0+3]=0 then
                 begin
                      inc(y0);
                      show;
                 end;
            'K' :if t[x0,y0-3]=0 then
                 begin
                      dec(y0);
                      show;
                 end;
            'L' :if t[x0+3,y0]=0 then
                 begin
                      inc(x0);
                      show;
                 end;
            'J' :if t[x0-3,y0]=0 then
                 begin
                      dec(x0);
                      show;
                 end;
       end;
      end;
     until z='E';
     asm
        MOV AX,2h
            INT 10H
     end;
end.


