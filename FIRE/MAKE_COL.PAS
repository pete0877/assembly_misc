uses dos,crt;
var f:file of byte;
	 a:byte;
	 z:char;
	 t:array [0..255,0..2] of byte;
begin
	 for a:=0 to 255 do
	 begin
		t[a,0]:=0;
		t[a,1]:=0;
		t[a,2]:=0;
	 end;
         for a:=0 to 63 do
         begin
              t[a,0]:=a;
              if a>32 then t[a,1]:=2*(a-32);
         end;

	 assign(f,'colors.dat');
	 rewrite(f);
	 for a:=1 to 255 do begin
             write(f,t[a,0]);
             write(f,t[a,1]);
             write(f,t[a,2]);
         end;
	 close(f);
         for a:=0 to 255 do
         begin
              write(t[a,0],'   ');
              write(t[a,1],'   ');
              writeln(t[a,2]);

         end;
end.
