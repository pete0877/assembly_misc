uses crt,dos;

var f:file of byte;
         ff:file of byte;
         a,b,c:longint;
         bb:byte;
    t:array[1..16,1..16] of byte;
begin
        assign(f,'horfont.dat');
        rewrite(f);
        assign(ff,'newfont.dat');
        reset(ff);
		  for c:=1 to 64 do
        begin
              for a:=1 to 16 do
                  for b:=1 to 16 do read(ff,t[a,b]);
              for a:=1 to 16 do
                  for b:=1 to 16 do write(f,t[b,a]);
        end;
        close(ff);
        close(f);
end.

