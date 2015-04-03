uses dos,crt;

var f:file of byte;
    a,b:integer;
    c:byte;
    r:real;
    z:char;
begin
      assign(f,'sin.dat');
      rewrite(f);
      for a:=0 to 15 do
      begin
			b:=round(1*360*a/15);
         r:=b/57.3;
								c:=1+round(1*sin(r));
                        write(f,c);
      end;
      close(f);
end.