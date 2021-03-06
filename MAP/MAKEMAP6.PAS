uses graph,crt;

type tab=array[0..199,0..199] of byte;

var MIX,MAX,MIY,MAY,mx,my,a,b,c,xx,yy,zz:integer;
    r,k:real;
    z:char;
    tx,ty:^tab;
    f:file;

procedure l(x,z,y:integer);
var wox,woy,xxx,yyy,x1,y1:integer;

begin
     x1:=round(x+r*z);
     y1:=round(k*(y-r*z));
     xxx:=x1+mx;
     yyy:=y1+my;     

     putpixel(xxx,yyy,white);
     if (xxx>=0) and (xxx<200) and (yyy>=0) and (yyy<200) then
     begin
        wox:=round((xx/(2*960))*200);
        woy:=round((yy/600)*200);

        if tx^[yyy,xxx]=0 then
        begin
                             tx^[yyy,xxx]:=wox;
        if (xxx<199) and (xxx>1) and (yyy<199) and (yyy>1) then
        begin


        if tx^[yyy+1,xxx] = 0 then tx^[yyy+1,xxx]:=wox;
        if tx^[yyy,xxx+1] = 0 then tx^[yyy,xxx+1]:=wox;
        if tx^[yyy-1,xxx] = 0 then tx^[yyy-1,xxx]:=wox;
        if tx^[yyy,xxx-1] = 0 then tx^[yyy,xxx-1]:=wox;
        if tx^[yyy-1,xxx-1] = 0 then tx^[yyy,xxx-1]:=wox;
        if tx^[yyy+1,xxx+1] = 0 then tx^[yyy,xxx-1]:=wox;
        if tx^[yyy-1,xxx+1] = 0 then tx^[yyy,xxx-1]:=wox;
        if tx^[yyy+1,xxx-1] = 0 then tx^[yyy,xxx-1]:=wox;

        end;
                
        end;
        if ty^[yyy,xxx]=0 then
        begin
                ty^[yyy,xxx]:=woy;

        if (xxx<199) and (xxx>1) and (yyy<199) and (yyy>1) then
        begin

        if ty^[yyy+1,xxx] = 0 then ty^[yyy+1,xxx]:=woy;
        if ty^[yyy,xxx+1] = 0 then ty^[yyy,xxx+1]:=woy;
        if ty^[yyy-1,xxx] = 0 then ty^[yyy-1,xxx]:=woy;
        if ty^[yyy,xxx-1] = 0 then ty^[yyy,xxx-1]:=woy;
        if ty^[yyy-1,xxx-1] = 0 then ty^[yyy,xxx-1]:=woy;
        if ty^[yyy+1,xxx+1] = 0 then ty^[yyy,xxx-1]:=woy;
        if ty^[yyy-1,xxx+1] = 0 then ty^[yyy,xxx-1]:=woy;
        if ty^[yyy+1,xxx-1] = 0 then ty^[yyy,xxx-1]:=woy;
        end;
         end;


     end;

end;

begin
     detectgraph(a,b);
     initgraph(a,b,'c:\dosprogs\tp\bgi');
     new(tx);
     new(ty);
     for a:=0 to 199 do for b:=0 to 199 do begin
                                                ty^[a,b]:=0;
                                                tx^[a,b]:=0;
                                           end;
     k:=getmaxx/getmaxy;
     r:=sqrt(2)/2-0.1;
     mx:=round(getmaxx/2);
     my:=round(getmaxy/2);
     mix:=1000;
     miy:=1000;
     max:=0;
     may:=0;
     line(200,0,200,200);
     line(200,200,0,200);
     mx:=mx-165;
     my:=my-161;

     for xx:=2*960 downto 0 do for yy:=600 downto 0 do
     l(round(0.125*xx/2)-100,round(0.25*yy)-100,round(-3*sin((7*xx*pi)/(2*960))));

     assign(f,'x_map.dat');
     rewrite(f,1);
     blockwrite(f,tx^[0,0],40000);
     close(f);
     assign(f,'y_map.dat');
     rewrite(f,1);
     blockwrite(f,ty^[0,0],40000);
     close(f);
     release(tx);
     release(ty);
     closegraph;                  
end.
