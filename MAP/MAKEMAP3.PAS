uses dos,crt;
var m,dx,x,y,a,b,mx,my,mc:integer;
         z:char;
         f:file of byte;
         y0,r:real;
         t:array[0..199,0..199] of byte;
procedure l(x1,y1,x2,y2:integer);
begin
     dx:=abs(x2-x1);
     if x2<>x1 then
     begin
      r:=(y2-y1)/(x2-x1);
      y0:=y1-round(r*x1);
      if (a>70) and (a<130) then m:=20 else m:=5;
      if (a>90) and (a<110) then m:=50;
      if (a>96) and (a<104) then m:=500;
      if x2>x1 then
      for x:=0 to m*dx do
      begin
          y:=round(r*(x1+(x/m))+y0);
          {putpixel((x1+round(x/m)),y,white);}
          t[x1+round(x/m),y]:=a;
      end;
      if x2<x1 then
      for x:=0 to m*dx do
      begin
          y:=round(r*(x2+(x/m))+y0);
{          putpixel((x2+round(x/m)),y,white);}
          t[x2+round(x/m),y]:=a;
      end;
     end
      else if y2>y1 then for x:=y1 to y2 do t[x1,x]:=a;
end;

procedure l2(x1,x2,y:integer);
begin
     for x:=x1 to x2 do
     begin
{          putpixel(x,y,white);}
          t[x,y]:=a;
     end;
end;

begin
writeln('please wait...');
{        a:=vga;
        b:=vgalo;
        initgraph(a,b,'c:\dosprogs\tp\bgi');}

        for a:=0 to 199 do for b:=0 to 199 do t[a,b]:=0;
{        clearviewport;}
        for a:=0 to 199 do l(99,99,a,198);
        assign(f,'y_map.dat');
        rewrite(f);
        for b:=0 to 199 do
                for a:=0 to 199 do write(f,t[a,b]);
        close(f);

{        clearviewport;}
        for b:=0 to 199 do t[a,b]:=0;
        for a:=0 to 99 do
        begin
{                setcolor(2*a);}
                l2(99-a,99+a,99+a);
        end;
        assign(f,'x_map.dat');
        rewrite(f);
        for b:=0 to 199 do
                for a:=0 to 199 do write(f,t[a,b]);
        close(f);        
{        closegraph;}
end.

