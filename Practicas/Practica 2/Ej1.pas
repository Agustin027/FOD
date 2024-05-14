
Program Ej1;

Uses 
SysUtils;

Const 
  valorAlto = 9999;

Type 
  empleado = Record
    cod: integer;
    nombre: string;
    comision: real;
  End;
  maestro = file Of empleado;
  detalle = file Of empleado;

Procedure leer(Var archivo: detalle; Var dato: empleado);
Begin
  If Not EOF(archivo) Then
    read(archivo, dato)
  Else
    dato.cod := valorAlto;
End;

Procedure procesar(Var mae : maestro; Var det : detalle);

Var 
  empD, empM: empleado;
  total: real;
Begin
  assign(mae, 'maestro');
  assign(det, 'detalle');
  rewrite(mae);
  reset(det);
  leer(det, empD);
  While empD.cod <> valorAlto Do
    Begin
      total := 0;
      empM.cod := empD.cod;
      empM.nombre := empD.nombre;
      While empD.cod = empM.cod Do
        Begin
          total := total + empD.comision;
          leer(det, empD);
        End;
      empM.comision := total;
      write(mae, empM);
    End;
  close(mae);
  close(det);
End;


Procedure cargar(Var det: detalle);

Var 
  emp: empleado;
  i: integer;
Begin
  assign(det, 'detalle');
  rewrite(det);
  For i := 1 To 7 Do
    Begin
      emp.cod := i;
      emp.nombre := 'Empleado ' + IntToStr(i);
      emp.comision := 1000.00 + random(1000);
      write(det, emp);
    End;
  emp.cod := 32;
  emp.nombre := 'Fer Bannon';
  emp.comision := 2000.00;
  write(det, emp);

  emp.cod := 7;
  emp.nombre := 'Agustin Castillo';
  emp.comision := 1500.00;
  write(det, emp);


  emp.cod := 7;
  emp.nombre := 'Agustin Castillo';
  emp.comision := 1500.00;
  write(det, emp);

  emp.cod := 15;
  emp.nombre := 'Tomas Aldao';
  emp.comision := 1500.00;
  write(det, emp);

  close(det);

End;

Procedure imprimir(Var mae: maestro);

Var 
  emp: empleado;
Begin
  reset(mae);
  While Not eof(mae) Do
    Begin
      read(mae, emp);
      writeln('Codigo: ', emp.cod);
      writeln('Nombre: ', emp.nombre);
      writeln('Comision: ', emp.comision:0:2);
      writeln('----------------------------');
    End;
  close(mae);
End;

Var 
  mae: maestro;
  det: detalle;
Begin
  cargar(det);
  writeln('Archivo detalle cargado');
  procesar(mae, det);
  writeln('Archivo maestro generado');
  writeln('----------------------------');
  imprimir(mae);
End.
