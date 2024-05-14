
Program Ej4;

Type 
  reg_flor = Record
    nombre: String[45];
    codigo: integer;
  End;
  tArchFlores = file Of reg_flor;



Procedure leerFlor(Var f: reg_flor);
Begin
  writeln('Ingrese el codigo de la flor');
  readln(f.codigo);
  If f.codigo<>-1 Then
    Begin
      writeln('Ingrese el nombre de la flor');
      readln(f.nombre);

    End;

End;



Procedure crearArchivo(Var a: tArchFlores);

Var 
  f: reg_flor;
Begin
  assign(a,'flores');
  rewrite(a);
  f.codigo := 0;
  write(a,f);
  leerFlor(f);
  While f.codigo<>-1 Do
    Begin
      write(a,f);
      leerFlor(f);
    End;
  close(a);
End;

Procedure  agregarFlor(Var a: tArchFlores ; nombre: String;codigo:integer);

Var 
  cabecera,flor: reg_flor;
Begin
  assign(a,'flores');

  reset(a);
  read(a,cabecera);
  If cabecera.codigo = 0 Then
    Begin
      flor.nombre := nombre;
      flor.codigo := codigo;
      seek(a,filesize(a));
      write(a,flor);
    End
  Else
    Begin
      cabecera.codigo := cabecera.codigo * -1;
      seek(a,cabecera.codigo);
      read(a,cabecera);

      seek(a,filepos(a)-1);
      flor.nombre := nombre;
      flor.codigo := codigo;
      write(a,flor);


      seek(a,0);
      write(a,cabecera);

    End;
  close (a);
End;

Procedure listarFlores(Var a: tArchFlores);

Var 
  r: reg_flor;
Begin
  assign(a,'flores');

  reset(a);
  While Not eof(a) Do
    Begin
      Read(a,r);
      If r.codigo>0   Then
        Begin
          writeln('Nombre: ',r.nombre);
          writeln('Codigo: ',r.codigo);
          writeln('-------------------')
        End;
    End;
  close(a);
End;

Procedure MainMenu();

Var 
  a: tArchFlores;
  f: reg_flor;
  opcion: integer;
Begin
  writeln('Bienvenido al programa de flores');
  writeln('------------------');

  writeln('Menu de opciones');
  writeln('------------------');
  writeln('1. Crear Archivo');
  writeln('2. Agregar Flor');
  writeln('3. Listar Flores');
  readln(opcion);
  writeln('------------------');
  Case opcion Of 
    1: crearArchivo(a);
    2:
       Begin
         leerFlor(f);
         agregarFlor(a,f.nombre,f.codigo);
       End;
    3: listarFlores(a);
  End;
End;

Begin
  MainMenu();
End.
