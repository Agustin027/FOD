
Program Ej2;
{$CODEPAGE UTF8}

Type 

  asistente = Record
    nro: integer;
    nombre : string;
    email : string;
    telefono : string;
    dni : string;
  End;




  archivo = file Of asistente;


Procedure crearArchivo(Var a: archivo);

Var 
  asist: asistente;
Begin
  assign(a, 'asistentes.dat');
  rewrite(a);
  writeln('Ingrese la información de los asistentes:');

  Repeat
    writeln('Nombre del asistente (o "fin" para terminar): ');
    readln(asist.nombre);
    If asist.nombre <> 'fin' Then
      Begin
        writeln('Número de asistente: ');
        readln(asist.nro);
        writeln('Email: ');
        readln(asist.email);
        writeln('Teléfono: ');
        readln(asist.telefono);
        writeln('D.N.I.: ');
        readln(asist.dni);

        write(a, asist);
      End;
  Until asist.nombre = 'fin';

  Close(a);
End;


Procedure imprimirArchivo(Var a: archivo);

Var 
  asist: asistente;
Begin
  assign(a, 'asistentes.dat');
  reset(a);

  writeln('Contenido del archivo:');
  writeln(


'Nro. Asistente | Nombre          | Email                   | Teléfono      | D.N.I.'
  );

  While Not eof(a) Do
    Begin
      read(a, asist);
      writeln(asist.nro:15, ' | ', asist.nombre:15, ' | ', asist.email:25, ' | '
              , asist.telefono:14, ' | ', asist.dni);
    End;

  Close(a);
End;




Procedure eliminar(Var a: archivo);

Var 
  asist: asistente;
Begin
  reset(a);

  While Not eof(a) Do
    Begin
      read(a, asist);
      If (asist.nro < 1000) Then
        Begin
          Seek(a, FilePos(a) - 1);
          asist.nombre := '@' + asist.nombre;
          write(a, asist);
        End;
    End;

  Close(a);
End;




Var 
  a: archivo;
Begin
  // crearArchivo(a);
  imprimirArchivo(a);
  eliminar(a);
  imprimirArchivo(a);
  readln;
End.
