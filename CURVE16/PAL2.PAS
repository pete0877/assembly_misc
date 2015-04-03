uses crt,dos;

var f:file of byte;
	 a,b,c:integer;
	 bb:byte;
begin
		assign(f,'pal.dat');
		rewrite(f);
		for a:=0 to 128 do
		begin
			 bb:=round(62*(a/128));
			 write(f,bb);
			 write(f,bb);
			 write(f,bb);
		end;
		for a:=128 downto 0 do
		begin
			 bb:=round(62*(a/128));
			 write(f,bb);
			 write(f,bb);
			 write(f,bb);
		end;
		close(f);
end.

