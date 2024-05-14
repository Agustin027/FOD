
Program Ej4;

Const 
  valoralto = 'zzz';

Type 

  maestro = Record
    nombre : string;
    cantAlfabetizados : integer;
    totalEncuestados : integer;
  End;
  detalle = Record
    nombre : string;
    codLocalidad : integer;
    cantAlfabetizados : integer;
    cantEncuestados : integer;
  End;

  master = file Of maestro;
  detail = file Of detalle;




Procedure cargarArchivoMaestro(Var m: master);

Var 
  reg: maestro;
Begin
  writeln('Cargando archivo maestro...');
  assign(m, 'archivo_maestro.dat');
  rewrite(m);

  // Datos predefinidos para cargar en el archivo maestro
  reg.nombre := 'Buenos Aires';
  reg.cantAlfabetizados := 2000;
  reg.totalEncuestados := 2500;
  write(m, reg);

  reg.nombre := 'Cordoba';
  reg.cantAlfabetizados := 1800;
  reg.totalEncuestados := 2200;
  write(m, reg);

  reg.nombre := 'Santa Fe';
  reg.cantAlfabetizados := 1500;
  reg.totalEncuestados := 1900;
  write(m, reg);

  reg.nombre := 'Mendoza';
  reg.cantAlfabetizados := 1200;
  reg.totalEncuestados := 1500;
  write(m, reg);

  // Puedes agregar más provincias aquí si es necesario

  close(m);
  writeln('Archivo maestro cargado exitosamente.');
End;


Procedure cargarArchivoDetalle(Var d1, d2: detail);

Var 
  reg: detalle;
Begin
  writeln('Cargando archivos detalle...');
  assign(d1, 'archivo_detalle1.dat');
  rewrite(d1);

  assign(d2, 'archivo_detalle2.dat');
  rewrite(d2);

  // Datos predefinidos para cargar en el archivo detalle 1
  reg.nombre := 'Buenos Aires';
  reg.codLocalidad := 1;
  reg.cantAlfabetizados := 800;
  reg.cantEncuestados := 1000;
  write(d1, reg);

  reg.nombre := 'Buenos Aires';
  reg.codLocalidad := 2;
  reg.cantAlfabetizados := 1200;
  reg.cantEncuestados := 1500;
  write(d1, reg);

  reg.nombre := 'Cordoba';
  reg.codLocalidad := 1;
  reg.cantAlfabetizados := 700;
  reg.cantEncuestados := 900;
  write(d1, reg);

  reg.nombre := 'Cordoba';
  reg.codLocalidad := 2;
  reg.cantAlfabetizados := 1100;
  reg.cantEncuestados := 1300;
  write(d1, reg);

  // Puedes agregar más datos para el archivo detalle 1 aquí si es necesario

  // Datos predefinidos para cargar en el archivo detalle 2
  reg.nombre := 'Santa Fe';
  reg.codLocalidad := 1;
  reg.cantAlfabetizados := 600;
  reg.cantEncuestados := 800;
  write(d2, reg);

  reg.nombre := 'Santa Fe';
  reg.codLocalidad := 2;
  reg.cantAlfabetizados := 900;
  reg.cantEncuestados := 1100;
  write(d2, reg);

  reg.nombre := 'Mendoza';
  reg.codLocalidad := 1;
  reg.cantAlfabetizados := 500;
  reg.cantEncuestados := 700;
  write(d2, reg);

  reg.nombre := 'Mendoza';
  reg.codLocalidad := 2;
  reg.cantAlfabetizados := 700;
  reg.cantEncuestados := 800;
  write(d2, reg);

  // Puedes agregar más datos para el archivo detalle 2 aquí si es necesario

  close(d1);
  close(d2);
  writeln('Archivos detalle cargados exitosamente.');
End;


Procedure imprimirArchivoMaestro(Var m: master);

Var 
  reg: maestro;
  maxLongitudNombre: Integer;
Begin
  writeln('Imprimiendo archivo maestro...');
  reset(m);
  // Encuentra la longitud máxima del nombre de la provincia
  maxLongitudNombre := 0;
  While Not eof(m) Do
    Begin
      read(m, reg);
      If Length(reg.nombre) > maxLongitudNombre Then
        maxLongitudNombre := Length(reg.nombre);
    End;
  reset(m);
  // Reinicia el archivo maestro para volver a leer desde el principio

  // Imprime los encabezados
  writeln('Provincia':maxLongitudNombre+1,
          ' | Cant. alfabetizados | Total de encuestados');
  writeln(StringOfChar('-', maxLongitudNombre+1),
  ' | ------------------- | -------------------');

  // Imprime los registros
  While Not eof(m) Do
    Begin
      read(m, reg);
      writeln(reg.nombre: maxLongitudNombre+1,' | ', reg.cantAlfabetizados:20,
              ' | ', reg.totalEncuestados:20);
    End;

  close(m);
  writeln('Archivo maestro impreso exitosamente.');
  writeln('---------------------------------------------.');
End;

//--------------------------------------------------------------


Procedure  leer(Var archivo: detail; Var dato: detalle);
Begin
  If (Not eof(archivo)) Then
    read(archivo,dato)
  Else
    dato.nombre := valoralto;
End;

Procedure minimo(Var d,d2: detail; Var r1,r2,min: detalle);
Begin
  If (r1.nombre <= r2.nombre) Then
    Begin
      min := r1;
      leer(d,r1);
    End
  Else
    Begin
      min := r2;
      leer(d2,r2);
    End;
End;

Procedure actualizarMaestro(Var m: master; Var d: detail; Var d2: detail);

Var 
  regM: maestro;
  min,regD,regD2: detalle;
Begin
  reset(m);
  reset(d);
  reset(d2);
  leer(d,regD);
  leer(d2,regD2);
  minimo(d,d2,regD,regD2,min);
  While (min.nombre <> valoralto) Do
    Begin
      read(m,regM);
      While (regM.nombre <> min.nombre) Do
        Begin
          read(m,regM);
        End;
      While (regM.nombre = min.nombre) Do
        Begin
          regM.cantAlfabetizados := regM.cantAlfabetizados + min.
                                    cantAlfabetizados;
          regM.totalEncuestados := regM.totalEncuestados + min.
                                   cantEncuestados;
          minimo(d,d2,regD,regD2,min);
        End;
      seek(m,filepos(m)-1);
      write(m,regM);
    End;
  writeln('Archivo maestro actualizado exitosamente.');
  writeln('---------------------------------------------.');
  close(m);
  close(d);
  close(d2);
End;


Var 
  m: master;
  d: detail;
  d2: detail;
Begin
  cargarArchivoDetalle(d,d2);
  cargarArchivoMaestro(m);
  imprimirArchivoMaestro(m);
  actualizarMaestro(m,d,d2);
  imprimirArchivoMaestro(m);

End.
