uses dos,crt;
var t: array [0..3] of byte;
    e,a,c:integer;
    b:longint;
    d:byte;
    z:char;
    f1: file of byte;
    f2: file of byte;
begin
     assign(f1,'lens.bmp');
     assign(f2,'cat.arc');
     reset(f1);
     rewrite(f2);
     for a:=1 to 54 do read(f1,d);
     for a:=0 to 3 do read(f1,t[a]);

     for b:=1 to 255 do
     begin
	  for a:=0 to 3 do
	  begin
		read(f1,t[a]);
		t[a] := round((t[a]/256)*64)
	  end;
	  write(f2,t[2]);
	  write(f2,t[1]);
	  write(f2,t[0]);
     end;

     for b:=1 to 64000 do
     begin
	  read(f1,d);
	  write(f2,d);
     end;
     close(f1);
     close(f2);
end.