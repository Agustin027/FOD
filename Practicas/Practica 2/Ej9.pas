
Program Ej9;

Const 
  valorAlto = 9999;

Type 
  mesaE = Record
    codP: integer;
    codL: integer;
    nroMesa: integer;
    cantV: integer;
  End;

  master = file Of mesaE;

Procedure leerMesa(Var m: mesaE);
Begin
  writeln('Ingrese el codigo de la provincia');
  readln(m.codP);
  If (m.codP <> -1) Then
    Begin
      writeln('Ingrese el codigo de la Localidad');
      readln(m.codL);
      //writeln('Ingrese el numero de mesa');
      //readln(m.nroMesa);
      //writeln('Ingrese la cantidad de votos');
      //readln(m.cantVotos);
      m.cantV := 100;
    End;
End;

Procedure crearArchivo(Var a: master);

Var 
  m: mesaE;
Begin
  assign(a, 'mesasElectorales');
  rewrite(a);
  leerMesa(m);
  While (m.codP <> -1) Do
    Begin
      write(a, m);
      leerMesa(m);
    End;
  close(a);
End;

Procedure leer(Var archivo: master; Var dato: mesaE);
Begin
  If (Not eof(archivo)) Then
    read(archivo, dato)
  Else
    dato.codP := valorAlto;
End;

Procedure listar (Var arc_maestro: master);

Var 
  m: mesaE;
  totalProvincia,totalLocalidad,total: integer;
  provActual,locActual: integer;
Begin
  reset (arc_maestro);
  leer (arc_maestro,m);
  total := 0;
  While (m.codP <> valorAlto) Do
    Begin
      provActual := m.codP;
      totalProvincia := 0;
      writeln ('|CODIGO PROVINCIA');
      writeln (' ',m.codP);
      writeln ('|CODIGO LOCALIDAD	|TOTAL DE VOTOS');
      While (m.codP = provActual) Do
        Begin
          locActual := m.codL;
          totalLocalidad := 0;
          While (m.codP = provActual) And (m.codL = locActual) Do
            Begin
              totalLocalidad := totalLocalidad + m.cantV;
              leer (arc_maestro,m);
            End;
          writeln (' ',locActual,'			 ',totalLocalidad);
          totalProvincia := totalProvincia + totalLocalidad;
        End;
      writeln ('|TOTAL DE VOTOS DE PROVINCIA: ',totalProvincia);
      writeln ('');
      writeln ('');
      total := total+ totalProvincia;
    End;
  writeln ('......................................');
  writeln ('TOTAL GENERAL DE VOTOS: ',total);
End;


Var 
  a: master;
Begin
  crearArchivo(a);
  assign(a, 'mesasElectorales');
  listar(a);
End.
