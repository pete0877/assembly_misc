uses dos,crt;
var a,b,mx,my,mc:integer;
         x,y:byte;
         z:char;
         f:file of byte;
         r:real;
         t:array[0..199,0..199] of byte;
begin
writeln('please wait...');
{        a:=vga;
        b:=vgalo;
        initgraph(a,b,'c:\dosprogs\tp\bgi');}
        for a:=0 to 199 do for b:=0 to 199 do t[a,b]:=0;
        {clearviewport;}
        for b:=0 to 199 do
                for a:=0 to 199 do
        begin
                {putpixel(a,b+10+round(10*sin(a/10)),a);}
                t[a,b]:=a;
        end;
        assign(f,'x_map.dat');
        rewrite(f);
        for b:=0 to 199 do
                for a:=0 to 199 do write(f,t[a,b]);
        close(f);
        {clearviewport;}
        for a:=0 to 199 do for b:=0 to 199 do t[a,b]:=0;
        for b:=0 to 199 do
                for a:=0 to 199 do
        begin
                {putpixel(a,b+10+round(10*sin(a/10)),b);}
                t[a,b]:=b+round(10*sin(a/10));
        end;
        assign(f,'y_map.dat');
        rewrite(f);
        for b:=0 to 199 do
                for a:=0 to 199 do write(f,t[a,b]);
        close(f);        
        {closegraph;}
end.

