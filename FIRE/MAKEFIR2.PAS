uses dos,crt;
var f:file of byte;
    a,b,e:integer;
    d:longint;
    c:byte;
begin
         randomize;
	 assign(f,'fire2.dat');
	 rewrite(f);
	 for a:=1 to 50 do
         begin
          for b:=1 to 20 do
          begin
                   c:=random(62)+1;
                   if (b>3) and (b<17) then if random(3)=0 then c:=63 else c:=23;
                   if (b>6) and (b<14) then if random(2)=0 then c:=63 else c:=28;
                   if (b>9) and (b<11) then if random(2)=0 then c:=63 else c:=45;
                   write(f,c);
          end;
         end;
	 close(f);
end.
