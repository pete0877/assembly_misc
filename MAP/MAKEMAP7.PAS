uses graph,crt;

type tab=array[0..199,0..199] of byte;

var MIX,MAX,MIY,MAY,mx,my,a,b,c,xx,yy,zz:integer;
    r,k:real;
    z:char;
    tx,ty:^tab;
    f:file;

procedure l(x,z,y:integer);
var xxx,yyy,x1,y1:integer;

begin
     x1:=round(x+r*z);
     y1:=round(k*(y-r*z));
     xxx:=x1+mx;
     yyy:=y1+my;
{     if mx+x1<mix then mix:=x1+mx;
     if mx+x1>max then max:=x1+mx;
     if my+y1<miy then miy:=y1+my;
     if my+y1>may then may:=y1+my;}
     putpixel(xxx,yyy,white);
     if (xxx>=0) and (xxx<200) and (yyy>=0) and (yyy<200) then
     begin
        tx^[yyy,xxx]:=round((xx/480)*200);
        ty^[yyy,xxx]:=round((yy/600)*200);
        if (tx^[yyy,xxx]>200) and (ty^[yyy,xxx]>200)  then
        begin
             a:=a;
        end;
     end;

end;

begin
     detectgraph(a,b);
     initgraph(a,b,'d:\dosprogs\tp\bgi');
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

     for xx:=0 to 960 do for yy:=0 to round(600) do
     l(round(0.125*xx)-100,round(0.25*yy)-100,round(-25*sin((2*xx*pi)/480)*sin((2*yy*pi)/600)));

     z:=readkey;
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
{     writeln('x:',mix,' to ',max);
     writeln('y:',miy,' to ',may);
     z:=readkey;                  }

end.