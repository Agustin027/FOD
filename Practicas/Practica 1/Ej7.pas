
Program Ej7;

Type 
  novela = Record
    cod: integer;
    nombre: string;
    genero: string;
    precio: real;
  End;

  archivo = file Of novela;

Procedure assignBin(Var archivoBin: archivo);

Var 
  nombre: string;
Begin
  writeln('Ingrese el nombre del archivo binario: ');
  readln(nombre);
  assign(archivoBin, nombre);
End;

Procedure crearArchivo(Var archivoBin: archivo);

Var 
  n: novela;
  txt: Text;
Begin
  assignBin(archivoBin);
  rewrite(archivoBin);
  assign(txt, 'novelas.txt');
  reset(txt);
  While Not eof(txt) Do
    Begin
      With n Do
        Begin
          readln(txt, cod, precio, genero);
          readln(txt, nombre);
        End;
      write(archivoBin, n);
    End;
  close(archivoBin);
  close(txt);
End;

Procedure leernovela(Var n: novela);
Begin
  writeln('Ingrese el codigo de la novela');
  readln(n.cod);
  writeln('Ingrese el nombre de la novela');
  readln(n.nombre);
  writeln('Ingrese el genero de la novela');
  readln(n.genero);
  writeln('Ingrese el precio de la novela');
  readln(n.precio);

End;
Procedure agregarNovela(Var archivoBin: archivo);

Var 
  n: novela;
Begin
  leerNovela(n);
  seek(archivoBin, filesize(archivoBin));
  write(archivoBin, n);
  writeln('Novela agregada');
End;
Procedure modificarNovela(Var archivoBin: archivo);

Var 
  buscar: integer;
  ok: boolean;
  n: novela;
Begin
  writeln('Ingrese el codigo de la novela a modificar');
  readln(buscar);
  ok := false;
  While Not eof(archivoBin)And Not ok Do
    Begin
      read(archivoBin, n);
      If n.cod=buscar Then
        Begin
          ok := true;
          writeln('Ingrese el nuevo nombre de la novela');
          readln(n.nombre);
          writeln('Ingrese el nuevo genero de la novela');
          readln(n.genero);
          writeln('Ingrese el nuevo precio de la novela');
          readln(n.precio);
          seek(archivoBin, filepos(archivoBin)-1);
          write(archivoBin, n);
        End;
    End;
  If ok Then
    writeln('Novela modificada')
  Else
    writeln('Novela no encontrada');
End;
Procedure actualizarArchivo(Var archivoBin: archivo);

Var 
  opcion: integer;
Begin
  assignBin(archivoBin);
  reset(archivoBin);
  writeln('1. Agregar novela');
  writeln('2. Modificar novela');
  readln(opcion);
  Case opcion Of 
    1: agregarNovela(archivoBin);
    2: modificarNovela(archivoBin);
    Else
      writeln('Opcion incorrecta');
  End;
  close(archivoBin);
End;

Procedure imprimirArchivo(Var archivoBin: archivo);

Var 
  n: novela;
Begin
  assignBin(archivoBin);
  reset(archivoBin);
  While Not eof(archivoBin) Do
    Begin
      read(archivoBin, n);
      writeln('Codigo: ', n.cod);
      writeln('Nombre: ', n.nombre);
      writeln('Genero: ', n.genero);
      writeln('Precio: ', n.precio:0:2);
    End;
  close(archivoBin);
End;



Procedure menu(Var archivoBin: archivo);

Var 
  opcion: integer;
Begin
  writeln('1. Crear archivo');
  writeln('2. Actualizar binario');
  writeln('3. Imprimir archivo');
  readln(opcion);
  Case opcion Of 
    1: crearArchivo(archivoBin);
    2: actualizarArchivo(archivoBin);
    3: imprimirArchivo(archivoBin);

    Else
      writeln('Opcion incorrecta');
  End;
End;

Var 
  archivoBin: archivo;
Begin
  menu(archivoBin);
End.
