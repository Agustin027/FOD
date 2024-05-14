
Program Ej8;

Uses 
SysUtils;

Const 
  valorAlto = 999;

Type 
  master = Record
    cod: integer;
    NyA: string;
    anio: integer;
    mes: 1..12;
    dia: 1..31;
    montoV: real;
  End;

  maestro = file Of master;

Procedure leer(Var archivo: maestro; Var dato: master);
Begin
  If (Not EOF(archivo)) Then
    read(archivo, dato)
  Else
    dato.cod := valorAlto;
End;

Procedure procesar(Var m: maestro);

Var 
  regM: master;
  totalVentas,totalMes,totalAnio: real;
  codAct,mesAct,anioAct: integer;
Begin
  assign(m, 'maestro');
  reset(m);
  leer(m, regM);
  totalVentas := 0;
  While (regM.cod <> valorAlto) Do
    Begin
      codAct := regM.cod;
      writeln('Codigo: ', codAct);
      While (codAct = regM.cod) Do
        Begin
          totalAnio := 0;
          writeln('anio: ', regM.anio);
          anioAct := regM.anio;
          While (codAct = regM.cod) And (anioAct = regM.anio) Do
            Begin
              writeln('mes: ', regM.mes);
              mesAct := regM.mes;
              totalMes := 0;
              While (codAct = regM.cod) And (anioAct = regM.anio) And (mesAct =
                    regM.mes) Do
                Begin
                  writeln('dia: ', regM.dia);
                  writeln('monto: ', regM.montoV:2:2);
                  totalMes := totalMes + regM.montoV;
                  leer(m, regM);
                End;
              writeln('Total mes: ', totalMes:2:2);
              totalAnio := totalAnio + totalMes;
            End;
          writeln('Total anio: ', totalAnio:2:2);
          totalVentas := totalVentas + totalAnio;
        End;
    End;
  writeln('Total ventas: ', totalVentas:2:2);
  close(m);
End;

Var 
  m: maestro;
Begin
  procesar(m);
End.
