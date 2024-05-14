
Program Ej6;

Uses 
SysUtils;

Const 
  valorAlto = 9999;

Type 

  detalle = Record
    cod_usuario: integer;
    fecha: string;
    tiempo_sesion: integer;
  End;

  maestro = Record
    cod_usuario: integer;
    fecha: string;
    tiempo_total: integer;
  End;

  master = File Of maestro;
  detail = File Of detalle;


  ArrayDetalle = Array[1..5] Of detail;
  ArrayRegistros = Array[1..5] Of detalle;

Procedure crearDetalle(Var d: ArrayDetalle);

Var 
  i, j: Integer;
  nombreArchivo: String;
  reg: detalle;
Begin
  // Cargar datos predefinidos en los archivos de detalle
  For i := 1 To 5 Do
    Begin
      nombreArchivo := 'detalle_' + IntToStr(i) + '.dat';
      assign(d[i], nombreArchivo);
      rewrite(d[i]);

      // Generar datos de ejemplo para cada archivo de detalle
      For j := 1 To 3 Do
        Begin
          reg.cod_usuario := i;
          // Códigos de usuario aleatorios entre 1 y 10
          reg.fecha := '2024-04-' + IntToStr(Random(30) + 1);
          // Fechas aleatorias en abril de 2024
          reg.tiempo_sesion := Random(180) + 1;
          // Tiempo de sesión aleatorio entre 1 y 180 minutos
          write(d[i], reg);
        End;

      close(d[i]);
      // Cerrar el archivo de detalle
    End;
  writeln('Archivos detalle creados exitosamente.');
End;




Procedure leer(Var d: detail; Var r: detalle);
Begin
  If Not eof(d) Then
    read(d,r)
  Else
    Begin
      r.cod_usuario := valorAlto;
      r.fecha := 'ZZZ';
    End;
End;

Procedure minimo(Var d:ArrayDetalle;Var r: ArrayRegistros; Var min:detalle);

Var 
  i,minI: integer;
Begin
  minI := 0;
  min.cod_usuario := valorAlto;
  min.fecha := 'ZZZ';
  For i:=1 To 5 Do
    Begin
      If (r[i].cod_usuario < min.cod_usuario) And (r[i].fecha<min.fecha) Then
        Begin
          min := r[i];
          minI := i;
        End;
    End;

  If (minI<>0) Then
    leer(d[minI], r[minI]);

End;

Procedure generarMaestro(Var m: master; d: ArrayDetalle);

Var 
  i: integer;
  regD: ArrayRegistros;
  min: detalle;
  act: maestro;
Begin
  assign(m, 'maestro');
  rewrite(m);
  writeln('Archivo maestro creado exitosamente.');
  For i:= 1 To 5 Do
    Begin
      reset(d[i]);
      leer(d[i], regD[i]);
    End;
  writeln('Archivos detalle abiertos exitosamente.');
  minimo(d, regD, min);
  writeln('Minimo leido exitosamente.');
  While (min.cod_usuario<>valorAlto) Do
    Begin
      act.cod_usuario := min.cod_usuario;
      While (act.cod_usuario=min.cod_usuario) Do
        Begin
          act.fecha := min.fecha;
          act.tiempo_total := 0;
          While (min.cod_usuario = act.cod_usuario) And (min.fecha = act.fecha) 
            Do
            Begin
              act.tiempo_total := act.tiempo_total + min.tiempo_sesion;
              minimo(d, regD, min);
            End;
          write(m, act);
        End;
    End;
  close(m);
  For i:= 1 To 5 Do
    close(d[i]);
  writeln('Archivos cerrados exitosamente.');
End;


Procedure imprimirDetalle(Var d: detail);

Var 
  reg: detalle;
Begin
  writeln('Imprimiendo archivo detalle...');
  reset(d);
  // Imprime los encabezados
  writeln('Cod. Usuario | Fecha | Tiempo de Sesión');
  writeln('----------------------------------------');

  // Imprime los registros
  While Not eof(d) Do
    Begin
      read(d, reg);
      writeln(reg.cod_usuario, ' | ', reg.fecha, ' | ', reg.tiempo_sesion);
    End;

  close(d);
  writeln('Archivo detalle impreso exitosamente.');
End;

Procedure imprimirMaestro(Var m: master);

Var 
  reg: maestro;
Begin
  writeln('Imprimiendo archivo maestro...');
  reset(m);
  // Imprime los encabezados
  writeln('Cod. Usuario | Fecha | Tiempo Total');
  writeln('-----------------------------------');

  // Imprime los registros
  While Not eof(m) Do
    Begin
      read(m, reg);
      writeln(reg.cod_usuario, ' | ', reg.fecha, ' | ', reg.tiempo_total);
    End;

  close(m);
  writeln('Archivo maestro impreso exitosamente.');
End;



Var 
  m: master;
  d: ArrayDetalle;
Begin
  crearDetalle(d);
  generarMaestro(m,d);
  imprimirMaestro(m);
End.
