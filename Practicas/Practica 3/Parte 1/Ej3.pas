
Program Ej3;
{$CODEPAGE UTF8}

Type 
  novela = Record
    codigo: integer;
    genero: string;
    nombre: string;
    duracion: real;
    director: string;
    precio: real;
  End;


  archivo = file Of novela;

Procedure leerNovela(Var n:novela);
Begin
  writeln('Ingrese el codigo de la novela');
  readln(n.codigo);
  If (n.codigo <> -1) Then
    Begin
      writeln('Ingrese el genero de la novela');
      readln(n.genero);
      writeln('Ingrese el nombre de la novela');
      readln(n.nombre);
      writeln('Ingrese la duracion de la novela');
      readln(n.duracion);
      writeln('Ingrese el director de la novela');
      readln(n.director);
      writeln('Ingrese el precio de la novela');
      readln(n.precio);
    End;

End;



Procedure alta(Var a:archivo);

Var 
  n: novela;
  regN: novela;
Begin
  reset(a);
  read(a,n);
  If n.codigo = 0 Then
    Begin
      seek(a, filesize(a));
      leerNovela(n);
      write(a,n);
    End
  Else
    Begin
      n.codigo := n.codigo * -1;
      seek(a,n.codigo);
      read(a,regN);

      seek(a,filepos(a)-1);
      leerNovela(n);
      write(a,n);


      seek(a,0);
      write(a,regN);
    End;
  close(a);
End;


Procedure modificar(Var a:archivo);

Var 
  codigo: integer;
  n: novela;
  ok: boolean;
Begin
  ok := false;
  reset(a);
  writeln('Ingrese el codigo de la novela a modificar');
  readln(codigo);
  While Not eof(a) And Not ok Do
    Begin
      read(a,n);
      If codigo = n.codigo Then
        Begin
          leerNovela(n);
          seek(a,filepos(a)-1);
          write(a,n);
          ok := true;
        End;
    End;
  close(a);
End;


Procedure baja(Var a: archivo);

Var 
  n, cabecera: novela;
  num, pos: integer;
Begin
  reset(a);
  read(a, cabecera);
  writeln('Ingrese el código de la novela a eliminar:');
  readln(num);
  read(a, n);
  While (n.codigo <> num) And (Not EOF(a)) Do
    read(a, n);
  If n.codigo = num Then
    Begin
      pos := filepos(a) - 1;
      n := cabecera;
      seek(a, pos);
      write(a, n);
      cabecera.codigo := -pos;
      seek(a, 0);
      write(a, cabecera);
      writeln('Novela eliminada correctamente.');
    End
  Else
    writeln('No se encuentra el código.');

  close(a);
End;


Procedure menu(Var a:archivo);

Var 
  opcion: integer;
  nombre: string;
Begin
  writeln('Ingrese el nombre del archivo');
  readln(nombre);
  assign(a, nombre);
  reset(a);
  writeln('------------------------------------ ');
  writeln('Seleccione una opcion');

  writeln('1.Dar de alta una novela');
  writeln('2.Modificar datos de una novela');
  writeln('3.Eliminar una novela');
  readln(opcion);
  writeln('------------------------------------ ');

  Case opcion Of 
    1: alta(a);
    2: modificar(a);
    3: baja(a);
  End;
End;



Procedure crearArchivo(Var a:archivo);

Var 
  nombre: string;
  n: novela;
Begin
  writeln('Creando archivo');
  writeln('Ingrese el nombre del archivo');
  readln(nombre);
  assign(a, nombre);
  rewrite(a);
  n.codigo := 0;
  write(a, n);
  While (n.codigo <> -1) Do
    Begin
      leerNovela(n);
      If (n.codigo <> -1) Then
        Begin
          write(a, n);
        End;
    End;
End;


Procedure listarNovelas(Var a:archivo);

Var 
  n: novela;
Begin
  assign(a, 'Novelas');
  reset(a);
  writeln('------------------------------------ ');
  writeln('Listando novelas:');
  While Not eof(a) Do
    Begin
      read(a, n);
      writeln('------------------------------------');
      writeln('Código: ', n.codigo);
      writeln('Género: ', n.genero);
      writeln('Nombre: ', n.nombre);
      writeln('Duración: ', n.duracion:0:2);
      // Mostrar la duración con dos decimales
      writeln('Director: ', n.director);
      writeln('Precio: ', n.precio:0:2);
      // Mostrar el precio con dos decimales
    End;
  close(a);
End;

Procedure exportarATxt(Var arch: archivo);

Var 
  novelasTxt: Text;
  n: novela;
Begin
  Assign(arch, 'Novelas');
  Assign(novelasTxt, 'novelas.txt');
  Rewrite(novelasTxt);
  Reset(arch);
  While Not EOF(arch) Do
    Begin
      Read(arch, n);
      writeln(novelasTxt, 'Código: ', n.codigo);
      writeln(novelasTxt, 'Género: ', n.genero);
      writeln(novelasTxt, 'Nombre: ', n.nombre);
      writeln(novelasTxt, 'Duración: ', n.duracion:0:2, ' minutos');
      writeln(novelasTxt, 'Director: ', n.director);
      writeln(novelasTxt, 'Precio: $', n.precio:0:2);
      writeln(novelasTxt, '---');
    End;
  Close(arch);
  Close(novelasTxt);
  writeln('Lista de novelas guardada en "novelas.txt".');
End;



Procedure mainMenu(Var a:archivo);

Var 
  opcion: integer;
Begin
  writeln('------------------------------------ ');
  writeln('Menu principal');
  writeln('Seleccione una opcion');
  writeln('1. Crear archivo');
  writeln('2. Abrir archivo');
  writeln('3. Listar Novelas');
  writeln('4. Exportar a txt');
  readln(opcion);
  writeln('------------------------------------ ');
  Case 
       opcion Of 
    1: crearArchivo(a);
    2: menu(a);
    3: listarNovelas(a);
    4: exportarATxt(a);
  End;
End;


Var 
  a: archivo;
Begin
  mainMenu(a);

End.
