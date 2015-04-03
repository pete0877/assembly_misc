uses crt,dos;

var f:file of byte;
	 a,b,c:integer;
	 bb:byte;
begin
		assign(f,'pal.dat');
		rewrite(f);
		for a:=80 downto 1 do
		begin
			 bb:=round((63)*(a/80));
                         write(f,bb);
		end;
		for a:=256-80 downto 1 do
		begin
			 bb:=0;
                         write(f,bb);
		end;
		close(f);
end.

