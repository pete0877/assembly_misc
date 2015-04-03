uses crt,dos,graph;
var f:file of byte;
    a,b:integer;
    c,c2:byte;
    del:integer;
    z:char;
    x,y:integer;
    p1,p2:integer;
begin
     a:=cga;
     b:=0;
     c2:=0;
     initgraph(a,b,'c:\nc\dat\tp\bgi');
     setcolor(white);
     assign(f,'Sin_per.dat');
     rewrite(f);
     for a:=0 to 199 do
     begin
          c:=round(142+20*sin(a/31.831927));
          if a=0 then
          begin
               p1:=c;
               c2:=c;
          end;
          if a=199 then p2:=c;
          line(c,a,32+c,a);
          write(f,c);
          if abs(c-c2)>del then del:=abs(c-c2);
          c2:=c;
     end;
     close(f);
     z:=readkey;
     x:=getmaxx;
     y:=getmaxy;
     closegraph;
     writeln;
     writeln('    ',p1,'  to  ',p2);
     writeln('  x-',x, '    y-',y);
       write('del-',del);
     z:=readkey;
end.