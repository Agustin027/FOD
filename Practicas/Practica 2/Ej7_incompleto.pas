
Program Ej7;

Const 
  n = 10;
  valorAlto = 9999;

Type 

  master = Record
    codLocalidad: integer;
    nombreLocalidad: string;
    codCepa: integer;
    nombreCepa: string;
    cantCasosA: integer;
    cantCasosN: integer;
    cantCasosR: integer;
    cantCasosF: integer;
  End;

  info = Record
    codLocalidad: integer;
    codCepa: integer;
    cantCasosA: integer;
    cantCasosN: integer;
    cantCasosR: integer;
    cantCasosF: integer;
  End;


  master = file Of master;
  detail = file Of info;

  vDetalles = Array[1..n] Of detail;
  rDetalles = Array[1..n] Of info;



Procedure crearDetalle(Var d: detail);
Begin

End;

Procedure crearMaestro(Var d: detail);
Begin

End;


Procedure leer();
Begin

End;

Procedure minimo();
Begin
End;


Procedure actualizarArchivoMaestro(Var m: master; d: detail);

Var 
  min: info;
  r: rDetalles;
  act,regM: maestro;
Begin
  reset(m);
  For i:= 1 To n Do
    Begin
      reset(d[i]);
      leer(d[i],r[i]);
    End;
  minimo(d,r,min);
  While (min.codLocalidad<>valorAlto) Do
    Begin
      act.codLocalidad := min.codLocalidad;
      While (act.codLocalidad=min.codLocalidad) Do
        Begin
          act.codCepa := min.codCepa;
          act.cantCasosR := 0;
          act.cantCasosF := 0;
          While (act.codLocalidad=min.codLocalidad)And (act.codCepa=min.codCepa)
            Do
            Begin
              act.cantCasosA := min.cantCasosA;
              act.cantCasosN := min.cantCasosN;
              act.cantCasosR := act.cantCasosR + min.cantCasosR;
              act.cantCasosF := act.cantCasosF + min.cantCasosF;
              minimo(d,r,min);
            End;
          While m.codCepa<>act.codCepa And m.codLocalidad Do
            read(m);

          seek(m,FilePos(m)-1);
          Write(m,act);
        End;
    End;
End;


Var 
  d: vDetalles;
  m: master;
Begin
  crearDetalle(d);
  crearMaestro(m);
  actualizarArchivoMaestro(m,d);
End.
