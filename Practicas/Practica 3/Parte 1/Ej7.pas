
Program Ej7;

Type 
  aves = Record
    codigo: integer;
    nombre: string;
    familia: string;
    descripcion: string;
    zonaG: string;
  End;




  archivo = file Of aves;



Procedure leerAve(Var ave: aves);
Begin
  writeln('Ingrese el codigo de la especie');
  readln(ave.codigo);
  If (ave.codigo <> -1) Then
    Begin
      //writeln('Ingrese el nombre de la especie');
      // readln(ave.nombre);
      ave.nombre := 'xD';
      //writeln('Ingrese la familia de la especie');
      //readln(ave.familia);
      ave.familia := 'Bolivianos';
      //writeln('Ingrese la descripcion de la especie');
      //readln(ave.descripcion);
      ave.descripcion := '???';
      //writeln('Ingrese la zona geografica de la especie');
      //readln(ave.zonaG);
      ave.zonaG := 'Bolivia';
    End;
End;

Procedure crearArchivo(Var a: archivo);

Var 
  ave: aves;
Begin
  assign(a, 'aves');
  rewrite(a);
  leerAve(ave);
  While ave.codigo <> -1 Do
    Begin
      write(a, ave);
      leerAve(ave);
    End;
  close(a);
End;


Procedure imprimirArchivo(Var a: archivo);

Var 
  ave: aves;
Begin
  reset(a);
  read(a, ave);
  While (Not Eof(a)) Do
    Begin
      writeln('Codigo: ', ave.codigo);
      writeln('Nombre: ', ave.nombre);
      writeln('Familia: ', ave.familia);
      writeln('Descripcion: ', ave.descripcion);
      writeln('Zona geografica: ', ave.zonaG);
      writeln('---------------------------------');
      read(a, ave);
    End;
  close(a);
End;



//Falta revisar el caso en el que el tenga que eliminar el ultimo registro
Procedure compactar(Var a:archivo);

Var 
  ultimo,actual: aves;
  pos: integer;
Begin


  reset(a);
  read(a,actual);

  While Not eof(a) Do
    Begin
      If (actual.nombre =('***')) Then
        Begin
          writeln('Entre al if');
          pos := filepos(a)-1;
          seek(a,filesize(a)-1);
          read(a,ultimo);
          seek(a,pos);
          write(a,ultimo);
          seek(a,filesize(a)-1);
          truncate(a);
          writeln('Se elimino la especie ',actual.codigo);
          seek(a,pos);
        End;
      read(a,actual);

    End;
  writeln('Compactacion realizada');
End;






Procedure marcar(Var a:archivo; codigo:integer);

Var 
  ave: aves;
Begin
  reset(a);
  read(a, ave);
  While (ave.codigo<>codigo) And (Not eof(a)) Do
    read(a, ave);
  If ave.codigo = codigo Then
    Begin
      ave.nombre := '***';
      seek(a, filepos(a)-1);
      write(a, ave);
      writeln('Especie',ave.codigo,'marcada');
    End
  Else
    writeln('Especie no encontrada');
End;


Procedure eliminarEspecie(Var a: archivo);

Var 
  ave: aves;
  codigo: integer;
  pos: integer;
Begin
  writeln('Ingrese el codigo de la especie a eliminar');
  readln(codigo);
  While codigo <> 5000 Do
    Begin
      marcar(a,codigo);
      writeln('Ingrese el codigo de la especie a eliminar');
      readln(codigo);
    End;
  compactar(a);
  close(a);
End;

Var 
  a: archivo;
Begin
  crearArchivo(a);
  assign(a, 'aves');
  imprimirArchivo(a);
  eliminarEspecie(a);
  imprimirArchivo(a);
End.
