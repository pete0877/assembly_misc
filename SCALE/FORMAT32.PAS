uses crt,dos;

var f:file of byte;
         ff:file of byte;
         a,b,c:longint;
         bb:byte;
    t:array[1..32,1..32] of byte;
begin
        assign(f,'horfont.dat');
        rewrite(f);
        assign(ff,'font.dat');
        reset(ff);
						for c:=1 to 64 do
        begin
                                  writeln(c);
                                  for a:=1 to 32 do
                                                for b:=1 to 32 do read(ff,t[a,b]);
                                  for a:=1 to 32 do
                                                for b:=1 to 32 do write(f,t[b,a]);
                  end;
                  close(ff);
        close(f);
end.

