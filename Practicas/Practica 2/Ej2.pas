
Program Ej2;

Const 
  valorAlto = 9999;

Type 

  alumno = Record
    cod: integer;
    apellido: string;
    nombre: string;
    cantMatSinF: integer;
    cantMatApr: integer;
  End;

  detalle = Record
    cod: integer;
    CoF: boolean;
  End;
  master = file Of alumno;
  detail = file Of detalle;


Procedure cargarArchivoMaestro(Var mast: master);

Var 
  reg: alumno;
Begin
  writeln('Cargando archivo maestro con datos aleatorios...');
  assign(mast, 'archivo_maestro.dat');
  rewrite(mast);

  reg.cod := 1;
  reg.apellido := 'Bannon';
  reg.nombre := 'Fernando';
  reg.cantMatSinF := Random(10);
  reg.cantMatApr := Random(10);
  write(mast, reg);

  reg.cod := 2;
  reg.apellido := 'Aldao';
  reg.nombre := 'Tomas';
  reg.cantMatSinF := Random(10);
  reg.cantMatApr := Random(10);
  write(mast, reg);

  reg.cod := 3;
  reg.apellido := 'Castillo';
  reg.nombre := 'Agustin';
  reg.cantMatSinF := Random(10);
  reg.cantMatApr := Random(10);
  write(mast, reg);

  reg.cod := 4;
  reg.apellido := 'Messi';
  reg.nombre := 'Lionel';
  reg.cantMatSinF := Random(10);
  reg.cantMatApr := Random(10);
  write(mast, reg);

  reg.cod := 5;
  reg.apellido := 'Ronaldo';
  reg.nombre := 'Cristiano';
  reg.cantMatSinF := Random(10);
  reg.cantMatApr := Random(10);
  write(mast, reg);

  close(mast);
  writeln('Archivo maestro cargado exitosamente.');
End;


Procedure cargarArchivoDetalle(Var det: detail);

Var 
  reg: detalle;
Begin
  writeln('Cargando archivo detalle con datos aleatorios...');
  assign(det, 'archivo_detalle.dat');
  rewrite(det);

  reg.cod := 1;
  reg.CoF := Random(2) = 1;
  write(det, reg);
  reg.cod := 1;
  reg.CoF := Random(2) = 1;
  write(det, reg);
  reg.cod := 1;
  reg.CoF := Random(2) = 1;
  write(det, reg);


  reg.cod := 2;
  reg.CoF := Random(2) = 1;
  write(det, reg);

  reg.cod := 3;
  reg.CoF := Random(2) = 1;
  write(det, reg);

  reg.cod := 4;
  reg.CoF := Random(2) = 1;
  write(det, reg);
  reg.cod := 4;
  reg.CoF := Random(2) = 1;
  write(det, reg);
  reg.cod := 4;
  reg.CoF := Random(2) = 1;
  write(det, reg);


  reg.cod := 5;
  reg.CoF := Random(2) = 1;
  write(det, reg);

  close(det);
  writeln('Archivo detalle cargado exitosamente.');
End;


Procedure imprimirArchivoMaestro(Var mast: master);

Var 
  reg: alumno;
Begin
  writeln('Imprimiendo archivo maestro...');
  assign(mast, 'archivo_maestro.dat');
  reset(mast);
  writeln('-----------------------------------------------------------');
  writeln('| Codigo |   Apellido   |   Nombre   | CantMatSinF | CantMatApr |');
  writeln('-----------------------------------------------------------');
  While Not eof(mast) Do
    Begin
      read(mast, reg);
      writeln('| ', reg.cod:7, ' | ', reg.apellido:12, ' | ', reg.nombre:10,
              ' | ', reg.cantMatSinF:11, ' | ', reg.cantMatApr:10, ' |');
    End;
  writeln('-----------------------------------------------------------');
  close(mast);
  writeln('Fin de archivo maestro.');
End;


Procedure leer(Var archivo: detail; Var dato: detalle);
Begin
  If (Not eof(archivo)) Then
    read(archivo, dato)
  Else
    dato.cod := valorAlto;
End;



Procedure actualizarArchivoMaestro(Var mae: master; Var det: detail);

Var 
  regM: alumno;
  regD: detalle;
Begin
  reset(mae);
  reset(det);
  read(mae, regM);
  leer(det, regD);
  While (regD.cod <> valorAlto) Do
    Begin
      regM.cod := regD.cod;
      While (regM.cod=regD.cod) Do
        Begin
          If (regD.CoF) Then
            Begin
              regM.cantMatApr := regM.cantMatApr + 1;
              regM.cantMatSinF := regM.cantMatSinF - 1;
            End
          Else
            regM.cantMatSinF := regM.cantMatSinF + 1;
          leer(det, regD);
        End;
      While (regM.cod <> regM.cod) Do
        read(mae, regM);
      seek(mae, filepos(mae) - 1);
      write(mae, regM);
      If Not eof(mae) Then
        read(mae, regM);
    End;
  close(mae);
  close(det);
End;



Procedure listarAlumnos(Var mast: master);

Var 
  reg: alumno;
  txt: Text;
Begin
  reset (mast);
  assign(txt, 'alumnosConMasMaterias.txt');
  rewrite(txt);
  While Not eof(mast) Do
    Begin
      read(mast, reg);
      If (reg.cantMatApr > reg.cantMatSinF) Then
        Begin
          writeln(txt, 'Codigo: ', reg.cod);
          writeln(txt, 'Apellido: ', reg.apellido);
          writeln(txt, 'Nombre: ', reg.nombre);
          writeln(txt, 'Cantidad de materias aprobadas: ', reg.cantMatApr);
          writeln(txt, 'Cantidad de materias sin final: ', reg.cantMatSinF);
          writeln(txt, '-----------------------------------');
        End;
    End;
  close(mast);
  close(txt);
End;




Procedure menu(Var mae: master; Var det: detail);

Var 
  opcion: char;
Begin
  writeln('Ingrese una opcion');
  writeln('A: Actualizar el archivo maestro');
  writeln('B: Listar alumnos que tengan mas materias con finales aprobados');
  readln(opcion);
  opcion := upcase(opcion);
  Case opcion Of 
    'A': actualizarArchivoMaestro(mae, det);
    'B': listarAlumnos(mae);
    Else
      writeln('Opcion incorrecta');
  End;
End;


Var 
  mast: master;
  det: detail;
Begin
  randomize;
  cargarArchivoMaestro(mast);
  cargarArchivoDetalle(det);
  imprimirArchivoMaestro(mast);
  writeln('-------------------------------------------------------');
  menu(mast, det);
  imprimirArchivoMaestro(mast);
End.
