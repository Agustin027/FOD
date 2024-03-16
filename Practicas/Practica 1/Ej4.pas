
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


Procedure agregarEmpleado(Var archivoEmpleado:archivo);

Var 
  e: empleado;
  ok: boolean;
Begin
  reset(archivoEmpleado);
  ok := true;
  Repeat
    leerEmpleado(e);
    seek(archivoEmpleado, filesize(archivoEmpleado));
    write(archivoEmpleado, e);
    writeln('Continuar?');
    ok := sino();
  Until Not ok

End;

Procedure modificarEdad(Var archivoEmpleado:archivo);

Var 
  e: empleado;
  ok: boolean;
  buscar: string;
Begin
  reset(archivoEmpleado);
  writeln('Ingrese el apellido o nombre a buscar');
  readln(buscar);
  ok := false;
  While Not eof(archivoEmpleado) And (Not ok) Do
    Begin
      read(archivoEmpleado, e);
      If (e.apellido=buscar) Or (e.nombre=buscar) Then
        Begin
          writeln('Ingrese la nueva edad');
          readln(e.edad);
          seek(archivoEmpleado, filepos(archivoEmpleado)-1);
          write(archivoEmpleado, e);
          ok := true;
        End;
    End;
  If Not ok Then
    writeln('No se encontro el empleado', #13#10,
            '---------------------------------')
  Else
    writeln('Edad modificada')

End;

Procedure exportarATexto(Var archivoEmpleado:archivo; Var txtEmpleados: Text);

Var 
  e: empleado;
Begin
  reset (archivoEmpleado);
  assign(txtEmpleados, 'empleados.txt');
  rewrite(txtEmpleados);
  While Not eof(archivoEmpleado) Do
    Begin
      read(archivoEmpleado, e);
      With e Do
        Begin
          writeln(txtEmpleados, 'Nombre: ', nombre);
          writeln(txtEmpleados, 'Apellido: ', apellido);
          writeln(txtEmpleados, 'Nro: ', nro);
          writeln(txtEmpleados, 'Edad: ', edad);
          writeln(txtEmpleados, 'Dni: ', dni);
          writeln(txtEmpleados, '---------------------------------');
        End;

    End;
  close(txtEmpleados);

End;

Procedure exportarSinDni(Var archivoEmpleado:archivo; Var txtSinDni: Text);

Var 
  e: empleado;
Begin
  reset (archivoEmpleado);
  assign(txtSinDni, 'empleadosSinDni.txt');
  rewrite(txtSinDni);
  While Not eof(archivoEmpleado) Do
    Begin
      read(archivoEmpleado, e);
      If e.dni=0 Then
        Begin
          With e Do
            Begin
              writeln(txtSinDni, 'Nombre: ', nombre);
              writeln(txtSinDni, 'Apellido: ', apellido);
              writeln(txtSinDni, 'Nro: ', nro);
              writeln(txtSinDni, 'Edad: ', edad);
              writeln(txtSinDni, 'Dni: ', dni);
              writeln(txtSinDni, '---------------------------------');
            End;
        End;
    End;
  close(txtSinDni);
End;


Procedure menu2(Var archivoEmpleado: archivo; Var txtEmpleados:Text ; Var
                txtSinDni: Text
);

Var 
  opcion: string;
Begin
  writeln('Menu de opciones');
  writeln('--------------------------------------------------------');
  writeln('1: Listar por apellido o nombre');
  writeln('2: Listar en pantalla los empleados de a uno por linea.');
  writeln('3: Listar los proximos a jubilarse');
  writeln('4: Agregar empleado');
  writeln('5: Modificar edad');
  writeln('6: Exportar a texto todos los empleados');
  writeln('7: Exportar a texto empleados sin DNI');

  writeln('--------------------------------------------------------');
  writeln('Ingrese la opcion deseada: ');
  readln(opcion);
  writeln('---------------------------------');
  Case opcion Of 
    '1': nombreOApellido(archivoEmpleado);
    '2': mostrarEmpleados(archivoEmpleado);
    '3': proximosAJubilarse(archivoEmpleado);
    '4': agregarEmpleado(archivoEmpleado);
    '5': modificarEdad(archivoEmpleado);
    '6': exportarATexto(archivoEmpleado,txtEmpleados);
    '7': exportarSinDni(archivoEmpleado,txtSinDni);
    Else
      writeln('Opcion incorrecta');
  End;

End;

Procedure abrirArchivo(Var archivoEmpleado:archivo; Var txtEmpleados:Text; Var
                       txtSinDni: Text);

Var 
  buscar: string;
  nombreArchivo: string;
Begin
  writeln('Ingrese el nombre del archivo');
  readln(nombreArchivo);
  assign(archivoEmpleado, nombreArchivo +'.dat');
  reset(archivoEmpleado);
  menu2(archivoEmpleado,txtEmpleados,txtSinDni);
  close(archivoEmpleado);
End;

Procedure mainMenu();

Var 
  archivoEmpleado: archivo;
  opcion: string;
  txtEmpleados,txtSinDni: Text;
Begin
  writeln('Menu de opciones');
  writeln('--------------------');
  writeln('A: Crear archivo');
  writeln('B: Abrir Archivo');
  writeln('C: Fin del programa');
  writeln('--------------------');
  writeln('Ingrese la opcion deseada: ');

  readln(opcion);
  opcion := upcase(opcion);
  Case opcion Of 
    'A': crearArchivo(archivoEmpleado);
    'B': abrirArchivo(archivoEmpleado,txtEmpleados,txtSinDni);
    'C': writeln('');
    Else
      writeln('Opcion incorrecta');
  End;


End;



Begin
  mainMenu();
  writeln('---------------------------------');
  writeln('Fin del programa');
  readln;
End.
