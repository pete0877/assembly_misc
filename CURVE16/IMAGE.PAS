uses crt,dos;

var f:file of byte;
    a,b,c:integer;
	 t:array[0..15,0..15] of byte;
begin
      randomize;
		for a:=0 to 15 do
			 for b:=0 to 15 do t[a,b]:=0;
		for a:=0 to 7 do
		  for b:=0 to 15 do t[2*a,b]:=10;
		for a:=0 to 7 do
		  for b:=0 to 15 do t[b,2*a]:=t[b,2*a]+30;

      assign(f,'image.dat');
		rewrite(f);
		for a:=0 to 15 do
			 for b:=0 to 15 do write(f,t[a,b]);
      close(f);

end.

