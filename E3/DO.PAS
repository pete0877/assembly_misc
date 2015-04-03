uses crt,dos;

var f1:file of byte;
    f2:file of byte;
    a,b,c:integer;
    d:byte;
begin
      assign(f1,'i2.dat');
      rewrite(f1);
      assign(f2,'image.dat');
      reset(f2);
      for a:=0 to 15 do
          for b:=0 to 15 do
          begin
               read(f2,d);
               if d=14 then d:=30;
               write(f1,d);
          end;
      close(f1);
      close(f2);
end.

