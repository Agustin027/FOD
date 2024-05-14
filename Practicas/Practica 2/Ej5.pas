
Program Ej5;

Uses 
SysUtils;

Const 
  valorAlto = 9999;
  dimF = 3;

Type 

  producto = Record
    codigo: integer;
    nombre: string;
    desc: string;
    stock: integer;
    stockMin: integer;
    precio: real;
  End;

  detalle = Record
    codigo: integer;
    cantVendida: integer;
  End;

  master = file Of producto;
  detail = file Of detalle;

  vecDetalle = Array[1..dimF] Of detail;
  regDetalle = Array[1..dimF] Of detalle;

Procedure crearMaestro(Var mae: master);

Var 
  regMae: producto;
Begin
  writeln('Creando archivo maestro...');
  assign(mae, 'archivo_maestro.dat');
  rewrite(mae);

  // Agregar datos de ejemplo al archivo maestro
  regMae.codigo := 1;
  regMae.nombre := 'Producto 1';
  regMae.desc := 'Descripcion del Producto 1';
  regMae.stock := 100;
  regMae.stockMin := 20;
  regMae.precio := 50.0;
  write(mae, regMae);

  regMae.codigo := 2;
  regMae.nombre := 'Producto 2';
  regMae.desc := 'Descripcion del Producto 2';
  regMae.stock := 150;
  regMae.stockMin := 30;
  regMae.precio := 70.0;
  write(mae, regMae);

  regMae.codigo := 3;
  regMae.nombre := 'Producto 3';
  regMae.desc := 'Descripcion del Producto 3';
  regMae.stock := 200;
  regMae.stockMin := 40;
  regMae.precio := 80.0;
  write(mae, regMae);

  regMae.codigo := 4;
  regMae.nombre := 'Producto 4';
  regMae.desc := 'Descripcion del Producto 4';
  regMae.stock := 120;
  regMae.stockMin := 25;
  regMae.precio := 60.0;
  write(mae, regMae);

  regMae.codigo := 5;
  regMae.nombre := 'Producto 5';
  regMae.desc := 'Descripcion del Producto 5';
  regMae.stock := 180;
  regMae.stockMin := 35;
  regMae.precio := 90.0;
  write(mae, regMae);

  regMae.codigo := 6;
  regMae.nombre := 'Producto 6';
  regMae.desc := 'Descripcion del Producto 6';
  regMae.stock := 180;
  regMae.stockMin := 35;
  regMae.precio := 90.0;
  write(mae, regMae);

  // Puedes agregar más productos aquí si es necesario

  close(mae);
  writeln('Archivo maestro creado exitosamente.');
  writeln('------------------------------------------------------');

End;

Procedure crearDetalle(Var vecDet: vecDetalle);

Var 
  i, j: integer;
  nombreArchivo: string;
  regDet: detalle;
Begin
  writeln('Creando archivos detalle...');
  For i := 1 To dimF Do
    Begin
      nombreArchivo := 'detalle_' + IntToStr(i) + '.dat';
      assign(vecDet[i], nombreArchivo);
      rewrite(vecDet[i]);
      For j := 1 To 6 Do
        // Generar 10 registros de ventas para cada sucursal
        Begin
          regDet.codigo := j;
          // Código de producto (usado para coincidir con el maestro)
          regDet.cantVendida := Random(50) + 1;
          // Generar cantidades aleatorias entre 1 y 50
          write(vecDet[i], regDet);
        End;
      close(vecDet[i]);
      // Cerrar el archivo después de crearlo
    End;
  writeln('Archivos detalle creados exitosamente.');
  writeln('------------------------------------------------------');
End;





Procedure leer(Var archivo: detail; Var dato: detalle);
Begin
  If (Not eof(archivo)) Then
    read(archivo, dato)
  Else
    dato.codigo := valorAlto;
End;

Procedure minimo( Var vecDet: vecDetalle;Var regD:regDetalle;Var min: detalle);

Var 
  i,minI: integer;
Begin
  min.codigo := valorAlto;
  For i:=1 To dimF Do
    If (regD[i].codigo < min.codigo)Then
      Begin
        min := regD[i];
        minI := i;
      End;
  If (min.codigo <> valorAlto) Then
    leer(vecDet[minI],regD[minI]);
End;

Procedure actualizarMaestro(Var mae: master; Var vecDet: vecDetalle);

Var 
  i: integer;
  regDet: regDetalle;
  regMae: producto;
  min: detalle;
Begin
  reset(mae);
  writeln('Actualizando archivo maestro...');
  For i:=1 To dimF Do
    Begin
      reset(vecDet[i]);
      leer(vecDet[i], regDet[i]);
    End;
  minimo(vecDet,regDet,min);

  While (min.codigo <> valorAlto) Do
    Begin
      read(mae, regMae);
      While (regMae.codigo <> min.codigo) Do
        read(mae, regMae);
      While (regMae.codigo = min.codigo) Do
        Begin
          writeln('Producto: ', regMae.codigo);
          regMae.stock := regMae.stock - min.cantVendida;
          minimo(vecDet,regDet,min);
        End;
      seek(mae, filepos(mae)-1);
      write(mae, regMae);
    End;
  close(mae);
  For i:=1 To dimF Do
    close(vecDet[i]);
End;



Procedure imprimirArchivoMaestro(Var m: master);

Var 
  reg: producto;
Begin
  writeln('Imprimiendo archivo maestro...');
  reset(m);
  // Imprime los encabezados
  writeln('Codigo | Nombre | Descripcion | Stock | Stock Minimo | Precio');
  writeln('-------------------------------------------------------------');

  // Imprime los registros
  While Not eof(m) Do
    Begin
      read(m, reg);
      writeln(reg.codigo, ' | ', reg.nombre, ' | ', reg.desc, ' | ',
              reg.stock, ' | ', reg.stockMin, ' | ', reg.precio:0:2);
    End;

  close(m);
  writeln('Archivo maestro impreso exitosamente.');
End;


Var 
  mae: master;
  vecDet: vecDetalle;
Begin
  crearMaestro(mae);
  crearDetalle(vecDet);
  imprimirArchivoMaestro(mae);
  actualizarMaestro(mae, vecDet);
  imprimirArchivoMaestro(mae);
End.
