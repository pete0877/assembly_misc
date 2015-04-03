uses dos,crt;
var f:file of byte;
    a,b,e,d:integer;
    c:byte;
begin
         randomize;
	 assign(f,'fire.dat');
	 rewrite(f);
	 for a:=1 to 50 do
         begin
          for b:=1 to 20 do
          begin
                   c:=random(62)+1;
                   if (b>6) and (b<14) then if random(20)<>0 then c:=63 else c:=1;
          write(f,c);
          end;
         end;
	 close(f);
end.
