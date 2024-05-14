
Program Ej3;

Const 
  valoralto = 9999;

Type 

  producto = Record
    cod: integer;
    nombre: string[20];
    precio: real;
    stockActual: integer;
    stockMinimo: integer;
  End;

  venta = Record
    cod: integer;
    cantidad: integer;
  End;


  master = File Of producto;
  detail = file Of venta;

Procedure cargarArchivoMaestro(Var mast: master);

Var 
  reg: producto;
Begin
  writeln('Cargando archivo maestro...');
  assign(mast, 'archivo_maestro_productos.dat');
  rewrite(mast);

  reg.cod := 1;
  reg.nombre := 'Detergente';
  reg.precio := 50.0;
  reg.stockActual := 100;
  reg.stockMinimo := 20;
  write(mast, reg);

  reg.cod := 2;
  reg.nombre := 'Desinfectante';
  reg.precio := 70.0;
  reg.stockActual := 80;
  reg.stockMinimo := 30;
  write(mast, reg);

  reg.cod := 3;
  reg.nombre := 'Limpiavidrios';
  reg.precio := 40.0;
  reg.stockActual := 120;
  reg.stockMinimo := 40;
  write(mast, reg);

  reg.cod := 4;
  reg.nombre := 'Lavandina';
  reg.precio := 60.0;
  reg.stockActual := 90;
  reg.stockMinimo := 25;
  write(mast, reg);

  reg.cod := 5;
  reg.nombre := 'Desengrasante';
  reg.precio := 80.0;
  reg.stockActual := 70;
  reg.stockMinimo := 35;
  write(mast, reg);

  close(mast);
  writeln('Archivo maestro cargado exitosamente.');
End;

Procedure cargarArchivoDetalle(Var det: detail);

Var 
  reg: venta;
Begin
  writeln('Cargando archivo detalle...');
  assign(det, 'archivo_detalle_ventas.dat');
  rewrite(det);

  reg.cod := 1;
  reg.cantidad := 10;
  write(det, reg);

  reg.cod := 2;
  reg.cantidad := 15;
  write(det, reg);

  reg.cod := 2;
  reg.cantidad := 1;
  write(det, reg);


  reg.cod := 3;
  reg.cantidad := 8;
  write(det, reg);

  reg.cod := 4;
  reg.cantidad := 12;
  write(det, reg);

  reg.cod := 5;
  reg.cantidad := 20;
  write(det, reg);

  close(det);
  writeln('Archivo detalle cargado exitosamente.');
End;

Procedure leer(Var reg:venta; Var det:detail);
Begin
  If Not eof(det) Then
    read(det,reg)
  Else
    reg.cod := valoralto;
End;

Procedure actualizarMaestro(Var mast: master; Var det: detail);

Var 
  regM: producto;
  regD: venta;
  totalVendido: integer;
  aux: integer;
Begin
  reset(mast);
  reset(det);
  read(mast, regM);
  leer(regD,det);
  While (regD.cod <> valoralto) Do
    Begin
      writeln('entro a primer while');
      aux := regD.cod;
      totalVendido := 0;
      While (aux = regD.cod) Do
        Begin
          writeln('entro a segundo while');
          writeln(aux);
          totalVendido := totalVendido + regD.cantidad;
          leer(regD,det);
        End;
      While (aux <> regM.cod) Do
        Begin
          writeln('busco archivo maestro');
          read(mast, regM);
        End;

      regM.stockActual := regM.stockActual - totalVendido;
      seek(mast, filepos(mast) - 1);
      write(mast, regM);
      If Not eof(mast) Then
        read(mast, regM);

    End;
  writeln('Archivo maestro actualizado exitosamente.');
  close(mast);
  close(det);

End;



Procedure listarEnTxt(Var mast: master);

Var 
  texto: Text;
  reg: producto;
  maxLongitudNombre: Integer;
Begin
  assign(texto, 'listado_productos.txt');
  rewrite(texto);

  // Encuentra la longitud máxima de nombre
  maxLongitudNombre := 0;
  reset(mast);
  While Not eof(mast) Do
    Begin
      read(mast, reg);
      If Length(reg.nombre) > maxLongitudNombre Then
        maxLongitudNombre := Length(reg.nombre);
    End;

  // Imprime el encabezado
  writeln(texto, 'Listado de productos');
  writeln(texto, '---------------------');
  writeln(texto, 'Codigo | Nombre':maxLongitudNombre+1,
          '| Precio | Stock Actual | Stock Minimo');
  writeln(texto, '--------------------------------------------------------');

  // Imprime los productos
  reset(mast);
  While Not eof(mast) Do
    Begin
      read(mast, reg);
      writeln(texto, reg.cod, ' | ', reg.nombre: maxLongitudNombre, ' | ',
              reg.precio:2:2, ' | ', reg.stockActual, ' | ', reg.stockMinimo);
    End;

  close(texto);
  close(mast);
  writeln('Listado de productos generado exitosamente.');
End;




Procedure menu(Var mast: master; Var det: detail);

Var 
  op: char;
Begin
  writeln('Ingrese una opcion');
  writeln('A. Actualizar maestro');
  writeln('B. Listar en txt');
  readln(op);
  op := upcase(op);
  Case op Of 
    'A': actualizarMaestro(mast, det);
    'B': listarEnTxt(mast);
    Else
      writeln('Opcion incorrecta');
  End;
End;

Var 
  maestro: master;
  detalle: detail;
  reg: producto;
Begin
  cargarArchivoDetalle(detalle);
  cargarArchivoMaestro(maestro);
  menu(maestro, detalle);
End.
