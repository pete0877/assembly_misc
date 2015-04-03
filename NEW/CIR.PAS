uses crt,dos;

var f:file of longint;
    x,y,z:longint;
    a:byte;
begin
		assign(f,'cir.dat');
		rewrite(f);
                for a:=1 to 20 do
                begin
                     x:=round(160+150*cos(a*18/57.3));
                     y:=round(100+90*sin(a*18/57.3));
                     z:=100;
                     write(f,x,y,z);
                end;
		close(f);
end.

