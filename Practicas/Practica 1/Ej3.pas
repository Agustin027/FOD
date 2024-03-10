
Program Ej3;

Type 
  empleado = Record
    nro: integer;
    apellido: string;
    nombre: string;
    edad: integer;
    dni: integer;
  End;

  archivo = file Of empleado;


Procedure leerEmpleado(Var e: empleado);
Begin
  writeln('Ingrese el apellido del empleado');
  readln(e.apellido);
  If e.apellido<>'fin' Then
    Begin
      writeln('Ingrese el nombre del empleado');
      readln(e.nombre);

      writeln('Ingrese el nro del empleado');
      readln(e.nro);

      writeln('Ingrese la edad del empleado');
      readln(e.edad);

      writeln('Ingrese el dni del empleado');
      readln(e.dni);
    End;
End;

Procedure cargarEmpleados(Var archivoEmpleado:archivo);

Var 
  e: empleado;
Begin
  leerEmpleado(e);
  While (e.apellido <>'fin') Do
    Begin
      write(archivoEmpleado, e);
      leerEmpleado(e);
    End;
End;
Procedure crearArchivo(Var archivoEmpleado:archivo);

Var 
  nombreArchivo: string;
Begin
  writeln('Ingrese el nombre del archivo');
  readln(nombreArchivo);
  assign(archivoEmpleado, nombreArchivo + '.dat');
  rewrite(archivoEmpleado);
  cargarEmpleados(archivoEmpleado);
  close(archivoEmpleado);
End;

Procedure mostrarEmpleado(e: empleado);
Begin
  writeln('Nombre: ', e.nombre);
  writeln('Apellido: ', e.apellido);
  writeln('Nro: ', e.nro);
  writeln('Edad: ', e.edad);
  writeln('Dni: ', e.dni);
End;



Procedure nombreOApellido(Var archivoEmpleado:archivo);

Var 
  e: empleado;
  buscar: string;
  ok: boolean;
Begin
  writeln('Ingrese el apellido o nombre a buscar');
  readln(buscar);
  reset(archivoEmpleado);
  ok := false;
  While (Not eof(archivoEmpleado)) Do
    Begin
      read(archivoEmpleado, e);
      If ((e.nombre = buscar ) Or (e.apellido = buscar) ) Then
        Begin
          ok := true;
          writeln('Se encontro el empleado');
          mostrarEmpleado(e);
          writeln('---------------------------------');
        End;
    End;
  If Not ok Then
    writeln('No se encontro ningun empleado', #13#10,
            '---------------------------------');
End;

Procedure mostrarEmpleados(Var archivoEmpleado:archivo);

Var 
  e: empleado;
Begin
  reset(archivoEmpleado);
  While (Not eof(archivoEmpleado)) Do
    Begin
      read(archivoEmpleado, e);

      mostrarEmpleado(e);
      writeln('---------------------------------');

    End;
End;
Procedure proximosAJubilarse(Var archivoEmpleado:archivo);

Var 
  e: empleado;
  cant: integer;
  ok : boolean;
Begin
  reset(archivoEmpleado);
  ok := false;
  While (Not eof(archivoEmpleado)) Do
    Begin
      read(archivoEmpleado, e);
      If (e.edad>=70) Then
        Begin
          ok := true;
          writeln('Esta proximo a jubilarse:');
          mostrarEmpleado(e);
          writeln('---------------------------------');
        End;

    End;
  If Not ok Then
    writeln('No hay empleados proximos a jubilarse', #13#10,
            '---------------------------------');
End;

Procedure menu2(Var archivoEmpleado: archivo);

Var 
  opcion: string;
Begin
  writeln('Menu de opciones');
  writeln('--------------------------------------------------------');
  writeln('1: Listar por apellido o nombre');
  writeln('2: Listar en pantalla los empleados de a uno por linea.');
  writeln('3: Listar los proximos a jubilarse');
  writeln('--------------------------------------------------------');
  writeln('Ingrese la opcion deseada: ');
  readln(opcion);
  writeln('---------------------------------');
  If (opcion='1')Then
    nombreOApellido(archivoEmpleado)
  Else If (opcion='2')Then
         mostrarEmpleados(archivoEmpleado)
  Else If (opcion='3')Then
         proximosAJubilarse(archivoEmpleado)
  Else
    writeln('Opcion incorrecta');
End;



Procedure mostrarEnPantalla(Var archivoEmpleado:archivo);

Var 
  buscar: string;
  nombreArchivo: string;
Begin
  writeln('Ingrese el nombre del archivo');
  readln(nombreArchivo);
  assign(archivoEmpleado, nombreArchivo+'.dat');
  reset(archivoEmpleado);
  menu2(archivoEmpleado);
  close(archivoEmpleado);
End;






Procedure mainMenu();

Var 
  archivoEmpleado: archivo;
  opcion: string;
Begin
  writeln('Menu de opciones');
  writeln('--------------------');
  writeln('A: Crear archivo');
  writeln('B: Abrir Archivo');
  writeln('C: Salir');
  writeln('--------------------');
  writeln('Ingrese la opcion deseada: ');
  readln(opcion);
  If (opcion='C') Or (opcion='c') Then
    write('')
  Else
    Begin
      If (opcion='A') Or (opcion='a') Then
        crearArchivo(archivoEmpleado)
      Else If (opcion='B') Or (opcion='b') Then
             mostrarEnPantalla(archivoEmpleado)
      Else
        Begin
          writeln('Opcion incorrecta');
        End;
    End;
End;



Begin
  mainMenu();
  writeln('Fin del programa');
  readln;
End.
