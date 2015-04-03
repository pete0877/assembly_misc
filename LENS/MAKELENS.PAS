uses dos,crt;
var a,b,mx,my,mc:integer;
	 x,y:byte;
	 z:char;
	 f:file of byte;
	 r:real;
	 t:array[0..79,0..79] of byte;
begin
writeln('please wait...');
{	 a:=vga;
	b:=vgalo;
	initgraph(a,b,'c:\dosprogs\tp\bgi');}
	for a:=0 to 79 do for b:=0 to 79 do t[a,b]:=0;
{	 clearviewport;}
	for b:=39 downto 0 do
	begin
		for a:=0 to 719 do
		begin
			x:=round(39+b*sin(a/(2*57.3)));
			y:=round(39+39*cos(a/(2*57.3)));
			if x<=39 then t[x,y]:=39-b
					  else t[x,y]:=b+39;
			{putpixel(x,y,white);}
		end;
	end;
	assign(f,'x_map.dat');
	rewrite(f);
	for b:=0 to 79 do
		for a:=0 to 79 do write(f,t[a,b]);
	close(f);
{	 clearviewport;}
	for a:=0 to 79 do for b:=0 to 79 do t[a,b]:=0;
	for b:=39 downto 0 do
	begin
		for a:=0 to 719 do
		begin
			x:=round(39+39*sin(a/(2*57.3)));
			y:=round(39+b*cos(a/(2*57.3)));
			if y<=39 then t[x,y]:=39-b
					  else t[x,y]:=b+39;
			{putpixel(x,y,white);}
		end;
	end;
	assign(f,'y_map.dat');
	rewrite(f);
	for b:=0 to 79 do
		for a:=0 to 79 do write(f,t[a,b]);
	close(f);
{	 closegraph;}
end.

