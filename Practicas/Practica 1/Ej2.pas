
Program ej2;

Type 
  archivo = file Of integer;

Procedure procesarArchivo(Var archivoInt: archivo);

Var 
  num,cantNum,may1500: integer;
  promedio: real;
Begin
  reset(archivoInt);
  promedio := 0;
  cantNum := 0;
  may1500 := 0;
  While Not eof(archivoInt) Do
    Begin
      cantNum := cantNum+1;
      read(archivoInt, num);
      promedio := promedio+num;
      If num < 1500 Then
        may1500 := may1500+1;

      writeln('Numero: ', num);
    End;
  Close(archivoInt);
  writeln('El promedio de los numeros es: ', promedio/cantNum:2:2);
  writeln('Cantidad de numeros menores a 1500: ', may1500);
End;


Var 
  archivoInt: archivo;
  nombre: string;
Begin
  readln(nombre);
  assign(archivoInt, nombre + '.dat');
  procesarArchivo(archivoInt);
  writeln('Fin del programa');
  readln;

End.
