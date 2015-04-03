uses crt,dos;

var f:file of byte;
	 a,b,c:integer;
	 bb:byte;
begin
		assign(f,'pal.dat');
		rewrite(f);
		for a:=0 to 255 do
		begin
			 bb:=round((63)*(a/255));
			 write(f,bb);
			 write(f,bb);
			 write(f,bb);
		end;
		close(f);
end.

