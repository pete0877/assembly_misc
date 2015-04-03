uses crt,dos;

var f:file of byte;
	 r,c,a:integer;
	 v:byte;
	 s:string;
begin
	if paramcount<>2 then
	begin
		writeln('no trash talk');
	end
	 else
	begin
		randomize;
		assign(f,'trash.dat');
		rewrite(f);
		s:=paramstr(1);
		val(s,c,a);
		s:=paramstr(2);
		val(s,r,a);
		for a:=1 to c do
		begin
			v:=random(r);
			write(f,v);
		end;
		close(f);
	end;
end.

