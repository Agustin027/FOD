
Program Ej8;

Type 

  distro = Record
    nombre: string;
    anio: integer;
    nroKernel: integer;
    cantDevs: integer;
    desc: string;
  End;


  archivo = file Of distro;

Procedure leerDistro(Var d: distro);
Begin
  writeln('Ingrese el nombre de la distribucion');
  readln(d.nombre);
  If d.nombre <> 'ZZZ' Then
    Begin
      // writeln('Ingrese el anio de la distribucion');
      //readln(d.anio);
      d.anio := 2024;
      //writeln('Ingrese el numero de kernel de la distribucion');
      //radln(d.nroKernel);
      d.nroKernel := 5;
      writeln('Ingrese la cantidad de desarrolladores de la distribucion');
      readln(d.cantDevs);
      //writeln('Ingrese la descripcion de la distribucion');
      //readln(d.desc);
      d.desc := 'Descripcion de la distribucion';
    End;
End;



Procedure crearArchivo(Var a: archivo);

Var 
  d: distro;
Begin
  assign(a, 'distribuciones');
  rewrite(a);
  leerDistro(d);
  While d.nombre <> 'ZZZ' Do
    Begin
      write(a, d);
      leerDistro(d);
    End;
  close(a);
End;

Procedure imprimirArchivo(Var a: archivo);

Var 
  d: distro;
Begin
  reset (a);
  While Not eof(a) Do
    Begin
      read(a, d);
      writeln('Nombre de la distribucion: ', d.nombre);
      writeln('Anio de la distribucion: ', d.anio);
      writeln('Numero de kernel de la distribucion: ', d.nroKernel);
      writeln('Cantidad de desarrolladores de la distribucion: ', d.cantDevs);
      writeln('Descripcion de la distribucion: ', d.desc);
      writeln('------------------------------------');
    End;
  close(a);
End;


Function ExisteDistribucion(Var a: archivo): boolean;

Var 
  d: distro;
  nombre: string;
  ok: boolean;
Begin
  writeln('Ingresar el nombre de la distribucion a buscar');
  readln(nombre);
  reset(a);
  ok := false;
  While (Not eof(a)) And (Not ok) Do
    Begin
      read(a, d);
      If d.nombre = nombre Then
        ok := true;
    End;
  close(a);
  ExisteDistribucion := ok;
End;

Procedure AltaDistribucion(Var a: archivo);

Var 
  b,cabecera: distro;
Begin
  writeln('Ingrese los datos de la distribucion a dar de alta');
  leerDistro(b);
  reset(a);
  read(a, cabecera);
  If cabecera.cantDevs >= 0 Then
    Begin
      seek(a, filesize(a));
      write(a, b);
      writeln('no hay espacio libre en el archivo');
    End
  Else
    Begin
      seek(a, ((cabecera.cantDevs)*-1));
      read(a,cabecera);
      seek(a, filepos(a)-1);
      write(a, b);
      seek(a, 0);
      write(a, cabecera);
      writeln('Se ha dado de alta la distribucion en la posicion ', cabecera.
              cantDevs);
    End;
  close(a);

  imprimirArchivo(a);
End;

Procedure BajaDistribucion(Var a: archivo);

Var 
  cabecera, d: distro;
  nombre: string;
  pos: integer;
Begin
  writeln('Ingrese el nombre de la distribucion a dar de baja');
  readln(nombre);
  If ExisteDistribucion(a) Then
    Begin
      reset(a);
      read(a, cabecera);
      read(a, d);
      While d.nombre <> nombre Do
        read(a, d);
      If d.nombre = nombre Then
        Begin
          pos := filepos(a)-1;
          d := cabecera;
          seek(a, pos);
          write(a, d);
          cabecera.cantDevs := pos * -1;
          seek(a, 0);
          write(a, cabecera);
          writeln('Se ha dado de baja la distribucion');
        End
      Else
        writeln('La distribucion no existe');
    End;
End;

Procedure menu(Var a: archivo);

Var 
  opcion: integer;
Begin
  writeln('------------------------------------');
  writeln('Menu de opciones');
  writeln('Ingrese una opcion');
  writeln('1: Existe Distribucion');
  writeln('2: Alta Distribucion');
  writeln('3: Baja Distribucion');
  writeln('4: Salir');
  readln(opcion);
  writeln('------------------------------------');
  Case opcion Of 
    1: writeln(ExisteDistribucion(a));
    2: AltaDistribucion(a);
    3: BajaDistribucion(a);
    4: writeln('Saliendo del programa');
  End;
End;

Var 
  a: archivo;
Begin
  // crearArchivo(a);
  assign(a, 'distribuciones');
  imprimirArchivo(a);
  menu(a);

End.
