USES CRT,DOS,GRAPH;
VAR F:FILE OF BYTE;
    A,B:INTEGER;
    C,C2:BYTE;
    DEL:INTEGER;
    Z:CHAR;
    X,Y:INTEGER;
    P1,P2:INTEGER;
BEGIN
     A:=CGA;
     B:=0;
     C2:=0;
     INITGRAPH(A,B,'C:\NC\DAT\TP\BGI');
     SETCOLOR(WHITE);
     ASSIGN(F,'SIN_PER.DAT');
     REWRITE(F);
     DEL:=0;
     FOR A:=0 TO 199 DO
     BEGIN
          C:=ROUND(142+30*SIN((A/31.831927)*2));
          IF A=0 THEN
          BEGIN
               P1:=C;
               C2:=C;
          END;
          IF A=199 THEN P2:=C;
          LINE(C,A,32+C,A);
          WRITE(F,C);
          IF ABS(C-C2)>DEL THEN DEL:=ABS(C-C2);
          C2:=C;
     END;
     CLOSE(F);
     Z:=READKEY;
     X:=GETMAXX;
     Y:=GETMAXY;
     CLOSEGRAPH;
     WRITELN;
     WRITELN('    ',P1,'  TO  ',P2);
     WRITELN('  X-',X, '    Y-',Y);
       WRITE('DEL-',DEL);
     Z:=READKEY;
END.
