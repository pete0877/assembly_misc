Uses dos,crt;
var f:file of byte;
	 a:integer;
	 b:byte;
	 z:char;
begin
	randomize;
	assign(f,'star.dat');
	rewrite(f);
	for a:=1 to 500 do
	begin
		b:=Random(190)+5;
		write(f,b);
		b:=random(250);
		write(f,b);
		b:=random(5)+1;
		write(f,b);
	end;
	close(f);
end.
