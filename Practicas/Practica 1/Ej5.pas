
Program Ej5;

Type 

  celulares = Record
    cod: integer;
    nombre: string;
    descripcion: string;
    marca: string;
    precio: real;
    stockMin: integer;
    stock: integer;
  End;

  archivoBin = file Of celulares;


Procedure opciones;
Begin
  writeln('Menu de opciones');
  writeln('--------------------------------------------------------');
  writeln('1:Crear archivo');
  writeln('--------------------------------------------------------');

  writeln('2: Listar en pantalla celulares con stock menor al minimo.');
  writeln('--------------------------------------------------------');

  writeln('3:Listar en pantalla los celulares del archivo cuya descripcion');
  writeln('contenga una cadena de caracteres proporcionada por el usuario');
  writeln('--------------------------------------------------------');
  writeln('4:Exportar el archivo creado a un TXT');
  writeln('--------------------------------------------------------');
  writeln('Ingrese la opcion deseada: ');

End;

Procedure crearArchivo(Var archivo: archivoBin);

Var 
  c: celulares;
  celularesTxt: Text;
  name: string;
Begin
  assign(celularesTxt, 'celulares.txt');
  reset(celularesTxt);

  writeln('Ingrese nombre de archivo binario:');
  readln(name);
  assign(archivo, name);
  rewrite(archivo);
  While Not eof(celularesTxt) Do
    Begin
      With c Do
        Begin
          readln(celularesTxt, cod);
          readln(celularesTxt, nombre);
          readln(celularesTxt, descripcion);
          readln(celularesTxt, marca);
          readln(celularesTxt, precio);
          readln(celularesTxt, stockMin);
          readln(celularesTxt, stock);
        End;
      write(archivo, c);
    End;

  close(celularesTxt);
  close(archivo);
  writeln('Archivo creado con exito');
End;

Procedure abrirArchivo(Var archivo: archivoBin);

Var 
  nombre: string;
Begin
  writeln('Ingrese nombre de archivo binario:');
  readln(nombre);
  assign(archivo, nombre);
  reset(archivo);

End;

Procedure imprimir(c: celulares);
Begin
  writeln('Codigo: ', c.cod);
  writeln('Nombre: ', c.nombre);
  writeln('Descripcion: ', c.descripcion);
  writeln('Marca: ', c.marca);
  writeln('Precio: ', c.precio:0:2);
  writeln('Stock Minimo: ', c.stockMin);
  writeln('Stock: ', c.stock);
  writeln('---------------------------------');
End;

Procedure listarEnPantalla(Var archivo: archivoBin);

Var 
  c: celulares;
Begin
  abrirArchivo(archivo);
  While Not eof(archivo) Do
    Begin
      read(archivo, c);
      If c.stock < c.stockMin Then
        imprimir(c);
    End;
  close(archivo);
End;

Procedure ListarConString(Var archivo: archivoBin);

Var 
  buscar: string;
  c: celulares;
  ok: boolean;
Begin
  ok := false;
  abrirArchivo(archivo);
  read(archivo, c);
  writeln('Ingrese la cadena de caracteres a buscar: ');
  readln(buscar);
  While Not eof(archivo) Do
    Begin
      read(archivo, c);
      If (buscar = c.descripcion) Or (buscar = c.nombre) Or (buscar =
         c.marca)  Then
        Begin
          imprimir(c);
          ok := true;
        End;
    End;
  If ok = false Then
    writeln('No se encontro la cadena de caracteres');
  close(archivo);

End;

Procedure exportarATexto(Var archivo: archivoBin);

Var 
  c: celulares;
  nombre: string;
  txt: Text;
Begin
  abrirArchivo(archivo);
  writeln('Ingrese nombre del archivo de texto: ');
  readln(nombre);
  assign(txt, nombre+ '.txt');
  rewrite(txt);
  While Not eof(archivo) Do
    Begin
      read(archivo, c);
      With c Do
        Begin
          writeln(txt, cod);
          writeln(txt, nombre);
          writeln(txt, descripcion);
          writeln(txt, marca);
          writeln(txt, precio:0:2);
          writeln(txt, stockMin);
          writeln(txt, stock);
          writeln('');

        End;

    End;
  close(txt);
  close(archivo);
  writeln('Archivo exportado con exito');
End;


Procedure menu(Var archivo: archivoBin);

Var 
  opcion: string;
Begin
  opciones;
  readln(opcion);
  writeln('---------------------------------');
  Case opcion Of 
    '1': crearArchivo(archivo);
    '2': listarEnPantalla(archivo);
    '3': ListarConString(archivo);
    '4': exportarATexto(archivo);
    Else
      writeln('Opcion Incorrecta');
  End;
End;

Var 
  archivo: archivoBin;
Begin
  menu(archivo);
End.
