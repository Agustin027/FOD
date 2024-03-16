
Program Ej6;

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

Function sino(): boolean;

Var 
  cont: string;
Begin
  Repeat
    writeln('(Y/N)');
    readln(cont);
    cont := upcase(cont);
    If cont='Y' Then
      sino := true
    Else If cont='N' Then
           sino := false
    Else
      Begin
        writeln('Opcion incorrecta');
        sino := false;
      End;
  Until (cont='Y') Or (cont='N');
End;

Procedure leerCelular(Var c: celulares);
Begin
  writeln('Ingrese el codigo del celular: ');
  readln(c.cod);
  writeln('Ingrese el nombre del celular: ');
  readln(c.nombre);
  writeln('Ingrese la descripcion del celular: ');
  readln(c.descripcion);
  writeln('Ingrese la marca del celular: ');
  readln(c.marca);
  writeln('Ingrese el precio del celular: ');
  readln(c.precio);
  writeln('Ingrese el stock minimo del celular: ');
  readln(c.stockMin);
  writeln('Ingrese el stock del celular: ');
  readln(c.stock);
End;

Procedure agregarCelular(Var archivo: archivoBin);

Var 
  ok: boolean;
  c: celulares;
Begin
  ok := true;
  abrirArchivo(archivo);
  While ok Do
    Begin
      leerCelular(c);
      seek(archivo, filesize(archivo));
      write(archivo, c);
      writeln('Desea agregar otro celular?');
      ok := sino();
    End;
End;



Procedure modificarStock(Var archivo: archivoBin);

Var 
  c: celulares;
  ok: boolean;
  buscar: string;
Begin
  abrirArchivo(archivo);

  writeln('Ingrese el nombre del celular a modificar: ');
  readln(buscar);
  ok := false;
  While Not eof(archivo) And Not ok Do
    Begin
      Read(archivo, c);
      If buscar = c.nombre Then
        Begin
          writeln('Ingrese el nuevo stock: ');
          readln(c.stock);
          seek(archivo, filepos(archivo)-1);
          write(archivo, c);
          ok := true;
        End;

    End;
  If ok Then
    writeln('Stock modificado con exito')
  Else
    writeln('No se encontro el celular');
End;


Procedure exportarSinStock(Var archivo: archivoBin);

Var 
  texto: Text;
  nombre: string;
  c: celulares;
Begin

  abrirArchivo(archivo);
  writeln('Ingrese el nombre del archivo de texto: ');
  readln(nombre);
  assign(texto, nombre);
  rewrite(texto);
  While Not eof(archivo) Do
    Begin
      read(archivo, c);
      If c.stock = 0 Then
        With c Do
          Begin
            writeln(texto, cod);
            writeln(texto, nombre);
            writeln(texto, descripcion);
            writeln(texto, marca);
            writeln(texto, precio:0:2);
            writeln(texto, stockMin);
            writeln(texto, stock);
            writeln('');
          End;
    End;
  close(texto);
  close(archivo);
End;








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
  writeln('5:Agregar un celular al archivo');
  writeln('--------------------------------------------------------');
  writeln('6:Modificar el stock de un celular');
  writeln('--------------------------------------------------------');
  writeln('7:Exportar a un archivo de texto los celulares con stock 0');
  writeln('--------------------------------------------------------');
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
    '5': agregarCelular(archivo);
    '6': modificarStock(archivo);
    '7': exportarSinStock(archivo);
    Else
      writeln('Opcion Incorrecta');
  End;
End;

Var 
  archivo: archivoBin;
Begin
  menu(archivo);
End.
