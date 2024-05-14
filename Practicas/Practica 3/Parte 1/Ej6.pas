
Program Ej6;
{$CODEPAGE UTF8}

Type 
  prenda = Record
    cod_prenda: integer;
    descripcion: string;
    colores: string;
    tipo_prenda: string;
    stock: integer;
    precio_unitario: real;
  End;

  //maestro
  archivo = file Of prenda;
  //detalle
  cod_prenda_bajas = file Of integer;


Procedure bajaLogica(Var a: archivo; Var d: cod_prenda_bajas);

Var 
  p: prenda;
  cod: integer;
Begin
  reset(d);
  read(d,cod);
  reset(a);
  While Not EOF(d) Do
    Begin
      read(a,p);
      While (Not EOF(a)) And (p.cod_prenda <> cod) Do
        read(a,p);
      If p.cod_prenda = cod Then
        Begin
          p.stock := -p.stock;
          seek(a, filepos(a)-1);
          write(a,p);
          writeln('Se dio de baja la prenda con el codigo: ', cod);
        End;
      read(d,cod);
    End;
  close(a);
  close(d);
End;


Procedure leerPrendas (Var p: prenda);
Begin
  writeln('Escriba el codigo de la prenda: ');
  readln(p.cod_prenda);
  If p.cod_prenda > 0 Then
    Begin
      writeln('Escriba la descripcion de la prenda: ');
      // readln(p.descripcion);
      p.descripcion := 'hola';
      writeln('Escriba el color de la prenda: ');
      //readln(p.colores);
      p.colores := 'rojo';
      writeln('Escriba el tipo de la prenda: ');
      //readln(p.tipo_prenda);
      p.tipo_prenda := 'xD';
      writeln('Escriba la cantidad en stock de la prenda: ');
      //readln(p.stock);
      p.stock := 10;
      writeln('Escriba el precio unitario de la prenda: ');
      //readln(p.precio_unitario);
      p.precio_unitario := 100;

    End;
End;



Procedure crearArchivoMaestro(Var a: archivo);

Var 
  p: prenda;
Begin
  assign(a, 'prendas');
  rewrite(a);
  leerPrendas(p);
  While p.cod_prenda > 0 Do
    Begin
      write(a,p);
      leerPrendas(p);
    End;
End;



Procedure imprimirPrenda(p: prenda);
Begin
  writeln('Código de la prenda: ', p.cod_prenda);
  writeln('Descripción: ', p.descripcion);
  writeln('Colores: ', p.colores);
  writeln('Tipo de prenda: ', p.tipo_prenda);
  writeln('Stock: ', p.stock);
  writeln('Precio unitario: ', p.precio_unitario:0:2);
  writeln('-----------------------------------');
End;


Procedure imprimirArchivoMaestro(Var a: archivo);

Var 
  p: prenda;
Begin
  reset(a);
  writeln('-----------------------------------');
  While Not EOF(a) Do
    Begin
      read(a, p);
      imprimirPrenda(p);
    End;
  close(a);
End;

Procedure crearArchivoDetalle(Var d:cod_prenda_bajas);

Var 
  cod: integer;
Begin
  assign(d, 'bajas');
  rewrite(d);
  writeln('Ingrese el codigo de la prenda a dar de baja: ');
  readln(cod);
  While cod <> 0 Do
    Begin
      write(d,cod);
      writeln('Ingrese el codigo de la prenda a dar de baja: ');
      readln(cod);
    End;
  close(d);
End;



Procedure efectivizarBajas(Var a: archivo; Var aux: archivo);

Var 
  p: prenda;
Begin
  writeln('Efectivizando bajas...');
  assign(aux, 'auxiliar');
  rewrite(aux);
  reset(a);
  readln;
  While Not eof(a) Do
    Begin
      read(a, p);
      If p.stock > 0 Then
        Begin
          write(aux, p);
        End;
    End;
  close(a);
  close(aux);
  erase(a);
  rename(aux, 'prendas');
End;



Var 
  a,aux: archivo;
  d: cod_prenda_bajas;
Begin
  crearArchivoMaestro(a);
  //crearArchivoDetalle(d);
  //assign(a, 'prendas');
  assign(d, 'bajas');
  bajaLogica(a,d);
  imprimirArchivoMaestro(a);
  writeln('-----------------------------------');
  efectivizarBajas(a,aux);
  imprimirArchivoMaestro(aux);
End.
