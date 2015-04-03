uses crt,dos;

var f:file of word;
         a,b,c:integer;
         dd:word;
         o,mx,my,nx,ny,s,x,y:integer;
         z:char;
                        ra:real;
                        ddd:shortint;


procedure mode_13h;
begin
        asm
                mov ax,0013h
                int 10h
         end;
end;

procedure text_mode;
begin
        asm
                mov ax,0003h
                int 10h
        end;
end;

function d(r:real):real;
begin
        d:=57.3*r;
end;

function r(d:real):real;
begin
        r:=d/57.3;
end;

procedure pp (x,y:word; c:byte);
begin
        asm
                mov ah,0ch
                mov al,c
                mov bh,0
                mov cx,x
                mov dx,y
                int 10h
        end;
end;

procedure key;
var a:char;
begin
        z:=readkey;
end;

begin
                  s:=5;
                  o:=0;
                  mx:=0;
        my:=0;
        nx:=600;
        ny:=600;
        mode_13h;
        assign(f,'curve.dat');
        rewrite(f);
        for a:=1 to s*360 do
        begin
													  ra:=100*cos(5*r(a/s))*cos(r(a/s));
													  x:=170+round(ra*cos(r(a/s)))-15;
													  y:=80+round(0.7*ra*sin(r(a/s)))-15;
					 pp(x,y,2);

                if x>mx then mx:=x;
                if x<nx then nx:=x;
					 if y>my then my:=y;
					 if y<ny then ny:=y;

                dd:=320*y+x;

                write(f,dd);
        end;
        close(f);
        key;
        text_mode;
        writeln(nx,',',ny,'-',mx,',',my);
        key;
end.

