uses crt,dos;

var f:file of byte;
	 ff:file of byte;
	 a:longint;
	 b:byte;
begin
	assign(f,'newfont.dat');
	rewrite(f);
	assign(ff,'font.dat');
	reset(ff);
	repeat
		for a:=0 to 31 do
		begin
			read(ff,b);
			if a mod 2 = 0 then write(f,b);
		end;
		for a:=0 to 31 do read(ff,b);
	until eof(ff);
	close(ff);
	close(f);
end.

