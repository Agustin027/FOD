
Program Ej1;

Type 
  archivo = file Of integer;

Procedure leer(Var num:integer);
Begin
  writeln('Ingrese un numero');
  readln(num);
End;

Procedure crearArchivo(Var archivoInt:archivo);

Var 
  nombre: string;
Begin
  writeln('Ingrese el nombre del archivo');
  readln(nombre);
  assign(archivoInt, nombre+'.dat');
  rewrite(archivoInt);
End;

Var 
  archivoInt : archivo;
  num : integer;
Begin
  crearArchivo(archivoInt);
  leer(num);
  While (num <> 0) Do
    Begin
      write(archivoInt, num);
      leer(num);
    End;
  close(archivoInt);






{ Esto es para leer el archivo y mostrarlo en pantalla
  reset(archivoInt;
  While Not eof(archivoInt Do
    Begin
      read(archivoInt num);
      writeln(num);
    End;
  close(archivoInt);
  }
  writeln('Fin del programa');
  readln;
End.
