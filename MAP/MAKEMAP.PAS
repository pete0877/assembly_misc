uses dos,graph,crt;
var a,b,mx,my,mc:integer;
	 x,y:byte;
	 z:char;
	 f:file of byte;
	 r:real;
	 t:array[0..199,0..199] of byte;
begin
	a:=vga;
	b:=vgalo;
	initgraph(a,b,'c:\peter\tp\bgi');
	for a:=0 to 199 do for b:=0 to 199 do t[a,b]:=0;
	clearviewport;
	for b:=99 downto 0 do
	begin
		for a:=0 to 719 do
		begin
			x:=round(99+b*sin(a/(2*57.3)));
			y:=round(99+99*cos(a/(2*57.3)));
			if x<=99 then t[x,y]:=99-b
					  else t[x,y]:=b+99;
			putpixel(x,y,white);
		end;
	end;
	assign(f,'x_map.dat');
	rewrite(f);
	for b:=0 to 199 do
		for a:=0 to 199 do write(f,t[a,b]);
	close(f);
	clearviewport;
	for a:=0 to 199 do for b:=0 to 199 do t[a,b]:=0;
	for b:=99 downto 0 do
	begin
		for a:=0 to 719 do
		begin
			x:=round(99+99*sin(a/(2*57.3)));
			y:=round(99+b*cos(a/(2*57.3)));
			if y<=99 then t[x,y]:=99-b
					  else t[x,y]:=b+99;
			putpixel(x,y,white);
		end;
	end;
	assign(f,'y_map.dat');
	rewrite(f);
	for b:=0 to 199 do
		for a:=0 to 199 do write(f,t[a,b]);
	close(f);
	closegraph;
end.

